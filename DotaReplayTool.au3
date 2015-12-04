Global $appname = "Dota Replay Tool"
If @OSArch = "X64" Then
	Global $pathToDota = "C:\Program Files (x86)\Steam\steamapps\common\dota 2 beta\game\bin\win64\dota2.exe"
	Global $path = "C:\Program Files (x86)\Steam\steamapps\common\dota 2 beta\game\dota\replays\"
Else
	Global $pathToDota = "C:\Program Files\Steam\steamapps\common\dota 2 beta\game\bin\win32\dota2.exe"
	Global $path = "C:\Program Files\Steam\steamapps\common\dota 2 beta\game\dota\replays\"
EndIf
If $cmdlineraw <> "" Then
	FileDropped()
Else
	DownloadFromUrl()
EndIf
Exit
Func FileDropped()
	For $i = 1 To $cmdline[0];Process each cmdline entry. In other words, get all files dropped and copy them.
		Local $iRet = FileCopy($cmdline[$i], $path, 1);copy dropped file $i to path, where $i represents the number in the order you dropped the files.
		If $iRet = 0 Then
			MsgBox(16, $appname, "Error copying " & $cmdline[$i] & " to " & $path & @CRLF & "Set this script to always run as admin and try again.");If failed, give error message with info.
			Exit
		EndIf
	Next
	MsgBox(0, $appname, "Processed " & $cmdline[0] & " files.")
EndFunc   ;==>FileDropped
Func DownloadFromUrl()
	Do
		$iUrl = InputBox($appname, "Where is the replay stored at?" & @CRLF & "This must be a URL." & @CRLF & "Files can simply be dragged and dropped to copied to the Replay Folder.")
		If @error Then Exit
		If $iUrl = "" Then MsgBox(16, $appname, "Url cannot be blank.")
	Until $iUrl <> ""
	If @error Then Exit
	Do
		$iMatchID = InputBox($appname, "What is the Match ID?")
		If @error Then Exit
		If $iMatchID = "" Then MsgBox(16, $appname, "Filename cannot be blank.")
	Until $iMatchID <> ""
	Local $iFilename = $path & $iMatchID & ".dem"
	$iDownload = InetGet($iUrl, $iFilename, 1)
	If @error Then
		MsgBox(16, $appname, "An error occured during downloading.")
	ElseIf $iDownload = 0 Then
		MsgBox(16, $appname, "An error occured during downloading.")
	ElseIf Not FileExists($path & $iMatchID & ".dem") Then
		MsgBox(16, $appname, "An error occured during saving.")
	Else
		Local $iRet = MsgBox(4, $appname, "Success! Would you like to download another file?")
		If $iRet = 6 Then DownloadFromUrl()
		If $iRet = 7 Then
			$iRun = MsgBox(4, $appname, "Would you like to watch the replay now?" & @CRLF & " This operation will close Dota 2 if it is already open.")
			If $iRun = 6 Then
				ShellExecuteWait("cmd.exe", "/c taskkill /im:dota2.exe /F", "", "", @SW_HIDE)
				ShellExecute($pathToDota, "+playdemo " & $iMatchID & ".dem")
			EndIf
			Return 1
		EndIf
	EndIf
EndFunc   ;==>DownloadFromUrl


