#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include <QQmlContext>

#include "backend.h"
#include "persistent_cookie_jar.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("TIMEIT_FRONTEND_URL", TIMEIT_FRONTEND_URL);
    engine.rootContext()->setContextProperty("TIMEIT_BACKEND_URL", TIMEIT_BACKEND_URL);

    Backend backend(app);
    engine.rootContext()->setContextProperty("backend", &backend);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
        QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    qDebug() << "frontend url: " TIMEIT_FRONTEND_URL;
    qDebug() << "backend url: " TIMEIT_BACKEND_URL;

    return app.exec();
}

