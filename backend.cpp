#include "backend.h"

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

Backend::Backend(QObject &parent)
{
    systemApi = getSystemApi();
    networkManager = new QNetworkAccessManager(&parent);

    QNetworkProxy proxy;
    proxy.setType(QNetworkProxy::HttpProxy);
    proxy.setHostName("localhost");
    proxy.setPort(8000);
    QNetworkProxy::setApplicationProxy(proxy);

    networkManager->setProxy(proxy);
    networkManager->setCookieJar(new PersistentCookieJar(networkManager));

    checkCurrentUser();

    QTimer* timer = new QTimer(this);

    // the preprocessor knows its the timeout() slot function inside timer
    // likewise, the preprocessor knows its the printWindow slot function inside this
    connect(timer, SIGNAL(timeout()), this, SLOT(printWindow()));

    timer->start(500);
}

 void Backend::authenticateUser()
 {
     qDebug() << "Authenticating user...";

     QUrlQuery formData;
     formData.addQueryItem("emailAddress", "jaime43@jamezrin.name");
     formData.addQueryItem("password", "superpass");

     QNetworkRequest request(QUrl(TIMEIT_BACKEND_URL "/authenticate"));
     request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
     request.setAttribute(QNetworkRequest::CookieSaveControlAttribute, QNetworkRequest::Automatic);
     QNetworkReply *reply = networkManager->post(request, formData.toString(QUrl::FullyEncoded).toUtf8());

     connect(reply, &QNetworkReply::finished, [=]() {
         if(reply->error() == QNetworkReply::NoError)
         {
             QByteArray response = reply->readAll();
             qDebug() << response;

             qDebug() << "Authenticated the user, checking current user again...";
             checkCurrentUser();
         }
         else
         {
             qDebug() << "Error when authenticating " << reply->error();
         }
     });
 }

void Backend::checkCurrentUser()
{
    QNetworkRequest request(QUrl(TIMEIT_BACKEND_URL "/current-user"));
    request.setAttribute(QNetworkRequest::CookieLoadControlAttribute, QNetworkRequest::Automatic);
    QNetworkReply *reply = networkManager->get(request);
    connect(reply, &QNetworkReply::finished, [=]() {
        if(reply->error() == QNetworkReply::NoError)
        {
            qDebug() << "User is logged in!";

            QByteArray response = reply->readAll();
            qDebug() << response;
        }
        else if (reply->error() == QNetworkReply::AuthenticationRequiredError)
        {
            qDebug() << "User is not authenticated, authenticating...";
            authenticateUser();
        }
        else
        {
            qDebug() << "Different error " << reply->error();
        }
    });
}

void Backend::printWindow()
{
    ISystem::WindowProps currentWindow = systemApi->getCurrentFocusedWindow();
    qDebug() << currentWindow.windowName
             << " " << currentWindow.windowClass
             << " " << currentWindow.windowPid;
}

void Backend::sayHi()
{
    qDebug() << "Hi world";
}
