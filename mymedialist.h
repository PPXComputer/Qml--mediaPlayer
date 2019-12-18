#ifndef MYMEDIALIST_H
#define MYMEDIALIST_H

#include<QMediaPlaylist>
#include<QMediaContent>

class MyMediaList : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentSource READ getCurrentSource  NOTIFY currentSourceChanged)
    Q_PROPERTY(int currentIndex READ getCurrentIndex WRITE setCurrentIndex NOTIFY currentIndexChanged)
public:

    MyMediaList(QObject *parent = nullptr);

    Q_INVOKABLE  bool addMedia(QStringList &items){

        QList<QMediaContent> contens;
        for(auto & sd:items){
            contens.push_back(QMediaContent{QUrl{sd}});
        }
        return list->addMedia(std::move(contens));
    }
    Q_INVOKABLE  bool addMedia(QString content){
        return list->addMedia(QMediaContent(QUrl{content}));
    }
    Q_INVOKABLE  bool insertMedia(int index, QString &content){
        return list->insertMedia(index,QMediaContent{QUrl{content}});
    }
    Q_INVOKABLE  bool insertMedia(int index, QStringList &items){

        QList<QMediaContent> contens;
        for(auto & sd:items){
            contens.push_back(QMediaContent{QUrl{sd}});
        }
        return list->insertMedia(index,std::move(contens));
    }
    Q_INVOKABLE  bool moveMedia(int from, int to){
        return list->moveMedia(from,to);
    }
    Q_INVOKABLE  bool removeMedia(int pos){
        return list->removeMedia(pos);
    }
    Q_INVOKABLE  bool removeMedia(int start, int end){
        return list->removeMedia(start,end);
    }
    Q_INVOKABLE int getCurrentIndex() const;
    Q_INVOKABLE void setCurrentIndex(int value);
    Q_INVOKABLE QString getCurrentSource() const;

signals:
     void currentIndexChanged(int index);
     void currentSourceChanged(QString source);
private:
    QMediaPlaylist *list;
    QString currentSource;
};

#endif // MYMEDIALIST_H
