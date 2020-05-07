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

void setupProxy(QNetworkAccessManager *networkManager) {
    QNetworkProxy proxy;
    proxy.setType(QNetworkProxy::HttpProxy);
    proxy.setHostName("localhost");
    proxy.setPort(8000);
    networkManager->setProxy(proxy);
}

Backend::Backend(QObject &parent)
{
    systemApi = getSystemApi();
    networkManager = new QNetworkAccessManager(&parent);
    networkManager->setCookieJar(new PersistentCookieJar(networkManager));
    setupProxy(networkManager);
}

QNetworkReply* Backend::fetchCurrentUser() const
{
    QNetworkRequest request(QUrl(TIMEIT_BACKEND_URL "/current-user"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    QNetworkReply *reply = networkManager->get(request);

    return reply;
}

void Backend::js_fetchCurrentUser(const QJSValue &callback) const
{
    QNetworkReply* reply = fetchCurrentUser();
    connect(reply, &QNetworkReply::finished, [=]() {
        QJSValue cbCopy(callback);
        QJSEngine *engine = qjsEngine(this);
        cbCopy.call(QJSValueList {
                        engine->toScriptValue(reply->readAll()),
                        engine->toScriptValue(reply->error())
        });
        reply->deleteLater();
    });
}

QNetworkReply* Backend::deauthenticateUser() const
{
    QNetworkRequest request(QUrl(TIMEIT_BACKEND_URL "/deauthenticate"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    QNetworkReply *reply = networkManager->post(request, QByteArray());

    return reply;
}

void Backend::js_deauthenticateUser(const QJSValue &callback) const
{
    QNetworkReply* reply = deauthenticateUser();
    connect(reply, &QNetworkReply::finished, [=]() {
        QJSValue cbCopy(callback);
        QJSEngine *engine = qjsEngine(this);
        cbCopy.call(QJSValueList {
                        engine->toScriptValue(reply->readAll()),
                        engine->toScriptValue(reply->error())
        });
        reply->deleteLater();
    });
}

QNetworkReply* Backend::authenticateUser(QString &emailAddress,
                                         QString &password) const
{
    QUrlQuery formData;
    formData.addQueryItem("emailAddress", emailAddress);
    formData.addQueryItem("password", password);

    QNetworkRequest request(QUrl(TIMEIT_BACKEND_URL "/authenticate"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    QNetworkReply *reply = networkManager->post(request, formData.toString(QUrl::FullyEncoded).toUtf8());

    return reply;
}

void Backend::js_authenticateUser(QString &emailAddress, QString &password, const QJSValue &callback) const
{
    QNetworkReply* reply = authenticateUser(emailAddress, password);
    connect(reply, &QNetworkReply::finished, [=]() {
        QJSValue cbCopy(callback);
        QJSEngine *engine = qjsEngine(this);
        cbCopy.call(QJSValueList {
                        engine->toScriptValue(reply->readAll()),
                        engine->toScriptValue(reply->error())
        });
        reply->deleteLater();
    });
}

QNetworkReply* Backend::fetchProjectList() const
{
    QNetworkRequest request(QUrl(TIMEIT_BACKEND_URL "/projects"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    QNetworkReply *reply = networkManager->get(request);

    return reply;
}

void Backend::js_fetchProjectList(const QJSValue &callback) const
{
    QNetworkReply* reply = fetchProjectList();
    connect(reply, &QNetworkReply::finished, [=]() {
        QJSValue cbCopy(callback);
        QJSEngine *engine = qjsEngine(this);
        cbCopy.call(QJSValueList {
                        engine->toScriptValue(reply->readAll()),
                        engine->toScriptValue(reply->error())
        });
        reply->deleteLater();
    });
}

QNetworkReply* Backend::createSession(quint32 projectId) const
{
    QNetworkRequest request(QUrl(QString("%s/projects/%d/sessions").arg(TIMEIT_BACKEND_URL, projectId)));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    QNetworkReply *reply = networkManager->post(request, QByteArray());

    return reply;
}

void Backend::js_createSession(quint32 projectId, const QJSValue &callback) const
{
    QNetworkReply* reply = createSession(projectId);
    connect(reply, &QNetworkReply::finished, [=]() {
        QJSValue cbCopy(callback);
        QJSEngine *engine = qjsEngine(this);
        cbCopy.call(QJSValueList {
                        engine->toScriptValue(reply->readAll()),
                        engine->toScriptValue(reply->error())
        });
        reply->deleteLater();
    });
}

QNetworkReply* Backend::sendNote(quint32 sessionId, QString &noteText) const
{
    QUrlQuery formData;
    formData.addQueryItem("noteText", noteText);

    QNetworkRequest request(QUrl(QString("%s/sessions/%d/notes").arg(TIMEIT_BACKEND_URL, sessionId)));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    QNetworkReply *reply = networkManager->post(request, formData.toString(QUrl::FullyEncoded).toUtf8());

    return reply;
}

void Backend::js_sendNote(quint32 sessionId, QString &noteText, const QJSValue &callback) const
{
    QNetworkReply* reply = sendNote(sessionId, noteText);
    connect(reply, &QNetworkReply::finished, [=]() {
        QJSValue cbCopy(callback);
        QJSEngine *engine = qjsEngine(this);
        cbCopy.call(QJSValueList {
                        engine->toScriptValue(reply->readAll()),
                        engine->toScriptValue(reply->error())
        });
        reply->deleteLater();
    });
}

QNetworkReply* Backend::sendAppEvent(quint32 sessionId, ISystem::WindowProps &windowProps) const
{
    QUrlQuery formData;
    formData.addQueryItem("windowName", windowProps.windowName);
    formData.addQueryItem("windowClass", windowProps.windowClass);
    formData.addQueryItem("windowPid", QString::number(windowProps.windowPid));

    QNetworkRequest request(QUrl(QString("%s/sessions/%d/app_events").arg(TIMEIT_BACKEND_URL, sessionId)));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    QNetworkReply *reply = networkManager->post(request, formData.toString(QUrl::FullyEncoded).toUtf8());

    return reply;
}

QNetworkReply* Backend::createAppEvent(quint32 sessionId) const
{
    ISystem::WindowProps windowProps = systemApi->getCurrentFocusedWindow();
    return sendAppEvent(sessionId, windowProps);
}

void handleReplyCallback(QNetworkReply *reply, const QJSValue &callback)
{
    connect(reply, &QNetworkReply::finished, [=]() {
        QJSValue cbCopy(callback);
        QJSEngine *engine = qjsEngine(this);
        cbCopy.call(QJSValueList {
                        engine->toScriptValue(reply->readAll()),
                        engine->toScriptValue(reply->error())
        });
        reply->deleteLater();
    });
}

void Backend::js_createAppEvent(quint32 sessionId, const QJSValue &callback) const
{
    QNetworkReply* reply = createAppEvent(sessionId);
    handleReplyCallback(reply, callback);
    connect(reply, &QNetworkReply::finished, [=]() {
        QJSValue cbCopy(callback);
        QJSEngine *engine = qjsEngine(this);
        cbCopy.call(QJSValueList {
                        engine->toScriptValue(reply->readAll()),
                        engine->toScriptValue(reply->error())
        });
        reply->deleteLater();
    });
}


