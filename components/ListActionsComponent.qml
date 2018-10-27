import QtQuick 2.11
import QtQuick.Controls 2.4

Item{
    id: item

    property alias itemText: field.text

    width: parent.width/1.1
    height: 40
    anchors.horizontalCenter: parent.horizontalCenter

    Rectangle{
        anchors.fill: parent
        color: "transparent"

        Row{
            height: item.height
            spacing: 5
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
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 15
                    color: ApplicationSettings.isDarkTheme ? field.textChanged ? "silver" : "#747474"  :  field.textChanged ? "#454545" : "#A5A5A5"

                    onActiveFocusChanged: {
                        if(field.activeFocus && !field.textChanged){
                            field.textChanged = true
                            field.text = ""
                        }
                        else if(!field.activeFocus && field.text.length === 0){
                            field.textChanged = false
                            field.text = field.placeholderText
                        }

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
                    if(!model.added){
                        listModel.setProperty(index,"added",true)
                        listModel.insert(0,{"added": false})
                    }
                    else{
                        listModel.remove(index)
                    }

                }


                background: Rectangle{
                    anchors.fill: parent
                    color: ApplicationSettings.isDarkTheme ? button.pressed ? "grey" : "silver" : button.pressed ? "silver" : "#454545"
                }


                contentItem: Rectangle{
                    id: rect
                    anchors.fill: parent
                    color: "transparent"

                    RotationAnimation{
                        target: rect
                        running: model.added
                        from: 0
                        to: 45
                        duration: 100
                    }

                    Rectangle{
                        width: 2
                        height: 16
                        color: ApplicationSettings.isDarkTheme ? "black" : "white"
                        anchors.centerIn: parent
                    }
                    Rectangle{
                        width: 16
                        height: 2
                        color: ApplicationSettings.isDarkTheme ? "black" : "white"
                        anchors.centerIn: parent
                    }
                }
            }
        }
    }
}
