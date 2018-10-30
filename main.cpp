#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>

#include "database.h"
#include "notemodel.h"
#include "tablenote.h"
#include "applicationsettings.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    ApplicationSettings settings("settings.json");

    qmlRegisterType<NoteModel>("QtModel",1,0,"NoteModel");

    TableNote *tableNote = new TableNote();
    Database db(tableNote);

    tableNote->getNotesDatabase();

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("tableNote",tableNote);
    engine.rootContext()->setContextProperty("ApplicationSettings",&settings);
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
