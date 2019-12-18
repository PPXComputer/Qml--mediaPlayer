#ifndef MYMODEL_H
#define MYMODEL_H

#include <QModelIndex>
#include <QObject>
#include <qdebug.h>
#include <qsqldatabase.h>
#include <qsqlerror.h>
#include <qsqlquery.h>
#include <qsqlrecord.h>
#include <qsqltablemodel.h>
// 在 Qsqltablemodel中可以`直接使用 槽函数 submitAll()
class MyModel : public QSqlTableModel
{
    Q_OBJECT
    Q_PROPERTY(QString tableName READ getTableName WRITE setTableName NOTIFY tableNameChanged)
    Q_PROPERTY(bool isView READ getisView WRITE setisView NOTIFY isViewChanged)
public:
    enum class MemberRole { type = Qt::UserRole + 1, name, access };
    enum class FunctionRole { values = Qt::UserRole + 1, name, args, access };
    enum class UsingRole { Function, Member };
    explicit MyModel(QObject *parent = nullptr,QSqlDatabase database=QSqlDatabase());
    QVariant data(const QModelIndex &index, int role) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;
    //设置职责 即 对应的行号
    virtual QHash<int, QByteArray> roleNames() const override;
    Q_INVOKABLE void setTableName(QString name)
    {
        if (tableName != name) {
            tableName = std::move(name);
            emit tableNameChanged(tableName);


        }
    }
    Q_INVOKABLE QString getTableName() const { return this->tableName; }
    bool getisView() const;
    Q_INVOKABLE void setisView(bool value);

signals:
    void tableNameChanged(const QString &name);
    void isViewChanged(const bool isplay);
public slots:
    void initHeader(); //与tableNameChanged的槽函数

protected:
    QString tableName="";
    bool isView=true;
};

#endif // MYMODEL_H
