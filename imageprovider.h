#ifndef IMAGEPROVIDER_H
#define IMAGEPROVIDER_H

#include <string>
#include <QQuickImageProvider>
#include <QtCore>
extern "C" {
#include "libavcodec/avcodec.h"
#include "libavdevice/avdevice.h"
#include "libavfilter/avfilter.h"
#include "libavformat/avformat.h"
#include "libswresample/swresample.h"
}
class ImageProvider : public QObject, public QQuickImageProvider
{
    Q_OBJECT
public:
    ImageProvider(QString filePath,
                  QObject *parent = nullptr,
                  ImageType type = QQuickImageProvider::Pixmap,
                  Flags flags = Flags());
    ~ImageProvider() = default;
    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize)
    {
        Q_UNUSED(id)
        Q_UNUSED(size)
        Q_UNUSED(requestedSize)
        // 这里获得是 qrc下的内容
        if (isSuccess) {
            isSuccess = false;
            qDebug() << "使用了读取后的图像";
            return this->img.toImage();
        } else {
            qDebug() << "default image show";
            return defaultPiutrce.toImage(); // 不按照使用标准来进行判定
        }
    }
    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
    {
        Q_UNUSED(id)
        Q_UNUSED(size)
        Q_UNUSED(requestedSize)
        // 这里获得是 qrc下的内容
        if (isSuccess) {
            isSuccess = false;
            qDebug() << "使用了读取后的图像";
            return this->img;
        } else {
            qDebug() << "default image show";
            return defaultPiutrce; // 不按照使用标准来进行判定
        }
    }

    QPixmap getImg() const { return img; }

    void setImg(QPixmap value)
    {
        img = std::move(value);
        qDebug() << "设置封面成功";
        isSuccess = true;
        emit imageResourceChanged();
    }

private:
    QPixmap img;
    QPixmap defaultPiutrce{":/images/Iamges/icon_udbw6jfgr79/qq.png"};
    QString url;
    bool isSuccess = false;

public:
    struct Information
    {
        QString musicName;
        QString author;
        QString album;
        QString duration;
        QString filePath;
    };
    using InfoMusicType = Information;

    QString CoveImage = "image://CodeImg/image.png"; // 最初的文件路径
signals:
    void urlChanged(QUrl);
    void imageResourceChanged();
    //  读取信息资源的时候　将　音乐的信息转出到数据库中使用
    // 成功时将触发此信号
    void getInformation(const QString &musicName,
                        const QString &author,
                        const QString &album,
                        const QString &duration,
                        const QString &filePath);
public slots:
    Q_INVOKABLE void setUrl(QString filePath)
    {
        if (filePath != this->url) {
            url = std::move(filePath);
            emit urlChanged(url);
        }
    }
    void getMessage(); //  emit getInformation when successed
private:
    std::string getResourceFromQrc(const QString &qrcFile)
    {
        QUrl dir{qrcFile};
        QDir assist;
        return assist.absoluteFilePath(dir.toLocalFile()).toStdString();
    }

    std::string getResourceFromFileSystem(const QString &url) { return url.toStdString(); }
};

#endif // IMAGEPROVIDER_H
