#pragma once

#include <QJsonDocument>
#include <QJsonObject>
#include <QFile>
#include <QTextStream>
#include <QString>
#include <QObject>
//#include <QtAndroidExtras>

class ApplicationSettings : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool isBlock READ isBlock WRITE setIsBlock NOTIFY isBlockChanged)
    Q_PROPERTY(bool isDarkTheme READ isDarkTheme WRITE setIsDarkTheme NOTIFY isDarkThemeChanged)

    explicit ApplicationSettings(QObject *parent = nullptr);
    ~ApplicationSettings();

    ApplicationSettings(ApplicationSettings const&) = delete;
    ApplicationSettings& operator= (ApplicationSettings const&) = delete;

    static ApplicationSettings* instance;
    QJsonObject j_object;
    QFile j_file;

    bool setJSON(QString);
    void setDefault();
    void saveToFile();

    bool m_isBlock;
    QString passwordHash;
    bool m_isDarkTheme;

public:
    bool isBlock() const;
    bool isDarkTheme() const;
    void initializeAndroidKeyboard();
  //  static void keyboardAndroidChanged(JNIEnv *env, jobject thiz, jint VirtualKeyboardHeight);
    static ApplicationSettings *AppSettingsInstance();
    void setFile(QString);

signals:
    void isBlockChanged(bool isBlock);
    void isDarkThemeChanged(bool isDarkTheme);
    void keyboardChanged(int keyboardHeight);

public slots:
    void setIsBlock(bool isBlock);
    bool blockAppOnStart();
    void setIsDarkTheme(bool isDarkTheme);
    void setPassword(QString pass);
    bool comparePassword(QString pass);
};
