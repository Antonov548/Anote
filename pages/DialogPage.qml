import QtQuick 2.11
import QtQuick.Controls 2.4
import "../components/"

Item {
    id: item
    anchors.fill: parent
    visible: overlay.isOpen

    property alias isOpen: overlay.isOpen
    property var onOkey: function(){}
    property var onCancel: function(){}
    property alias text: information.text

    OverlayPage{
        id: overlay
        overlayOpacity: ApplicationSettings.isDarkTheme ? 0.75 : 0.6

        content: Page{
            id: content
            clip: true
            width: item.width/1.4
            height: dialogColumn.implicitHeight//item.height/3
            anchors.centerIn: parent
            opacity: overlay.isOpen ? 1 : 0
            background: Rectangle{
                anchors.fill: parent
                radius: 8
                color: ApplicationSettings.isDarkTheme ? "#333333" : "#E9E9E9"
            }
            Behavior on opacity{
                NumberAnimation{
                    duration: overlay.duration; easing.type: Easing.OutCirc
                }
            }
            Column{
                id: dialogColumn
                width: parent.width
                spacing: 50
                topPadding: 40
                leftPadding: 20
                rightPadding: 20
                Text{
                    id: information
                    width: parent.width
                    font.pixelSize: 16
                    wrapMode: Text.Wrap
                    font.family: ApplicationSettings.font
                    color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                    horizontalAlignment: Text.AlignHCenter
                }
                Row{
                    anchors.right: parent.right
                    topPadding: 10
                    bottomPadding: 10
                    rightPadding: 20
                    spacing: 10

                    Button{
                        id: btnOkey
                        width: 70
                        onClicked: onOkey()
                        contentItem:Text{
                            width: parent.width
                            horizontalAlignment: Text.AlignHCenter
                            text: "Ок"
                            font.pixelSize: 16
                            font.family: ApplicationSettings.font
                            color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                        }
                        background: Rectangle{
                            radius: 4
                            anchors.fill: parent
                            color: ApplicationSettings.isDarkTheme ? btnOkey.pressed ? "#3C3C3C" : "#272727" : btnOkey.pressed ? "#C6C6C6" : "#DADADA"
                        }
                    }
                    Button{
                        id: btnCancel
                        width: 70
                        onClicked: onCancel()
                        contentItem:Text{
                            width: parent.width
                            horizontalAlignment: Text.AlignHCenter
                            text: "Отмена"
                            font.pixelSize: 16
                            font.family: ApplicationSettings.font
                            color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                        }
                        background: Rectangle{
                            radius: 4
                            anchors.fill: parent
                            color: ApplicationSettings.isDarkTheme ? btnCancel.pressed ? "#3C3C3C" : "#272727" : btnCancel.pressed ? "#C6C6C6" : "#DADADA"
                        }
                    }
                }
            }
        }
    }
}
