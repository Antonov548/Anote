#include "tablenote.h"
#include <QDebug>

TableNote::TableNote(QObject *parent) : QObject(parent)
{

    getNotesDatabase();

}

void TableNote::createTable()
{
    QString str_query;

    str_query = "CREATE TABLE " TABLE_NOTE " ( " TABLE_TITLE " VARCHAR(255) , " TABLE_TEXT " VARCHAR(255) )";

    QSqlQuery sql_query;

    sql_query.exec(str_query);
}

bool TableNote::setNoteAt(int index, Note note)
{
    if(index<0 || index>=note_list.size())
        return false;

    note_list[index] = note;

    return true;
}

QVector<Note> TableNote::getNote() const
{
    return note_list;
}

bool TableNote::isEmpty() const
{
    return m_isEmpty;
}

bool TableNote::addNote(QString title, QString text)
{

    if(title.length() == 0)
        return false;

    for(auto note : note_list){

        if(title == note.title)
            return false;

    }


    emit addNoteStart();

    QString str_query;

    str_query = "INSERT INTO " TABLE_NOTE " ( " TABLE_TITLE " , " TABLE_TEXT " ) VALUES ( :title , :text )";

    QSqlQuery sql_query;

    sql_query.prepare(str_query);

    sql_query.bindValue(":title",title);
    sql_query.bindValue(":text",text);

    sql_query.exec();

    Note new_note;
    new_note.title = title;
    new_note.text = text;

    note_list.insert(0,new_note);

    setIsEmpty(false);

    emit addNoteEnd();

    return true;

}

void TableNote::deleteNote(QString title,int index)
{
    emit deleteNoteStart(index);

    QString str_query;

    str_query = "DELETE FROM " TABLE_NOTE " WHERE " TABLE_TITLE " = :title";

    QSqlQuery sql_query;

    sql_query.prepare(str_query);

    sql_query.bindValue(":title",title);

    sql_query.exec();

    note_list.remove(index);

    if(!note_list.count())
        setIsEmpty(true);

    emit deleteNoteEnd();

}

void TableNote::setIsEmpty(bool isEmpty)
{
    if (m_isEmpty == isEmpty)
        return;

    m_isEmpty = isEmpty;
    emit isEmptyChanged(m_isEmpty);
}

void TableNote::getNotesDatabase()
{

    QString str_query;

    str_query = "SELECT * FROM " TABLE_NOTE;

    QSqlQuery sql_query;

    sql_query.exec(str_query);

    //check database empty
    if(!sql_query.last()){
        setIsEmpty(true);
        return;
    }

    do{

        Note new_note;

        new_note.title = sql_query.value(sql_query.record().indexOf("title")).toString();
        new_note.text = sql_query.value(sql_query.record().indexOf("text")).toString();

        note_list.append(new_note);

    }while((sql_query.previous()));

    setIsEmpty(false);

}
