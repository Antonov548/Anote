import QtQuick 2.11
import QtQuick.Controls 2.4
import "../components"

Item{
    id: item
    anchors.fill: parent
    visible: overlay.isOpen

    property alias isOpen: overlay.isOpen

    function clear(){
        for(var i=0; i < listModel.count; i++)
            listModel.setProperty(i,"text","")
        list.activatedCount = 0
        list.pass = ""
    }

    ApplicationOverlay{
        id: overlay
        isOpen: item.isOpen

        content: Page{
            id: content
            width: parent.width/1.2
            height: parent.height/1.5
            anchors.centerIn: parent
            clip: true

            background: Rectangle{
                anchors.fill: parent
                color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"
                radius: 6
            }

            header: Column{
                width: parent.width
                height: 40
                topPadding: 5
                Button{
                    id: button
                    width: parent.height
                    height: parent.height
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    background: Rectangle{
                        anchors.fill: parent
                        color: "transparent"
                        Rectangle{
                            height: 18
                            width: 2
                            color: ApplicationSettings.isDarkTheme? "#454545" : "silver"
                            anchors.centerIn: parent
                            transform: Rotation { origin.x: 1; origin.y: 9; angle: 45}
                        }
                        Rectangle{
                            height: 18
                            width: 2
                            color: ApplicationSettings.isDarkTheme? "#454545" : "silver"
                            anchors.centerIn: parent
                            transform: Rotation { origin.x: 1; origin.y: 9; angle: 135}
                        }
                    }
                    onClicked: {item.isOpen = false}
                }
            }

            Column{
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                spacing: 60

                ListView{
                    property real activatedCount: 0
                    property string pass: ""

                    id: list
                    width: content.width/2.5
                    height: contentHeight
                    anchors.horizontalCenter: parent.horizontalCenter
                    orientation: ListView.Horizontal
                    spacing: 5

                    delegate: Rectangle{
                        width: list.width/6
                        height: width
                        color: "transparent"

                        Label{
                            id: label
                            anchors.fill: parent
                            font.pixelSize: 20
                            font.family: ApplicationSettings.font
                            bottomPadding: 5
                            text: model.text
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                        }

                        Rectangle{
                            width: parent.width
                            height: 2
                            color: ApplicationSettings.isDarkTheme ? (label.text==="") ? "#6B6B6B" : "silver" : (label.text==="") ? "silver" : "black"
                            anchors.bottom: parent.bottom


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

                }

                Column{
                    anchors.horizontalCenter: parent.horizontalCenter
                    GridPasswordComponent{

                        id: grid
                        width: content.width/2
                        anchors.horizontalCenter: parent.horizontalCenter
                        enabled: !(list.activatedCount === listModel.count)

                        delegateGrid: Button{
                            id: button
                            width: grid.cellWidth-10
                            height: width

                            onClicked: {
                                listModel.setProperty(list.activatedCount,"text",model.text)
                                list.pass += model.text
                                list.activatedCount++
                            }

                            background: Rectangle{
                                anchors.fill: parent
                                color: ApplicationSettings.isDarkTheme ?  button.pressed ? "#4C4C4C" : "transparent" : button.pressed ? "silver" : "transparent"
                                radius: 2
                            }

                            contentItem: Text{
                                anchors.fill: parent
                                text: model.text
                                color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                                font.pixelSize: 22
                                font.family: ApplicationSettings.font
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                    }

                    Button{
                        id: btnClear

                        anchors.horizontalCenter: parent.horizontalCenter
                        width: grid.cellWidth-10
                        height: width
                        enabled: !(list.activatedCount === 0)

                        onClicked: {
                            listModel.setProperty(list.activatedCount-1,"text","")
                            list.pass = list.pass.slice(0,list.activatedCount-1)
                            list.activatedCount--
                        }

                        background: Rectangle{
                            anchors.fill: parent
                            radius: 2
                            color: ApplicationSettings.isDarkTheme ?  btnClear.pressed ? "#4C4C4C" : "transparent" : btnClear.pressed ? "silver" : "transparent"
                        }

                        contentItem: Rectangle{
                            anchors.fill: parent
                            color: "transparent"
                            Rectangle{
                                id: line_1
                                width: parent.width/3
                                height: 2
                                color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                                anchors.centerIn: parent
                            }

                            Rectangle{
                                width: parent.width/6
                                height: 2
                                x: line_1.x
                                y: line_1.y - line_1.height/4
                                color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                                transform: Rotation{origin.x: 0; origin.y: 1; angle: 45 }
                            }

                            Rectangle{
                                width: parent.width/6
                                height: 2
                                x: line_1.x
                                y: line_1.y + line_1.height/4
                                color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                                transform: Rotation{origin.x: 0; origin.y: 1; angle: 315 }
                            }
                        }
                    }
                }
            }

            footer: Column{
                width: parent.width
                bottomPadding: 20
                Button{
                    id: btnAccept
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 20
                    font.family: ApplicationSettings.font
                    text: "Подтвердить"
                    onClicked: {
                        if(list.activatedCount === listModel.count){
                            ApplicationSettings.setPassword(list.pass)
                            ApplicationSettings.setIsBlock(true)
                            item.isOpen = false
                        }
                        else
                            console.log("error")
                    }
                    contentItem: Text{
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        text: "Подтвердить"
                        font.pixelSize: 16
                        padding: 5
                        font.family: ApplicationSettings.font
                        color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                    }
                    background: Rectangle{
                        anchors.fill: parent
                        radius: 4
                        color: ApplicationSettings.isDarkTheme ? btnAccept.pressed ? "#3C3C3C" : "#272727" : btnAccept.pressed ? "#C6C6C6" : "#DADADA"
                    }
                }
            }
        }
    }
}
