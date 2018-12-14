import QtQuick 2.11
import QtQuick.Controls 2.4
import QtModel 1.0
import "../components"

ScrollablePage{
    id: page

    property string month: ""
    property string day_w: ""
    property string date: ""
    property real day: -1
    property real indexNote: -1

    signal signalClose()

    function popSignal(){
        signalClose()
    }

    function getLabel(parse_date){
        var string_date = parse_date.toString()

        if(parseInt(string_date[string_date.length-1]) === 1)
            return "Остался " + parse_date + " день"
        if(parseInt(string_date[string_date.length-1]) >1 && parseInt(string_date[string_date.length-1]) <5)
            return "Осталось " + parse_date + " дня"
        if(parseInt(string_date[string_date.length-1]) >= 5 || parseInt(string_date[string_date.length-1]) === 0)
            return "Осталось " + parse_date + " дней"
    }

    FontLoader{
        id: titleFont
        source: "qrc:/font/header_font.ttf"
    }

    header: Rectangle{
        width: parent.width
        height: 50
        color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"
        visible: true

        Button{
            id: btn_back
            width: height
            height: parent.height/1.8
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            icon.name: "delete"
            padding: 0
            background: Rectangle{
                width: btn_back.pressed ? Math.max(btn_back.height,btn_back.width)+10 : 0
                height: btn_back.pressed ? Math.max(btn_back.height,btn_back.width)+10 : 0
                color: "#EEEEEE"
                radius: height/2
                anchors.centerIn: parent

                Behavior on width{
                    SequentialAnimation{
                        PauseAnimation {
                            duration: 200
                        }
                        NumberAnimation{
                            duration: 800
                            easing.type: Easing.OutExpo
                        }
                    }
                }
                Behavior on height{
                    SequentialAnimation{
                        PauseAnimation {
                            duration: 200
                        }
                        NumberAnimation{
                            duration: 800
                            easing.type: Easing.OutExpo
                        }
                    }
                }
            }

            onClicked: {signalClose()}
        }

        Button{
            id: btn_delete
            width: height
            height: parent.height/1.8
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            icon.name: "delete"
            icon.height: 25
            icon.width: 25
            padding: 0
            background: Rectangle{
                width: btn_delete.pressed ? Math.max(btn_delete.height,btn_delete.width)+10 : 0
                height: btn_delete.pressed ? Math.max(btn_delete.height,btn_delete.width)+10 : 0
                color: "#EEEEEE"
                radius: height/2
                anchors.centerIn: parent

                Behavior on width{
                    SequentialAnimation{
                        PauseAnimation {
                            duration: 200
                        }
                        NumberAnimation{
                            duration: 800
                            easing.type: Easing.OutExpo
                        }
                    }
                }
                Behavior on height{
                    SequentialAnimation{
                        PauseAnimation {
                            duration: 200
                        }
                        NumberAnimation{
                            duration: 800
                            easing.type: Easing.OutExpo
                        }
                    }
                }
            }

            onClicked:{
                tableNote.deleteNote(date,indexNote)
                tableAction.deleteActionsDatabase(date)
                signalClose()
            }
        }

        Rectangle{
            width: parent.width
            height: 1
            visible: page.contentYPosition
            color: "#C5C5C5"
            anchors.bottom: parent.bottom
            opacity: Math.abs(page.contentYPosition)/100
        }
    }

    backgroundColor: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"

    content: Column{
        anchors.fill: parent
        spacing: 40
        topPadding: 10
        bottomPadding: 20

        Column{
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            Label{
                anchors.horizontalCenter: parent.horizontalCenter
                text: day + " " + month + ", " + day_w
                color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                font.family: titleFont.name
                font.pixelSize: 30
            }
            Label{
                anchors.horizontalCenter: parent.horizontalCenter
                text: {
                    var hours_count = (new Date(date+"T24:00:00") - Date.now())/(1000*60*60)
                    if(hours_count<0)
                        return "Заметка устарела"
                    if(hours_count >0 && hours_count < 24)
                        return "Сегодня"
                    if(hours_count > 24)
                        getLabel(Math.floor(hours_count/24))
                }
                color: "#909090"
                font.family: ApplicationSettings.font
                font.pixelSize: 14
            }
        }

        ListView{
            width: parent.width
            height: contentHeight
            anchors.horizontalCenter: parent.horizontalCenter
            boundsBehavior: Flickable.StopAtBounds

            delegate: ListNoteAction{}
            model: ActionModel{
                list: tableAction
            }
        }
    }
}
