import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Item{

    id: item

    width: parent.width - 16
    height: 60 + bottomSpacing.height
    anchors.horizontalCenter: parent.horizontalCenter
    clip: true

    ListView.onRemove: SequentialAnimation {
        PropertyAction { target: item; property: "ListView.delayRemove"; value: true }
        PropertyAnimation {
            property: "height"
            target: item
            to: 0
            duration: 300
            easing.type: Easing.InOutQuad
        }
        PropertyAction { target: item; property: "ListView.delayRemove"; value: false }
    }

    Column{
        width: parent.width
        Rectangle{

            width: parent.width
            height: 60
            radius: 2

            color: ApplicationSettings.isDarkTheme ?  mouseArea.pressed ? "#292929" : "#323232" : mouseArea.pressed ? "#DEDEDE" : "white"

            Rectangle{
                id: buttonTool
                height: 60
                width: visible ? lbl.implicitWidth : 0
                anchors.right: parent.right
                color: ApplicationSettings.isDarkTheme? "#292929" : "#DEDEDE"
                radius: 2
                visible: stackInitial.indexChange == index
                clip: true

                Behavior on width {
                    NumberAnimation{
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }
                Label{
                    id: lbl
                    anchors.centerIn: parent
                    font.pixelSize: 14
                    text: "Удалить"
                    rightPadding: 15
                    leftPadding: 15
                    color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        var data = listModel.getProperty("date",stackInitial.indexChange)
                        tableNote.deleteNote(data,stackInitial.indexChange)
                        tableAction.deleteActionsDatabase(data)
                        stackInitial.indexChange = -1
                    }
                }
            }

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
                onPressAndHold: {stackInitial.indexChange = index}
                pressAndHoldInterval: 300
                onClicked: {tableAction.getActionsDatabase(model.date); stackView.push("qrc:/qml/pages/NotePage.qml")}
            }
        }
        Rectangle{
            id: bottomSpacing
            height: 8
            width: parent.width
            color: "transparent"
        }
    }
}
