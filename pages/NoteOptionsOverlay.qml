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
            width: optionsColumn.implicitWidth
            height: optionsColumn.implicitHeight
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
                width: Math.max(btn_edit.buttonWidth,btn_delete.buttonWidth)
                OptionsButton{
                    id: btn_edit
                    text: "Редактировать"
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    handler: function(){
                        overlay.close()
                        editNote(date)
                    }
                }
                OptionsButton{
                    id: btn_delete
                    text: "Удалить"
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    handler: function(){
                        tableNote.deleteNote(date,indexNote)
                        tableAction.deleteActionsDatabase(date)
                        ApplicationSettings.showSnackBar("Заметка удалена")
                        signalClose()
                    }
                }
            }
        }
    }
}
