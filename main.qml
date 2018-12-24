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

        Connections{
            target: stackView.currentItem
            onSignalClose:{
                stackView.pop()
            }
            onEditNote:{
                stackView.push("qrc:/qml/pages/CreateNotePage.qml",{"appHeight": appWindow.height, "isEdit": true, "str_date": date})
            }
            ignoreUnknownSignals: true
        }

        background: Rectangle{
            anchors.fill: parent
            color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"
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

            padding: 0

            function popSignal(){
                if(settings.isOpen){
                    settings.isOpen = false
                    return
                }
                Qt.quit()
            }

            background: Rectangle{
                anchors.fill: parent
                color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"
            }

            ListView{

                id: listView

                clip: true

                anchors.fill: parent

                model: NoteModel{
                    id: listModel
                    list: tableNote
                }

                headerPositioning: ListView.PullBackHeader
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
                    id: listHeader
                    height: headerColumn.implicitHeight
                    width: appWindow.width
                    clip: true
                    z: 2

                    background: Rectangle{
                        anchors.fill: parent
                        color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"
                    }

                    Column{
                        id: headerColumn
                        width: parent.width
                        spacing: 40
                        bottomPadding: 20
                        Pane{
                            width: parent.width
                            height: 60
                            padding: 0
                            background: Rectangle{
                                anchors.fill: parent
                                color: "transparent"
                            }

                            MenuButton{
                                height: 21
                                width: 30
                                anchors.left: parent.left
                                anchors.leftMargin: 15
                                anchors.verticalCenter: parent.verticalCenter
                                onClicked: function(){console.log("work")}
                            }
                            Button{
                                id: addButton
                                height: 39
                                padding: 0
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter

                                onClicked: {tableAction.resetList(); stackView.push("qrc:/qml/pages/CreateNotePage.qml",{"appHeight": appWindow.height})}

                                background: Rectangle{
                                    anchors.fill: parent
                                    radius: height/2
                                    color: "#3073FA"
                                    clip: true
                                    Rectangle{
                                        anchors.fill: parent
                                        color: "#408DFB"
                                        radius: height/2
                                        opacity: addButton.pressed ? 1 : 0
                                        Behavior on opacity {
                                            NumberAnimation{
                                                duration: 200
                                            }
                                        }
                                    }
                                }

                                contentItem: Row{
                                    Rectangle{
                                        width: addButton.height
                                        height: addButton.height
                                        color: "transparent"
                                        Rectangle{
                                            width: 2
                                            height: parent.height/2.4
                                            color: "white"
                                            anchors.centerIn: parent
                                        }
                                        Rectangle{
                                            width: parent.width/2.4
                                            height: 2
                                            color: "white"
                                            anchors.centerIn: parent
                                        }
                                    }
                                    Label{
                                        text: "Новая заметка"
                                        height: parent.height
                                        font.pixelSize: height/2.5
                                        font.family: ApplicationSettings.font
                                        leftPadding: 0
                                        rightPadding: 15
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        color: "white"
                                    }
                                }
                            }
                            SettingsButton{
                                height: 23
                                width: 30
                                anchors.right: parent.right
                                anchors.rightMargin: 8
                                anchors.verticalCenter: parent.verticalCenter
                                onClicked: function(){settings.isOpen = true}
                            }
                        }
                        Column{
                            width: parent.width/1.05
                            anchors.horizontalCenter: parent.horizontalCenter
                            leftPadding: 20

                            FontLoader{
                                id: headerFont
                                source: "qrc:/font/header_font.ttf"
                            }

                            Label{
                                text: "Мои заметки"
                                font.pixelSize: 35
                                font.family: headerFont.name
                                color: ApplicationSettings.isDarkTheme ? "silver" : "#4E4E4E"
                            }
                            Label{
                                property var date: new Date()
                                text: date.getDate() + " " + ApplicationSettings.getMonth(date.getMonth()) + ", " + ApplicationSettings.getDayOfWeek(date.getDay())
                                font.pixelSize: 25
                                font.family: headerFont.name
                                color: "#7C7C7C"
                            }
                        }
                    }
                }
                delegate: ListViewComponent{}
            }

            Pane{
                anchors.fill: parent
                padding: 0
                visible: false // tableNote.isEmpty

                clip: true
                anchors.centerIn: parent

                background: Rectangle{
                    anchors.fill: parent
                    color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "#E9E9E9"
                }

                Column{
                    width: parent.width
                    spacing: 60
                    //opacity: tableNote.isEmpty ? 1 : 0

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
                        topPadding: appWindow.height/4

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
    }

    SettingsOverlay{
        id: settings; isOpen: false
    }
    PasswordPage{
        id: passwordPage
        visible: ApplicationSettings.blockAppOnStart()
    }
}
