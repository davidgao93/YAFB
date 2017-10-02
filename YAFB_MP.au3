#cs ----------------------------------------------------------------------------
	AutoIt Version: 3.3.14.2
	Author:         CrayonCode edited by David
	Version:		1
	Contact:		https://discord.gg/yEqadvZ 
#ce ----------------------------------------------------------------------------


#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compile_Both=y  ;required for ImageSearch.au3
#AutoIt3Wrapper_UseX64=y  ;required for ImageSearch.au3
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#RequireAdmin
#include "ImageSearch.au3"
#include "FastFind.au3"
#include "Support.au3"
#include "MP_GUI.au3"
#include <File.au3>
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <GuiEdit.au3>

OnAutoItExitRegister(_ImageSearchShutdown)
Opt("MouseClickDownDelay", 100)
Opt("MouseClickDelay", 50)
Opt("SendKeyDelay", 50)

Global $Marketplace = False
Global $Res[4] = [0, 0, @DesktopWidth, @DesktopHeight]
Global $hTitle = "BLACK DESERT - "
Global $LNG = "en"
Global $LogEnable = True
HotKeySet("^{F1}", "_terminate")
HotKeySet("{F4}", "RunMarketplace")

; # GUI
Func SetGUIStatus($data)
	Local Static $LastGUIStatus
	Local Static $Limits = _GUICtrlEdit_SetLimitText ( $ELog, 300000000 ) ; Increase Text Limit since Log usually stopped around 800 lines
	If $data <> $LastGUIStatus Then
		_GUICtrlEdit_AppendText($ELog, @HOUR & ":" & @MIN & "." & @SEC & " " & $data & @CRLF)
		ConsoleWrite(@CRLF & @HOUR & ":" & @MIN & "." & @SEC & " " & $data)
		If $LogEnable = True Then LogData(@HOUR & ":" & @MIN & "." & @SEC & " " & $data, "logs/MP_LOGFILE.txt")
		$LastGUIStatus = $data
	EndIf
EndFunc   ;==>SetGUIStatus

Func GUILoopSwitch()
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			Exit
		Case $BQuit
			_terminate()
		Case $BMarketplace
			RunMarketplace()
		Case $BSave
			StoreGUI()
	EndSwitch
EndFunc   ;==>GUILoopSwitch

Func InitGUI()
	; LootSettings
	; ClientSettings
	Global $ClientSettings = IniReadSection("config/settings.ini", "ClientSettings")
	GUICtrlSetData($IClientName, $ClientSettings[1][1])
	GUICtrlSetData($CLang, "|en|de|fr", $ClientSettings[2][1])
	GUICtrlSetState($CBLogFile, CBT($ClientSettings[3][1]))

EndFunc

Func StoreGUI()
	; ClientSettings
	Global $ClientSettings = IniReadSection("config/settings.ini", "ClientSettings")
	$ClientSettings[1][1] = GUICtrlRead($IClientName)
	$ClientSettings[2][1] = GUICtrlRead($CLang)
	$ClientSettings[3][1] = CBT(GUICtrlRead($CBLogFile))
	IniWriteSection("config/settings.ini", "ClientSettings", $ClientSettings)
	
	InitGUI()
EndFunc

Func CreateConfig()
	If FileExists("logs/") = False Then DirCreate("logs/")
	If FileExists("config/") = False Then DirCreate("config/")

	If FileExists("config/settings.ini") = False Then
		Local $ClientSettings = ""
		$ClientSettings &= "ClientName=BLACK DESERT - " & @LF
		$ClientSettings &= "ClientLanguage=en" & @LF
		$ClientSettings &= "Enable_Logfile=1" & @LF
		$ClientSettings &= "Enable_ScreencapLoot=0" & @LF
		IniWriteSection("config/settings.ini", "ClientSettings", $ClientSettings)
	EndIf
EndFunc   ;==>CreateConfig

