#include "actionmodel.h"
#include <QDebug>

ActionModel::ActionModel(QObject *parent)
    : QAbstractListModel(parent),m_groupActions(ActionsGroup::All){

}

int ActionModel::rowCount(const QModelIndex &parent) const{
    if (parent.isValid())
        return 0;
    return getActionsGroup().count();
}

QVariant ActionModel::data(const QModelIndex &index, int role) const{
    if (!index.isValid())
        return QVariant();

    const Action action = getActionsGroup().at(index.row());

    switch (role) {
    case Information:
        return  QVariant(action.information);
    case IsDone:
        return  QVariant(action.isDone);
    case Date:
        return QVariant(action.date);
    case Index:
        return QVariant(action.index);
    }
    return QVariant();
}

TableAction *ActionModel::list() const{
    return m_list;
}

int ActionModel::groupActions() const{
    return m_groupActions;
}

QHash<int, QByteArray> ActionModel::roleNames()const{
    roles[Information] = "info";
    roles[IsDone] = "done";
    roles[Date] = "date";
    roles[Index] = "action_index";

    return roles;
}

Qt::ItemFlags ActionModel::flags(const QModelIndex &index) const{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable;
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
        connect(m_list, &TableAction::setDoneStart, this, &ActionModel::setDoneStart);
        connect(m_list, &TableAction::setDoneEnd, this,&ActionModel::setDoneEnd);
        connect(m_list,SIGNAL(updateData(QString,int)), this, SLOT(setProperty(QString,int)));
    }

    emit listChanged(m_list);

    endResetModel();
}

bool ActionModel::setProperty(QString role, int index){
    if(!m_list)
        return  false;

    int number_role = roles.key(role.toUtf8());
    QVector<int> changed_role;
    changed_role << number_role;

    emit dataChanged(ActionModel::index(index), ActionModel::index(index), changed_role);
    return true;
}

int ActionModel::getCount(){
    return m_list->getActions().size();
}

void ActionModel::setGroupActions(int groupActions){
    if (m_groupActions == groupActions)
        return;

    m_groupActions = groupActions;
    emit groupActionsChanged(m_groupActions);
}

QList<Action> ActionModel::getActionsGroup() const{
    QList<Action> list = m_list->getActions();

    switch (m_groupActions) {
    case OnlyDone:
        for(int i=0; i<list.count(); i++){
            if(!list.at(i).isDone){
                list.removeAt(i);
                i--;
            }
        }
        return list;
    case OnlyNotDone:
        for(int i=0; i<list.count(); i++){
            if(list.at(i).isDone){
                list.removeAt(i);
                i--;
            }
        }
        return list;
    }
    return list;
}

void ActionModel::setDoneStart(int remove, int db_add, bool isDone){
    int index_add;
    if(isDone){
        switch (m_groupActions) {
        case OnlyDone:
            index_add = getIndexFromGroup(db_add);
            qDebug() << index_add << "add_done";
            beginInsertRows(QModelIndex(),index_add,index_add);
            break;
        case OnlyNotDone:
            qDebug() << remove << "remove_done";
            beginRemoveRows(QModelIndex(),remove,remove);
            break;
        }
    }
    else{
        switch (m_groupActions) {
        case OnlyNotDone:
            index_add = getIndexFromGroup(db_add);
            qDebug() << index_add << "add_not";
            beginInsertRows(QModelIndex(),index_add,index_add);
            break;
        case OnlyDone:
            qDebug() << remove << "remove_not";
            beginRemoveRows(QModelIndex(),remove,remove);
            break;
        }
    }
}

void ActionModel::setDoneEnd(bool isDone){
    if(isDone){
        switch (m_groupActions) {
        case OnlyDone:
            endInsertRows();
            break;
        case OnlyNotDone:
            endRemoveRows();
            break;
        }
    }
    else{
        switch (m_groupActions) {
        case OnlyNotDone:
            endInsertRows();
            break;
        case OnlyDone:
            endRemoveRows();
            break;
        }
    }
}

int ActionModel::getIndexFromGroup(int db_index){
    QList<Action> list = getActionsGroup();

    if(list.count() == 0){
        return 0;
    }

    int count = list.count();
    for(int i=0; i<count; i++){
        if(db_index<list[i].index){
            if(i == count-1)
                return count;
            else
                continue;
        }
        else
            return i;
    }
    return -1;
}
