#include<GuiButton.au3>
#include<GuiToolBar.au3>
#include <GuiConstants.au3>
#include<GuiConstantsEx.au3>
#include <Misc.au3>
#include <Array.au3>
#include <File.au3>
#include <WinAPI.au3>

Opt('MouseCoordMode', 0)
$rx=3
$ry=25
$option=0

$hGUI = GUICreate("Infarct Segmentation", 1280,720,(@DesktopWidth-1280)/2,0)
$left = 0
$right = 0
$line1 = 0
$line2 = 0
$line3 = 0
$line4 = 0
$point1 = 0
$point2 = 0
$prevx = 0
$prevy = 0
$background = GUICtrlCreatePic(@WorkingDir & "\layout\main.jpg", 0, 0,1280,720)
$load = GUICtrlCreatePic(@WorkingDir & "\layout\load.jpg", 76-$rx,51-$ry,216,54)
$save = GUICtrlCreatePic(@WorkingDir & "\layout\save.jpg", 989-$rx,51-$ry,216,54)
$fast = GUICtrlCreatePic(@WorkingDir & "\layout\fast.jpg", 70-$rx,668-$ry,216,54)
$accurate = GUICtrlCreatePic(@WorkingDir & "\layout\accurate.jpg", 354-$rx,668-$ry,216,54)
$begin = GUICtrlCreatePic(@WorkingDir & "\layout\begin.jpg", 705-$rx,673-$ry,216,54)
$loadFlag = 0
$runFlag = 0
$x1 = 0
$x2 = 0
$y1 = 0
$y2 = 0
$path = 0

GUICtrlSetState($line1,$GUI_HIDE)
GUICtrlSetState($line2,$GUI_HIDE)
GUICtrlSetState($line3,$GUI_HIDE)
GUICtrlSetState($line4,$GUI_HIDE)
GUICtrlSetState($point1,$GUI_HIDE)
GUICtrlSetState($point2,$GUI_HIDE)
GUICtrlSetState($left,$GUI_HIDE)
GUICtrlSetState($right,$GUI_HIDE)
GUICtrlSetState($background,$GUI_SHOW)
GUICtrlSetState($load,$GUI_HIDE)
GUICtrlSetState($save,$GUI_HIDE)
GUICtrlSetState($fast,$GUI_SHOW)
GUICtrlSetState($accurate,$GUI_HIDE)
GUICtrlSetState($begin,$GUI_HIDE)
GUISetState(@SW_SHOW)

