#pragma once

#include "tableaction.h"
#include "abstractactionmodel.h"

class ActionModel : public AbstractActionModel
{
    Q_OBJECT

    Q_PROPERTY(TableAction* list READ list WRITE setList NOTIFY listChanged)

public:
    ActionModel();

public slots:
    virtual void setList(TableAction* list) override;

signals:
    void listChanged(TableAction* list);

protected:
    virtual QList<Action> getList() const override;
};

