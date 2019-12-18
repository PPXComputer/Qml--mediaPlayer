#include "mymodel.h"

MyModel::MyModel(QObject *parent,QSqlDatabase db) : QSqlTableModel (parent,db)
{

    qDebug()<<"设置数据库的名字为"<<this->database ().tables ();


    initHeader();
    setEditStrategy(QSqlTableModel::EditStrategy::OnManualSubmit);
    for (int var = 0; var < this->columnCount(); ++var) {
        QSqlTableModel::setSort(var, Qt::AscendingOrder);
    }
    // 当重新设置 表格 名字 和 类型的时候 进行更新
    connect(this,&MyModel::isViewChanged,this,&MyModel::initHeader);
    connect(this, &MyModel::tableNameChanged, this, [this](const QString  & tableName){

        this->setTable(tableName);
        qDebug() << "提交操作";
        submitAll(); // 在重新设置的时候 刷新操作

        qDebug()<<"表格名字设置成功  最后一次错误为"<<this->lastError ();
    });
}

QVariant MyModel::data(const QModelIndex &index, int role) const
{
    QVariant value = QSqlTableModel::data(index, role);
    if (role < Qt::UserRole) {
        value = QSqlTableModel::data(index, role);
    } else {
        int columnIdx = role - Qt::UserRole - 1;
        QModelIndex modelIndex = this->index(index.row(), columnIdx);
        value = QSqlTableModel::data(modelIndex, Qt::DisplayRole);
    }
    return value;
}

bool MyModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    bool ret;
    if (role < Qt::UserRole) {
        ret = QSqlTableModel::setData(index, value, role);
    } else {
        int colIdx = role - Qt::UserRole - 1;
        ret = QSqlTableModel::setData(this->index(index.row(), colIdx), value, Qt::DisplayRole);
    }
    return ret;
}

QHash<int, QByteArray> MyModel::roleNames() const
{
    //设置为 UseRole使用的大量数据
    QHash<int, QByteArray> roleNames;
    for (int i = 0; i < record().count(); i++) {
        roleNames[Qt::UserRole + i + 1] = record().fieldName(i).toUtf8();
    }
    for (auto &&sd : roleNames.values()) {
        qDebug() << "该行的名字为" << sd;
    }
    return roleNames;
}

void MyModel::initHeader()
{

    if(isView){
        //此处为显示 id的部分 不需要显示出来
        this->setHeaderData(0, Qt::Horizontal,"  ");
        this->setHeaderData(1, Qt::Horizontal, QString("歌曲"));
        this->setHeaderData(2, Qt::Horizontal, QString("歌手"));
        this->setHeaderData(3, Qt::Horizontal, QString("专辑"));
        this->setHeaderData(4, Qt::Horizontal, QString("时长"));
        }
    else{
        // 这里显示的是主文件 当其他的列表出现的 时候 均是使用的视图
        this->setHeaderData(0, Qt::Horizontal,QString("id"));
        this->setHeaderData(1, Qt::Horizontal, QString("歌曲"));
        this->setHeaderData(2, Qt::Horizontal, QString("歌手"));
        this->setHeaderData(3, Qt::Horizontal, QString("专辑"));
        this->setHeaderData(4, Qt::Horizontal, QString("时长"));
        this->setHeaderData(5, Qt::Horizontal, QString("文件路径"));
    }
    setTable(tableName);
}

bool MyModel::getisView() const
{
    return isView;
}

void MyModel::setisView(bool value)
{
    if(isView!=value){

        isView = value;
        emit isViewChanged(isView);
    }


}

