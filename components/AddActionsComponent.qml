import QtQuick 2.11
import QtQuick.Controls 2.4

Item{
    id: item

    property bool isEnable: true

    width: mainRow.width
    height: 40

    Row{
        id: mainRow
        height: item.height
        spacing: 5
        anchors.horizontalCenter: item.horizontalCenter
        Rectangle{
            id: rect
            width: item.height
            height: width
            color: "transparent"
            Rectangle{
                width: 2
                height: 14
                color: ApplicationSettings.isDarkTheme ? item.isEnable ? "silver" : "#717171" : item.isEnable ? "#454545" : "#929292"
                anchors.centerIn: rect
                Behavior on color {
                    ColorAnimation{
                        duration: 200
                    }
                }
            }
            Rectangle{
                width: 14
                height: 2
                color: ApplicationSettings.isDarkTheme ? item.isEnable ? "silver" : "#717171" : item.isEnable ? "#454545" : "#929292"
                anchors.centerIn: rect
                Behavior on color {
                    ColorAnimation{
                        duration: 200
                    }
                }
            }
        }
        Label{
            height: item.height
            text: "Добавить пункт"
            font.pixelSize: 16
            verticalAlignment: Text.AlignVCenter
            color: ApplicationSettings.isDarkTheme ? item.isEnable ? "silver" : "#717171" : item.isEnable ? "#454545" : "#929292"
            Behavior on color {
                ColorAnimation{
                    duration: 200
                }
            }
        }
    }
    MouseArea{
        anchors.fill: item
        enabled: item.isEnable
        onClicked: {
            ApplicationSettings.commitInputMethod()
            if(fieldAction.text.length == 0){
                msgError.showMessage("Введите текст заметки")
                page.contentYPosition = 0
            }
            else{
                tableAction.addAction(fieldAction.text)
                fieldAction.clear()
            }
        }
    }
}
