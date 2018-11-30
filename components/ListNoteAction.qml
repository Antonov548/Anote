import QtQuick 2.11
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0

Item{
    id: item

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
        NumberAnimation { target: item; property: "height"; to: 0; duration: 200; easing.type: Easing.InOutQuad }
        PropertyAction { target: item; property: "ListView.delayRemove"; value: false }
    }
    Column{
        width: item.width
        height: item.height
        Rectangle{
            width: item.width
            height: item.height - bottomSpaccing.height
            color: ApplicationSettings.isDarkTheme ? "#3A3A3A" : "#E1E1E1"
            radius: 4

            state: model.done ? "done" : "default"

            states: [
                State {
                    name: "default"
                    PropertyChanges {target: textAction; color: ApplicationSettings.isDarkTheme ? "silver" : "#454545" }
                },
                State {
                    name: "done"
                    PropertyChanges {target: textAction; color: ApplicationSettings.isDarkTheme ? "#B5B5B5" : "#646464" }
                }
            ]

            Text{
                id: textAction
                text: model.info
                height: contentHeight
                width: parent.width/1.1
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
                anchors.rightMargin: 8
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
                    border.color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                    border.width: 2
                    radius: 4
                    Rectangle{
                        height: parent.height/1.5
                        color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                        width: 2
                        anchors.verticalCenter: parent.verticalCenter
                        x: (parent.width-width) - 3
                        transform: Rotation {origin.x: 0; origin.y: 1; angle: 45}
                    }
                    Rectangle{
                        height: parent.height/3.4
                        color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                        width: 2
                        y: 10
                        x: 4
                        transform: Rotation {origin.x: 0; origin.y: 1; angle: -45}
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
