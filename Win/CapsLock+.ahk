; C:/Users/L/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup/CapsLock+.ahk

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

#HotIf GetKeyState("Capslock","P")
*h::
{
	global sendEsc := false
	SetKeyDelay -1
	Send "{Blind}{Left DownR}"
}
*h up::
{
	SetKeyDelay -1
	Send "{Blind}{Left Up}"
}
*j::
{
	global sendEsc := false
	SetKeyDelay -1
	Send "{Blind}{Down DownR}"
}
*j up::
{
	SetKeyDelay -1
	Send "{Blind}{Down Up}"
}
*k::
{
	global sendEsc := false
	SetKeyDelay -1
	Send "{Blind}{Up DownR}"
}
*k up::
{
	SetKeyDelay -1
	Send "{Blind}{Up Up}"
}
*l::
{
	global sendEsc := false
	SetKeyDelay -1
	Send "{Blind}{Right DownR}"
}
*l up::
{
	SetKeyDelay -1
	Send "{Blind}{Right Up}"
}
*n::
{
	global sendEsc := false
	SetKeyDelay -1
	Send "{Blind}{Home DownR}"
}
*n up::
{
	SetKeyDelay -1
	Send "{Blind}{Home Up}"
}
*m::
{
	global sendEsc := false
	SetKeyDelay -1
	Send "{Blind}{End DownR}"
}
*m up::
{
	SetKeyDelay -1
	Send "{Blind}{End Up}"
}
#HotIf