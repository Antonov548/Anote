#pragma once

#include <QObject>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QString>
#include <QVariant>
#include <QVector>

#define TABLE_NOTE "note"
#define TABLE_DAY_W "day_w"
#define TABLE_DAY_N "day_n"
#define TABLE_MONTH "month"
#define TABLE_DATE "date"


struct Note
{
    QString month;
    QString day_w;
    int day;
    QString date;
};

class TableNote : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool isEmpty READ isEmpty WRITE setIsEmpty NOTIFY isEmptyChanged)
    QVector<Note> note_list;
    QString getSqlDate(int year,int month,int day);
    bool m_isEmpty;

public:
    explicit TableNote(QObject *parent = nullptr);
    void createTable();
    bool setNoteAt(int,Note);
    QVector<Note> getNote() const;
    void getNotesDatabase();
    bool isEmpty() const;

signals:
    void addNoteStart();
    void addNoteEnd();

    void deleteNoteStart(int index);
    void deleteNoteEnd();

    void isEmptyChanged(bool isEmpty);

public slots:
    bool addNote(int ,QString, int, QString, int);
    void deleteNote(QString, int);

    void setIsEmpty(bool isEmpty);
};
