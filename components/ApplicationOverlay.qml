import QtQuick 2.11
import QtQuick.Controls 2.4

Item{
    id: item
    visible: isOpen
    property alias content: page.contentData
    property bool isOpen: false

    state: isOpen ? "open" : "close"

    states: [
        State {
            name: "close"
            PropertyChanges{target: page.contentItem; visible: false}
            PropertyChanges{target: background; opacity: 0}
            PropertyChanges{target: page; visible: false}
        },
        State {
            name: "open"
            PropertyChanges{target: page.contentItem; visible: true}
            PropertyChanges{target: background; opacity: 0.6}
            PropertyChanges{target: page; visible: true}
        }
    ]

    transitions: [
        Transition {
            from: "close"
            to: "open"
            SequentialAnimation{
                PropertyAction {targets: [background,page.contentItem,page]; property: "visible"; value: true}
                ParallelAnimation{
                    PropertyAnimation{target:background; property:"opacity"; duration: 250; easing.type: Easing.OutCirc}
                }
            }
        },
        Transition {
            from: "open"
            to: "close"
            SequentialAnimation{
                PropertyAction {target: page.contentItem; property: "visible"; value: false}
                ParallelAnimation{
                    PropertyAnimation{target:background; property:"opacity"; duration: 150; easing.type: Easing.OutCirc}
                }
                PropertyAction{targets: [background,page]; properties: "visible"; value: false}
            }
        }
    ]

    Page{
        id: page
        parent: ApplicationWindow.overlay
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
