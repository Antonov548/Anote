import QtQuick 2.11
import QtQuick.Controls 2.4

Item{
    id: item
    height: 40

    property alias buttonWidth: button.implicitWidth
    property alias text: button.text
    property var handler: function(){}

    signal click()

    Button{
        id: button
        height: parent.height
        width: parent.width
        onClicked: item.click()
        font.pixelSize: 14
        font.family: ApplicationSettings.font

        contentItem: Text{
            height: parent.height
            width: contentWidth
            leftPadding: 10
            rightPadding: 10
            text: button.text
            font: button.font
            color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
        background: Rectangle{
            id: background
            anchors.fill: parent
            color: ApplicationSettings.isDarkTheme ? button.pressed ? "#292929" : "#1B1B1B" : button.pressed ? "#DEDEDE" : "white"
        }
    }
}
