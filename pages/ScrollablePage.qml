import QtQuick 2.11
import QtQuick.Controls 2.4

Page {
    id: page
    clip: true

    property alias content: pane.contentItem
    property alias backgr: pane.background

    background: backgr

    Flickable {
        anchors.fill: parent
        contentHeight: pane.implicitHeight
        flickableDirection: Flickable.AutoFlickIfNeeded
        boundsBehavior: Flickable.StopAtBounds

        Pane {
            padding: 0
            id: pane
            width: parent.width
        }

        ScrollIndicator.vertical: ScrollIndicator {}
    }
}
