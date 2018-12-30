import QtQuick 2.11
import QtQuick.Controls 2.4
import "../components/"

Page{
    anchors.fill: parent
    id: passwordPage

    property real lengthEntered: 0
    property string strPassword: ""

    background: Rectangle{
        anchors.fill: parent
        color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"
    }

    ErrorMessage{
        id: msgError
        width: parent.width
        fullHeight: parent.height
        onCloseError: function(){msgError.hide()}
        errorString: "Неверный пароль"
    }

    Column{
        anchors.fill: parent
        topPadding: parent.height/3
        spacing: 20

        Label{
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Введите пароль"
            font.pixelSize: 18
            font.family: ApplicationSettings.font
            color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
        }

        ListView{
            width: contentWidth
            height: 40
            anchors.horizontalCenter: parent.horizontalCenter
            orientation: ListView.Horizontal
            spacing: 5
            boundsBehavior: Flickable.StopAtBounds

            delegate: Rectangle{
                id: rect
                height: 20
                width: 20
                color: "transparent"
                border.color: ApplicationSettings.isDarkTheme ? "white" : "#454545"
                border.width: 1
                radius: 10

                PropertyAnimation{
                    running: model.activated
                    target: rect
                    property: "color"
                    to: ApplicationSettings.isDarkTheme ? "white" : "#454545"
                    duration: 200

                    onStopped: {
                        if(lengthEntered === passListModel.count)
                            if(ApplicationSettings.comparePassword(strPassword))
                                passwordPage.visible = false
                            else{
                                msgError.show()
                                for(var i=0; i < passListModel.count; i++)
                                    passListModel.setProperty(i,"activated",false)

                                strPassword = ""
                                lengthEntered = 0
                                gridPassword.enabled = true
                            }
                    }

                }

                PropertyAnimation{
                    running: !model.activated
                    target: rect
                    property: "color"
                    to: "transparent"
                    duration: 200
                }
            }

            model: ListModel{
                id: passListModel
                ListElement{activated: false}
                ListElement{activated: false}
                ListElement{activated: false}
                ListElement{activated: false}
                ListElement{activated: false}
            }
        }

        GridPasswordComponent{
            id: gridPassword

            width: 200
            anchors.horizontalCenter: parent.horizontalCenter
            click: onClick

            function onClick(data){
                strPassword += data
                passListModel.setProperty(lengthEntered,"activated",true)
                lengthEntered++

                if(lengthEntered === passListModel.count)
                    enabled = false
            }
        }
    }
}
