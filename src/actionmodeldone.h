#pragma once

#include "abstractactionmodel.h"

class ActionModelDone : public AbstractActionModel
{
    Q_OBJECT

    Q_PROPERTY(TableAction* list READ list WRITE setList NOTIFY listChanged)

public:
    ActionModelDone();

public slots:
    virtual void setList(TableAction* list) override;

signals:
    void listChanged(TableAction* list);

protected:
    virtual QList<Action> getList() const override;
    virtual int getCount() const override;
};
