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

    property var handlers: {"Добавить запись": function(name){tableAction.resetList();stackView.createNotePage = stackView.push("qrc:/qml/pages/CreateNotePage.qml",{"appHeight": appWindow.height}); stackInitial.indexChange = -1; drawer.close()},
        "Настройки": function(name){stackView.push(stackView.page[name]);drawer.close()}}

    Drawer{

        id: drawer
        enabled: true
        width: parent.width/1.2
        height: parent.height
        interactive: (stackView.depth === 1  && !passwordPage.visible)

        background: Rectangle{
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#2D395B" }
                GradientStop { position: 1.0; color: "#303C60" }
            }
        }

        DrawerComponent{id: drawerComponent}
        ListView{

            id: drawerListViewTop

            width: parent.width
            height: contentHeight
            anchors.top: parent.top
            anchors.topMargin: 30
            spacing:2
            boundsBehavior: Flickable.StopAtBounds
            clip: true

            model: ListModel{
                id: drawerListModelTop

                ListElement{title: "Добавить запись"; source: "qrc:/image/icons/add.png"}
            }

            delegate: Loader{
                width: parent.width
                sourceComponent: drawerComponent

                property string delegateTitle: model.title
                property string delegateSourceImage: model.source
                property var delegateHandler: handlers[model.title]
            }
        }

        ListView{

            id: drawerListViewBottom

            width: parent.width
            height: contentHeight
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            spacing:2
            boundsBehavior: Flickable.StopAtBounds
            clip: true

            model: ListModel{
                ListElement{title: "Настройки"; source: "qrc:/image/icons/settings.png"}
            }

            delegate: Loader{
                sourceComponent: drawerComponent
                width: parent.width

                property string delegateTitle: model.title
                property string delegateSourceImage: model.source
                property var delegateHandler: handlers[model.title]
            }
        }
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
                if(indexChange >= 0){
                    indexChange = -1
                }else{
                    Qt.quit()
                }
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

                spacing: 8

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
                    Button{
                        anchors.top: parent.top
                        anchors.topMargin: 10
                        anchors.left: parent.left
                        anchors.leftMargin: 10

                        icon.source: "qrc:/image/icons/drawer.png"
                        icon.color: ApplicationSettings.isDarkTheme ? "white" : "black"

                        icon.width: 20
                        icon.height: 20

                        background: Rectangle{

                            anchors.fill: parent
                            color: "transparent"

                        }

                        onClicked: {drawer.open()}
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

                                    onClicked: handlers["Добавить запись"]()

                                    background: Rectangle{
                                        anchors.fill: parent
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
                                    color: ApplicationSettings.isDarkTheme ? "silver" : "black"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                    }
                }

                delegate: ListViewComponent{}
            }
        }
    }

    PasswordPage{
        id: passwordPage
        visible: ApplicationSettings.blockAppOnStart()
    }
}
