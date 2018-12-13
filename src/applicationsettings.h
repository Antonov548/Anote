#pragma once

#include <QJsonDocument>
#include <QJsonObject>
#include <QFile>
#include <QTextStream>
#include <QString>
#include <QObject>
#include <QList>
//#include <QtAndroidExtras>

class ApplicationSettings : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool isBlock READ isBlock WRITE setIsBlock NOTIFY isBlockChanged)
    Q_PROPERTY(bool isDarkTheme READ isDarkTheme WRITE setIsDarkTheme NOTIFY isDarkThemeChanged)
    Q_PROPERTY(bool isOrder READ isOrder WRITE setIsOrder NOTIFY isOrderChanged)
    Q_PROPERTY(QString font READ font WRITE setFont NOTIFY fontChanged)

    explicit ApplicationSettings(QObject *parent = nullptr);
    ~ApplicationSettings();

    ApplicationSettings(ApplicationSettings const&) = delete;
    ApplicationSettings& operator= (ApplicationSettings const&) = delete;

    static ApplicationSettings* instance;
    QJsonObject j_object;
    QFile j_file;
    QList<QString> list_month;
    QList<QString> list_week;


    bool setJSON(QString);
    void setDefault();
    void saveToFile();

    bool m_isBlock;
    QString passwordHash;
    bool m_isDarkTheme;
    QString m_font;
    bool m_isOrder;

public:
    bool isBlock() const;
    bool isDarkTheme() const;
    void initializeAndroidKeyboard();
  //  static void keyboardAndroidChanged(JNIEnv *env, jobject thiz, jint VirtualKeyboardHeight);
    static ApplicationSettings *AppSettingsInstance();
    void setFile(QString);
    QString font() const;
    bool isOrder() const;

signals:
    void isBlockChanged(bool isBlock);
    void isDarkThemeChanged(bool isDarkTheme);
    void keyboardChanged(int keyboardHeight);
    void commit();
    void fontChanged(QString font);
    void isOrderChanged(bool isOrder);

public slots:
    void setIsBlock(bool isBlock);
    bool blockAppOnStart();
    void setIsDarkTheme(bool isDarkTheme);
    void setPassword(QString pass);
    bool comparePassword(QString pass);
    void commitInputMethod();
    void setFont(QString font);
    void setIsOrder(bool isOrder);
    QString getMonth(int number);
    QString getDayOfWeek(int number);
};
