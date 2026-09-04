; %APPDATA%/Microsoft/Windows/Start Menu/Programs/Startup/CapsLock+.ahk
#Requires AutoHotkey 2.0+
#SingleInstance Force

LShift & RShift::Capslock
RShift & LShift::Capslock

hook := InputHook("B L1", "{Esc}")
sendEsc := true
*CapsLock::
{
	hook.Start()
	reason := hook.Wait()
	global sendEsc
	if (reason = "Stopped") {
		if (sendEsc) {
			Send "{Esc}"
		} else {
			sendEsc := true
		}
	} else if (reason = "Max") {
		Send "{Blind}{Ctrl down}" hook.Input
	}
}
*CapsLock up::
{
	if (hook.InProgress) {
		hook.Stop()
	} else {
		Send "{Ctrl up}"
	}
}
S_Down(action) {
	Critical "On"
	global sendEsc := false
    SetKeyDelay -1
    Send "{Blind}{" action " DownR}"
	Critical "Off"
}
S_Up(action) {
	Critical "On"
    SetKeyDelay -1
    Send "{Blind}{" action " Up}"
	Critical "Off"
}
#HotIf GetKeyState("Capslock", "P")
*h::S_Down("Left")
*h up::S_Up("Left")
*j::S_Down("Down")
*j up::S_Up("Down")
*k::S_Down("Up")
*k up::S_Up("Up")
*l::S_Down("Right")
*l up::S_Up("Right")
*n::S_Down("Home")
*n up::S_Up("Home")
*m::S_Down("End")
*m up::S_Up("End")
#HotIf