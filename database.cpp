#include "database.h"

Database::Database(TableNote &tb_note, TableAction& tb_action):table_note(tb_note),table_action(tb_action){
    connectDataBase();
}

Database::~Database(){
    closeDataBase();
}

void Database::connectDataBase(){

    if( QFile(DATABASE_NAME).exists()){
        db = QSqlDatabase::addDatabase("QSQLITE");
        db.setDatabaseName(DATABASE_NAME);
        db.open();
    }
    else{
        db = QSqlDatabase::addDatabase("QSQLITE");
        db.setDatabaseName(DATABASE_NAME);
        db.open();
        table_note.createTable();
        table_action.createTable();
    }
}

void Database::closeDataBase(){
    db.close();
}
