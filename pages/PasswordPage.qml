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

        color: "#1E263E"
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
            color: "silver"
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
                border.color: "white"
                border.width: 1
                radius: 2

                PropertyAnimation{
                    running: model.activated
                    target: rect
                    property: "color"
                    to: "white"
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

            width: parent.width/1.7
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