; # Basic
Func DetectFullscreenToWindowedOffset($hTitle) ; Returns $Offset[4] left, top, right, bottom (Fullscreen returns 0, 0, Width, Height)
	Local $x1, $x2, $y1, $y2
	Local $Offset[4]
	Local $ClientZero[4] = [0, 0, 0, 0]

	WinActivate($hTitle)
	WinWaitActive($hTitle, "", 5)
	WinActivate($hTitle)
	Local $Client = WinGetPos($hTitle)
	If Not IsArray($Client) Then
		SetGUIStatus("E: ClientSize could not be detected")
		Return ($ClientZero)
	EndIf

	If $Client[2] = @DesktopWidth And $Client[3] = @DesktopHeight Then
		SetGUIStatus("Fullscreen detected (" & $Client[2] & "x" & $Client[3] & ") - No Offsets")
		Return ($Client)
	EndIf

	If Not VisibleCursor() Then CoSe("{LCTRL}")
	Opt("MouseCoordMode", 2)
	MouseMove(0, 0, 0)
	Opt("MouseCoordMode", 1)
	$x1 = MouseGetPos(0)
	$y1 = MouseGetPos(1)
	Opt("MouseCoordMode", 0)
	MouseMove(0, 0, 0)
	Opt("MouseCoordMode", 1)
	$x2 = MouseGetPos(0)
	$y2 = MouseGetPos(1)
	MouseMove($x1, $y1, 0)


	$Offset[0] = $Client[0] + $x1 - $x2
	$Offset[1] = $Client[1] + $y1 - $y2
	$Offset[2] = $Client[0] + $Client[2]
	$Offset[3] = $Client[1] + $Client[3]
	For $i = 0 To 3
		SetGUIStatus("ScreenOffset(" & $i & "): " & $Offset[$i])
	Next

	Return ($Offset)
EndFunc   ;==>DetectFullscreenToWindowedOffset

; #Region - Marketplace
Func RunMarketplace()
	$Marketplace = Not $Marketplace
	If $Marketplace = False Then
		SetGUIStatus("Stopping Marketplace")
	Else
		SetGUIStatus("Starting Marketplace")
		Marketplace()
	EndIf
EndFunc   ;==>RunMarketplace

Func Marketplace()
	Local Const $PurpleBags = "res/marketplace_purplebags.bmp"
	Local $RegistrationCountOffset[4] = [70, -9, 110, 5]
	Local $RefreshOffset[2] = [-440, 480]
	Local $x, $y, $IS
	Local $Diff[4]
	Local $timer

	$ResOffset = DetectFullscreenToWindowedOffset($hTitle)
	
	$IS = _ImageSearchArea($PurpleBags, 1, $ResOffset[0], $ResOffset[1], $ResOffset[2], $ResOffset[3], $x, $y, 0, 0)
	If $IS = False Then
		SetGUIStatus("No PurpleBags found. Stopping.")
		$Marketplace = False
	EndIf
		
	Local $count = 0, $breakout = 0
	While $Marketplace
		SetGUIStatus("Waiting for Registration Count change")
		$number = FastFindBidBuy($x, $y)
		If $number >= 0 Then BuyItem($x, $y, $number)

		$Diff[$count] = PixelChecksum($x + $RegistrationCountOffset[0], $y + $RegistrationCountOffset[1], $x + $RegistrationCountOffset[2], $y + $RegistrationCountOffset[3])
		For $i = 0 To UBound($Diff) - 1
			If $Diff[0] <> $Diff[$i] Then
				If TimerDiff($timer) > 1000 Then
					SetGUIStatus("Refresh (Registration Count change)")
					MouseClick("left", $x + $RefreshOffset[0], $y + $RefreshOffset[1], 1, 0)
					$timer = TimerInit()
					Sleep(50)
					ExitLoop
				Else
					$breakout += 1
					If $breakout > 10 Then
						$IS = _ImageSearchArea($PurpleBags, 1, $x - 10, $y - 10, $x + 10, $y + 10, $x, $y, 0, 0)
						If $IS = False Then
							SetGUIStatus("No PurpleBags found. Stopping.")
							$Marketplace = False
						Else
							$breakout = 0
						EndIf
					EndIf
				EndIf
			EndIf
		Next
		If TimerDiff($timer) > 15000 Then
			SetGUIStatus("Refresh (15s no change detected)")
			MouseClick("left", $x + $RefreshOffset[0], $y + $RefreshOffset[1], 1, 0)
			$timer = TimerInit()
			Sleep(50)
		EndIf
		Sleep(50)
		$count += 1
		If $count = 4 Then $count = 0
	WEnd
