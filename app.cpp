#include "app.h"

#include "persistent_cookie_jar.h"
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

#include <QNetworkCookieJar>
#include <QMutexLocker>
#include <QSettings>
#include <QNetworkProxy>
#include <QUrlQuery>
#include <QNetworkConfiguration>

App::App()
{
    systemApi = getSystemApi();
    networkManager = new QNetworkAccessManager(this);

    QNetworkProxy proxy;
    proxy.setType(QNetworkProxy::HttpProxy);
    proxy.setHostName("localhost");
    proxy.setPort(8000);
    QNetworkProxy::setApplicationProxy(proxy);

    networkManager->setProxy(proxy);
    networkManager->setCookieJar(new PersistentCookieJar(networkManager));

    qDebug() << "Compiled targetting backend: " TIMEIT_BACKEND_URL;

    checkCurrentUser();

    QTimer* timer = new QTimer(this);

    // the preprocessor knows its the timeout() slot function inside timer
    // likewise, the preprocessor knows its the printWindow slot function inside this
    connect(timer, SIGNAL(timeout()), this, SLOT(printWindow()));

    timer->start(500);
}

 void App::authenticateUser()
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

void App::checkCurrentUser()
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

void App::printWindow()
{
    ISystem::WindowProps currentWindow = systemApi->getCurrentFocusedWindow();
    qDebug() << currentWindow.windowName
             << " " << currentWindow.windowClass
             << " " << currentWindow.windowPid;
}
