#ifndef PERSISTENT_COOKIE_JAR_H
#define PERSISTENT_COOKIE_JAR_H

#include <QMutexLocker>
#include <QNetworkCookie>
#include <QNetworkCookieJar>
#include <QSettings>
#include <QDebug>

class PersistentCookieJar : public QNetworkCookieJar {
public:
    PersistentCookieJar(QObject *parent);
    ~PersistentCookieJar();
    virtual QList<QNetworkCookie> cookiesForUrl(const QUrl &url) const;
    virtual bool setCookiesFromUrl(const QList<QNetworkCookie> &cookieList, const QUrl &url);

private:
    void save();
    void load();

    mutable QMutex mutex;
};

#endif // PERSISTENT_COOKIE_JAR_H
