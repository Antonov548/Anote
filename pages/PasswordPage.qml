import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.impl 2.4
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

    Column{
        anchors.centerIn: parent
        spacing: 20

        IconLabel{
            id: img_lock
            icon.name: "lock"
            icon.width: 40
            icon.height: 40
            anchors.horizontalCenter: parent.horizontalCenter
            icon.color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"

            SequentialAnimation{
                id: animationError
                ScaleAnimator{
                    target: img_lock
                    from: 0
                    to: 1
                    easing.type: Easing.InOutBack
                }
            }
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
                    alwaysRunToEnd: true

                    onStopped: {
                        if(lengthEntered === passListModel.count)
                            if(ApplicationSettings.comparePassword(strPassword))
                                passwordPage.visible = false
                            else{
                                animationError.start()
                                ApplicationSettings.showSnackBar("Неверный пароль")
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
