import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtModel 1.0
import QtQml.Models 2.1
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
                if(about.isOpen){
                    about.isOpen = false
                    return
                }
                if(menu.isOpen){
                    menu.isOpen = false
                    return
                }
                if(passwordDialog.isOpen){
                    passwordDialog.isOpen = false
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
                anchors.fill: parent
                clip: true

                model: DelegateModel{
                    id: visualModel
                    model: NoteModel{
                        list: tableNote
                    }
                    delegate: ListViewComponent{}
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
                                onClicked: function(){menu.isOpen = true}
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
            }

            Column{
                width: parent.width
                visible: tableNote.isEmpty
                anchors.centerIn: parent
                opacity: tableNote.isEmpty ? 1 : 0
                Behavior on opacity{
                    NumberAnimation{
                        duration: 300
                    }
                }

                Column{
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 5
                    Label{
                        text: "Распланируйте свои дни"
                        font.pixelSize: 18
                        font.family: ApplicationSettings.font
                        font.bold: true
                        color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Label{
                        text: "Совсем нету дел?"
                        font.pixelSize: 15
                        font.family: ApplicationSettings.font
                        color: "#909090"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }
    }

    SettingsOverlay{
        id: settings; isOpen: false
    }
    MenuOverlay{
        id: menu; isOpen: false
    }
    SetPasswordOverlay{
        id: passwordDialog; isOpen: false
    }
    PasswordPage{
        id: passwordPage
        visible: ApplicationSettings.blockAppOnStart()
    }
    AboutPage{
        id: about; isOpen: false
    }

    SnackBar{
        id: snackBar; anchors.fill: parent
        Connections{
            target: ApplicationSettings
            onSnackBarShowed: snackBar.show(info_text)
        }
    }
}
