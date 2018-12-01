import QtQuick 2.11
import QtQuick.Controls 2.4

Item{
    id: item
    visible: false
    property alias background: content.background
    property alias content: content.contentItem
    property alias footer: content.footer

    Page{
        padding: 0
        anchors.fill: parent

        background: Rectangle{
            id: background
            parent: ApplicationWindow.overlay
            visible: item.visible
            anchors.fill: parent
            color: "black"
            MouseArea{
                anchors.fill: parent
                onClicked: ApplicationWindow.overlay.visible = false
            }
        }

        Page{
            id: content
            x: item.x
            y: item.y
            width: item.width
            height: item.height
            visible: item.visible
            clip: true
            parent: ApplicationWindow.overlay
        }
    }
}
