#include <QtGlobal>

#if defined(Q_OS_WIN32) && !defined(WINDOWS_SYSTEM_H)

#define WINDOWS_SYSTEM_H

#include "../system.h"

#include <Windows.h>
#include <iostream>
#include <psapi.h>
#include <stdlib.h>

class WindowsSystem : public ISystem
{
public:
    WindowsSystem();
    ~WindowsSystem();

    virtual WindowProps getCurrentFocusedWindow();
};

#endif // only for Q_OS_WIN32 and WINDOWS_SYSTEM_H guard
