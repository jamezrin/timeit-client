#include <QtGlobal>

#if defined(Q_OS_LINUX)

#include "linux_system.h"

Display *display;
unsigned long window;

LinuxSystem::LinuxSystem()
{
    char *display_name = NULL;  // could be the value of $DISPLAY

    display = XOpenDisplay(display_name);
    if (display == NULL) {
        qDebug()
                << "Unable to open display "
                << XDisplayName(display_name);
    }

    qInfo() << "Sistema inicializado para Linux";
}

LinuxSystem::~LinuxSystem()
{
    XCloseDisplay(display);
}

const unsigned char* LinuxSystem::getStringProperty(const char *propertyName)
{
    unsigned char *prop;
    Atom actual_type, filter_atom;
    int actual_format, status;
    unsigned long nitems, bytes_after;

    filter_atom = XInternAtom(display, propertyName, True);
    status = XGetWindowProperty(display, window, filter_atom, 0, 1000, False, AnyPropertyType,
                                &actual_type, &actual_format, &nitems, &bytes_after, &prop);

    if (status == BadWindow) {
        qDebug() << "Could not find valid window " << window;
    }

    if (status != Success) {
        qDebug() << "XGetWindowProperty failed";
    }

    return prop;
}

unsigned long LinuxSystem::getLongProperty(const char *propertyName)
{
    const unsigned char* prop = getStringProperty(propertyName);

    if (prop == NULL) {
        return 0;
    }

    unsigned long long_property =
            prop[0] +
            (prop[1]<<8) +
            (prop[2]<<16) +
            (prop[3]<<24);

    return long_property;
}

LinuxSystem::WindowProps LinuxSystem::getCurrentFocusedWindow()
{
    int screen = XDefaultScreen(display);
    window = RootWindow(display, screen);

    window = getLongProperty("_NET_ACTIVE_WINDOW");

    return WindowProps{
        QString::fromUtf8((char*) getStringProperty("_NET_WM_NAME")),
        QString::fromUtf8((char*) getStringProperty("WM_CLASS")),
        (qint16) getLongProperty("_NET_WM_PID")
    };
}

#endif // only for Q_OS_LINUX
