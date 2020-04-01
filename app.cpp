#include "app.h"

#include "platform/system.h"

#if defined(Q_OS_LINUX)
    #include "platform/linux_x11/linux_system.h"
#elif defined(Q_OS_WIN)
    #include "platform/windows/windows_system.h"
#endif

ISystem* getSystemApi()
{
#if defined(Q_OS_LINUX)
    return new LinuxSystem();
#elif defined(Q_OS_WIN)
    return new WindowsSystem();
#else
    #error "Plataforma no soportada"
#endif
}

ISystem* systemApi;

App::App()
{
    systemApi = getSystemApi();

    QTimer* timer = new QTimer(this);

    // the preprocessor knows its the timeout() slot function inside timer
    // likewise, the preprocessor knows its the printWindow slot function inside this
    connect(timer, SIGNAL(timeout()), this, SLOT(printWindow()));

    timer->start(500);
}

void App::printWindow()
{
    ISystem::WindowProps currentWindow = systemApi->getCurrentFocusedWindow();
    qDebug() << currentWindow.windowName
             << " " << currentWindow.windowClass
             << " " << currentWindow.windowPid;
}
