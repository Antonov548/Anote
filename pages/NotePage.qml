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

    signal signalClose()

    function popSignal(){
        signalClose()
    }

    function getLabel(parse_date){
        var string_date = parse_date.toString()

        if(string_date.length >= 2){
            if(parseInt(string_date[string_date.length-2]) === 1)
                return "Осталось " + parse_date + " дней"
        }

        if(parseInt(string_date[string_date.length-1]) === 1)
            return "Остался " + parse_date + " день"
        if(parseInt(string_date[string_date.length-1]) >1 && parseInt(string_date[string_date.length-1]) <5)
            return "Осталось " + parse_date + " дня"
        if(parseInt(string_date[string_date.length-1]) >= 5)
            return "Осталось " + parse_date + " дней"
    }

    header: Rectangle{
        width: parent.width
        height: 50
        color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"
        visible: true

        Row{
            anchors.fill: parent
            spacing: 20
            padding: 0

            Button{
                id: button
                width: parent.height
                height: parent.height
                background: Rectangle{
                    anchors.fill: parent
                    color: ApplicationSettings.isDarkTheme ?  button.pressed ? "#292929" : "#1B1B1B" : button.pressed ? "#DEDEDE" : "white"
                    Rectangle{
                        height: 18
                        width: 2
                        color: ApplicationSettings.isDarkTheme? "silver" : "black"
                        anchors.centerIn: parent
                        transform: Rotation { origin.x: 1; origin.y: 9; angle: 45}
                    }
                    Rectangle{
                        height: 18
                        width: 2
                        color: ApplicationSettings.isDarkTheme? "silver" : "black"
                        anchors.centerIn: parent
                        transform: Rotation { origin.x: 1; origin.y: 9; angle: 135}
                    }
                }

                onClicked: {stackView.pop()}
            }

            Label{
                text: "Заметка"
                color: ApplicationSettings.isDarkTheme? "silver" : "black"
                width: contentWidth
                height: parent.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 17
            }
        }

        Rectangle{
            width: parent.width
            height: 1
            color: ApplicationSettings.isDarkTheme ? "silver" : "black"
            anchors.bottom: parent.bottom
            opacity: 0.2
        }
    }

    backgroundColor: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"

    content: Column{
        anchors.fill: parent
        spacing: 40
        topPadding: 40
        bottomPadding: 20

        Column{
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 5
            width: parent.width
            Label{
                anchors.horizontalCenter: parent.horizontalCenter
                text: day + " " + month + ", " + day_w
                color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                font.family: ApplicationSettings.font
                font.pixelSize: 18
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
                        getLabel(Math.round(hours_count/24))
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
