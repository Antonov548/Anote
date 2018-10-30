#include "database.h"

Database::Database(TableNote* tb_note):table_note(tb_note){
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
        table_note->createTable();
    }
}

void Database::closeDataBase(){
    db.close();
}
