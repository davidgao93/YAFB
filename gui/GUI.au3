#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>

#include "MultiLang.au3"

;Set location of the language files *OPTIONAL*
Local $LANG_DIR = @ScriptDir & "\gui\LanguageFiles"; Where we are storing the language files.

;This is the language we will load.  You could load this value from an INI file or saved
;location to stop the user having to select a Language every time they run your program.
If FileExists("logs/") = False Then DirCreate("logs/")
If FileExists("config/") = False Then DirCreate("config/")
If FileExists("config/settings.ini") = False Then
	Local $LangSettings = ""
	$LangSettings &= "0409" & @LF
	IniWriteSection("config/settings.ini", "LangSettings", $LangSettings)
EndIf

; Read language from INI
Global $LangSettings = IniReadSection("config/settings.ini", "LangSettings")
Local $user_lang = $LangSettings[1][1]

;Create an array of available language files
; ** n=0 is the default language file
; [n][0] = Display Name in Local Language (Used for Select Function)
; [n][1] = Language File (Full path.  In this case we used a $LANG_DIR
; [n][2] = [Space delimited] Character codes as used by @OS_LANG (used to select correct lang file)
Local $LANGFILES[3][3]

$LANGFILES[0][0] = "English (US)" ;
$LANGFILES[0][1] = $LANG_DIR & "\ENGLISH.XML"
$LANGFILES[0][2] = "0409 " & _ ;English_United_States
		"0809 " & _ ;English_United_Kingdom
		"0c09 " & _ ;English_Australia
		"1009 " & _ ;English_Canadian
		"1409 " & _ ;English_New_Zealand
		"1809 " & _ ;English_Irish
		"1c09 " & _ ;English_South_Africa
		"2009 " & _ ;English_Jamaica
		"2409 " & _ ;English_Caribbean
		"2809 " & _ ;English_Belize
		"2c09 " & _ ;English_Trinidad
		"3009 " & _ ;English_Zimbabwe
		"3409" ;English_Philippines

$LANGFILES[1][0] = "Deutsch" ; German
$LANGFILES[1][1] = $LANG_DIR & "\GERMAN.XML"
$LANGFILES[1][2] = "0407 " & _ ;German_Standard
		"0807 " & _ ;German_Swiss
		"0c07 " & _ ;German_Austrian
		"1007 " & _ ;German_Luxembourg
		"1407" ;German_Liechtenstei

$LANGFILES[2][0] = "Français" ; French
$LANGFILES[2][1] = $LANG_DIR & "\FRENCH.XML"
$LANGFILES[2][2] = "040c " & _ ;French_Standard
		"080c " & _ ;French_Belgian
		"0c0c " & _ ;French_Canadian
		"100c " & _ ;French_Swiss
		"140c " & _ ;French_Luxembourg
		"180c" ;French_Monaco

;Set the available language files, names, and codes.
_MultiLang_SetFileInfo($LANGFILES)
If @error Then
	MsgBox(48, "Error", "Could not set file info.  Error Code " & @error)
	Exit
EndIf

;Check if the loaded settings file exists.  If not ask user to select language.
If $user_lang = -1 Then
	;Create Selection GUI
	$user_lang = _MultiLang_SelectGUI("Select Language", "Please select a language")
	If @error Then
		MsgBox(48, "Error", "Could not create selection GUI.  Error Code " & @error)
		Exit
	EndIf
	;MsgBox(48, "prompt", "$langsettings should be: " & $user_lang)
	Global $LangSettings = IniReadSection("config/settings.ini", "LangSettings")
	$LangSettings[1][1] = $user_lang
	IniWriteSection("config/settings.ini", "LangSettings", $LangSettings)
	
	;It is here where you could save the settings.
EndIf

;Load the language file
$ret = _MultiLang_LoadLangFile($user_lang)
If @error Then
	MsgBox(48, "Error", "Could not load lang file.  Error Code " & @error)
	Exit
EndIf

;If you supplied an invalid $user_lang, we will load the default language file
If $ret = 2 Then
	MsgBox (64, "Information", "Just letting you know that we loaded the default language file")
EndIf

#Region ### START Koda GUI section ### Form=c:\program files (x86)\autoit3\scite\koda\forms\fish2.kxf
$Form1_1 = GUICreate("CrayonCode Fishing", 615, 437, 231, 124)
$Tab1 = GUICtrlCreateTab(0, 0, 614, 400)
$Tab_StatusLog = GUICtrlCreateTabItem(_MultiLang_GetText("status_log"))
$ELog = GUICtrlCreateEdit("", 8, 32, 593, 361, BitOR($GUI_SS_DEFAULT_EDIT,$ES_READONLY))
GUICtrlSetFont(-1, 8, 400, 0, "Fixedsys")
$Tab_Settings = GUICtrlCreateTabItem(_MultiLang_GetText("global_settings"))
GUICtrlSetState(-1,$GUI_SHOW)
$Loot_Settings = GUICtrlCreateGroup(_MultiLang_GetText("loot_settings"), 13, 37, 121, 169)
$LRarity = GUICtrlCreateLabel(_MultiLang_GetText("rarity_settings"), 25, 60, 78, 17)
$CRarity = GUICtrlCreateCombo("", 33, 84, 82, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, _MultiLang_GetText("fish_colors"), _MultiLang_GetText("fish_default_color"))
GUICtrlSetTip(-1, _MultiLang_GetText("fish_color_tip"))
$CBSpecial1 = GUICtrlCreateCheckbox(_MultiLang_GetText("silver_key"), 25, 164, 97, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetTip(-1, _MultiLang_GetText("silver_key_tip"))
$CBSpecial2 = GUICtrlCreateCheckbox(_MultiLang_GetText("relic"), 25, 132, 105, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetTip(-1, _MultiLang_GetText("relic_tip"))
$CBSpecial3 = GUICtrlCreateCheckbox(_MultiLang_GetText("coel"), 25, 148, 97, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetTip(-1, _MultiLang_GetText("coel_tip"))
$CBEvent = GUICtrlCreateCheckbox(_MultiLang_GetText("event"), 25, 117, 97, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetTip(-1, _MultiLang_GetText("event_tip"))
$CBTrash = GUICtrlCreateCheckbox(_MultiLang_GetText("trash"), 25, 181, 97, 17)
GUICtrlSetTip(-1, _MultiLang_GetText("trash_tip"))
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Side_Functions = GUICtrlCreateGroup(_MultiLang_GetText("side_functions"), 8, 213, 601, 89)
$CBFeedWorker = GUICtrlCreateCheckbox(_MultiLang_GetText("feed_worker"), 20, 245, 121, 17)
GUICtrlSetTip(-1, _MultiLang_GetText("worker_tip"))
$IFeedWorkerInterval = GUICtrlCreateInput("30", 226, 243, 41, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_NUMBER))
GUICtrlSetLimit(-1, 3)
GUICtrlSetTip(-1, _MultiLang_GetText("interval_tip"))
$Label1 = GUICtrlCreateLabel(_MultiLang_GetText("interval"), 174, 247, 42, 17)
$BFeedWorker = GUICtrlCreateButton(_MultiLang_GetText("test"), 280, 243, 50, 21)
$CBBuff = GUICtrlCreateCheckbox(_MultiLang_GetText("enable_buffs"), 21, 272, 121, 17)
$Label2 = GUICtrlCreateLabel(_MultiLang_GetText("interval"), 173, 275, 42, 17)
$IBuffInterval = GUICtrlCreateInput("999", 225, 272, 41, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_NUMBER))
GUICtrlSetLimit(-1, 3)
GUICtrlSetTip(-1, _MultiLang_GetText("interval_tip"))
$IBuffKeys = GUICtrlCreateInput("", 328, 272, 121, 21)
$Label3 = GUICtrlCreateLabel(_MultiLang_GetText("buffkeys"), 288, 275, 30, 17)
$BBuffKeys = GUICtrlCreateButton(_MultiLang_GetText("test"), 472, 272, 50, 21)
$BLoopSide = GUICtrlCreateButton(_MultiLang_GetText("side_functions_on"), 464, 233, 132, 33)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Client_Settings = GUICtrlCreateGroup(_MultiLang_GetText("cl_settings"), 144, 37, 457, 169)
$IClientName = GUICtrlCreateInput("", 256, 61, 153, 21)
$Label4 = GUICtrlCreateLabel(_MultiLang_GetText("cl_name"), 160, 64, 64, 17)
$Label5 = GUICtrlCreateLabel(_MultiLang_GetText("cl_lang"), 160, 96, 84, 17)
$CLang = GUICtrlCreateCombo("", 260, 92, 82, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "en|de|fr", "en")
GUICtrlSetTip(-1, _MultiLang_GetText("rarity_tip"))
$CBLogFile = GUICtrlCreateCheckbox(_MultiLang_GetText("log"), 160, 128, 97, 17)
$CBLootCapture = GUICtrlCreateCheckbox(_MultiLang_GetText("screencap"), 160, 152, 209, 17)
$CBReserve = GUICtrlCreateCheckbox(_MultiLang_GetText("relic_reserve"), 160, 174, 300, 17)
$ISlotsReserved = GUICtrlCreateInput("8", 470, 174, 41, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_NUMBER))
GUICtrlSetLimit(-1, 3)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Drying_Settings = GUICtrlCreateGroup(_MultiLang_GetText("dry"), 8, 304, 337, 89)
$CBDryFish = GUICtrlCreateCheckbox(_MultiLang_GetText("dry_fish"), 19, 329, 121, 17)
GUICtrlSetTip(-1, _MultiLang_GetText("dry_tip"))
$LDryingRarity = GUICtrlCreateLabel(_MultiLang_GetText("dry_rarity"), 141, 331, 57, 17)
$CDryFish = GUICtrlCreateCombo("", 201, 327, 82, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, _MultiLang_GetText("dry_colors"), _MultiLang_GetText("dry_default_color"))
GUICtrlSetTip(-1, _MultiLang_GetText("dry_max_rarity"))
$BDryFish = GUICtrlCreateButton(_MultiLang_GetText("test"), 287, 327, 50, 21)
$IDryFishInterval = GUICtrlCreateInput("5", 87, 351, 41, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_NUMBER))
GUICtrlSetLimit(-1, 3)
GUICtrlSetTip(-1, _MultiLang_GetText("interval_tip"))
$Label6 = GUICtrlCreateLabel(_MultiLang_GetText("interval"), 35, 354, 42, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Inventory_Settings = GUICtrlCreateGroup(_MultiLang_GetText("inven_settings"), 352, 304, 257, 89)
$CBDiscardRods = GUICtrlCreateCheckbox(_MultiLang_GetText("discard_rods"), 368, 328, 121, 17)
GUICtrlSetTip(-1, _MultiLang_GetText("discard_tip"))
$IBufferSize = GUICtrlCreateInput("0", 440, 356, 65, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_NUMBER))
$Label7 = GUICtrlCreateLabel(_MultiLang_GetText("buffer"), 368, 360, 58, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$TabSheet1 = GUICtrlCreateTabItem(_MultiLang_GetText("stats"))
$ListView1 = GUICtrlCreateListView(_MultiLang_GetText("stats_tip"), 24, 40, 570, 342)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 100)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 100)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 100)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 100)
GUICtrlCreateTabItem("")
$BSave = GUICtrlCreateButton(_MultiLang_GetText("b_save"), 8, 400, 100, 33)
$BFish = GUICtrlCreateButton(_MultiLang_GetText("b_fish"), 256, 400, 100, 33)
$BMinigame = GUICtrlCreateButton(_MultiLang_GetText("b_mini"), 128, 400, 100, 33)
$BQuit = GUICtrlCreateButton(_MultiLang_GetText("b_quit"), 504, 400, 100, 33)
$BPause = GUICtrlCreateButton(_MultiLang_GetText("b_pause"), 384, 400, 100, 33)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###