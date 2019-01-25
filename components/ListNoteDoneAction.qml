import QtQuick 2.11
import QtQuick.Controls 2.4

Item{
    id: item

    height: textAction.implicitHeight + bottomSpaccing.height
    width: parent.width/1.2
    anchors.horizontalCenter: parent.horizontalCenter
    clip: true

    ListView.onRemove: SequentialAnimation {
        PropertyAction {target: mouseArea; property: "enabled"; value: false}
        PropertyAction { target: item; property: "ListView.delayRemove"; value: true }
        ParallelAnimation{
            NumberAnimation { target: item; property: "height"; to: 0; duration: 150; easing.type: Easing.InOutQuad }
            NumberAnimation { target: mainColumn; property: "opacity"; to: 0; duration: 150; easing.type: Easing.InOutQuad }
        }
        PropertyAction { target: item; property: "ListView.delayRemove"; value: false }
    }

    ListView.onAdd: ParallelAnimation{
        NumberAnimation { target: item; property: "height"; from:0; to: item.height; duration: 150; easing.type: Easing.InOutQuad }
        NumberAnimation { target: mainColumn; property: "opacity"; from:0; to: 1; duration: 150; easing.type: Easing.InOutQuad }
    }
    MouseArea{
        id: mouseArea
        anchors.fill: parent
        onClicked: {tableAction.setNotDone(model.date,index)}
    }
    Column{
        id: mainColumn
        width: item.width
        height: item.height
        clip: true
        Rectangle{
            width: item.width
            height: item.height - bottomSpaccing.height
            color: ApplicationSettings.isDarkTheme ? "#3A3A3A" : "#E1E1E1"
            radius: 4
            clip: true

            Text{
                id: textAction
                text: model.info
                height: contentHeight
                width: parent.width/1.1
                font.family: ApplicationSettings.font
                font.pixelSize: 16
                wrapMode: Text.Wrap
                padding: 10
                color: ApplicationSettings.isDarkTheme ? "#7E7E7E" : "#9D9D9D"
            }
            Rectangle{
                width: textAction.contentHeight/textAction.lineCount
                height: width
                clip: true
                anchors.right: parent.right
                anchors.rightMargin: 8
                anchors.top: parent.top
                anchors.topMargin: (width + textAction.padding*2 - height)/2
                color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                border.color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                border.width: 2
                radius: 4
                Rectangle{
                    color: "transparent"
                    anchors.fill: parent
                    visible: true
                    Rectangle{
                        height: parent.height/1.5
                        color: ApplicationSettings.isDarkTheme ? "#454545" : "silver"
                        width: 2
                        anchors.verticalCenter: parent.verticalCenter
                        x: (parent.width-width) - 3
                        transform: Rotation {origin.x: 0; origin.y: 1; angle: 45}
                    }
                    Rectangle{
                        height: parent.height/3.4
                        color: ApplicationSettings.isDarkTheme ? "#454545" : "silver"
                        width: 2
                        y: 9
                        x: 3
                        transform: Rotation {origin.x: 0; origin.y: 1; angle: -45}
                    }
                }
            }
        }
        Rectangle{
            id: bottomSpaccing
            width: item.width
            height: 15
            color: "transparent"
        }
    }
}
