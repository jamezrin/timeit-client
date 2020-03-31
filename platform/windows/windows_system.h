#ifndef WINDOWS_SYSTEM_H
#define WINDOWS_SYSTEM_H

#include "../system.h"

class WindowsSystem : public ISystem
{
public:
    WindowsSystem();
    ~WindowsSystem();

    virtual WindowProps getCurrentFocusedWindow();
};

#endif // WINDOWS_SYSTEM_H
