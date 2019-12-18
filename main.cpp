#include "imageprovider.h"
#include "mymodel.h"
#include "mysql.h"
#include "stable.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickImageProvider>
class MySql;
class MyModel;
int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    app.setOrganizationName("PPX Company");
    app.setOrganizationDomain("ppx.github");
    app.setApplicationName("ppx Application");

    app.setWindowIcon (QIcon{"qrc:/gridView/Iamges/gridView/109951164213417907.jpg.png"});


    QQmlApplicationEngine engine;
    QUrl currentPathMusic = QUrl::fromLocalFile(app.applicationDirPath() + "/musicResource/");
    qDebug() << "当前的文件音乐资源为" << currentPathMusic;
    //QUrl testUrl{currentPathMusic};
    qDebug() << "当前的路径是合法" << currentPathMusic.isLocalFile() << currentPathMusic.isValid();
    const QUrl url(QStringLiteral("qrc:/main.qml"));

    auto *provider = new ImageProvider{
        currentPathMusic.toString ()+"/Thomas Greenberg - The Right Path.mp3"};

    engine.addImageProvider(QLatin1String("CodeImg"), dynamic_cast<QQuickImageProvider *>(provider));
    engine.rootContext()->setContextProperty("CodeImg", provider);
    engine.rootContext()->setContextProperty("CoveImageSource", QString("image://CodeImg/123"));
    engine.rootContext()->setContextProperty("currentPathMusic", currentPathMusic);

    // 主文件中只有一个 链接使用数据库


    auto mysql=new MySql {} ;

    engine.rootContext ()->setContextObject (mysql);

    //engine.rootContext ()->setContextObject ("mySql",mysql);


    qmlRegisterType<MySql>("MyPackge",1,0,"MySql");
    qmlRegisterType<MyModel>("MyPackge",1,0,"MyModel");

   // qmlRegisterType<MyMediaList>("MyPackge",1,0,"MyMediaList");
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);
    engine.load(url);
    //qDebug() << "qml文件加载的路径为" << url;
    provider->getMessage(); // changed the url
    return app.exec();
}
