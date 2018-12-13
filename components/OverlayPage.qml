import QtQuick 2.11
import QtQuick.Controls 2.4

Item{
    id: item
    property alias content: page.contentData
    property bool isOpen: false
    property real duration: 200

    state: isOpen ? "open" : "close"

    states: [
        State {
            name: "close"
            PropertyChanges{target: background; opacity: 0; visible: false}
            PropertyChanges{target: page; visible: false}
        },
        State {
            name: "open"
            PropertyChanges{target: background; opacity: 0.6; visible: true}
            PropertyChanges{target: page; visible: true}
        }
    ]

    transitions: [
        Transition {
            from: "close"
            to: "open"
            SequentialAnimation{
                PropertyAction{targets: [page,background]; properties: "visible"; value: true}
                ParallelAnimation{
                    PropertyAnimation{target:background; property: "opacity"; duration: item.duration; easing.type: Easing.OutCirc}
                }
            }
        },
        Transition {
            from: "open"
            to: "close"
            SequentialAnimation{
                ParallelAnimation{
                    PropertyAnimation{target:background; property: "opacity"; duration: item.duration; easing.type: Easing.OutCirc}
                }
                PropertyAction{targets: [background,page]; properties: "visible"; value: false}
            }
        }
    ]

    Page{
        id: page
        parent: ApplicationWindow.overlay
        visible: false
        anchors.fill: parent
        padding: 0
        background: Rectangle{
            id: background
            anchors.fill: parent
            color: "black"
            MouseArea{
                anchors.fill: parent
                onClicked: isOpen = false
            }
        }
    }
}
