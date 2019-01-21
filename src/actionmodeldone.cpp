#include "actionmodeldone.h"

ActionModelDone::ActionModelDone(){
}

void ActionModelDone::setList(TableAction *list){
    beginResetModel();

    m_list = list;

    if (m_list) {
        connect(m_list, &TableAction::setDoneStart, this, [=](){
            const int index = 0;
            beginInsertRows(QModelIndex(), index, index);
        });
        connect(m_list, &TableAction::setDoneEnd, this, [=](){
            endInsertRows();
        });
        connect(m_list, &TableAction::setNotDoneStart, this, [=](int index){
            beginRemoveRows(QModelIndex(), index, index);
        });
        connect(m_list, &TableAction::setNotDoneEnd, this, [=](){
            endRemoveRows();
        });
    }
    emit listChanged(m_list);

    endResetModel();
}

QList<Action> ActionModelDone::getList() const{
    return m_list->getActions(TableAction::Done);
}

int ActionModelDone::getCount() const{
    return m_list->getActionsCount(TableAction::Done);
}
