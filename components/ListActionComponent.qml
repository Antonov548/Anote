import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Window 2.11

Item{
    id: item

    property real startHeight: 0

    width: parent.width/1.2
    height: field.height + 12
    anchors.horizontalCenter: parent.horizontalCenter

    Component.onCompleted: {
        startHeight = item.height
    }

    ListView.onAdd: NumberAnimation {
        target: item
        property: "opacity"
        from: 0
        to: 1
        duration: 300
        easing.type: Easing.InOutQuad
    }

    Rectangle{
        width: item.width
        height: item.height
        color: ApplicationSettings.isDarkTheme ? "#3A3A3A" : "#E1E1E1"
        radius: 4
        TextArea{
            id: field
            placeholderText: "Текст заметки"
            width: parent.width/1.1
            padding: 5
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
            color: ApplicationSettings.isDarkTheme ? field.textChanged ? "silver" : "#747474"  :  field.textChanged ? "#454545" : "#A5A5A5"
            wrapMode: TextArea.Wrap

            onActiveFocusChanged: {
                if(field.activeFocus){
                    if(!page.keyBoardOpened)
                        page.coordFlick = listViewColumn.y + item.y + 30 + item.height + mainColumn.spacing
                    else
                        page.contentYPosition = listViewColumn.y + item.y + 30 + item.height + mainColumn.spacing - page.height
                }
            }
            onLineCountChanged: {
                page.contentYPosition = listViewColumn.y + item.y + 30 + item.height + mainColumn.spacing - page.height
            }
        }

        Button{
            id: button
            width: startHeight/1.2
            height: width
            clip: true
            visible: (field.activeFocus || button.pressed)
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.top: parent.top
            anchors.topMargin: (startHeight - height)/2

            onClicked: {
                tableAction.deleteAction(index)
            }

            background: Rectangle{
                anchors.fill: button
                color: "transparent"
            }
            contentItem: Rectangle{
                id: rect
                anchors.fill: parent
                color: "transparent"

                Rectangle{
                    width: 2
                    height: 16
                    color: ApplicationSettings.isDarkTheme ? "#A5A5A5" : "#454545"
                    anchors.centerIn: rect
                    transform: Rotation{ origin.x: 1; origin.y: 8; angle: 45}
                }
                Rectangle{
                    width: 16
                    height: 2
                    color: ApplicationSettings.isDarkTheme ? "#A5A5A5" : "#454545"
                    anchors.centerIn: rect
                    transform: Rotation{ origin.x: 8; origin.y: 1; angle: 45}
                }
            }
        }
    }
}
