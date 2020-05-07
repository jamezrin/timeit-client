#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QWidget>
#include <QTimer>
#include <QDebug>
#include <QVariant>
#include <QSettings>
#include <QMutexLocker>
#include <QUrlQuery>
#include <QHttpMultiPart>
#include <QNetworkReply>
#include <QNetworkProxy>
#include <QNetworkCookie>
#include <QNetworkCookieJar>
#include <QNetworkAccessManager>
#include <QNetworkConfiguration>

#include "persistent_cookie_jar.h"
#include "platform/system.h"

class Backend : public QObject
{
    Q_OBJECT
public:
    Backend(QObject &parent);

    void checkCurrentUser();
    void authenticateUser();

    mutable ISystem* systemApi;
    mutable QNetworkAccessManager* networkManager;
public slots:
    void printWindow();
    void sayHi();
};

#endif // BACKEND_H
