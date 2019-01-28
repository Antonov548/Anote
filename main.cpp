#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QStringList>

#include "src/database.h"
#include "src/notemodel.h"
#include "src/actionmodel.h"
#include "src/actionmodeldone.h"
#include "src/tablenote.h"
#include "src/applicationsettings.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_DisableShaderDiskCache);

    QGuiApplication app(argc, argv);

    QIcon::setThemeName("anote");

    ApplicationSettings *settings = ApplicationSettings::AppSettingsInstance();
    settings->setFile("settings.json");

    QObject::connect(settings,SIGNAL(commit()),app.inputMethod(),SLOT(commit()));

    qmlRegisterType<NoteModel>("QtModel",1,0,"NoteModel");
    qmlRegisterType<ActionModel>("QtModel",1,0,"ActionModel");
    qmlRegisterType<ActionModelDone>("QtModel",1,0,"ActionModelDone");

    TableNote tableNote;
    TableAction tableAction;
    Database db(tableNote,tableAction);

    tableNote.getNotesDatabase(settings->isOrder());

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("tableNote",&tableNote);
    engine.rootContext()->setContextProperty("tableAction",&tableAction);
    engine.rootContext()->setContextProperty("ApplicationSettings",settings);
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    //settings->initializeAndroidKeyboard();

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
