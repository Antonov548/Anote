#pragma once

#include <QAbstractListModel>
#include "tableaction.h"

class AbstractActionModel : public QAbstractListModel
{
    Q_OBJECT

public:
    AbstractActionModel();

    enum {
        Information = Qt::UserRole,
        IsDone,
        Date,
        Index
    };

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    virtual QHash<int,QByteArray> roleNames() const override;
    Qt::ItemFlags flags(const QModelIndex& index) const override;
    TableAction* list() const;

public slots:
    virtual void setList(TableAction* list) = 0;
    bool setProperty(QString, int);

signals:
    void listChanged(TableAction* list);

protected:
    TableAction* m_list;
    mutable QHash<int,QByteArray> roles;
    virtual QList<Action> getList() const = 0;
    virtual int getCount() const = 0;
};