EndFunc   ;==>Marketplace

Func FastFindBidBuy($x, $y)
	Local $Valid[2] = [0x979292, 0xB8B8B8]
	Local $SSN = 1, $FF
	Local $BidR[3] = [21, 12, 21]
	Local $Buy[3] = [3, 12, 21]
	Local $Bid[3] = [4, 12, 21]
	Local $BuyOffset[3] = [78, 54, 62] ; x, y, height 7
	Local $ButtonRegion[4] = [$x + $BuyOffset[0] - 15, $y + $BuyOffset[1] - 15, $x + $BuyOffset[0] + 15, $y + $BuyOffset[1] + 15]
	Local $count

	FFSnapShot($ButtonRegion[0], $ButtonRegion[1], $ButtonRegion[2], $ButtonRegion[3] + $BuyOffset[2] * 6, $SSN)

	For $i = 0 To 6
		$count = 0
		For $yBid = $Bid[1] To $Bid[2]
			$FF = FFGetPixel($ButtonRegion[0] + $Bid[0], $ButtonRegion[1] + $yBid + $BuyOffset[2] * $i, $SSN)
			If $FF = $Valid[0] Or $FF = $Valid[1] Then
				$count += 1
			EndIf
		Next
		If $count > 9 Then
			SetGUIStatus("Bid " & $i)
			MouseClick("left", $x + $BuyOffset[0], $y + $BuyOffset[1] + $i * $BuyOffset[2], 2, 0)
			CoSe("{SPACE}")
		EndIf
	Next


	For $i = 0 To 6
		$count = 0
		For $yBuy = $Buy[1] To $Buy[2]
			$FF = FFGetPixel($ButtonRegion[0] + $Buy[0], $ButtonRegion[1] + $yBuy + $BuyOffset[2] * $i, $SSN)
			If $FF = $Valid[0] Or $FF = $Valid[1] Then
				$count += 1
			EndIf
		Next
		If $count > 9 Then
			SetGUIStatus("Buy " & $i)
			Return ($i)
		EndIf
		$count = 0
		For $yBidR = $BidR[1] To $BidR[2]
			$FF = FFGetPixel($ButtonRegion[0] + $BidR[0], $ButtonRegion[1] + $yBidR + $BuyOffset[2] * $i, $SSN)
			If $FF = $Valid[0] Or $FF = $Valid[1] Then
				$count += 1
			EndIf
		Next
		If $count > 9 Then
			SetGUIStatus("BidR " & $i)
			Return ($i)
		EndIf
	Next
	Return -1
EndFunc   ;==>FastFindBidBuy


Func BuyItem($x, $y, $number)
	Local $MaxOffset[2] = [-111, 297]
	Local $BuyOffset[3] = [78, 54, 62] ; x, y, height

	MouseClick("left", $x + $BuyOffset[0], $y + $BuyOffset[1] + $number * $BuyOffset[2], 2, 0) ; buy
	MouseClick("left", $x + $MaxOffset[0] - 30, $y + $MaxOffset[1], 1, 0) ; amount
	CoSe("f") ; max
	CoSe("r") ; confirm
	CoSe("{SPACE}") ; yes
EndFunc   ;==>BuyItem
; #EndRegion - Marketplace

Func Main()
	ObfuscateTitle($Form1_1)
	CreateConfig()
	InitGUI()
	While True
		GUILoopSwitch()
	WEnd
EndFunc   ;==>Main



Main()
