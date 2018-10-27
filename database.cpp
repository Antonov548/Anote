#include "database.h"

Database::Database(QObject* parent):QObject(parent){

    connectDataBase();

}

Database::~Database(){

    closeDataBase();

}

TableNote *Database::tb_note() const
{
    return m_tb_note;
}

void Database::setTb_note(TableNote *tb_note)
{
    if (m_tb_note == tb_note)
        return;

    m_tb_note = tb_note;
    emit tb_noteChanged(m_tb_note);
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

        m_tb_note->createTable();

    }
}

void Database::closeDataBase(){

    db.close();

}
