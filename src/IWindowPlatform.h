#pragma once

#if defined(_WIN32)
#define WIN32_LEAN_AND_MEAN
#include <windows.h>

namespace IWindow {
	typedef HWND NativeWindowHandle;
}

#endif



