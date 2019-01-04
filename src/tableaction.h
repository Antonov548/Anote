#pragma once

#include <QObject>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QList>
#include <QVariant>



struct Action{
    QString information;
    bool isDone;
    QString date;
};

class TableAction : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool isEmpty READ isEmpty WRITE setIsEmpty NOTIFY isEmptyChanged)
    QList<Action> action_list;
    bool m_isEmpty;
    int getCountFromNote(QString date);

public:
    explicit TableAction(QObject *parent = nullptr);
    void createTable();
    QList<Action> getAction() const;
    bool isEmpty() const;

signals:
    void isEmptyChanged(bool isEmpty);

    void addNoteStart();
    void addNoteEnd();

    void deleteNoteStart(int index);
    void deleteNoteEnd();

    void updateData(QString role, int index);

public slots:
    void addAction(QString);
    void resetList();
    void deleteAction(int);
    void addActionsDatabase(QString date);
    void getActionsDatabase(QString);
    void deleteActionsDatabase(QString date);
    void setDone(QString, int, bool);
    void setIsEmpty(bool isEmpty);
    int getCountNotCompleted();
};
