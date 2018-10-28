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

class Database : public QObject
{
    Q_OBJECT

    Q_PROPERTY(TableNote* tb_note READ tb_note WRITE setTb_note NOTIFY tb_noteChanged)
    Q_PROPERTY(TableAction* tb_action READ tb_action WRITE setTb_action NOTIFY tb_actionChanged)

public:
    explicit Database(QObject *parent = nullptr);
    ~Database();

    TableNote* tb_note() const;
    TableAction* tb_action() const;

public slots:
    void setTb_note(TableNote* tb_note);
    void setTb_action(TableAction* tb_action);

signals:
    void tb_noteChanged(TableNote* tb_note);
    void tb_actionChanged(TableAction* tb_action);

private:
    QSqlDatabase db;

    void connectDataBase();
    void closeDataBase();
    TableNote* m_tb_note;
    TableAction* m_tb_action;
};
