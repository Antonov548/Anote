import QtQuick 2.11
import QtQuick.Controls 2.4

Item{
    property bool isOpen: false

    id: item
    visible: isOpen
    anchors.fill: parent

    property var onOkey: function(){}
    property var onCancel: function(){}
    property alias text: information.text

    state: isOpen ? "open" : "close"

    states: [
        State {
            name: "close"
            PropertyChanges{target: background ; opacity: 0; visible: false}
            PropertyChanges{target: content ; visible: false}
        },
        State {
            name: "open"
            PropertyChanges{target: background ; opacity: 0.6; visible: true}
            PropertyChanges{target: content ; visible: true}
        }
    ]

    transitions: [
        Transition {
            from: "close"
            to: "open"
            SequentialAnimation{
                PropertyAction {targets: [background,content]; properties: "visible"; value: true }
                ParallelAnimation{
                    PropertyAnimation{target: background; property: "opacity"; duration: 250; easing.type: Easing.OutCirc}
                }
            }
        },
        Transition {
            from: "open"
            to: "close"
            SequentialAnimation{
                PropertyAction {targets: [content]; properties: "visible"; value: false}
                ParallelAnimation{
                    PropertyAnimation{target: background; property: "opacity"; duration: 150; easing.type: Easing.OutCirc}
                }
                PropertyAction {targets: [background]; properties: "visible"; value: false}
            }
        }
    ]

    Page{
        padding: 0
        anchors.fill: parent

        background: Rectangle{
            id: background
            parent: ApplicationWindow.overlay
            anchors.fill: parent
            color: "black"
            MouseArea{
                anchors.fill: parent
                onClicked: isOpen = false
            }
        }
        Page{
            id: content
            clip: true
            parent: ApplicationWindow.overlay
            width: item.width/1.4
            height: item.height/3
            anchors.centerIn: parent
            background: Rectangle{
                anchors.fill: parent
                radius: 6
                color: ApplicationSettings.isDarkTheme ? "#333333" : "#E9E9E9"
            }

            contentItem: Text{
                id: information
                width: parent.width
                height: parent.height
                leftPadding: 20
                rightPadding: 20
                font.pixelSize: 16
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.Wrap
                font.family: ApplicationSettings.font
                color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
            }

            footer: Column{
                width: parent.width
                Row{
                    anchors.right: parent.right
                    topPadding: 10
                    bottomPadding: 10
                    rightPadding: 20
                    spacing: 10

                    Button{
                        id: btnOkey
                        width: 70
                        onClicked: onOkey()
                        contentItem:Text{
                            width: parent.width
                            horizontalAlignment: Text.AlignHCenter
                            text: "Ок"
                            font.pixelSize: 16
                            font.family: ApplicationSettings.font
                            color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                        }
                        background: Rectangle{
                            radius: 4
                            anchors.fill: parent
                            color: ApplicationSettings.isDarkTheme ? btnOkey.pressed ? "#3C3C3C" : "#272727" : btnOkey.pressed ? "#C6C6C6" : "#DADADA"
                        }
                    }
                    Button{
                        id: btnCancel
                        width: 70
                        onClicked: onCancel()
                        contentItem:Text{
                            width: parent.width
                            horizontalAlignment: Text.AlignHCenter
                            text: "Отмена"
                            font.pixelSize: 16
                            font.family: ApplicationSettings.font
                            color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                        }
                        background: Rectangle{
                            radius: 4
                            anchors.fill: parent
                            color: ApplicationSettings.isDarkTheme ? btnCancel.pressed ? "#3C3C3C" : "#272727" : btnCancel.pressed ? "#C6C6C6" : "#DADADA"
                        }
                    }
                }
            }
        }
    }
}
