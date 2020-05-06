#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include <QQmlContext>

#include "app.h"
#include "persistent_cookie_jar.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    App* controller = new App();

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
        QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    engine.rootContext()->setContextProperty("TIMEIT_FRONTEND_URL", TIMEIT_FRONTEND_URL);
    engine.rootContext()->setContextProperty("TIMEIT_BACKEND_URL", TIMEIT_BACKEND_URL);

    const int returnCode = app.exec();

    // Destructor saves the PersistentCookieJar
    delete controller->networkManager->cookieJar();

    return returnCode;
}

