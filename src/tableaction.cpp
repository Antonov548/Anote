#include "tableaction.h"
#include <QDebug>

#define TABLE_ACTION "action"
#define TABLE_DATE "date"
#define TABLE_INFO "info"
#define TABLE_DONE "done"
#define TABLE_INDEX "action_index"

TableAction::TableAction(QObject *parent) : QObject(parent){

}

void TableAction::createTable(){
    QString str_query;
    QSqlQuery sql_query;

    str_query = "CREATE TABLE " TABLE_ACTION " ( " TABLE_INFO " text, " TABLE_DONE " int , " TABLE_INDEX " int , " TABLE_DATE " text NOT NULL)";
    sql_query.exec(str_query);
}

QList<Action> TableAction::getActions(int group) const{
    switch (group) {
    case NotDone:
        return action_list;
    case Done:
        return list_completed;
    }

    return action_list + list_completed;
}

int TableAction::getActionsCount(int group) const{
    switch (group) {
    case NotDone:
        return action_list.count();
    case Done:
        return list_completed.count();
    }
    return action_list.count() + list_completed.count();
}

void TableAction::addAction(QString text){
    int index = 0;
    emit addActionStart(index);

    Action new_action;
    new_action.information = text;
    new_action.isDone = false;
    new_action.date = "";

    action_list.insert(index,new_action);

    emit addActionEnd();
}

void TableAction::resetList(){
    action_list.clear();
    list_completed.clear();
}

void TableAction::deleteAction(int index){
    emit deleteActionStart(index);
    action_list.removeAt(index);
    emit deleteActionEnd();
}

void TableAction::initAddActionsDatabase(QString date){

    int index = getLastIndexByDate(date);
    //index increment for new actions
    if(index!=0)
        index++;

    QString str_query;
    QSqlQuery sql_query;

    for(int i=action_list.count()-1; i >= 0; i--){

        str_query = "INSERT INTO " TABLE_ACTION " ( " TABLE_INFO " , " TABLE_DONE " , " TABLE_INDEX " , " TABLE_DATE  "  ) VALUES ( :info, :done, :index, :date )";

        sql_query.prepare(str_query);

        sql_query.bindValue(":info",action_list[i].information);
        sql_query.bindValue(":done",action_list[i].isDone);
        sql_query.bindValue(":index",index);
        sql_query.bindValue(":date",date);

        sql_query.exec();
        index++;
    }
}

void TableAction::getActionsDatabase(QString date){
    resetList();

    QString str_query;
    QSqlQuery sql_query;

    str_query = "SELECT * FROM " TABLE_ACTION " WHERE " TABLE_DATE "='" + date + "' ORDER BY " TABLE_INDEX " ASC ";
    sql_query.exec(str_query);

    if(!sql_query.first()){
        return;
    }

    do{
        Action new_action;
        new_action.date = sql_query.value(sql_query.record().indexOf(TABLE_DATE)).toString();
        new_action.information = sql_query.value(sql_query.record().indexOf(TABLE_INFO)).toString();
        new_action.isDone = sql_query.value(sql_query.record().indexOf(TABLE_DONE)).toBool();
        new_action.db_index = sql_query.value(sql_query.record().indexOf(TABLE_INDEX)).toInt();

        if(new_action.isDone)
            list_completed.insert(0,new_action);
        else
            action_list.insert(0,new_action);

    }while((sql_query.next()));
}

void TableAction::deleteActionsDatabase(QString date){
    QString str_query;
    QSqlQuery sql_query;

    str_query = "DELETE FROM " TABLE_ACTION " WHERE " TABLE_DATE "='" + date + "'";
    sql_query.exec(str_query);
}

void TableAction::setDone(QString date, int index){
    emit setDoneStart(index);

    QString str_query;
    QSqlQuery sql_query;

    int db_index = action_list[index].db_index;
    int new_index = getLastIndexByDate(date);

    str_query = "UPDATE " TABLE_ACTION " SET " TABLE_DONE " = :done, " TABLE_INDEX " = :new_index WHERE " TABLE_DATE "=:date AND " TABLE_INDEX "=:index";
    sql_query.prepare(str_query);

    sql_query.bindValue(":done",int(true));
    sql_query.bindValue(":new_index",new_index);
    sql_query.bindValue(":date",date);
    sql_query.bindValue(":index",db_index);
    sql_query.exec();

    list_completed.append(action_list.at(index));
    action_list.removeAt(index);

    emit setDoneEnd();
}

//get last index action in database
int TableAction::getLastIndexByDate(QString date){
    QString str_query;
    QSqlQuery sql_query;

    str_query = "SELECT " TABLE_INDEX " FROM " TABLE_ACTION " WHERE " TABLE_DATE " =:date ORDER BY " TABLE_INDEX " DESC ";
    sql_query.prepare(str_query);
    sql_query.bindValue(":date",date);
    sql_query.exec();
    if(sql_query.first()){
        return sql_query.value(sql_query.record().indexOf(TABLE_INDEX)).toInt();
    }
    else
        return 0;
}

void TableAction::moveAction(int from, int to){
    if(from == to)
        return;
    if(from>to)
        moveActionStart(from, to);
    else
        moveActionStart(from, to+1);
    action_list.move(from,to);
    moveActionEnd();
}
