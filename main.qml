import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtModel 1.0
import "components"
import "pages"

ApplicationWindow{

    id: appWindow

    visible: true

    width: 500
    height: 800

    background: Rectangle{
        anchors.fill: parent
        color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"
    }

    onClosing: {
        close.accepted = false
        stackView.currentItem.popSignal()
    }

    StackView{
        id: stackView
        anchors.fill: parent

        SettingsPage{id: settings}

        Connections{
            target: stackView.createNotePage
            onSignalClose:{
                stackView.pop()
            }
            ignoreUnknownSignals: true
        }

        Connections{
            target: stackView.notePage
            onSignalClose:{
                stackView.pop()
            }
            ignoreUnknownSignals: true
        }

        property var createNotePage: null
        property var notePage: null
        property var page: {
            "Настройки": settings
        }

        background: Rectangle{
            anchors.fill: parent
            color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "#E9E9E9"
        }

        pushEnter: Transition {
            ParallelAnimation{
                ScaleAnimator {
                    from: 0.95
                    to: 1
                    duration: 400
                    easing.type: Easing.OutCubic
                }
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to:1
                    duration: 200
                }
            }
        }
        popEnter: Transition {
            ParallelAnimation{
                ScaleAnimator {
                    from: 1.1
                    to: 1
                    duration: 400
                    easing.type: Easing.OutCubic
                }
            }
        }
        pushExit: Transition {}
        popExit: Transition {}

        initialItem: Pane{
            id: stackInitial
            property real indexChange: -1

            padding: 0

            function popSignal(){
                if(menu.isOpen){
                    menu.isOpen = false
                    return
                }
                if(indexChange >= 0){
                    indexChange = -1
                    return
                }
                Qt.quit()
            }

            background: Rectangle{
                anchors.fill: parent
                color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "#E9E9E9"
            }
            ListView{

                id: listView

                topMargin: tableNote.isEmpty ? 0 : 8
                bottomMargin: tableNote.isEmpty ? 0 : 8
                clip: true

                anchors.fill: parent

                model: NoteModel{
                    id: listModel
                    list: tableNote
                }

                headerPositioning: ListView.OverlayHeader
                boundsBehavior: Flickable.StopAtBounds
                boundsMovement: Flickable.StopAtBounds

                ScrollBar.vertical: ScrollBar{
                    visible: true
                    width: 8
                }

                add: Transition {

                    PropertyAnimation {
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 300
                        easing.type: Easing.InOutQuad
                    }
                }

                header: Page{
                    height: appWindow.height/4
                    width: appWindow.width

                    background: Rectangle{
                        anchors.fill: parent
                        color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "#E9E9E9"
                    }

                    Rectangle{
                        width: parent.width/1.05
                        height: parent.height/1.1
                        anchors.centerIn: parent
                        radius: 8
                        color: ApplicationSettings.isDarkTheme ? "#323232" : "white"
                    }
                }

                delegate: ListViewComponent{}
            }
            Pane{
                anchors.fill: parent
                padding: 0
                visible: tableNote.isEmpty

                clip: true
                anchors.centerIn: parent

                background: Rectangle{
                    anchors.fill: parent
                    color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "#E9E9E9"
                }

                Column{
                    width: parent.width
                    spacing: 60
                    topPadding: 200
                    opacity: tableNote.isEmpty ? 1 : 0

                    Behavior on opacity {
                        enabled: !tableNote.isEmpty
                        OpacityAnimator{
                            duration: 250
                            easing.type: Easing.InOutQuad
                        }
                    }

                    Column{
                        width: parent.width
                        spacing: 10

                        Button{
                            height: 40
                            padding: 0
                            anchors.horizontalCenter: parent.horizontalCenter

                            onClicked: {tableAction.resetList(); stackView.createNotePage = stackView.push("qrc:/qml/pages/CreateNotePage.qml",{"appHeight": appWindow.height}); stackInitial.indexChange = -1}

                            background: Rectangle{
                                anchors.fill: parent
                                radius: 4
                                color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                            }

                            contentItem: Row{
                                Rectangle{
                                    width: 40
                                    height: 40
                                    color: "transparent"
                                    Rectangle{
                                        width: 2.2
                                        height: parent.height/2.5
                                        color: ApplicationSettings.isDarkTheme ? "black" : "white"
                                        anchors.centerIn: parent
                                    }
                                    Rectangle{
                                        width: parent.width/2.5
                                        height: 2.2
                                        color: ApplicationSettings.isDarkTheme ? "black" : "white"
                                        anchors.centerIn: parent
                                    }
                                }
                                Label{
                                    text: "Добавить"
                                    height: parent.height
                                    font.pixelSize: height/2
                                    font.family: ApplicationSettings.font
                                    leftPadding: 0
                                    rightPadding: 15
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    color: ApplicationSettings.isDarkTheme ? "black" : "white"
                                }
                            }
                        }

                        Label{
                            text: "Добавить заметки на день"
                            font.pixelSize: 16
                            font.family: ApplicationSettings.font
                            color: ApplicationSettings.isDarkTheme ? "silver" : "black"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }
            MenuPage{id: menu}
        }
    }

    PasswordPage{
        id: passwordPage
        visible: ApplicationSettings.blockAppOnStart()
    }
}
