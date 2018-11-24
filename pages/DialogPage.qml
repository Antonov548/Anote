import QtQuick 2.11
import QtQuick.Controls 2.4

Item{
    id: item
    visible: isOpen
    anchors.fill: parent

    property bool isOpen: false

    Popup{
        id: background
        visible: true
        padding: 0
        x: (parent.width - width)/2
        y: (parent.height - height)/2

        background: Rectangle{
            visible: isOpen
            parent: ApplicationWindow.overlay
            anchors.fill: parent
            color: "black"
            opacity: 0.6
            MouseArea{
                anchors.fill: parent
                onClicked: isOpen = false
            }
        }
        contentItem: Page{
            implicitHeight: item.height/4
            implicitWidth: item.width/1.7
            anchors.centerIn: parent
            background: Rectangle{
                anchors.fill: parent
                radius: 6
            }
        }
    }
}
