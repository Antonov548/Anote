import QtQuick 2.11
import QtQuick.Controls 2.4
import "../components"

Item{
    id: item
    anchors.fill: parent

    property alias isOpen: overlay.isOpen

    OverlayPage{
        id: overlay
        durationOpen: 300
        durationClose: 300
        overlayOpacity: ApplicationSettings.isDarkTheme ? 0.75 : 0.6

        content: Page{
            id: page
            y: overlay.isOpen ? parent.height - optionsColumn.implicitHeight - 10 : parent.height + optionsColumn.implicitHeight
            width: parent.width/2.2
            height: optionsColumn.height
            anchors.horizontalCenter: parent.horizontalCenter
            background: Rectangle{
                anchors.fill: parent
                radius: 8
                color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"
            }

            Behavior on y{
                NumberAnimation{
                    duration: 300; easing.type: Easing.OutCirc
                }
            }
            opacity: overlay.isOpen ? 1 : 0
            Behavior on opacity {
                NumberAnimation{
                    duration: 200; easing.type: Easing.OutCirc
                }
            }
            Column{
                id: optionsColumn
                topPadding: 10
                bottomPadding: 10
                width: parent.width
                ListView{
                    id: list
                    height: contentHeight
                    width: parent.width
                    boundsBehavior: ListView.StopAtBounds
                    model: ListModel{
                        ListElement{text:"Редактировать"; handler: function(){
                            overlay.close()
                            editNote(date)
                        }}
                        ListElement{text:"Удалить"; handler: function(){
                            tableNote.deleteNote(date,indexNote)
                            tableAction.deleteActionsDatabase(date)
                            signalClose()
                        }}
                    }
                    delegate: Button{
                        id: button
                        width: parent.width
                        height: 40
                        display: AbstractButton.TextBesideIcon
                        font.family: ApplicationSettings.font
                        font.pixelSize: 14
                        text: model.text
                        spacing: 15
                        contentItem: Item{
                            Text{
                                height: parent.height
                                width: contentWidth
                                text: button.text
                                font: button.font
                                color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        onClicked: model.handler()

                        background: Rectangle{
                            anchors.fill: parent
                            color: ApplicationSettings.isDarkTheme ? button.pressed ? "#292929" : "#1B1B1B" : button.pressed ? "#DEDEDE" : "white"
                        }
                    }
                }
            }
        }
    }
}
