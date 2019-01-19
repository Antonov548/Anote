#include "actionmodel.h"
#include <QDebug>

ActionModel::ActionModel(){
}

void ActionModel::setList(TableAction *list){
    beginResetModel();

    m_list = list;

    if (m_list) {
        connect(m_list, &TableAction::addActionStart, this, [=]() {
            const int index = 0;
            beginInsertRows(QModelIndex(), index, index);
        });
        connect(m_list, &TableAction::addActionEnd, this, [=]() {
           endInsertRows();
        });
        connect(m_list, &TableAction::deleteActionStart, this, [=](int index) {
            beginRemoveRows(QModelIndex(), index, index);
        });
        connect(m_list, &TableAction::deleteActionEnd, this, [=]() {
            endRemoveRows();
        });
        connect(m_list, &TableAction::moveActionStart, this, [=](int from, int to) {
            beginMoveRows(QModelIndex(),from,from,QModelIndex(),to);
        });
        connect(m_list, &TableAction::moveActionEnd, this, [=]() {
            endMoveRows();
        });
        connect(m_list,SIGNAL(updateData(QString,int)), this, SLOT(setProperty(QString,int)));
    }

    emit listChanged(m_list);

    endResetModel();
}

QList<Action> ActionModel::getList() const{
    return m_list->getActions(TableAction::NotDone);
}
