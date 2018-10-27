#pragma once

#include <QObject>
#include <QString>
#include <QFile>
#include <QSql>
#include <QSqlQuery>
#include <QSqlDatabase>
#include <QSqlRecord>
#include "tablenote.h"

#define DATABASE_NAME "database.db"

class Database : public QObject
{
    Q_OBJECT

    Q_PROPERTY(TableNote* tb_note READ tb_note WRITE setTb_note NOTIFY tb_noteChanged)

public:
    explicit Database(QObject *parent = nullptr);
    ~Database();

    TableNote* tb_note() const;

public slots:
    void setTb_note(TableNote* tb_note);

signals:

    void tb_noteChanged(TableNote* tb_note);

private:
    QSqlDatabase db;

    void connectDataBase();
    void closeDataBase();
    TableNote* m_tb_note;
};
