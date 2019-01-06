#include "tablenote.h"
#include <QDebug>

#define TABLE_NOTE "note"
#define TABLE_INDEX "note_index"
#define TABLE_DAY_W "day_w"
#define TABLE_DAY_N "day_n"
#define TABLE_MONTH "month"
#define TABLE_DATE "date"
#define TABLE_COMPLETED "completed"

TableNote::TableNote(QObject *parent) : QObject(parent){

}

void TableNote::createTable(){
    QString str_query;
    QSqlQuery sql_query;

    str_query = "CREATE TABLE " TABLE_NOTE " ( " TABLE_INDEX " int , "  TABLE_MONTH " text , " TABLE_DAY_N " int , " TABLE_COMPLETED " int , "
            TABLE_DAY_W " text , " TABLE_DATE " text NOT NULL PRIMARY KEY )";

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
    int index = getCountNotes();

    emit addNoteStart();

    str_query = "INSERT INTO " TABLE_NOTE " ( " TABLE_INDEX " , "  TABLE_MONTH " , " TABLE_DAY_N " , " TABLE_COMPLETED " , " TABLE_DAY_W  " , " TABLE_DATE " ) VALUES (:index,  :month , :day , :count , :day_w , :date )";

    sql_query.prepare(str_query);

    sql_query.bindValue(":index",index);
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

void TableNote::updateDate(QString date, int index){
    QString str_query;
    QSqlQuery sql_query;

    str_query = "UPDATE " TABLE_NOTE " SET " TABLE_DATE " = :date WHERE " TABLE_DATE "=:date";
    sql_query.prepare(str_query);

    sql_query.bindValue(":date",date);

    sql_query.exec();
    note_list[index].date = date;

    emit updateData("date",index);
}

int TableNote::getIndexByDate(QString date){
    for (int i=0; i<note_list.count(); i++){
        if(note_list[i].date == date)
            return i;
    }
    return -1;
}

int TableNote::getCountNotCompletedByIndex(int index){
    return note_list[index].count_c;
}

void TableNote::reindexNotesFromTo(int from, int to){
    if(from<0 || to < 0)
        return;

    if(from==to)
        return;

    QString str_query;
    QSqlQuery sql_query;
    int length = note_list.length();
    if(from < to){
        for(int i = from; i<=to; i++){
            str_query = "UPDATE " TABLE_NOTE " SET " TABLE_INDEX " = :index WHERE " TABLE_DATE "= :date ";
            sql_query.prepare(str_query);

            sql_query.bindValue(":index",length-i-1);
            sql_query.bindValue(":date",note_list[i].date);

            sql_query.exec();
        }
    }
    else if (to < from){
        for(int i = from; i>=to; i--){
            str_query = "UPDATE " TABLE_NOTE " SET " TABLE_INDEX " = :index WHERE " TABLE_DATE "= :date ";
            sql_query.prepare(str_query);

            sql_query.bindValue(":index",length-i-1);
            sql_query.bindValue(":date",note_list[i].date);

            sql_query.exec();
        }
    }
}

void TableNote::moveNote(int from, int to){
    if(from == to)
        return;
    if(from>to)
        moveNoteStart(from, to);
    else
        moveNoteStart(from, to+1);
    note_list.move(from,to);
    moveNoteEnd();
}

void TableNote::reorderList(bool isOrder){
    if(m_isEmpty)
        return;

    QString str_query;
    QSqlQuery sql_query;

    if(isOrder)
        str_query = "SELECT * FROM " TABLE_NOTE " ORDER BY date(" TABLE_DATE")";
    else
        str_query = "SELECT * FROM " TABLE_NOTE " ORDER BY " TABLE_INDEX " DESC ";

    sql_query.exec(str_query);
    note_list.clear();

    while(sql_query.next()){
        Note new_note;

        new_note.month = sql_query.value(sql_query.record().indexOf(TABLE_MONTH)).toString();
        new_note.day_w = sql_query.value(sql_query.record().indexOf(TABLE_DAY_W)).toString();
        new_note.count_c = sql_query.value(sql_query.record().indexOf(TABLE_COMPLETED)).toInt();
        new_note.day = sql_query.value(sql_query.record().indexOf(TABLE_DAY_N)).toInt();
        new_note.date = sql_query.value(sql_query.record().indexOf(TABLE_DATE)).toString();

        note_list.append(new_note);
    }
}

void TableNote::setNotCompletedActionsCount(QString date, int index, int count){
    QString str_query;
    QSqlQuery sql_query;

    str_query = "UPDATE " TABLE_NOTE " SET " TABLE_COMPLETED " = :count WHERE " TABLE_DATE " = :date";
    sql_query.prepare(str_query);

    sql_query.bindValue(":date",date);
    sql_query.bindValue(":count",count);

    sql_query.exec();
    note_list[index].count_c = count;

    emit updateData("count_c",index);
}

void TableNote::getNotesDatabase(bool isOrder){
    QString str_query;

    if(isOrder)
        str_query = "SELECT * FROM " TABLE_NOTE " ORDER BY date(" TABLE_DATE")";
    else
        str_query = "SELECT * FROM " TABLE_NOTE " ORDER BY " TABLE_INDEX " DESC ";

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

        note_list.insert(0,new_note);

    }while((sql_query.previous()));
    setIsEmpty(false);
}

int TableNote::getCountNotes(){
    QString str_query;
    QSqlQuery sql_query;

    str_query = "SELECT " TABLE_INDEX " FROM " TABLE_NOTE " ORDER BY " TABLE_INDEX;
    sql_query.exec(str_query);

    if(sql_query.last()){
        return sql_query.value(sql_query.record().indexOf(TABLE_INDEX)).toInt()+1;
    }
    else
        return 0;
}
