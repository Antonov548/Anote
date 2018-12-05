import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Component{
    Column{
        width: parent.width

        Rectangle{
            height: 45
            width: parent.width
            color: mouseArea.pressed ? ApplicationSettings.isDarkTheme ? "#454545" : "silver" : "transparent"

            Text{
                text: model.text
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                leftPadding: 40
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
}
