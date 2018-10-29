import QtQuick 2.11
import QtQuick.Controls 2.4

Component{

    Button{
        id: button
        width: parent.width
        height: 50

        enabled: delegateCheck

        onClicked: delegateHandler()

        contentItem: Label{
            anchors.fill: parent
            text: delegateTitle
            font.pixelSize: 16
            color: ApplicationSettings.isDarkTheme ? delegateCheck ? "silver" : "grey" : delegateCheck ? "black" : "silver"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            leftPadding: 30

        }

        background: Rectangle{
            anchors.fill: parent
            color: ApplicationSettings.isDarkTheme ?  button.pressed ? "#292929" : "#1B1B1B" : button.pressed ? "#DEDEDE" : "white"
        }
    }
}
