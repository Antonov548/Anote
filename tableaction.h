#pragma once

#include <QObject>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QVector>
#include <QVariant>

#define TABLE_ACTION "action"
#define TABLE_DATE "date"
#define TABLE_INFO "info"
#define TABLE_DONE "done"

struct Action{
    QString information;
    bool isDone;
    QString date;
};

class TableAction : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool isEmpty READ isEmpty WRITE setIsEmpty NOTIFY isEmptyChanged)
    QVector<Action> action_list;
    bool m_isEmpty;

public:
    explicit TableAction(QObject *parent = nullptr);
    void createTable();
    QVector<Action> getAction() const;
    bool isEmpty() const;

signals:
    void isEmptyChanged(bool isEmpty);

    void addNoteStart();
    void addNoteEnd();

    void deleteNoteStart(int index);
    void deleteNoteEnd();

public slots:
    void addAction(QString);
    void resetList();
    void deleteAction(int);
    void addActionsDatabase(QString);
    void getActionsDatabase(QString);
    void deleteActionsDatabase(QString);
   // void setDone(QString,int);
    void setIsEmpty(bool isEmpty);
};
