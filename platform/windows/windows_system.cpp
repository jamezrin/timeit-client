#include "windows_system.h"

#include <iostream>
#include <psapi.h>
#include <stdlib.h>

WindowsSystem::WindowsSystem()
{
    qInfo() << "Sistema inicializado para Windows";
}

WindowsSystem::~WindowsSystem() {

}

// TODO: Comprobar nulos y resultados de las funciones
WindowsSystem::WindowProps WindowsSystem::getCurrentFocusedWindow()
{
    HWND hwnd = GetForegroundWindow();

    char windowName[200];
    GetWindowTextA(hwnd, windowName, 200);

    DWORD windowPid;
    GetWindowThreadProcessId(hwnd, &windowPid);

    HANDLE handle = OpenProcess(
                PROCESS_QUERY_INFORMATION | PROCESS_VM_READ,
                false,
                windowPid
    );

    char windowProcess[200];
    GetModuleFileNameExA(handle, NULL, windowProcess, 200);

    CloseHandle(handle);

    return WindowProps{
        QString::fromUtf8(windowName),
        QString::fromUtf8(windowProcess),
        (qint16) windowPid
    };
}
