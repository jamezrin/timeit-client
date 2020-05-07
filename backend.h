#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QWidget>
#include <QTimer>
#include <QDebug>
#include <QString>
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
#include <QJsonDocument>
#include <QJsonObject>
#include <QJSEngine>
#include <QJSValue>

#include "persistent_cookie_jar.h"
#include "platform/system.h"

class Backend : public QObject
{
    Q_OBJECT
public:
    Backend(QObject &parent);

    mutable ISystem *systemApi;
    mutable QNetworkAccessManager *networkManager;

public slots:
    QNetworkReply* fetchCurrentUser() const;
    void js_fetchCurrentUser(const QJSValue &callback) const;

    QNetworkReply* deauthenticateUser() const;
    void js_deauthenticateUser(const QJSValue &callback) const;

    QNetworkReply* authenticateUser(QString &emailAddress, QString &password) const;
    void js_authenticateUser(QString &emailAddress, QString &password, const QJSValue &callback) const;

    QNetworkReply* fetchProjectList() const;
    void js_fetchProjectList(const QJSValue &callback) const;

    QNetworkReply* createSession(quint32 projectId) const;
    void js_createSession(quint32 projectId, const QJSValue &callback) const;

    QNetworkReply* sendNote(quint32 sessionId, QString &noteText) const;
    void js_sendNote(quint32 sessionId, QString &noteText, const QJSValue &callback) const;

    QNetworkReply* sendAppEvent(quint32 sessionId, ISystem::WindowProps &windowProps) const;
    QNetworkReply* createAppEvent(quint32 sessionId) const;
    void js_createAppEvent(quint32 sessionId, const QJSValue &callback) const;
};

#endif // BACKEND_H
