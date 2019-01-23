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
    int db_index;
};

class TableAction : public QObject
{
    Q_OBJECT

    QList<Action> action_list;
    QList<Action> list_completed;
    int getLastIndexByDate(QString date);
    void addActionsDatabase(QList<Action>& list, QString date,int start_index);
    QList<Action>& getListReference(int group);

public:
    explicit TableAction(QObject *parent = nullptr);
    void createTable();
    QList<Action> getActions(int group) const;
    int getActionsCount(int group) const;

    enum{
        Done,
        NotDone
    };

signals:
    void addActionStart(int index);
    void addActionEnd();

    void deleteActionStart(int index);
    void deleteActionEnd();

    void moveActionStart(int from, int to);
    void moveActionEnd();

    void setDoneStart(int index);
    void setDoneEnd();

    void setNotDoneStart(int index);
    void setNotDoneEnd();

    void updateData(QString role, int index);

public slots:
    void addAction(QString);
    void resetList();
    void deleteAction(int);
    void initAddActionsDatabase(QString date);
    void rewriteActionsDatabase(QString date);
    void getActionsDatabase(QString date);
    void deleteActionsDatabase(QString date);
    void setDone(QString date, int index);
    void setNotDone(QString date, int index);
    void moveAction(int from, int to);
};
