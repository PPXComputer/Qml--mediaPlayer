#ifndef MYSQL_H
#define MYSQL_H
#include "mythread.h"
#include <QObject>
#include <QThread>
#include <QUrl>
#include <QtDebug>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlError>
#include <QtSql/QSqlQuery>
#include <QtSql/QSqlRecord>
class MySql : public QObject
{
    Q_OBJECT
public:
    explicit MySql(QObject *parent = nullptr);
    bool connectDatabase();

signals:
    void successConnect();
    void somethingChanged();
public slots:

    Q_INVOKABLE bool insertMusic(const QString &musicName,
                                 const QString &artist,
                                 const QString &album,
                                 const QString &duration,
                                 const QString &filePath);

    Q_INVOKABLE bool removeMusic(QString &filepath);

    Q_INVOKABLE bool insertTourList(QString &className, QString &dataArray);
    Q_INVOKABLE bool removeList(QString &className, QString &dataArray);

    Q_INVOKABLE bool getMusicFile(QUrl urls);
signals:
    // 在歌单进行改变的时候 进行的变化
    void dataArrayChanged(const QString &dataArray);
    void insertCompeleted(); //插入文件完成时触发此操作
    void getFile(QUrl &urls);

private:
    //Q_INVOKABLE bool changedTourListName(QString &clasName, QString &dataArray);
    inline bool printError(QSqlQuery &query)
    {
        if (!query.exec()) {
            qDebug() << query.lastError();
            return false;
        }
        emit somethingChanged();
        return true;
    }

private:
    MyThead myThead;
    QSqlDatabase database;
    QSqlQuery query;
    QStringList songList; //保存着歌单
};

#endif // MYSQL_H
