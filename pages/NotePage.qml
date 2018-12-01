import QtQuick 2.11
import QtQuick.Controls 2.4
import QtModel 1.0
import "../components"

ScrollablePage{
    id: page

    signal signalClose()

    function popSignal(){
        signalClose()
    }

    header: Rectangle{
        width: parent.width
        height: 50
        color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"
        visible: true

        Row{
            anchors.fill: parent
            spacing: 20
            padding: 0

            Button{
                id: button
                width: parent.height
                height: parent.height
                background: Rectangle{
                    anchors.fill: parent
                    color: ApplicationSettings.isDarkTheme ?  button.pressed ? "#292929" : "#1B1B1B" : button.pressed ? "#DEDEDE" : "white"
                    Rectangle{
                        height: 18
                        width: 2
                        color: ApplicationSettings.isDarkTheme? "silver" : "black"
                        anchors.centerIn: parent
                        transform: Rotation { origin.x: 1; origin.y: 9; angle: 45}
                    }
                    Rectangle{
                        height: 18
                        width: 2
                        color: ApplicationSettings.isDarkTheme? "silver" : "black"
                        anchors.centerIn: parent
                        transform: Rotation { origin.x: 1; origin.y: 9; angle: 135}
                    }
                }

                onClicked: {stackView.pop()}
            }

            Label{
                text: "Заметка"
                color: ApplicationSettings.isDarkTheme? "silver" : "black"
                width: contentWidth
                height: parent.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 17
            }
        }

        Rectangle{
            width: parent.width
            height: 1
            color: ApplicationSettings.isDarkTheme ? "silver" : "black"
            anchors.bottom: parent.bottom
            opacity: 0.2
        }
    }

    backgroundColor: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"

    content: Column{
        anchors.fill: parent
        spacing: 20
        topPadding: 40

        ListView{
            width: parent.width
            height: contentHeight
            anchors.horizontalCenter: parent.horizontalCenter
            boundsBehavior: Flickable.StopAtBounds

            delegate: ListNoteAction{}
            model: ActionModel{
                list: tableAction
            }
        }
    }
}
