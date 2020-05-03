#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDebug>

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

    int returnCode = app.exec();
    qDebug() << "Aplication is exiting...";

    QNetworkCookieJar *cookieJar = controller->networkManager->cookieJar();
    PersistentCookieJar *persistentCookieJar = dynamic_cast<PersistentCookieJar*>(cookieJar);
    persistentCookieJar->save();

    return returnCode;
}

