import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQml.Models 2.1

Item{
    id: item

    width: parent.width
    height: 60 + bottomSpacing.height
    anchors.horizontalCenter: parent.horizontalCenter
    clip: true

    ListView.onRemove: SequentialAnimation {
        PropertyAction { target: item; property: "ListView.delayRemove"; value: true }
        PropertyAnimation {
            property: "height"
            target: item
            to: 0
            duration: (listView.count == 1) ? 0 : 150
            easing.type: Easing.InOutQuad
        }
        PropertyAction { target: item; property: "ListView.delayRemove"; value: false }
    }

    Column{
        id: mainColumn
        width: parent.width

        Drag.active: mouseArea.isHeld
        Drag.source: mouseArea
        Drag.hotSpot.x: item.width/2
        Drag.hotSpot.y: item.height/2

        states: [
            State {
                when: mouseArea.isHeld
                ParentChange{
                    target: mainColumn; parent: stackInitial
                }
                AnchorChanges {
                    target: mainColumn
                    anchors { horizontalCenter: undefined; verticalCenter: undefined }
                }
            }
        ]

        Rectangle{
            height: 62
            width: parent.width/1.05
            radius: 8
            anchors.horizontalCenter: parent.horizontalCenter
            color: ApplicationSettings.isDarkTheme ? "#121212" : "#D6D6D6"
            Rectangle{
                width: parent.width
                height: 60
                radius: 8
                anchors.horizontalCenter: parent.horizontalCenter
                color: ApplicationSettings.isDarkTheme ?  mouseArea.pressed ? "#292929" : "#323232" : mouseArea.pressed ? "#DEDEDE" : "#E6E6E6"

                Row{
                    anchors.fill: parent
                    leftPadding: 40
                    Column{
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2
                        Label{
                            text: model.day + " " + model.month + ", " + model.day_w
                            font.family: ApplicationSettings.font
                            font.pixelSize: 16
                            color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                        }
                        Label{
                            text: (model.count_c === 0) ? "Все дела завершены" : model.count_c + " не завершенных дел"
                            font.family: "Arial"
                            font.pixelSize: 12
                            color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                        }
                    }
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

                    onClicked: {tableAction.getActionsDatabase(model.date); stackView.push("qrc:/qml/pages/NotePage.qml",{"month":model.month, "day":model.day, "day_w":model.day_w, "date":model.date, "indexNote":index})}
                    onPressAndHold: {isHeld = true; oldIndex = dragIndex}
                    onReleased: {isHeld = false;tableNote.reindexNotesFromTo(oldIndex,dragIndex)}

                    drag.target: (isHeld && !ApplicationSettings.isOrder) ? mainColumn : undefined
                    drag.axis: Drag.YAxis

                }
            }
        }

        Rectangle{
            id: bottomSpacing
            height: 12
            width: parent.width
            color: "transparent"
        }
    }
    DropArea {
        anchors.fill: parent
        anchors.margins: 10

        onEntered: {
            tableNote.moveNote(drag.source.dragIndex,
                               index)
        }
    }
}
