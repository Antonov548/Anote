import QtQuick 2.11
import QtQuick.Controls 2.4

Page {
    id: page
    clip: true

    property alias content: pane.contentItem
    property alias contentYPosition: flickable.contentY
    property color backgroundColor: "white"
    property real pageRadius: 0

    background: Rectangle{
        anchors.fill: page
        color: backgroundColor
        radius: pageRadius
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        contentHeight: pane.implicitHeight
        flickableDirection: Flickable.AutoFlickIfNeeded
        boundsBehavior: Flickable.StopAtBounds

        Behavior on contentY {
            NumberAnimation{
                duration: 150
            }
        }

        Pane {
            padding: 0
            id: pane
            width: parent.width

            background: Rectangle{
                anchors.fill: parent
                color: backgroundColor
                radius: pageRadius
            }
        }

        ScrollIndicator.vertical: ScrollIndicator {}
    }
}
