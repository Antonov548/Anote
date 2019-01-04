#include "applicationsettings.h"
#include <QCryptographicHash>
#include <QDebug>

ApplicationSettings* ApplicationSettings::instance = nullptr;

bool ApplicationSettings::setJSON(QString file_path){
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

void ApplicationSettings::setDefault(){
    j_object.insert("isBlock",QJsonValue::fromVariant(false));
    j_object.insert("passwordHash",QJsonValue::fromVariant(""));
    j_object.insert("isDarkTheme",QJsonValue::fromVariant(false));
    j_object.insert("font",QJsonValue::fromVariant("Arial"));
    j_object.insert("isOrder",QJsonValue::fromVariant(false));

    saveToFile();
}

void ApplicationSettings::saveToFile(){
    j_file.open(QFile::ReadWrite);
    QJsonDocument document(j_object);
    j_file.write(document.toJson());
    j_file.close();
}

ApplicationSettings::ApplicationSettings(QObject *parent) : QObject(parent){
    list_month = {"Января","Февраля","Марта","Апреля","Мая","Июня","Июля","Августа","Сентября","Октября","Ноября","Декабря"};
    list_week = {"Вс","Пн","Вт","Ср","Чт","Пт","Сб"};
}

ApplicationSettings::~ApplicationSettings(){
}

bool ApplicationSettings::isBlock() const{
    return m_isBlock;
}

bool ApplicationSettings::isDarkTheme() const{
    return m_isDarkTheme;
}

void ApplicationSettings::initializeAndroidKeyboard(){
    JNINativeMethod methods[] = {
        {
            "VirtualKeyboardStateChanged",
            "(I)V",
            reinterpret_cast<void*>(keyboardAndroidChanged)
        }
    };

    QAndroidJniObject javaClass("anote/android/VirtualKeyboardListener");
    QAndroidJniEnvironment env;

    jclass objectClass = env->GetObjectClass(javaClass.object<jobject>());

    env->RegisterNatives(objectClass,
                         methods,
                         sizeof(methods) / sizeof(methods[0]));
    env->DeleteLocalRef(objectClass);

    QAndroidJniObject::callStaticMethod<void>("anote/android/VirtualKeyboardListener", "InstallKeyboardListener");
}

void ApplicationSettings::keyboardAndroidChanged(JNIEnv *env, jobject thiz, jint VirtualKeyboardHeight){
    Q_UNUSED(env)
    Q_UNUSED(thiz)

    instance->keyboardChanged(VirtualKeyboardHeight);
}

ApplicationSettings *ApplicationSettings::AppSettingsInstance(){
    if(!instance)
        instance = new ApplicationSettings();
    return instance;
}

void ApplicationSettings::setFile(QString filepath){
    if(!setJSON(filepath))
        setDefault();

    m_isDarkTheme = j_object.value("isDarkTheme").toBool();
    m_isBlock = j_object.value("isBlock").toBool();
    m_font = j_object.value("font").toString();
    m_isOrder = j_object.value("isOrder").toBool();
    passwordHash = j_object.value("passwordHash").toString();

}

QString ApplicationSettings::font() const{
    return m_font;
}

bool ApplicationSettings::isOrder() const{
    return m_isOrder;
}

void ApplicationSettings::setIsBlock(bool isBlock){
    if (m_isBlock == isBlock)
        return;

    m_isBlock = isBlock;

    j_file.resize(0);
    j_object.remove("isBlock");
    j_object.insert("isBlock",m_isBlock);

    saveToFile();
    emit isBlockChanged(m_isBlock);
}

bool ApplicationSettings::blockAppOnStart(){
    return m_isBlock;
}

void ApplicationSettings::setIsDarkTheme(bool isDarkTheme){
    if (m_isDarkTheme == isDarkTheme)
        return;

    m_isDarkTheme = isDarkTheme;

    j_file.resize(0);
    j_object.remove("isDarkTheme");
    j_object.insert("isDarkTheme",m_isDarkTheme);

    saveToFile();
    emit isDarkThemeChanged(m_isDarkTheme);
}

void ApplicationSettings::setPassword(QString pass){
    if(passwordHash == pass)
        return;

    passwordHash = QCryptographicHash::hash(pass.toUtf8(),QCryptographicHash::Md5);

    j_file.resize(0);
    j_object.remove("passwordHash");
    j_object.insert("passwordHash",passwordHash);

    saveToFile();
}

bool ApplicationSettings::comparePassword(QString pass){
    if(QCryptographicHash::hash(pass.toUtf8(),QCryptographicHash::Md5) == passwordHash)
        return true;
    else
        return false;
}

void ApplicationSettings::commitInputMethod(){
    emit commit();
}

void ApplicationSettings::setFont(QString font){
    if (m_font == font)
        return;

    m_font = font;
    emit fontChanged(m_font);
}

void ApplicationSettings::setIsOrder(bool isOrder){
    if (m_isOrder == isOrder)
        return;

    m_isOrder = isOrder;

    j_file.resize(0);
    j_object.remove("isOrder");
    j_object.insert("isOrder",m_isOrder);

    saveToFile();
    emit isOrderChanged(m_isOrder);
}

QString ApplicationSettings::getMonth(int number){
    if(number >= 0 && number<=11){
        return list_month.at(number);
    }
    else {
        return "invalid number";
    }
}

QString ApplicationSettings::getDayOfWeek(int number){
    if(number>=0 && number<=6){
        return list_week.at(number);
    }
    else {
        return "invalid number";
    }
}

void ApplicationSettings::showSnackBar(QString info){
    emit snackBarShowed(info);
}
