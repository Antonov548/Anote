import QtQuick 2.11
import QtQuick.Controls 2.4
import "../components"

Page{

    id: modal
    signal signalClose()

    function popSignal(){
        signalClose()
    }

    background: Rectangle{
        anchors.fill: modal
        color: ApplicationSettings.isDarkTheme ? "#3F3F3F" : "black"
        opacity: 0.3
    }

    MouseArea{
        anchors.fill: parent
        onClicked: modal.signalClose()
    }

    ErrorMessage{
        id: msgError
        width: parent.width
        fullHeight: parent.height
        onCloseError: function(){msgError.hide()}
        errorString: "Введите все символы"
    }

    Page{
        anchors.centerIn: parent
        width: parent.width/1.2
        height: parent.height/1.5
        clip: true

        footer:Button{
            width: parent.width
            font.pixelSize: 20
            text: "Подтвердить"
            onClicked: {
                if(list.activatedCount === listModel.count){
                    var password
                    ApplicationSettings.setPassword(list.pass)
                    ApplicationSettings.setIsBlock(true)
                    modal.signalClose()
                }
                else
                    msgError.show()
            }
        }

        background: Rectangle{
            anchors.fill: parent
            color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"
        }

        Column{
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            spacing: 60

            ListView{
                property real activatedCount: 0
                property string pass: ""

                id: list
                width: modal.width/2.5
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

                        Behavior on color {
                            ColorAnimation{duration: 350}
                        }

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
                    width: modal.width/2
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
    }
}
