#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>

#include "database.h"
#include "notemodel.h"
#include "actionmodel.h"
#include "tablenote.h"
#include "applicationsettings.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_DisableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_DisableShaderDiskCache);

    QGuiApplication app(argc, argv);

    ApplicationSettings settings("settings.json");

    qmlRegisterType<NoteModel>("QtModel",1,0,"NoteModel");
    qmlRegisterType<ActionModel>("QtModel",1,0,"ActionModel");

    TableNote tableNote;
    TableAction tableAction;
    Database db(tableNote,tableAction);

    tableNote.getNotesDatabase();

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("tableNote",&tableNote);
    engine.rootContext()->setContextProperty("tableAction",&tableAction);
    engine.rootContext()->setContextProperty("ApplicationSettings",&settings);
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
