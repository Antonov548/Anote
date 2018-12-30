import QtQuick 2.11
import QtQuick.Controls 2.4

GridView{
    id: gridView
    height: contentHeight

    property var click: function(){}

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
            color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
            font.pixelSize: 20
            font.family: ApplicationSettings.font
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        background: Rectangle{
            id: delegateBack
            width: parent.width
            height: parent.height
            color: "silver"
            opacity: button.pressed ? 0.3 : 0
            radius: width/2
            anchors.centerIn: parent
            Behavior on opacity{
                OpacityAnimator{
                    duration: 150
                }
            }
        }
    }
}
