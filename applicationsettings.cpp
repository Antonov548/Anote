#include "applicationsettings.h"
#include <QCryptographicHash>
#include <QDebug>

ApplicationSettings* ApplicationSettings::instance = nullptr;

bool ApplicationSettings::setJSON(QString file_path)
{
    j_file.setFileName(file_path);

    if(!j_file.exists())
        return false;

    j_file.open(QFile::ReadWrite);

    // text stream for get all text
    QTextStream stream(&j_file);
    QString textJson = stream.readAll();

    // byte array for QDocument as argument
    QByteArray textJson_byte = textJson.toLocal8Bit();

    QJsonDocument document = QJsonDocument::fromJson(textJson_byte);

    // create QJSONobject from QJSONdocument
    j_object = document.object();

    j_file.close();

    return true;
}

void ApplicationSettings::setDefault()
{
    j_object.insert("isBlock",QJsonValue::fromVariant(false));
    j_object.insert("passwordHash",QJsonValue::fromVariant(""));
    j_object.insert("isDarkTheme",QJsonValue::fromVariant(false));

    saveToFile();
}

void ApplicationSettings::saveToFile()
{
    j_file.open(QFile::ReadWrite);
    QJsonDocument document(j_object);
    j_file.write(document.toJson());
    j_file.close();
}

ApplicationSettings::ApplicationSettings(QObject *parent) : QObject(parent)
{
}

ApplicationSettings::~ApplicationSettings()
{
}

bool ApplicationSettings::isBlock() const
{
    return m_isBlock;
}

bool ApplicationSettings::isDarkTheme() const
{
    return m_isDarkTheme;
}

/*
void ApplicationSettings::initializeAndroidKeyboard()
{
    JNINativeMethod methods[] = {
        {
            "VirtualKeyboardStateChanged",
            "(I)V",
            reinterpret_cast<void*>(keyboardAndroidChanged)
        }
    };

    QAndroidJniObject javaClass("anote/java/keyboardsize/VirtualKeyboardListener");
    QAndroidJniEnvironment env;

    jclass objectClass = env->GetObjectClass(javaClass.object<jobject>());

    env->RegisterNatives(objectClass,
                         methods,
                         sizeof(methods) / sizeof(methods[0]));
    env->DeleteLocalRef(objectClass);

    QAndroidJniObject::callStaticMethod<void>("anote/java/keyboardsize/VirtualKeyboardListener", "InstallKeyboardListener");
}

void ApplicationSettings::keyboardAndroidChanged(JNIEnv *env, jobject thiz, jint VirtualKeyboardHeight)
{
    Q_UNUSED(env)
    Q_UNUSED(thiz)

    instance->keyboardChanged(VirtualKeyboardHeight);
}
*/

ApplicationSettings *ApplicationSettings::AppSettingsInstance()
{
    if(!instance)
        instance = new ApplicationSettings();
    return instance;
}

void ApplicationSettings::setFile(QString filepath)
{
    if(!setJSON(filepath))
        setDefault();

    m_isDarkTheme = j_object.value("isDarkTheme").toBool();
    m_isBlock = j_object.value("isBlock").toBool();
    passwordHash = j_object.value("passwordHash").toString();

}

void ApplicationSettings::setIsBlock(bool isBlock)
{
    if (m_isBlock == isBlock)
        return;

    m_isBlock = isBlock;

    j_file.resize(0);
    j_object.remove("isBlock");
    j_object.insert("isBlock",m_isBlock);

    saveToFile();

    emit isBlockChanged(m_isBlock);
}

bool ApplicationSettings::blockAppOnStart()
{
    return m_isBlock;
}

void ApplicationSettings::setIsDarkTheme(bool isDarkTheme)
{
    if (m_isDarkTheme == isDarkTheme)
        return;

    m_isDarkTheme = isDarkTheme;

    j_file.resize(0);
    j_object.remove("isDarkTheme");
    j_object.insert("isDarkTheme",m_isDarkTheme);

    saveToFile();

    emit isDarkThemeChanged(m_isDarkTheme);
}

void ApplicationSettings::setPassword(QString pass)
{
    if(passwordHash == pass)
        return;

    passwordHash = QCryptographicHash::hash(pass.toUtf8(),QCryptographicHash::Md5);

    j_file.resize(0);
    j_object.remove("passwordHash");
    j_object.insert("passwordHash",passwordHash);

    saveToFile();
}

bool ApplicationSettings::comparePassword(QString pass)
{
    if(QCryptographicHash::hash(pass.toUtf8(),QCryptographicHash::Md5) == passwordHash)
        return true;
    else
        return false;
}
