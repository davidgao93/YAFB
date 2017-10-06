#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=c:\program files (x86)\autoit3\scite\koda\forms\fish2.kxf
$Form1_1 = GUICreate("CrayonCode Marketplace", 615, 437, 231, 124)
$Tab1 = GUICtrlCreateTab(0, 0, 614, 400)
$Tab_StatusLog = GUICtrlCreateTabItem("Status Log")
$ELog = GUICtrlCreateEdit("", 8, 32, 593, 361, BitOR($GUI_SS_DEFAULT_EDIT,$ES_READONLY))
GUICtrlSetFont(-1, 8, 400, 0, "Fixedsys")
$Tab_Settings = GUICtrlCreateTabItem("Global Settings")
GUICtrlSetState(-1,$GUI_SHOW)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Client_Settings = GUICtrlCreateGroup("Client Settings", 144, 37, 457, 169)
$IClientName = GUICtrlCreateInput("", 256, 61, 153, 21)
$Label4 = GUICtrlCreateLabel("Client Name:", 160, 64, 64, 17)
$Label5 = GUICtrlCreateLabel("Client Language:", 160, 96, 84, 17)
$CLang = GUICtrlCreateCombo("", 260, 92, 82, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "en|de|fr", "en")
$CBLogFile = GUICtrlCreateCheckbox("Enable Logfile", 160, 128, 97, 17)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 100)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 100)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 100)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 100)
GUICtrlCreateTabItem("")
$BSave = GUICtrlCreateButton("Save Settings", 8, 400, 100, 33)
$BMarketplace = GUICtrlCreateButton("Start MP [F4]", 256, 400, 100, 33)
$BQuit = GUICtrlCreateButton("Quit [CTRL+F1]", 504, 400, 100, 33)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###