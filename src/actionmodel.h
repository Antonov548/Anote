#pragma once

#include <QAbstractListModel>
#include "tableaction.h"

class ActionModel : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(TableAction* list READ list WRITE setList NOTIFY listChanged)

public:
    explicit ActionModel(QObject *parent = nullptr);

    enum {
        Information = Qt::UserRole,
        IsDone,
        Date,
        Index
    };

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    virtual QHash<int,QByteArray> roleNames() const override;
    Qt::ItemFlags flags(const QModelIndex& index) const override;
    TableAction* list() const;

public slots:
    void setList(TableAction* list);
    bool setProperty(QString, int);
    int getCount();

signals:
    void listChanged(TableAction* list);

private:
    TableAction* m_list;
    mutable QHash<int,QByteArray> roles;
    void setDoneStart(int remove, int db_add, bool isDone);
    void setDoneEnd(bool isDone);
    int getIndexFromGroup(int db_index);
};

