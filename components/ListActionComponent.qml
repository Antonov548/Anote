import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Window 2.11

Item{
    id: item

    property string itemText: ""

    height: textAction.implicitHeight + bottomSpaccing.height
    width: parent.width/1.2
    anchors.horizontalCenter: parent.horizontalCenter
    clip: true

    ListView.onAdd: NumberAnimation {
        target: item
        property: "opacity"
        from: 0
        to: 1
        duration: 300
        easing.type: Easing.InOutQuad
    }

    ListView.onRemove: SequentialAnimation {
        PropertyAction { target: item; property: "ListView.delayRemove"; value: true }
        ParallelAnimation{
            NumberAnimation { target: item; property: "height"; to: 0; duration: 250; easing.type: Easing.InOutQuad }
            NumberAnimation { target: mainColumn; property: "opacity"; to: 0; duration: 150; easing.type: Easing.InOutQuad }
        }
        PropertyAction { target: item; property: "ListView.delayRemove"; value: false }
    }
    Column{
        id: mainColumn
        width: item.width
        height: item.height
        Rectangle{
            width: item.width
            height: item.height - bottomSpaccing.height
            color: ApplicationSettings.isDarkTheme ? "#3A3A3A" : "#E1E1E1"
            radius: 4
            Text{
                id: textAction
                text: itemText
                height: contentHeight
                width: parent.width/1.1
                color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                font.pixelSize: 16
                wrapMode: Text.Wrap
                padding: 10
            }

            Button{
                id: button
                width: textAction.contentHeight/textAction.lineCount
                height: width
                clip: true
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.top: parent.top
                anchors.topMargin: (width + textAction.padding*2 - height)/2

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
        Rectangle{
            id: bottomSpaccing
            width: item.width
            height: 15
            color: "transparent"
        }
    }
}
