#include "abstractactionmodel.h"

AbstractActionModel::AbstractActionModel(){
}

int AbstractActionModel::rowCount(const QModelIndex &parent) const{
    if (parent.isValid())
        return 0;
    return getList().count();
}

QVariant AbstractActionModel::data(const QModelIndex &index, int role) const{
    if (!index.isValid())
        return QVariant();

    const Action action = getList().at(index.row());

    switch (role) {
    case Information:
        return  QVariant(action.information);
    case IsDone:
        return  QVariant(action.isDone);
    case Date:
        return QVariant(action.date);
    case Index:
        return QVariant(action.db_index);
    }
    return QVariant();
}

TableAction *AbstractActionModel::list() const{
    return m_list;
}

QHash<int, QByteArray> AbstractActionModel::roleNames() const{
    roles[Information] = "info";
    roles[IsDone] = "done";
    roles[Date] = "date";
    roles[Index] = "action_index";

    return roles;
}

Qt::ItemFlags AbstractActionModel::flags(const QModelIndex &index) const{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable;
}

bool AbstractActionModel::setProperty(QString role, int index){
    if(!m_list)
        return  false;

    int number_role = roles.key(role.toUtf8());
    QVector<int> changed_role;
    changed_role << number_role;

    emit dataChanged(QAbstractListModel::index(index), QAbstractListModel::index(index), changed_role);
    return true;
}
