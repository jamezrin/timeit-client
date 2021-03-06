QT += quick widgets network

CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

RESOURCES += qml.qrc

TRANSLATIONS += \
    timeit-client_es_ES.ts

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

CONFIG(debug, debug|release) {
    DEFINES += TIMEIT_BACKEND_URL=\\\"http://127.0.0.1:7001\\\"
    DEFINES += TIMEIT_FRONTEND_URL=\\\"http://127.0.0.1:3000\\\"
}

CONFIG(release, debug|release) {
    DEFINES += TIMEIT_BACKEND_URL=\\\"https://timeit.jamezrin.name/api\\\"
    DEFINES += TIMEIT_FRONTEND_URL=\\\"https://timeit.jamezrin.name\\\"
}

HEADERS += \
    backend.h \
    persistent_cookie_jar.h \
    platform/system.h \
    platform/linux_x11/linux_system.h \
    platform/windows/windows_system.h

SOURCES += \
    backend.cpp \
    main.cpp \
    persistent_cookie_jar.cpp \
    platform/linux_x11/linux_system.cpp \
    platform/windows/windows_system.cpp

win32 {
    CONFIG += windows
    LIBS += -lpsapi -luser32
    RC_ICONS += timeit.ico
}

unix {
    CONFIG += x11
}

