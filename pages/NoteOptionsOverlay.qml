import QtQuick 2.11
import QtQuick.Controls 2.4
import "../components"

Item{
    id: item
    anchors.fill: parent

    property alias isOpen: overlay.isOpen

    OverlayPage{
        id: overlay
        duration: 300

        content: Page{
            id: page
            y: overlay.isOpen ? parent.height - optionsColumn.implicitHeight - 10 : parent.height + optionsColumn.implicitHeight
            width: parent.width/3
            height: optionsColumn.height
            anchors.horizontalCenter: parent.horizontalCenter
            background: Rectangle{
                anchors.fill: parent
                radius: 8
            }

            Behavior on y{
                NumberAnimation{
                    duration: overlay.duration; easing.type: Easing.OutCirc
                }
            }
            opacity: overlay.isOpen ? 1 : 0
            Behavior on opacity {
                NumberAnimation{
                    duration: overlay.duration; easing.type: Easing.OutCirc
                }
            }
            Column{
                id: optionsColumn
                padding: 10
                width: parent.width
                ListView{
                    id: list
                    height: contentHeight
                    width: parent.width
                    boundsBehavior: ListView.StopAtBounds
                    model: ListModel{
                        ListElement{text:"Изменить"}
                        ListElement{text:"Удалить"}
                    }
                    delegate: Button{
                        text: model.text
                        width: 60
                        onClicked: {console.log(list.width + " " + overlay.height)}
                    }
                }
            }
        }
    }
}
