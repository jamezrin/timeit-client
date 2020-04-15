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
QNetworkAccessManager* manager;

App::App()
{
    systemApi = getSystemApi();
    manager = new QNetworkAccessManager(this);

    QTimer* timer = new QTimer(this);

    // the preprocessor knows its the timeout() slot function inside timer
    // likewise, the preprocessor knows its the printWindow slot function inside this
    connect(timer, SIGNAL(timeout()), this, SLOT(printWindow()));

    timer->start(500);
}

void App::printWindow()
{
    QHttpMultiPart *multiPart = new QHttpMultiPart(QHttpMultiPart::ContentType::FormDataType);
    QNetworkReply *reply = manager->post(QNetworkRequest(QUrl("http://localhost:7001/set-cookie")), multiPart);
    connect(reply, &QNetworkReply::finished, [=]() {
        if(reply->error() == QNetworkReply::NoError)
        {
            // https://doc.qt.io/qt-5/qnetworkcookiejar.html
            //qDebug() << reply->manager()->cookieJar();
            QVariant variant = reply->header(QNetworkRequest::KnownHeaders::SetCookieHeader);
            for (QNetworkCookie cookie : variant.value<QList<QNetworkCookie>>())
            {
                qDebug() << cookie;
            }
            QByteArray response = reply->readAll();
            qDebug() << response;
        }
        else
        {
            qDebug() << reply->errorString();
        }
    });

    ISystem::WindowProps currentWindow = systemApi->getCurrentFocusedWindow();
    qDebug() << currentWindow.windowName
             << " " << currentWindow.windowClass
             << " " << currentWindow.windowPid;
}
