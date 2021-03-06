import QtQuick 2.11
import QtQuick.Controls 2.4

Item{
    id: item

    width: mainRow.width
    height: 40

    Row{
        id: mainRow
        height: item.height
        anchors.horizontalCenter: item.horizontalCenter
        Rectangle{
            id: rect
            width: item.height
            height: width
            color: "transparent"
            Rectangle{
                width: 2
                height: 14
                color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                anchors.centerIn: rect
            }
            Rectangle{
                width: 14
                height: 2
                color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                anchors.centerIn: rect
            }
        }
        Label{
            height: item.height
            text: "Добавить пункт"
            font.pixelSize: 16
            padding: 0
            verticalAlignment: Text.AlignVCenter
            color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
        }
    }
    MouseArea{
        anchors.fill: item
        onClicked: {
            ApplicationSettings.commitInputMethod()

            // FIXME : check empty text field only with '/n'
            // FIXME : clear '/n' simvols after text

            if(fieldAction.text.length == 0){
                fieldAction.isIncorrect = true
                page.contentYPosition = 0
            }
            else{
                tableAction.addAction(fieldAction.text)
                fieldAction.isIncorrect = false
                fieldAction.clear()
            }
        }
    }
}
