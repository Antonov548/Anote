#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>

#include "database.h"
#include "notemodel.h"
#include "applicationsettings.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    ApplicationSettings settings("settings.json");

    qmlRegisterType<Database>("QtDatabase",1,0,"Database");
    qmlRegisterType<TableNote>("QtDatabase",1,0,"TableNote");
    qmlRegisterType<NoteModel>("QtDatabase",1,0,"NoteModel");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("ApplicationSettings",&settings);
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
