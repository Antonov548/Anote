import QtQuick 2.11
import QtQuick.Controls 2.4

Item{
    id: item

    width: parent.width
    height: 40

    Rectangle{
        anchors.fill: parent
        color: "transparent"

        Rectangle{
            width: parent.width
            height: 1
            color: "silver"
            anchors.bottom: parent.bottom
        }

        Row{
            width: item.width
            height: item.height

            Rectangle{
                width: parent.width - parent.height
                height: parent.height
                color: "transparent"

                Flickable{
                    height: parent.height
                    width: parent.width/1.1
                    anchors.horizontalCenter: parent.horizontalCenter
                    boundsBehavior: Flickable.StopAtBounds
                    contentWidth: lblAction.width
                    clip: true

                    Label{
                        id: lblAction
                        height: parent.height
                        width: contentWidth
                        verticalAlignment: Text.AlignBottom
                        bottomPadding: 4
                        color: ApplicationSettings.isDarkTheme ? "#A7A7A7" : "#7C7C7C"

                        text: model.info
                        font.pixelSize: 16
                    }
                }
            }

            Button{
                id: button
                width: item.height
                height: width
                anchors.verticalCenter: parent.verticalCenter
                clip: true

                background: Rectangle{
                    anchors.fill: parent
                    color: ApplicationSettings.isDarkTheme ? button.pressed ? "grey" : "silver" : button.pressed ? "silver" : "#454545"
                }

                onClicked: tableAction.deleteAction(index)

                contentItem: Rectangle{
                    id: rect
                    anchors.fill: parent
                    color: "transparent"

                    Rectangle{
                        width: 2
                        height: 16
                        color: ApplicationSettings.isDarkTheme ? "black" : "white"
                        anchors.centerIn: parent
                        transform: Rotation{ origin.x: 1; origin.y: 8; angle: 45}
                    }
                    Rectangle{
                        width: 16
                        height: 2
                        color: ApplicationSettings.isDarkTheme ? "black" : "white"
                        anchors.centerIn: parent
                        transform: Rotation{ origin.x: 8; origin.y: 1; angle: 45}
                    }
                }
            }
        }
    }
}
