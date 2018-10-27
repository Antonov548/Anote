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

    switch (role) {

    case Title:
        return  QVariant(note.title);
    case Text:
        return  QVariant(note.text);

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

    roles[Title] = "title";
    roles[Text] = "text";

    return roles;
}

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

TableNote *NoteModel::list() const
{
    return m_list;
}


QString NoteModel::getProperty(QString role, int index)
{
    int rol = roles.key(role.toUtf8());

    switch (rol) {
    case Title:
        return m_list->getNote().at(index).title;
    case Text:
        return m_list->getNote().at(index).text;
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
