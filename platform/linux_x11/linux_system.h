#ifndef LINUX_SYSTEM_H
#define LINUX_SYSTEM_H

#include "../system.h"

#include <X11/Xlib.h>

class LinuxSystem : public ISystem
{
public:
    LinuxSystem();
    ~LinuxSystem();

    virtual WindowProps getCurrentFocusedWindow();

private:
    const unsigned char* getStringProperty(const char* propertyName);
    unsigned long getLongProperty(const char* propertyName);
};

#endif // LINUX_SYSTEM_H
