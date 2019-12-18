#include "mymedialist.h"

MyMediaList::MyMediaList(QObject *parent):list(new QMediaPlaylist{this})
{
    setParent(parent);
    connect(list,&QMediaPlaylist::currentIndexChanged,this,[this](int index){this->currentIndexChanged(index);});
    connect(list,&QMediaPlaylist::currentMediaChanged,this,[this](){   this->currentSourceChanged(getCurrentSource());});
}

int MyMediaList::getCurrentIndex() const
{
    return  list->currentIndex();
}

void MyMediaList::setCurrentIndex(int value)
{
    list->setCurrentIndex(value);
}

QString MyMediaList::getCurrentSource() const
{

    auto sd= list->currentMedia();
    return sd.canonicalUrl().toString();
}
