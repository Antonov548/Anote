import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.impl 2.4
import "../components"

Item{
    id: item

    property alias isOpen: overlay.isOpen

    function clear(){
        list.isClear = true
        list.isIncorrect = false
        for(var i=0; i < listModel.count; i++)
            listModel.setProperty(i,"text","")
        list.activatedCount = 0
        list.pass = ""
        list.isClear = false
    }

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
            width: setPasswordColumn.implicitWidth
            height: setPasswordColumn.implicitHeight
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
                id: setPasswordColumn
                spacing: 15
                leftPadding: 40
                rightPadding: 40
                topPadding: 20
                bottomPadding: 20
                Label{
                    text: "Установка пароля"
                    font.pixelSize: 30
                    font.family: titleFont.name
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: ApplicationSettings.isDarkTheme ? "silver" : "#4E4E4E"
                }

                Column{
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 3
                    ListView{
                        property real activatedCount: 0
                        property string pass: ""
                        property bool isIncorrect: false
                        property bool isClear: false

                        id: list
                        width: contentWidth
                        height: 30
                        orientation: ListView.Horizontal

                        delegate: Rectangle{
                            width: 30
                            height: 30
                            color: "transparent"

                            Label{
                                id: label
                                anchors.fill: parent
                                padding: 0
                                font.pixelSize: 20
                                font.family: ApplicationSettings.font
                                text: model.text
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                            }

                            Rectangle{
                                width: parent.width
                                height: 2
                                anchors.bottom: parent.bottom
                                color: ApplicationSettings.isDarkTheme ? "#6B6B6B" : "silver"
                            }
                            Rectangle{
                                width: (label.text==="") ? 0 : parent.width
                                Behavior on width {
                                    enabled: !list.isClear
                                    NumberAnimation{
                                        duration: 150
                                    }
                                }

                                height: 2
                                anchors.bottom: parent.bottom
                                color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                            }
                        }

                        model: ListModel{
                            id: listModel
                            ListElement{text: ""}
                            ListElement{text: ""}
                            ListElement{text: ""}
                            ListElement{text: ""}
                            ListElement{text: ""}
                        }
                        IconImage{
                            width: 18
                            height: 18
                            name: "field"
                            color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                            anchors.left: parent.right
                            anchors.leftMargin: 5
                            anchors.verticalCenter: parent.verticalCenter
                            opacity: list.isIncorrect ? 1 : 0
                            Behavior on opacity {
                                enabled: !list.isClear
                                NumberAnimation{
                                    duration: 150
                                }
                            }
                        }
                    }
                    Text{
                        text: "Введите 5 символов"
                        font.family: ApplicationSettings.font
                        font.pixelSize: 14
                        color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                        leftPadding: 3
                        opacity: list.isIncorrect ? 1 : 0
                        Behavior on opacity {
                            enabled: !list.isClear
                            NumberAnimation{
                                duration: 150
                            }
                        }
                    }
                }

                Column{
                    anchors.horizontalCenter: parent.horizontalCenter
                    GridPasswordComponent{
                        id: grid
                        width: 180
                        anchors.horizontalCenter: parent.horizontalCenter
                        enabled: !(list.activatedCount === listModel.count)
                        click: function(text){
                            if(list.isIncorrect)
                                list.isIncorrect = false
                            listModel.setProperty(list.activatedCount,"text",text)
                            list.pass += text
                            list.activatedCount++
                        }
                    }
                    Button{
                        anchors.horizontalCenter: parent.horizontalCenter
                        background: Rectangle{
                            anchors.fill: parent
                            color: "transparent"
                        }
                        contentItem: Row{
                            topPadding: 10
                            bottomPadding: 10
                            spacing: 10
                            IconImage{
                                name: "okey"
                                color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                                anchors.verticalCenter: parent.verticalCenter
                                width: 18
                                height: 18
                            }
                            Text{
                                text: "Сохранить"
                                font.family: ApplicationSettings.font
                                font.pixelSize: 16
                                padding: 0
                                color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                        onClicked: {
                            if(list.activatedCount === listModel.count){
                                ApplicationSettings.setPassword(list.pass)
                                ApplicationSettings.setIsBlock(true)
                                item.isOpen = false
                            }
                            else{
                                list.isIncorrect = true
                                list.isClear = true
                                for(var i=0; i < listModel.count; i++)
                                    listModel.setProperty(i,"text","")
                                list.activatedCount = 0
                                list.pass = ""
                                list.isClear = false
                            }
                        }
                    }
                }
            }
        }
    }
}
