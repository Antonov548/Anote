import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Window 2.11

Item{
    id: item

    height: textAction.implicitHeight + bottomSpaccing.height
    width: parent.width/1.2
    anchors.horizontalCenter: parent.horizontalCenter
    clip: true

    ListView.onRemove: SequentialAnimation {
        PropertyAction { target: item; property: "ListView.delayRemove"; value: true }
        PropertyAction {target: button; property: "enabled"; value: false}
        ParallelAnimation{
            NumberAnimation { target: item; property: "height"; to: 0; duration: (listActions.count == 1) ? 0 : 250; easing.type: Easing.InOutQuad }
            NumberAnimation { target: mainColumn; property: "opacity"; to: 0; duration: (listActions.count == 1) ? 0 : 150; easing.type: Easing.InOutQuad }
        }
        PropertyAction { target: item; property: "ListView.delayRemove"; value: false }
    }

    ListView.onAdd: NumberAnimation {
        target: item
        property: "opacity"
        from: 0
        to: 1
        duration: 300
        easing.type: Easing.InOutQuad
    }

    Column{
        id: mainColumn
        width: item.width
        height: item.height

        Drag.active: mouseArea.isHeld
        Drag.source: mouseArea
        Drag.hotSpot.x: item.width/2
        Drag.hotSpot.y: item.height/2

        states: [
            State {
                when: mouseArea.isHeld
                ParentChange{
                    target: mainColumn; parent: page
                }
                AnchorChanges {
                    target: mainColumn
                    anchors { horizontalCenter: undefined; verticalCenter: undefined }
                }
            }
        ]

        Rectangle{
            width: item.width
            height: item.height - bottomSpaccing.height
            color: ApplicationSettings.isDarkTheme ? mouseArea.isHeld ? "#4C4C4C" : "#3A3A3A" : mouseArea.isHeld ? "#D7D7D7" : "#E1E1E1"
            Behavior on color{
                ColorAnimation{
                    duration: 200
                    easing.type: Easing.OutCirc
                }
            }

            radius: 4
            Text{
                id: textAction
                text: model.info
                height: contentHeight
                width: parent.width/1.1
                color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                font.pixelSize: 16
                wrapMode: Text.Wrap
                padding: 10
            }

            MouseArea{
                id: mouseArea
                property bool isHeld: false
                property real dragIndex: index
                property real oldIndex: -1

                width: parent.width
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                hoverEnabled: true
                pressAndHoldInterval: 300

                onPressAndHold: {isHeld = true; oldIndex = dragIndex}
                onReleased: {isHeld = false}

                drag.target: isHeld ? mainColumn : undefined
                drag.axis: Drag.YAxis
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
    DropArea {
        anchors.fill: parent
        anchors.margins: 10

        onEntered: {
            tableAction.moveAction(drag.source.dragIndex,index)
        }
    }
}
