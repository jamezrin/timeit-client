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

class App : public QObject
{
    Q_OBJECT
public:
    App();

public slots:
    void printWindow();
};

#endif // APP_H
