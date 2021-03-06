#include <QtGlobal>

#if defined(Q_OS_WIN32)

#include "windows_system.h"

WindowsSystem::WindowsSystem()
{
    qInfo() << "Loaded for Windows environment";
}

WindowsSystem::~WindowsSystem() {

}

// TODO: Comprobar nulos y resultados de las funciones
WindowsSystem::WindowProps WindowsSystem::getCurrentFocusedWindow()
{
    HWND hwnd = GetForegroundWindow();
    if (!hwnd) return WindowProps{};

    wchar_t windowName[200];
    GetWindowTextW(hwnd, windowName, 200);

    DWORD windowPid;
    GetWindowThreadProcessId(hwnd, &windowPid);

    HANDLE handle = OpenProcess(
                PROCESS_QUERY_INFORMATION | PROCESS_VM_READ,
                false,
                windowPid
    );

    if (!handle) return WindowProps{};

    wchar_t windowProcess[200];
    GetModuleFileNameEx(handle, NULL, windowProcess, 200);

    CloseHandle(handle);

    return WindowProps{
        QString::fromWCharArray(windowName),
        QString::fromWCharArray(windowProcess),
        (quint64) windowPid
    };
}

#endif // only for Q_OS_WIN32
