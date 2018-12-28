import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.impl 2.4
import "../components"

Item{
    id: item

    property var arr_year: [2018,2019,2020,2021,2022,2023,2024,2025]

    property var date: isEdit ? new Date(str_date) : new Date()

    property real dateYear: date.getFullYear()
    property real dateMonth: date.getMonth()
    property real dateDay: date.getDate()
    property real dateCountDays: new Date(dateYear,dateMonth,0).getDate()

    property alias isOpen: overlay.isOpen
    property alias day: tumblerDay.currentIndex
    property alias month: tumblerMonth.currentIndex
    property alias year: tumblerYear.currentIndex

    FontLoader{
        id: titleFont
        source: "qrc:/font/header_font.ttf"
    }

    OverlayPage{
        id: overlay
        overlayOpacity: ApplicationSettings.isDarkTheme ? 0.75 : 0.6

        content: Page{
            id: page
            width: calendarColumn.implicitWidth
            height: calendarColumn.implicitHeight
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
                    duration: overlay.duration; easing.type: Easing.OutCirc
                }
            }

            Column{
                id: calendarColumn
                spacing: 20
                leftPadding: 40
                rightPadding: 40
                topPadding: 20
                bottomPadding: 20
                Label{
                    text: "Выбор даты"
                    font.pixelSize: 30
                    font.family: titleFont.name
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: ApplicationSettings.isDarkTheme ? "silver" : "#4E4E4E"
                }
                Column{
                    spacing: 5
                    Pane{
                        id: tumblers
                        anchors.horizontalCenter: parent.horizontalCenter
                        padding: 0
                        background: Rectangle{
                            anchors.fill: parent
                            color: "transparent"
                        }

                        Row{
                            Tumbler {
                                id: tumblerDay
                                wrap: false
                                model: item.dateCountDays
                                width: 40

                                Component.onCompleted: {
                                    tumblerDay.contentItem.currentIndex = item.dateDay - 1
                                    tumblerDay.contentItem.positionViewAtIndex(item.dateDay - 1,ListView.Center)
                                }

                                background: Rectangle{
                                    anchors.fill: parent
                                    color: "transparent"
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
                                delegate: Text{
                                    text: index+1
                                    padding: 0
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
                                    width: tumblerDay.width
                                    height: 1
                                    color: "#21be2b"
                                }
                                Rectangle {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    y: parent.height * 0.6
                                    width: tumblerDay.width
                                    height: 1
                                    color: "#21be2b"
                                }
                            }
                            Tumbler {
                                id: tumblerMonth
                                wrap: false
                                model: 12
                                width: 40

                                Component.onCompleted: {
                                    tumblerMonth.contentItem.currentIndex = item.dateMonth
                                    tumblerMonth.contentItem.positionViewAtIndex(item.dateMonth,ListView.Center)
                                }

                                background: Rectangle{
                                    anchors.fill: parent
                                    color: "transparent"
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
                                    text: ApplicationSettings.getMonth(index).slice(0,3)
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
                                    width: tumblerMonth.width
                                    height: 1
                                    color: "#21be2b"
                                }
                                Rectangle {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    y: parent.height * 0.6
                                    width: tumblerMonth.width
                                    height: 1
                                    color: "#21be2b"
                                }
                            }
                            Tumbler{
                                id: tumblerYear
                                model: arr_year.length
                                width: 55

                                Component.onCompleted: {
                                    tumblerYear.contentItem.currentIndex = arr_year.indexOf(item.dateYear)
                                    tumblerYear.contentItem.positionViewAtIndex(arr_year.indexOf(item.dateYear),ListView.Center)
                                }

                                background: Rectangle{
                                    anchors.fill: parent
                                    color: "transparent"
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
                                    width: tumblerYear.width
                                    height: 1
                                    color: "#21be2b"
                                }

                                Rectangle {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    y: parent.height * 0.6
                                    width: tumblerYear.width
                                    height: 1
                                    color: "#21be2b"
                                }
                            }
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
                                name: "today"
                                color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                                anchors.verticalCenter: parent.verticalCenter
                                width: 18
                                height: 18
                            }
                            Text{
                                text: "Сегодня"
                                font.family: ApplicationSettings.font
                                font.pixelSize: 16
                                padding: 0
                                color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                        onClicked: {
                            tumblerDay.contentItem.positionViewAtIndex(dateDay-1,ListView.Center)
                            tumblerMonth.contentItem.positionViewAtIndex(dateMonth,ListView.Center)
                            tumblerYear.contentItem.positionViewAtIndex(arr_year.indexOf(dateYear),ListView.Center)
                        }
                    }
                }
            }
        }
    }
}
