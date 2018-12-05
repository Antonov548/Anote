#include "tablenote.h"
#include <QDebug>

TableNote::TableNote(QObject *parent) : QObject(parent){

}

void TableNote::createTable(){
    QString str_query;
    QSqlQuery sql_query;

    str_query = "CREATE TABLE " TABLE_NOTE " ( " TABLE_MONTH " VARCHAR(255) , " TABLE_DAY_N " int , " TABLE_COMPLETED " int , "
            TABLE_DAY_W " VARCHAR(255) , " TABLE_DATE " VARCHAR(255) NOT NULL PRIMARY KEY )";

    sql_query.exec(str_query);
}

bool TableNote::setNoteAt(int index, Note note){
    if(index<0 || index>=note_list.size())
        return false;

    note_list[index] = note;

    return true;
}

QVector<Note> TableNote::getNote() const{
    return note_list;
}

bool TableNote::isEmpty() const{
    return m_isEmpty;
}

bool TableNote::addNote(QString sql_date, QString month_s, QString day_w, int day_n, int count_comp){
    for(auto &note : note_list){
        if(note.date == sql_date)
            return false;
    }

    QString str_query;
    QSqlQuery sql_query;

    emit addNoteStart();

    str_query = "INSERT INTO " TABLE_NOTE " ( " TABLE_MONTH " , " TABLE_DAY_N " , " TABLE_COMPLETED " , " TABLE_DAY_W  " , " TABLE_DATE " ) VALUES ( :month , :day , :count , :day_w , :date )";

    sql_query.prepare(str_query);

    sql_query.bindValue(":month",month_s);
    sql_query.bindValue(":day",day_n);
    sql_query.bindValue(":count",count_comp);
    sql_query.bindValue(":day_w",day_w);
    sql_query.bindValue(":date",sql_date);

    sql_query.exec();

    Note new_note;
    new_note.month = month_s;
    new_note.day = day_n;
    new_note.day_w = day_w;
    new_note.count_c = count_comp;
    new_note.date = sql_date;

    note_list.insert(0,new_note);

    setIsEmpty(false);

    emit addNoteEnd();

    return true;

}

void TableNote::deleteNote(QString date, int index){

    emit deleteNoteStart(index);

    QString str_query;
    str_query = "DELETE FROM " TABLE_NOTE " WHERE " TABLE_DATE " = :date";

    QSqlQuery sql_query;
    sql_query.prepare(str_query);
    sql_query.bindValue(":date",date);
    sql_query.exec();

    note_list.remove(index);

    if(!note_list.count())
        setIsEmpty(true);

    emit deleteNoteEnd();

}

void TableNote::setIsEmpty(bool isEmpty){
    if (m_isEmpty == isEmpty)
        return;

    m_isEmpty = isEmpty;
    emit isEmptyChanged(m_isEmpty);
}

void TableNote::reorderList(bool isOrder){
    if(m_isEmpty)
        return;

    QString str_query;
    QSqlQuery sql_query;

    if(isOrder)
        str_query = "SELECT * FROM " TABLE_NOTE " ORDER BY " TABLE_DATE;
    else
        str_query = "SELECT * FROM " TABLE_NOTE;

    sql_query.exec(str_query);
    note_list.clear();

    while(sql_query.next()){
        Note new_note;

        new_note.month = sql_query.value(sql_query.record().indexOf(TABLE_MONTH)).toString();
        new_note.day_w = sql_query.value(sql_query.record().indexOf(TABLE_DAY_W)).toString();
        new_note.count_c = sql_query.value(sql_query.record().indexOf(TABLE_COMPLETED)).toInt();
        new_note.day = sql_query.value(sql_query.record().indexOf(TABLE_DAY_N)).toInt();
        new_note.date = sql_query.value(sql_query.record().indexOf(TABLE_DATE)).toString();

        if(isOrder)
            note_list.append(new_note);
        else
            note_list.insert(0,new_note);
    }
}

void TableNote::setNCompleted(QString date, int index, bool completed){
    QString str_query;
    QSqlQuery sql_query;

    str_query = "UPDATE " TABLE_NOTE " SET " TABLE_COMPLETED " = :count WHERE " TABLE_DATE "=:date";
    sql_query.prepare(str_query);

    int new_count = note_list[index].count_c;
    if(completed)
        new_count++;
    else
        new_count--;

    sql_query.bindValue(":date",date);
    sql_query.bindValue(":count",new_count);

    sql_query.exec();
    note_list[index].count_c = new_count;

    emit updateData("count_c",index);
}

void TableNote::getNotesDatabase(bool isOrder){
    QString str_query;

    if(isOrder)
        str_query = "SELECT * FROM " TABLE_NOTE " ORDER BY " TABLE_DATE;
    else
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

        new_note.month = sql_query.value(sql_query.record().indexOf(TABLE_MONTH)).toString();
        new_note.day_w = sql_query.value(sql_query.record().indexOf(TABLE_DAY_W)).toString();
        new_note.day = sql_query.value(sql_query.record().indexOf(TABLE_DAY_N)).toInt();
        new_note.count_c = sql_query.value(sql_query.record().indexOf(TABLE_COMPLETED)).toInt();
        new_note.date = sql_query.value(sql_query.record().indexOf(TABLE_DATE)).toString();

        if(isOrder)
            note_list.insert(0,new_note);
        else
            note_list.append(new_note);

    }while((sql_query.previous()));
    setIsEmpty(false);
}
