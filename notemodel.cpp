#include "notemodel.h"

NoteModel::NoteModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int NoteModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    return m_list->getNote().size();
}

QVariant NoteModel::data(const QModelIndex &index, int role) const
{

    if (!index.isValid())
        return QVariant();

    const Note note = m_list->getNote().at(index.row());

    switch (role){

    case Month:
        return  QVariant(note.month);
    case Day_w:
        return  QVariant(note.day_w);
    case Day:
        return QVariant(note.day);
    case Date:
        return QVariant(note.date);

    }

    return QVariant();
}

Qt::ItemFlags NoteModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable;
}

QHash<int, QByteArray> NoteModel::roleNames()const
{

    roles[Month] = "month";
    roles[Day_w] = "day_w";
    roles[Day] = "day";
    roles[Date] = "date";

    return roles;
}

/*
bool NoteModel::setData(const QModelIndex &index, const QVariant &value,int role)
{
    if(!m_list)
        return  false;

    Note note = m_list->getNote().at(index.row());

    switch (role) {
    case Title:
        note.title = value.toString();
        break;
    case Text:
        note.text = value.toString();
        break;
    }

    if (m_list->setNoteAt(index.row(), note)) {
        emit dataChanged(index, index);
        return true;
    }


    return  false;

}
*/

TableNote *NoteModel::list() const
{
    return m_list;
}


QString NoteModel::getProperty(QString role, int index)
{
    int rol = roles.key(role.toUtf8());

    switch (rol) {
    case Month:
        return m_list->getNote().at(index).month;
    case Day_w:
        return m_list->getNote().at(index).day_w;
    case Day:
        return QString::number(m_list->getNote().at(index).day);
    case Date:
        return m_list->getNote().at(index).date;
    }

    return QString();

}

void NoteModel::setList(TableNote *list)
{

    beginResetModel();

    m_list = list;

    if (m_list) {
        connect(m_list, &TableNote::addNoteStart, this, [=]() {
            const int index = 0;
            beginInsertRows(QModelIndex(), index, index);
        });
        connect(m_list, &TableNote::addNoteEnd, this, [=]() {
            endInsertRows();
        });

        connect(m_list, &TableNote::deleteNoteStart, this, [=](int index) {
            beginRemoveRows(QModelIndex(), index, index);
        });
        connect(m_list, &TableNote::deleteNoteEnd, this, [=]() {
            endRemoveRows();
        });
    }

    emit listChanged(m_list);

    endResetModel();
}
