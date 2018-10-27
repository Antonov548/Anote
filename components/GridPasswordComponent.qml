import QtQuick 2.11
import QtQuick.Controls 2.4

GridView{
    id: gridView
    height: contentHeight

    property var click: function(){}

    property alias delegateGrid: gridView.delegate

    boundsBehavior: Flickable.StopAtBounds

    cellWidth: width/3
    cellHeight: cellWidth

    model: ListModel{
        ListElement{text: "1"}
        ListElement{text: "2"}
        ListElement{text: "3"}

        ListElement{text: "4"}
        ListElement{text: "5"}
        ListElement{text: "6"}

        ListElement{text: "7"}
        ListElement{text: "8"}
        ListElement{text: "9"}
    }

    delegate: Button{
        id: button
        width: gridView.cellWidth
        height: gridView.cellHeight

        onClicked: gridView.click(model.text)

        contentItem: Label{
            anchors.fill: parent
            text: model.text
            color: "white"
            font.pointSize: 18
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        background: Rectangle{
            id: delegateBack
            anchors.fill: parent
            color: button.pressed ? "silver" : "transparent"
            opacity: 0.3
            radius: 2
        }
    }
}
