#ifndef MYTHREAD_H
#define MYTHREAD_H

#include <QList>
#include <QObject>
#include <QString>
#include <QThread>
#include <QUrl>
#include <QtDebug>
extern "C" {
#include "libavcodec/avcodec.h"
#include "libavdevice/avdevice.h"
#include "libavfilter/avfilter.h"
#include "libavformat/avformat.h"
#include "libswresample/swresample.h"
}
class MyThead : public QThread
{
    Q_OBJECT
public: // QThread interface
    MyThead(QObject *sd = nullptr) : QThread(sd) {}
signals:
    void insertMusic(const QString &musicName,
                     const QString &artist,
                     const QString &album,
                     const QString &duration,
                     const QString &filePath);

    void compeleted();
public slots:
    void getFile(QUrl &sd);

protected:
    QUrl urls;

    virtual void run() override;
};
#endif // MYTHREAD_H
