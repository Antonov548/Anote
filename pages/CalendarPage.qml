import QtQuick 2.11
import QtQuick.Controls 2.4
import "../components"

Item{
    id: item

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
            width: overlay.isOpen ? calendarColumn.implicitWidth : 0
            height: overlay.isOpen ? calendarColumn.implicitHeight : 0
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
            Behavior on width{
                NumberAnimation{
                    duration: overlay.duration; easing.type: Easing.OutCirc
                }
            }
            Behavior on height{
                NumberAnimation{
                    duration: overlay.duration; easing.type: Easing.OutCirc
                }
            }

            Column{
                id: calendarColumn
                width: parent.width
                spacing: 20
                topPadding: 10
                Label{
                    text: "Выбор даты"
                    font.pixelSize: 30
                    font.family: titleFont.name
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: ApplicationSettings.isDarkTheme ? "silver" : "#4E4E4E"
                }

                Pane{
                    id: tumblers
                    anchors.horizontalCenter: parent.horizontalCenter
                    background: Rectangle{
                        anchors.fill: parent
                        color: "transparent"
                    }

                    Row{
                        Tumbler {
                            id: tumblerDay
                            wrap: false
                            model: dateCountDays

                            Component.onCompleted: {
                                tumblerDay.contentItem.currentIndex = dateDay - 1
                                tumblerDay.contentItem.positionViewAtIndex(dateDay - 1,ListView.Center)
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
                            model: 12

                            Component.onCompleted: {
                                tumblerMonth.contentItem.currentIndex = dateMonth
                                tumblerMonth.contentItem.positionViewAtIndex(dateMonth,ListView.Center)
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
                            Component.onCompleted: {
                                tumblerYear.contentItem.currentIndex = arr_year.indexOf(dateYear)
                                tumblerYear.contentItem.positionViewAtIndex(arr_year.indexOf(dateYear),ListView.Center)
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
            }
        }
    }
}

/*
                onClicked: {
                    tumblerDay.contentItem.positionViewAtIndex(dateDay-1,ListView.Center)
                    tumblerMonth.contentItem.positionViewAtIndex(dateMonth,ListView.Center)
                    tumblerYear.contentItem.positionViewAtIndex(arr_year.indexOf(dateYear),ListView.Center)
                }
*/
