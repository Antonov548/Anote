import QtQuick 2.11
import QtQuick.Controls 2.4

Item{
    id: item
    property alias content: page.contentData
    property bool isOpen: false
    property bool fromTop: true

    state: isOpen ? "open" : "close"

    states: [
        State {
            name: "close"
            PropertyChanges{target: page.contentItem; opacity: 0.4; y: fromTop ? -page.contentHeight : page.height + page.contentHeight}
            PropertyChanges{target: background; opacity: 0; visible: false}
            PropertyChanges{target: page; visible: false}
        },
        State {
            name: "open"
            PropertyChanges{target: page.contentItem; opacity: 1; y: fromTop ? 0 : page.height - page.contentHeight}
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
                PropertyAction{target: page.contentItem; property: "opacity"; value: 1}
                ParallelAnimation{
                    PropertyAnimation{target:background; property: "opacity"; duration: 400; easing.type: Easing.OutCirc}
                    PropertyAnimation{target: page.contentItem; property: "y"; duration: 300; easing.type: Easing.OutCirc}
                }
            }
        },
        Transition {
            from: "open"
            to: "close"
            SequentialAnimation{
                ParallelAnimation{
                    PropertyAnimation{target:background; property: "opacity"; duration: 300; easing.type: Easing.OutCirc}
                    PropertyAnimation{target: page.contentItem; properties: "y,opacity"; duration: 300; easing.type: Easing.OutCirc}
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
