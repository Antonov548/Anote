#pragma once

#include <QObject>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QString>
#include <QVariant>
#include <QVector>

struct Note{
    QString month;
    QString day_w;
    int day;
    int count_c;
    QString date;
};

class TableNote : public QObject
{
    Q_OBJECT

    QVector<Note> note_list;
    int getCountNotes();

public:
    explicit TableNote(QObject *parent = nullptr);
    void createTable();
    bool setNoteAt(int,Note);
    QVector<Note> getNote() const;
    void getNotesDatabase(bool);

signals:
    void addNoteStart();
    void addNoteEnd();

    void deleteNoteStart(int index);
    void deleteNoteEnd();

    void moveNoteStart(int from, int to);
    void moveNoteEnd();

    void resetList(bool);
    void updateData(QString role,int index);

public slots:
    bool addNote(QString sql_date, QString month_s, QString day_w, int day_n, int count_comp);
    void deleteNote(QString, int);
    void reorderList(bool);
    void setNotCompletedActionsCount(QString date, int index, int count);
    void updateDate(QString date, int index);
    int getIndexByDate(QString date);
    int getCountNotCompletedByIndex(int index);
    void reindexNotesFromTo(int from, int to);
    void moveNote(int from, int to);
};
