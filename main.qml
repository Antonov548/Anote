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

    Connections{
        id: connectionDialogNote
        target: stackView.createNotePage
        onSignalClose:{
            stackView.pop()
        }
        ignoreUnknownSignals: true
    }

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

        property var createNotePage: null
        property var page: {
            "Настройки": settings
        }

        background: Rectangle{
            anchors.fill: parent
            color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "#E9E9E9"
        }

        pushEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to:1
                duration: 200
            }
        }
        pushExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0.5
                to:0
                duration: 200
            }
        }
        popEnter: Transition {
            ParallelAnimation{

                PropertyAnimation {
                    property: "opacity"
                    from: 0.5
                    to:1
                    duration: 150
                }
                ScaleAnimator {
                    from: 1.1
                    to: 1
                    duration: 400
                    easing.type: Easing.OutCubic
                }
            }
        }

        popExit: Transition {

            SequentialAnimation{

                ParallelAnimation{
                    PropertyAnimation{
                        property: "opacity"
                        to: 0
                        duration: 100
                    }
                    ScaleAnimator {
                        from: 1
                        to: 1.05
                        duration: 400
                        easing.type: Easing.OutCubic
                    }
                }
                PropertyAction {
                    property: "scale"; value: 1 }
            }
        }

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

                header: Rectangle{
                    id: listHeader

                    z: 2
                    width: appWindow.width
                    height: tableNote.isEmpty ? appWindow.height : appWindow.height/4

                    color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "#E9E9E9"
                    clip: true

                    Behavior on height{
                        NumberAnimation{
                            duration: 300
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        preventStealing: true
                    }

                    Pane{
                        width: parent.width/1.5
                        height: parent.height/2
                        anchors.centerIn: parent
                        padding: 0
                        visible: tableNote.isEmpty

                        background: Rectangle{
                            anchors.fill: parent
                            color: "transparent"
                        }

                        Column{
                            width: parent.width
                            spacing: 60

                            Column{
                                width: parent.width
                                spacing: 10

                                Button{
                                    height: 40
                                    padding: 0
                                    anchors.horizontalCenter: parent.horizontalCenter

                                    onClicked: {tableAction.resetList(); stackView.createNotePage = stackView.push("qrc:/qml/pages/CreateNotePage.qml",{"appHeight": appWindow.height}); stackInitial.indexChange = -1; menu.isOpen = false}

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
                }

                delegate: ListViewComponent{}
            }
            MenuPage{id: menu}
        }
    }

    PasswordPage{
        id: passwordPage
        visible: ApplicationSettings.blockAppOnStart()
    }
}
