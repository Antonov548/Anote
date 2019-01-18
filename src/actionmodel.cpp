#include "actionmodel.h"
#include <QDebug>

ActionModel::ActionModel(QObject *parent)
    : QAbstractListModel(parent){

}

int ActionModel::rowCount(const QModelIndex &parent) const{
    if (parent.isValid())
        return 0;
    return m_list->getActions().count();
}

QVariant ActionModel::data(const QModelIndex &index, int role) const{
    if (!index.isValid())
        return QVariant();

    const Action action = m_list->getActions().at(index.row());

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

QHash<int, QByteArray> ActionModel::roleNames() const{
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
    return m_list->getActions().count();
}
