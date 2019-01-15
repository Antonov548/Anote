#pragma once

#include <QAbstractListModel>
#include "tableaction.h"

class ActionModel : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(TableAction* list READ list WRITE setList NOTIFY listChanged)
    Q_PROPERTY(int groupActions READ groupActions WRITE setGroupActions NOTIFY groupActionsChanged)

public:
    explicit ActionModel(QObject *parent = nullptr);

    enum {
        Information = Qt::UserRole,
        IsDone,
        Date
    };

    enum ActionsGroup {
        All,
        OnlyDone,
        OnlyNotDone
    };
    Q_ENUM(ActionsGroup)

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    virtual QHash<int,QByteArray> roleNames() const override;
    Qt::ItemFlags flags(const QModelIndex& index) const override;
    TableAction* list() const;
    int groupActions() const;

public slots:
    void setList(TableAction* list);
    bool setProperty(QString, int);
    int getCount();
    void setGroupActions(int groupActions);

signals:
    void listChanged(TableAction* list);
    void groupActionsChanged(int groupActions);

private:
    TableAction* m_list;
    mutable QHash<int,QByteArray> roles;
    int m_groupActions;
    QList<Action> getActionsGroup() const;
};

