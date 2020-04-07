#ifndef ISYSTEM_H
#define ISYSTEM_H

#include <QString>
#include <QDebug>

class ISystem {
public:
    struct WindowProps {
        QString windowName;
        QString windowClass;
        quint64 windowPid;
    };

    virtual WindowProps getCurrentFocusedWindow() = 0;
};

#endif // ISYSTEM_H
