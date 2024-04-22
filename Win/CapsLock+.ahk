; C:/Users/L/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup/CapsLock+.ahk

#Requires AutoHotkey 2.0+
#SingleInstance Force

LShift & RShift::Capslock
RShift & LShift::Capslock

hook := InputHook("B L1 T0.2", "{Esc}")
*CapsLock::
{
	hook.Start()
	reason := hook.Wait()
	if (reason = "Stopped") {
		Send "{Esc}"
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
h::Left
j::Down
k::Up
l::Right
n::Home
m::End
#HotIf