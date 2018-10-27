import QtQuick 2.11
import QtQuick.Controls 2.4

Component{

    CheckDelegate{
        id: check
        width: parent.width
        height: 50
        checked: delegateCheck

        onClicked: delegateHandler()

        background: Rectangle{
            anchors.fill: parent
            color: ApplicationSettings.isDarkTheme ?  check.pressed ? "#292929" : "#1B1B1B" : check.pressed ? "#DEDEDE" : "white"
        }

        contentItem: Label{
            anchors.fill: parent
            text: delegateTitle
            font.pointSize: 15
            color: ApplicationSettings.isDarkTheme ? "silver" : "black"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            leftPadding: 30

        }

        indicator: Rectangle {
            width: 40
            height: parent.height/2.5
            x: check.width - width - check.rightPadding
            y: check.topPadding + check.availableHeight / 2 - height / 2
            radius: height/2
            color: delegateCheck ? "#6D88D3" : "#969696"

            Rectangle{
                id: indicatorCircle
                width: parent.height*1.2
                height: parent.height*1.2
                radius: height/2
                color: delegateCheck ? "#2D395B" : "#CFCFCF"
                x: 0
                y: -(height - parent.height)/2

                PropertyAnimation{
                    running: delegateCheck
                    property: "x"
                    target: indicatorCircle
                    to: 20
                    duration: 100

                }

                PropertyAnimation{
                    running: !delegateCheck
                    property: "x"
                    target: indicatorCircle
                    to: 0
                    duration: 100

                }

            }

        }

    }
}