While 1
   $p=MouseGetPos()
   ;traytip("",$p[0] &" "& $p[1],1000)
   $msg=GUIGetMsg()
   If $msg=-3 Then
	  stop()
   ElseIf _ispressed(1) Then
	  $state = checkPos($p)
	  ;traytip("",$state,1000)
	  
	  If $state = 1 Then
		 flash($load)
		 Run("explorer.exe")
		 While 1
			$msg=GUIGetMsg()
			If _ispressed('20') Then
			   Send("^c")
			   Sleep(300)
			   $path = CopyUNC()
			   $confirm = MsgBox(1,"confirm","Select this file?")
			   If $confirm = 1 Then
				  WinClose("[CLASS:CabinetWClass]")
				  WinClose("[CLASS:ExploreWClass]")
				  ExitLoop
			   EndIf
			ElseIf $msg=-3 Then
			   stop()
			EndIf
		 WEnd
		 $file = FileOpen(@WorkingDir & "\bin\tmp",2)
		 FileWrite($file,$path)
		 FileWrite($file,@LF)
		 FileClose($file)
		 FileDelete(@WorkingDir & "\bin\input.jpg")
		 Run(@WorkingDir & "\bin\guiDicomread.exe",@WorkingDir & "\bin",@SW_HIDE)
		 Sleep(1000)
		 TrayTip("",$path,1000)
		 While 1
			$msg=GUIGetMsg()
			If FileExists(@WorkingDir & "\bin\input.jpg") Then
			   Sleep(1000)
			   TrayTip("","Load Complete",2000)
			   resetRoi()
			   ExitLoop
			ElseIf $msg=-3 Then
			   stop()
			EndIf
		 WEnd
		 $left = GUICtrlCreatePic(@WorkingDir & "\bin\input.jpg",70,110,504,504)
		 GUICtrlSetState($left,$GUI_SHOW)
		 $loadFlag = 1
	  ElseIf $state = 2 Then
		 flash($save)
		 If $runFlag = 1 Then
			$path = InputBox("Enter Path", "Please specify path and file name : ", StringReplace($path,".dcm","-segment.jpg"),"",300,130)
			FileCopy(@WorkingDir & "\bin\segment.jpg",$path)
		 EndIf
	  ElseIf $state = 3 And $option = 1 Then
		 $option = 0
		 GUICtrlSetState($fast,$GUI_SHOW)
		 GUICtrlSetState($accurate,$GUI_HIDE)
		 Sleep(100)
	  ElseIf $state = 4 And $option = 0 Then
		 $option = 1
		 GUICtrlSetState($fast,$GUI_HIDE)
		 GUICtrlSetState($accurate,$GUI_SHOW)
		 Sleep(100)
	  ElseIf $state = 5 Then
		 flash($begin)
		 If $loadFlag = 1 Then
			If $point1<>0 And $point2<>0 Then
			   $file = FileOpen(@WorkingDir & "\bin\tmp",1)
			   FileWrite($file,$x1)
			   FileWrite($file,@LF)
			   FileWrite($file,$x2)
			   FileWrite($file,@LF)
			   FileWrite($file,$y1)
			   FileWrite($file,@LF)
			   FileWrite($file,$y2)
			   FileWrite($file,@LF)
			   FileClose($file)
			EndIf
			TrayTip("","Execute",30000)
			FileDelete(@WorkingDir & "\bin\segment.jpg")
			If $option=0 Then
			   Run(@WorkingDir & "\bin\guiOtsu.exe",@WorkingDir & "\bin",@SW_HIDE)
			Else
			   Run(@WorkingDir & "\bin\guiFuzzy.exe",@WorkingDir & "\bin",@SW_HIDE)
			EndIf
			While 1
			   $msg=GUIGetMsg()
			   If FileExists(@WorkingDir & "\bin\segment.jpg") Then
				  Sleep(1000)
				  TrayTip("","Segmentation Complete",2000)
				  ExitLoop
			   ElseIf $msg=-3 Then
				  stop()
			   EndIf
			WEnd
			$right = GUICtrlCreatePic(@WorkingDir & "\bin\segment.jpg",700,110,0,0)
			GUICtrlSetState($right,$GUI_SHOW)
			$runFlag = 1
		 EndIf
	  ElseIf $state=6 And $loadFlag = 1 Then
		 If $point1=0 Then
			$prevx=$p[0]
			$prevy=$p[1]
			$point1 = GUICtrlCreateLabel("", $p[0]-1, $p[1]-$ry, 2, 2)
			GUICtrlSetBkColor($point1, 0xFF0000)
			GUICtrlSetState($point1,$GUI_SHOW)
			Sleep(300)
		 ElseIf $point2=0 Then
			$point2 = GUICtrlCreateLabel("", $p[0]-1, $p[1]-$ry, 2, 2)
			GUICtrlSetBkColor($point2, 0xFF0000)
			GUICtrlSetState($point2,$GUI_SHOW)
			
			If $p[0]<$prevx Then
			   $tmp = $prevx
			   $prevx = $p[0]
			   $p[0] = $tmp
			EndIf
			If $p[1]<$prevy Then
			   $tmp = $prevy
			   $prevy = $p[1]
			   $p[1] = $tmp
			EndIf
			
			$x1 = Round(224*($prevx-75)/504)
			$x2 = Round(224*($p[0]-75)/504)
			$y1 = Round(224*($prevy-134)/504)
			$y2 = Round(224*($p[1]-134)/504)
			
			$line1 = GUICtrlCreateLabel("", $prevx-1, $prevy-$ry, $p[0]-$prevx, 2)
			GUICtrlSetBkColor($line1, 0xFF0000)
			GUICtrlSetState($line1,$GUI_SHOW)
			
			$line2 = GUICtrlCreateLabel("", $prevx-1, $prevy-$ry, 2, $p[1]-$prevy)
			GUICtrlSetBkColor($line2, 0xFF0000)
			GUICtrlSetState($line2,$GUI_SHOW)
			
			$line3 = GUICtrlCreateLabel("", $p[0]-1, $prevy-$ry, 2, $p[1]-$prevy)
			GUICtrlSetBkColor($line3, 0xFF0000)
			GUICtrlSetState($line3,$GUI_SHOW)
			
			$line4 = GUICtrlCreateLabel("", $prevx-1, $p[1]-$ry, $p[0]-$prevx, 2)
			GUICtrlSetBkColor($line4, 0xFF0000)
			GUICtrlSetState($line4,$GUI_SHOW)
			
		 EndIf
	  EndIf
   ElseIf _ispressed(2) Then
	  $state = checkPos($p)
	  If $state=6 Then
		 resetRoi()
	  EndIf
   EndIf
WEnd

Func flash($tmp)
   GUICtrlSetState($tmp,$GUI_SHOW)
   Sleep(100)
   GUICtrlSetState($tmp,$GUI_HIDE)
EndFunc

Func resetRoi()
   GUICtrlSetState($line1,$GUI_HIDE)
   GUICtrlSetState($line2,$GUI_HIDE)
   GUICtrlSetState($line3,$GUI_HIDE)
   GUICtrlSetState($line4,$GUI_HIDE)
   GUICtrlSetState($point1,$GUI_HIDE)
   GUICtrlSetState($point2,$GUI_HIDE)
   $line1 = 0
   $line2 = 0
   $line3 = 0
   $line4 = 0
   $point1 =0
   $point2 = 0
EndFunc

Func CopyUNC()
   Local $saveClip = ""
   Local $filesFolders = ""
   Local $handle = _WinAPI_GetForegroundWindow()
   Local $className = _WinAPI_GetClassName($handle)
   If $className = "ExploreWClass" Or $className = "CabinetWClass" Then
	  $saveClip = ClipGet()
	  Send("^c")
	  Sleep(50) ; give clipboard time to react
	  $filesFolders = ClipGet()
	  ClipPut($saveClip)
   EndIf
   Return $saveClip
EndFunc
   
Func checkPos($p)
   If $p[0]<=290  And $p[0]>=76  And $p[1]<=104  And $p[1]>=51  Then
	  Return 1
   ElseIf $p[0]<=1205  And $p[0]>=989  And $p[1]<=104  And $p[1]>=51  Then
	  Return 2
   ElseIf $p[0]<=290  And $p[0]>=75  And $p[1]<=726  And $p[1]>=673  Then
	  Return 3
   ElseIf $p[0]<=574  And $p[0]>=359  And $p[1]<=726  And $p[1]>=673  Then
	  Return 4
   ElseIf $p[0]<=920  And $p[0]>=705  And $p[1]<=726  And $p[1]>=673  Then
	  Return 5
   ElseIf $p[0]<=576  And $p[0]>=75  And $p[1]<=637  And $p[1]>=134  Then
	  Return 6
   EndIf
   Return 0
EndFunc

Func stop()
   FileDelete(@WorkingDir & "\bin\input.jpg")
   FileDelete(@WorkingDir & "\bin\segment.jpg")
   Exit
EndFunc