#pragma once

#include <QJsonDocument>
#include <QJsonObject>
#include <QFile>
#include <QTextStream>
#include <QString>
#include <QObject>

class ApplicationSettings : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool isBlock READ isBlock WRITE setIsBlock NOTIFY isBlockChanged)
    Q_PROPERTY(bool isDarkTheme READ isDarkTheme WRITE setIsDarkTheme NOTIFY isDarkThemeChanged)

    QJsonObject j_object;
    QFile j_file;

    bool setJSON(QString);
    void setDefault();
    void saveToFile();

    bool m_isBlock;
    QString passwordHash;
    bool m_isDarkTheme;

public:
    explicit ApplicationSettings(QString, QObject *parent = nullptr);
    ~ApplicationSettings();
    bool isBlock() const;
    bool isDarkTheme() const;

signals:
    void isBlockChanged(bool isBlock);
    void isDarkThemeChanged(bool isDarkTheme);

public slots:
    void setIsBlock(bool isBlock);
    bool blockAppOnStart();
    void setIsDarkTheme(bool isDarkTheme);
    void setPassword(QString pass);
    bool comparePassword(QString pass);
};
