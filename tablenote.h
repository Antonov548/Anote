#pragma once

#include <QObject>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QString>
#include <QVariant>
#include <QVector>

#define TABLE_NOTE "note"
#define TABLE_TITLE "title"
#define TABLE_TEXT "text"

struct Note
{
    QString title;
    QString text;

};

class TableNote : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool isEmpty READ isEmpty WRITE setIsEmpty NOTIFY isEmptyChanged)

    QVector<Note> note_list;

    void getNotesDatabase();

    bool m_isEmpty;

public:
    explicit TableNote(QObject *parent = nullptr);
    void createTable();
    bool setNoteAt(int,Note);
    QVector<Note> getNote() const;

    bool isEmpty() const;

signals:
    void addNoteStart();
    void addNoteEnd();

    void deleteNoteStart(int index);
    void deleteNoteEnd();

    void isEmptyChanged(bool isEmpty);

public slots:
    bool addNote(QString,QString);
    void deleteNote(QString,int);

    void setIsEmpty(bool isEmpty);
};
