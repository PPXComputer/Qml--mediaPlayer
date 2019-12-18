#include "mysql.h"

MySql::MySql(QObject *parent) : QObject(parent)
{
    connect(&myThead, &MyThead::compeleted, this, [this] { emit somethingChanged(); });
    connect(this, &MySql::getFile, &myThead, &MyThead::getFile);
    connect(&myThead, &MyThead::insertMusic, this, &MySql::insertMusic);
    connectDatabase();
}

bool MySql::connectDatabase()
{
    if(QSqlDatabase::contains("qt_sql_default_connection"))
        database = QSqlDatabase::database("qt_sql_default_connection");
    else
        database = QSqlDatabase::addDatabase("QSQLITE");
    database.setDatabaseName ("music.db");
    if(database.open ()){
        //设置主键自增 插入 null值则可以 使用
        query = std::move(QSqlQuery(database));
        qDebug() << "数据库是否开始" << database.isOpen();

        query.exec(QString("select dataArray from tourList where className='创建的歌单'"));
        int fieldNo = query.record().indexOf("dataArray");
        if (query.next()) {
            songList = query.value(fieldNo).toString().split(QChar{','});
        }
        qDebug()<<"数据库中含有多少表格"<<this->database.tables ().length ();
        for(auto&tables: this->database.tables ()){
            qDebug()<<tables;
        }
        emit successConnect();



        return true;
    }
    else
    {
        auto dirvers=QSqlDatabase::drivers();
        qDebug()<<dirvers;
        return false;
    }
}

bool MySql::insertMusic(const QString &musicName,
                        const QString &artist,
                        const QString &album,
                        const QString &duration,
                        const QString &filePath)
{
    QUrl url = filePath;
    if (!filePath.startsWith("file:"))
        url = QUrl::fromLocalFile(filePath);

    qDebug() << "经过转化为的文件系统的路径为" << url.toString();
    query.prepare("INSERT INTO musicResource (musicName,artist,album,duration,filePath) "
                  "VALUES (?,?, ?, ?,?)");
    query.addBindValue(musicName);
    query.addBindValue(artist);
    query.addBindValue(album);
    query.addBindValue(duration);
    query.addBindValue(url.toString());
    return printError(query);
}

bool MySql::removeMusic(QString &filepath)
{
    if(filepath.isEmpty())return true;
    query.prepare(QString("delete from musicResource where filePath=?"));
    query.addBindValue(filepath);
    return printError(query);
}

bool MySql::insertTourList(QString &className, QString &dataArray)
{
    query.prepare("insert into tourList (className,dataArray) values (?,?)");
    query.addBindValue(className);
    query.addBindValue(dataArray);

    return printError(query);
}

bool MySql::removeList(QString &className, QString &dataArray)
{
    Q_UNUSED(className)
    Q_UNUSED(dataArray)
    //    query.prepare(QString("update tourList from dataArray=? where className= ?"));
    //    query.addBindValue(dataArray);
    //    query.addBindValue(className);
    //    if (printError(query)) {
    //        auto temp_songList = dataArray.split(',');
    //        int newSize = temp_songList.size();
    //        int oldSize = songList.size();
    //        if (newSize != oldSize) {
    //            query.prepare("create table song_source? "
    //                          "(id bigint autoincrement ,musicName varchar ,album varchar ,duration "
    //                          "varchar,artist varchar ,filePath varchar)");
    //            database.transaction();
    //            //当新增的时候 添加加入
    //            for (int var = oldSize; var < newSize; ++var) {

    //                query.addBindValue(QString::setNum(var));
    //                query.exec();
    //                query.clear();
    //            }
    //        }
    //        songList = std::move(temp_songList);
    //    }
    return false;
}

bool MySql::getMusicFile(QUrl urls)
{
    emit getFile(urls);
    return true;
}
