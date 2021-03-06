#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include <QQmlContext>
#include <QIcon>

#include "backend.h"
#include "persistent_cookie_jar.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    Backend backend(app);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("TIMEIT_FRONTEND_URL", TIMEIT_FRONTEND_URL);
    engine.rootContext()->setContextProperty("TIMEIT_BACKEND_URL", TIMEIT_BACKEND_URL);
    engine.rootContext()->setContextProperty("backend", &backend);

    app.setWindowIcon(QIcon(":/assets/logo/main_256.png"));

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
        QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    qDebug() << "SSL Supported:" << QSslSocket::supportsSsl();
    qDebug() << "SSL Library Build Version:" << QSslSocket::sslLibraryBuildVersionString();
    qDebug() << "SSL Library Current Version:" << QSslSocket::sslLibraryVersionString();

    return app.exec();
}

