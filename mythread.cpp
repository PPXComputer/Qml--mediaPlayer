#include "mythread.h"

void MyThead::getFile(QUrl &sd)
{
    urls = sd;
    if (!this->isRunning())
        this->start();
}

void MyThead::run()

{
    auto &&url = this->urls;
    std::string imagePath = url.toLocalFile().toStdString();
    AVFormatContext *fmt_ctx = nullptr;
    AVDictionaryEntry *tag = nullptr;
    int ret = 0;
    qDebug() << "当前的资源为" << imagePath.c_str();
    if ((ret = avformat_open_input(&fmt_ctx, imagePath.c_str(), nullptr, nullptr))) {
        qDebug() << "Fail to open file";
        return;
    } else {
        avformat_find_stream_info(fmt_ctx, nullptr);
        // 读取为秒 //将此数据传到 数据库中去
        QMap<QString, QString> maps;
        //读取metadata中所有的tag
        while ((tag = av_dict_get(fmt_ctx->metadata, "", tag, AV_DICT_IGNORE_SUFFIX))) {
            maps.insert(tag->key, tag->value);
        }
        if (fmt_ctx->iformat->read_header(fmt_ctx) < 0) {
            printf("No header format");
            return;
        }
        auto duration = static_cast<int>(fmt_ctx->duration / AV_TIME_BASE);
        QString time;
        if (duration <= 600) {
            time = "0" + QString::number(duration / 60) + ":" + QString::number(duration % 60);
        } else {
            time = QString::number(duration / 60) + ":" + QString::number(duration % 60);
        }
        qDebug() << "读取的时长为" << time;

        emit insertMusic(maps.value("title"),
                         maps.value("artist"),
                         maps.value("album"),
                         time,
                         url.toString());
    }

    emit compeleted();
}
