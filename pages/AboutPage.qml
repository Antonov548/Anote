import QtQuick 2.11
import QtQuick.Controls 2.4

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.impl 2.4
import "../components"

Item{
    id: item

    property alias isOpen: overlay.isOpen

    FontLoader{
        id: titleFont
        source: "qrc:/font/header_font.ttf"
    }

    OverlayPage{
        id: overlay
        durationOpen: 0
        durationClose: 300
        overlayOpacity: ApplicationSettings.isDarkTheme ? 0.75 : 0.6

        content: Page{
            id: page
            width: aboutColumn.implicitWidth
            height: aboutColumn.implicitHeight
            opacity: overlay.isOpen ? 1 : 0
            anchors.centerIn: parent
            clip: true
            background: Rectangle{
                anchors.fill: parent
                radius: 8
                color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"
            }
            Behavior on opacity{
                NumberAnimation{
                    duration: 300; easing.type: Easing.OutCirc
                }
            }

            Column{
                id: aboutColumn
                spacing: 30
                leftPadding: 40
                rightPadding: 40
                topPadding: 20
                bottomPadding: 20
                Label{
                    text: "О программе"
                    font.pixelSize: 30
                    font.family: titleFont.name
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: ApplicationSettings.isDarkTheme ? "silver" : "#4E4E4E"
                }
                Text{
                    text: "Программа для создания заметок на каждый день. Используйте программу для улучшения своей пунктуальности."
                    width: 200
                    wrapMode: Text.WordWrap
                    font.family: ApplicationSettings.font
                    font.pixelSize: 16
                    color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                    horizontalAlignment: Text.AlignHCenter
                }

                Label{
                    text: "Версия: v2.0"
                    color: "grey"
                    font.family: ApplicationSettings.font
                    font.pixelSize: 14
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }
}
