#pragma once

#include <QObject>
#include <QString>
#include <QFile>
#include <QSql>
#include <QSqlQuery>
#include <QSqlDatabase>
#include <QSqlRecord>
#include "tablenote.h"
#include "tableaction.h"

#define DATABASE_NAME "database.db"

class Database
{

public:
    explicit Database(TableNote *tb_note);
    ~Database();

private:
    QSqlDatabase db;
    TableNote *table_note;

    void connectDataBase();
    void closeDataBase();
};
