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
            font.pixelSize: 14
            font.family: ApplicationSettings.font
            color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            leftPadding: 30

        }

        indicator: Rectangle {
            id: backgroundCheck
            width: 45
            height: parent.height/2.5
            x: check.width - width - check.rightPadding
            y: check.topPadding + check.availableHeight / 2 - height / 2
            radius: height/2
            color: delegateCheck ? "#A6C4FF" : "#C2C2C2"

            Rectangle{
                id: indicatorCircle
                width: parent.height*1.3
                height: parent.height*1.3
                radius: height/2
                color: "#3073FA"
                x: delegateCheck ? backgroundCheck.width - indicatorCircle.width : 0
                y: -(height - parent.height)/2

                Behavior on x{
                    NumberAnimation{
                        duration: 150
                        easing.type: Easing.InOutSine
                    }
                }
            }
        }
    }
}
