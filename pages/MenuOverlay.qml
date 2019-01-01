import QtQuick 2.11
import QtQuick.Controls 2.4
import "../components"

Item{
    id: item
    property alias isOpen: overlay.isOpen

    OverlayPage{
        id: overlay
        durationClose: 300
        durationOpen: 300
        overlayOpacity: ApplicationSettings.isDarkTheme ? 0.75 : 0.6

        content: Page{
            id: page
            y: overlay.isOpen ? 0 : -page.implicitHeight
            background: Rectangle{
                anchors.fill: parent
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
                    duration: 300; easing.type: Easing.OutCirc
                }
            }

            width: parent.width
            height: settingsColumn.implicitHeight
            clip: true

            Column{
                id: settingsColumn
                width: parent.width

                ListView{
                    id: settingsListView

                    property var sett_pages: {
                        "О программе": btn_about,
                        "Оставить отзыв": btn_market
                    }

                    property var handlers : {"О программе": function(){overlay.close(); about.isOpen = true},
                        "Оставить отзыв": function(){Qt.openUrlExternally("https://play.google.com/store/apps/details?id=anote.android")}
                    }

                    property var check: {"О программе": true,
                        "Оставить отзыв": true
                    }

                    SettingsButtonCompoment{id: btn_about}
                    SettingsButtonCompoment{id: btn_market}

                    height: contentHeight
                    width: parent.width

                    boundsBehavior: Flickable.StopAtBounds

                    model: ListModel{
                        ListElement{text:"О программе"}
                        ListElement{text:"Оставить отзыв"}
                    }

                    delegate: Loader{
                        id: loader
                        width: settingsListView.width

                        property string delegateTitle: model.text
                        property var delegateHandler: settingsListView.handlers[model.text]
                        property bool delegateCheck: settingsListView.check[model.text]

                        sourceComponent: settingsListView.sett_pages[model.text]
                    }
                }
            }
        }
    }
}
