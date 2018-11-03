import QtQuick 2.11
import QtQuick.Controls 2.4

Item{
    id: item

    width: parent.width/1.1
    height: 40
    anchors.horizontalCenter: parent.horizontalCenter

    Rectangle{
        anchors.fill: parent
        color: "transparent"

        Row{
            height: item.height
            spacing: 0
            Rectangle{
                width: item.width - item.height
                height: item.height
                color: "transparent"
                Rectangle{
                    width: parent.width
                    height: 1
                    color: field.activeFocus ? "#21be2b" : "silver"
                    anchors.bottom: parent.bottom
                }

                TextInput{
                    property string placeholderText: "Текст заметки"
                    property bool textChanged: false

                    id: field
                    clip: true
                    text: placeholderText
                    height: parent.height
                    width: parent.width/1.1
                    anchors.horizontalCenter: parent.horizontalCenter
                    verticalAlignment: Text.AlignBottom
                    bottomPadding: 4
                    font.pixelSize: 16
                    inputMethodHints: Qt.ImhNoAutoUppercase
                    font.hintingPreference: Font.PreferVerticalHinting
                    color: ApplicationSettings.isDarkTheme ? field.textChanged ? "silver" : "#747474"  :  field.textChanged ? "#454545" : "#A5A5A5"

                    onActiveFocusChanged: {
                        if(field.activeFocus && !field.textChanged){
                            field.textChanged = true
                            field.text = ""
                        }
                        else if(!field.activeFocus && field.text.length === 0){
                            setPlaceHolder()
                        }
                    }

                    function setPlaceHolder(){
                        field.textChanged = false
                        field.text = field.placeholderText
                    }

                    function getInfo(){
                        if(textChanged)
                            return field.text
                        else
                            return ""
                    }
                }
            }
            Button{
                id: button
                width: field.height
                height: width
                anchors.verticalCenter: parent.verticalCenter
                clip: true

                onClicked: {
                    if(field.getInfo() === "")
                        msgError.showMessage("Введите текст заметки")
                    else{
                        tableAction.addAction(field.text)
                        field.setPlaceHolder()
                    }
                }

                background: Rectangle{
                    anchors.fill: button
                    color: ApplicationSettings.isDarkTheme ? button.pressed ? "grey" : "silver" : button.pressed ? "silver" : "#454545"
                }


                contentItem: Rectangle{
                    id: rect
                    anchors.fill: parent
                    color: "transparent"

                    Rectangle{
                        width: 2
                        height: 16
                        color: ApplicationSettings.isDarkTheme ? "black" : "white"
                        anchors.centerIn: rect
                    }
                    Rectangle{
                        width: 16
                        height: 2
                        color: ApplicationSettings.isDarkTheme ? "black" : "white"
                        anchors.centerIn: rect
                    }
                }
            }
        }
    }
}
