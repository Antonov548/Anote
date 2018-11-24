import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Component{
    Rectangle{

        height: 50
        width: parent.width
        color: mouseArea.pressed ? ApplicationSettings.isDarkTheme ? "#454545" : "silver" : "transparent"

        Text{
            text: model.text
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: ApplicationSettings.font
            font.pixelSize: 16
            color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
        }

        MouseArea{
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: onClick()

            function onClick(){
                model.event()
            }
        }
    }
}
