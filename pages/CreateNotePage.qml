import QtQuick 2.11
import QtQuick.Controls 2.4
import QtModel 1.0
import QtQuick.Window 2.11
import QtGraphicalEffects 1.0
import "../components/"

ScrollablePage{
    id: page

    signal signalClose()

    property var arr_month: ["Января","Февраля","Марта","Апреля","Мая","Июня","Июля","Августа","Сентября","Октября","Ноября","Декабря"]
    property var arr_year: [2018,2019,2020,2021,2022,2023,2024,2025]
    property var arr_week: ["Вс","Пн","Вт","Ср","Чт","Пт","Сб"]

    property var date: new Date()

    property real dateYear: date.getFullYear()
    property real dateMonth: date.getMonth()
    property real dateDay: date.getDate()
    property real dateCountDays: new Date(dateYear,dateMonth,0).getDate()

    property bool date_valid: false
    property bool list_valid: false
    property real appHeight: 0

    function popSignal(){
        if(dialog.isOpen){
            dialog.isOpen = false
            return
        }

        if(tableAction.isEmpty){
            signalClose()
            return
        }

        var sql_date = getSQLDateFormat(arr_year[tumblerYear.currentIndex],tumblerMonth.currentIndex+1,tumblerDay.currentIndex+1)
        if(tableNote.addNote(sql_date,lblMonth.text,lblDay_w.text.slice(0,2),tumblerDay.currentIndex+1)){
            tableAction.addActionsDatabase(sql_date)
            signalClose()
        }
        else
            dialog.isOpen = true
    }

    Connections{
        target: ApplicationSettings
        onKeyboardChanged: {
            page.height = appHeight - keyboardHeight/Screen.devicePixelRatio
        }
    }

    function getSQLDateFormat(year,month,day){
        var sql_format_date = year
        if(month<10) sql_format_date += "-0" + month
        else sql_format_date += "-" + month

        if(day<10) sql_format_date += "-0" +day
        else sql_format_date += "-" + day

        return sql_format_date;
    }

    header: Rectangle{

        width: parent.width
        height: 50
        color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"
        visible: true

        Row{
            anchors.fill: parent
            spacing: 40
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

                onClicked: {popSignal()}
            }

            Label{
                text: "Добавить запись"
                color: ApplicationSettings.isDarkTheme? "silver" : "black"
                width: contentWidth
                height: parent.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 17
                font.family: ApplicationSettings.font
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

    ErrorMessage{
        id: msgError
        width: parent.width
        fullHeight: parent.height
        onCloseError: function(){msgError.hide()}
    }

    DialogPage{
        id: dialog
        text: "Текущая дата занята.\nЗапись не будет сохранена."
        onOkey: function(){dialog.isOpen = false; signalClose()}
        onCancel: function(){dialog.isOpen = false}
    }

    content: Column{
        id: mainColumn
        width: parent.width
        bottomPadding: 20

        Column{
            id: listViewColumn
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            Column{
                spacing: 10
                topPadding: 40
                bottomPadding: 10
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                TextEditAction{id: fieldAction; anchors.horizontalCenter: parent.horizontalCenter}
                AddActionsComponent{anchors.horizontalCenter: parent.horizontalCenter}
            }

            ListView{
                id: listView
                width: parent.width
                height: contentHeight
                anchors.horizontalCenter: parent.horizontalCenter
                boundsBehavior: Flickable.StopAtBounds

                delegate: ListActionComponent{itemText: model.info}
                model: ActionModel{
                    list: tableAction
                }
            }
        }

        Column{
            id: tumblerColumn
            topPadding: 20
            bottomPadding: 20
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            Pane{
                id: tumblers
                anchors.horizontalCenter: parent.horizontalCenter
                background: Rectangle{
                    anchors.fill: parent
                    color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"
                }

                Row{
                    Tumbler {
                        id: tumblerDay
                        wrap: false
                        model: dateCountDays
                        currentIndex: dateDay
                        Component.onCompleted: {
                            tumblerDay.contentItem.positionViewAtIndex(dateDay-1,ListView.Center)
                        }

                        NumberAnimation {
                            id: animation
                            target: tumblerDay
                            property: "currentIndex"
                            duration: 200
                            easing.type: Easing.InOutQuad
                        }

                        background: Rectangle{
                            anchors.fill: parent
                            color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"
                        }
                        contentItem: ListView {
                            model: tumblerDay.model
                            delegate: tumblerDay.delegate
                            height: parent.height

                            snapMode: ListView.SnapToItem
                            highlightRangeMode: ListView.StrictlyEnforceRange
                            preferredHighlightBegin: height / 2 - (height / tumblerDay.visibleItemCount / 2)
                            preferredHighlightEnd: height / 2 + (height / tumblerDay.visibleItemCount / 2)
                            clip: true
                        }
                        delegate: Text {
                            text: index+1
                            font.pixelSize: 17
                            font.family: ApplicationSettings.font
                            color: ApplicationSettings.isDarkTheme ? "silver" : "black"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            opacity: 1 - (Math.abs(tumblerDay.currentIndex-index))*0.4
                        }
                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            y: parent.height * 0.4
                            width: 40
                            height: 1
                            color: "#21be2b"
                        }
                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            y: parent.height * 0.6
                            width: 40
                            height: 1
                            color: "#21be2b"
                        }
                    }
                    Tumbler {
                        id: tumblerMonth
                        wrap: false
                        currentIndex: dateMonth
                        model: arr_month.length

                        Component.onCompleted: {
                            tumblerMonth.contentItem.positionViewAtIndex(dateMonth,ListView.Center)
                        }

                        background: Rectangle{
                            anchors.fill: parent
                            color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"
                        }
                        contentItem: ListView {
                            model: tumblerMonth.model
                            delegate: tumblerMonth.delegate
                            height: parent.height

                            snapMode: ListView.SnapToItem
                            highlightRangeMode: ListView.StrictlyEnforceRange
                            preferredHighlightBegin: height / 2 - (height / tumblerMonth.visibleItemCount / 2)
                            preferredHighlightEnd: height / 2 + (height / tumblerMonth.visibleItemCount / 2)
                            clip: true
                        }
                        delegate: Text{
                            font.pixelSize: 17
                            font.family: ApplicationSettings.font
                            text: arr_month[index].slice(0,3)
                            color: ApplicationSettings.isDarkTheme ? "silver" : "black"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            opacity: 1 - (Math.abs(tumblerMonth.currentIndex-index))*0.4
                        }
                        onCurrentIndexChanged: {
                            var countDays = new Date(arr_year[tumblerYear.currentIndex],tumblerMonth.currentIndex+1,0).getDate()
                            var currDay = tumblerDay.currentIndex+1
                            if(countDays < currDay){
                                tumblerDay.model = countDays
                                tumblerDay.contentItem.positionViewAtIndex(countDays-1,ListView.Center)
                            }
                            else{
                                tumblerDay.model = countDays
                                tumblerDay.contentItem.positionViewAtIndex(currDay-1,ListView.Center)
                            }
                        }
                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            y: parent.height * 0.4
                            width: 40
                            height: 1
                            color: "#21be2b"
                        }
                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            y: parent.height * 0.6
                            width: 40
                            height: 1
                            color: "#21be2b"
                        }
                    }
                    Tumbler{
                        id: tumblerYear
                        model: arr_year.length
                        currentIndex: arr_year.indexOf(dateYear)
                        Component.onCompleted: {
                            tumblerYear.contentItem.positionViewAtIndex(arr_year.indexOf(dateYear),ListView.Center)
                        }

                        background: Rectangle{
                            anchors.fill: parent
                            color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"
                        }
                        contentItem: ListView {
                            model: tumblerYear.model
                            delegate: tumblerYear.delegate
                            height: parent.height

                            snapMode: ListView.SnapToItem
                            highlightRangeMode: ListView.StrictlyEnforceRange
                            preferredHighlightBegin: height / 2 - (height / tumblerYear.visibleItemCount / 2)
                            preferredHighlightEnd: height / 2 + (height / tumblerYear.visibleItemCount / 2)
                            clip: true
                        }
                        wrap: false
                        delegate: Text{
                            font.pixelSize: 17
                            font.family: ApplicationSettings.font
                            text: arr_year[index]
                            color: ApplicationSettings.isDarkTheme ? "silver" : "black"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            opacity: 1 - (Math.abs(tumblerYear.currentIndex-index))*0.4
                        }
                        onCurrentIndexChanged: {
                            var countDays = new Date(arr_year[currentIndex],tumblerMonth.currentIndex+1,0).getDate()
                            var currDay = tumblerDay.currentIndex+1
                            if(countDays < currDay){
                                tumblerDay.model = countDays
                                tumblerDay.contentItem.positionViewAtIndex(countDays-1,ListView.Center)
                            }
                            else{
                                tumblerDay.model = countDays
                                tumblerDay.contentItem.positionViewAtIndex(currDay-1,ListView.Center)
                            }
                        }
                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            y: parent.height * 0.4
                            width: 40
                            height: 1
                            color: "#21be2b"
                        }

                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            y: parent.height * 0.6
                            width: 40
                            height: 1
                            color: "#21be2b"
                        }
                    }
                }
            }

            Row{
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                bottomPadding: 10

                Label{
                    id: lblDay_w
                    text: arr_week[new Date(arr_year[tumblerYear.currentIndex],tumblerMonth.currentIndex,tumblerDay.currentIndex+1).getDay()]+","
                    font.pixelSize: 18
                    font.family: ApplicationSettings.font
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: ApplicationSettings.isDarkTheme ? "silver" : "black"
                }
                Label{
                    id: lblDay
                    text: tumblerDay.currentIndex+1
                    font.pixelSize: 18
                    font.family: ApplicationSettings.font
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: ApplicationSettings.isDarkTheme ? "silver" : "black"

                }
                Label{
                    id: lblMonth
                    text: arr_month[tumblerMonth.currentIndex]
                    font.pixelSize: 18
                    font.family: ApplicationSettings.font
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: ApplicationSettings.isDarkTheme ? "silver" : "black"
                }
            }

            Button{
                id: buttonToday
                height: 40
                padding: 0
                anchors.horizontalCenter: parent.horizontalCenter

                onClicked: {
                    tumblerDay.contentItem.positionViewAtIndex(dateDay-1,ListView.Center)
                    tumblerMonth.contentItem.positionViewAtIndex(dateMonth,ListView.Center)
                    tumblerYear.contentItem.positionViewAtIndex(arr_year.indexOf(dateYear),ListView.Center)
                }

                background: Rectangle{
                    anchors.fill: parent
                    radius: 4
                    color: ApplicationSettings.isDarkTheme ?  buttonToday.pressed ? "#292929" : "#323232" : buttonToday.pressed ? "#C7C7C7" : "#E1E1E1"
                }

                contentItem: Label{
                    text: "Сегодня"
                    height: parent.height
                    font.family: ApplicationSettings.font
                    font.pixelSize: 16
                    leftPadding: 15
                    rightPadding: 15
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                }
            }
        }
    }
}
