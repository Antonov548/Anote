import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Item{

    id: item

    width: parent.width - 16
    height: 60
    anchors.horizontalCenter: parent.horizontalCenter

    signal openDrawer(real c_index)


    ListView.onRemove: SequentialAnimation {

        PropertyAction { target: item; property: "ListView.delayRemove"; value: true }

        PropertyAnimation {
            property: "opacity"
            target: item
            to: 0
            duration: 400
            easing.type: Easing.InOutQuad
        }

        PropertyAction { target: item; property: "ListView.delayRemove"; value: false }
    }


    Rectangle{

        width: parent.width
        height: 60
        radius: 2

        color: ApplicationSettings.isDarkTheme ?  mouseArea.pressed ? "#292929" : "#323232" : mouseArea.pressed ? "#DEDEDE" : "white"

        Rectangle{
            width: parent.width
            height: 3
            color: ApplicationSettings.isDarkTheme ? "#272727" : "#DADADA"
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Row{
            anchors.fill: parent
            spacing: 100

            Rectangle{
                width: parent.width/5
                height: parent.height
                color: "#2D395B"
                radius: 2

                Column{
                    width: parent.width/2
                    height: parent.height
                    leftPadding: 5

                    Label{
                        topPadding: 2
                        leftPadding: 2
                        text: model.day
                        font.pixelSize: 16
                        color: "white"
                        height: parent.height/2
                        width: parent.width
                    }

                    Label{
                        leftPadding: 2
                        bottomPadding: 8
                        text: model.month
                        font.pixelSize: 12
                        color: "white"
                        height: parent.height/2
                        width: parent.width
                        verticalAlignment: Text.AlignBottom
                    }
                }

                Label{
                    topPadding: 2
                    width: parent.width/2
                    height: parent.height/2
                    text: model.day_w
                    color: "white"
                    font.pixelSize: 16
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.top: parent.top
                    horizontalAlignment: Text.AlignRight

                }
            }

            Label{
                height: parent.height
                width: contentWidth
                text: "Title"
                font.pixelSize: 17
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: ApplicationSettings.isDarkTheme? "white" : "black"
            }
        }

        MouseArea{

            id: mouseArea

            width: parent.width/1.3
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            hoverEnabled: true
            onPressAndHold: item.openDrawer(index)
            pressAndHoldInterval: 300
            onClicked: {console.log(model.date); tableAction.getActionsDatabase(model.date); stackView.push(Qt.createComponent("qrc:/qml/pages/NotePage.qml").createObject(null,{"noteTitle":model.title,"noteText":model.text}))}
        }
    }
}
