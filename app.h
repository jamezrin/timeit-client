#ifndef APP_H
#define APP_H

#include <QObject>
#include <QWidget>
#include <QTimer>
#include <QDebug>
#include <QNetworkAccessManager>
#include <QHttpMultiPart>
#include <QNetworkReply>
#include <QVariant>
#include <QNetworkCookie>

#include <platform/system.h>

class App : public QObject
{
    Q_OBJECT
public:
    App();

    void checkCurrentUser();
    void authenticateUser();

    mutable ISystem* systemApi;
    mutable QNetworkAccessManager* networkManager;
public slots:
    void printWindow();
};

#endif // APP_H
