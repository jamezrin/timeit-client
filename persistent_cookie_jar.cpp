#include "persistent_cookie_jar.h"

PersistentCookieJar::PersistentCookieJar(QObject *parent) : QNetworkCookieJar(parent)
{
    load();
}

PersistentCookieJar::~PersistentCookieJar()
{
    save();
}

QList<QNetworkCookie> PersistentCookieJar::cookiesForUrl(const QUrl &url) const
{
    QMutexLocker lock(&mutex);
    QList<QNetworkCookie> cookieList = QNetworkCookieJar::cookiesForUrl(url);
    qDebug() << "Getting urls from url " << url << " : " << cookieList;
    return cookieList;
}

bool PersistentCookieJar::setCookiesFromUrl(const QList<QNetworkCookie> &cookieList, const QUrl &url)
{
    QMutexLocker lock(&mutex);
    bool result = QNetworkCookieJar::setCookiesFromUrl(cookieList, url);
    qDebug() << "Setting urls from " << url << " : " << cookieList << " success: " << result;
    return result;
}

void PersistentCookieJar::save()
{
    QMutexLocker lock(&mutex);
    QList<QNetworkCookie> list = allCookies();
    QByteArray data;
    foreach (QNetworkCookie cookie, list) {
        qDebug() << "Found cookie when saving: " << cookie;
        if (!cookie.isSessionCookie()) {
            data.append(cookie.toRawForm());
            data.append("\n");
        }
    }
    QSettings settings;
    settings.setValue("Cookies", data);
    qDebug() << "Saving persistent CookieJar to " << settings.fileName();
}

void PersistentCookieJar::load()
{
    QMutexLocker lock(&mutex);
    QSettings settings;


    qDebug() << "Loading persistent CookieJar from " << settings.fileName();
    QByteArray data = settings.value("Cookies").toByteArray();
    setAllCookies(QNetworkCookie::parseCookies(data));
}
