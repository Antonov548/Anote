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
