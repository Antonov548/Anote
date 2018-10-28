import QtQuick 2.11
import QtQuick.Controls 2.4
import Qt.labs.calendar 1.0
import "../components/"

Page{
    id: modal

    property var arr_month: ["Января","Февраля","Марта","Апреля","Мая","Июня","Июля","Августа","Сентября","Октября","Ноября","Декабря"]
    property var arr_year: [2018,2019,2020,2021,2022,2023,2024,2025]
    property var arr_week: ["Вс","Пн","Вт","Ср","Чт","Пт","Сб"]

    signal signalClose()
    signal signalAccept(real year, string month_s, real month_n, string day_w, real day)

    Component.onCompleted: {
        tumblerDay.currentIndex = new Date().getDate()-1
        tumblerMonth.currentIndex = new Date().getMonth()
        tumblerYear.currentIndex = arr_year.indexOf(new Date().getFullYear())
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

    Page{
        id: dialog
        anchors.centerIn: parent
        width: parent.width/1.2
        height: parent.height/1.5

        background: Rectangle{
            anchors.fill: parent
            color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"
        }

        contentItem: SwipeView{
            id: swipeView
            width: parent.width
            height: parent.height - footer.height
            clip: true
            ScrollablePage{

                backgr: Rectangle{
                    anchors.fill: parent
                    color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"
                }

                content: Column{
                    topPadding: 20
                    bottomPadding: 20
                    spacing: 20

                    Label{
                        text: "Настройки записи"
                        font.pointSize: 15
                        color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

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
                                model: ListModel{
                                    id: tumblerModel
                                }
                                background: Rectangle{
                                    anchors.fill: parent
                                    color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"
                                }

                                function setDayModel(new_count){

                                    if(tumblerModel.count<new_count){
                                        tumblerModel.append({"text":tumblerModel.count+1})
                                        tumblerDay.setDayModel(new_count)
                                    }
                                    else if(tumblerModel.count>new_count){
                                        tumblerModel.remove(tumblerModel.count-1)
                                        tumblerDay.setDayModel(new_count)
                                    }
                                }

                                delegate: Text {
                                    text: model.text
                                    font.pointSize: 15
                                    color: ApplicationSettings.isDarkTheme ? "silver" : "black"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    opacity: 1.0 - Math.abs(Tumbler.displacement) / (tumblerDay.visibleItemCount / 2)
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
                                id: tumblerMonth

                                model: arr_month.length
                                background: Rectangle{
                                    anchors.fill: parent
                                    color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"
                                }
                                wrap: false
                                delegate: Text{
                                    text: arr_month[index].slice(0,3)
                                    color: ApplicationSettings.isDarkTheme ? "silver" : "black"
                                    font.pointSize: 15
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    opacity: 1.0 - Math.abs(Tumbler.displacement) / (tumblerDay.visibleItemCount / 2)
                                }

                                onCurrentIndexChanged:tumblerDay.setDayModel(new Date(arr_year[tumblerYear.currentIndex],currentIndex+1,0).getDate())

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
                                background: Rectangle{
                                    anchors.fill: parent
                                    color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"
                                }
                                wrap: false
                                delegate: Text{
                                    font.pointSize: 15
                                    text: arr_year[index]
                                    color: ApplicationSettings.isDarkTheme ? "silver" : "black"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    opacity: 1.0 - Math.abs(Tumbler.displacement) / (tumblerDay.visibleItemCount / 2)
                                }

                                onCurrentIndexChanged: tumblerDay.setDayModel(new Date(arr_year[currentIndex],tumblerMonth.currentIndex+1,0).getDate())

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

                        Label{
                            id: lblDay_w
                            text: arr_week[new Date(arr_year[tumblerYear.currentIndex],tumblerMonth.currentIndex,tumblerDay.currentIndex+1).getDay()]+","
                            font.pointSize: 15
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: ApplicationSettings.isDarkTheme ? "silver" : "black"
                        }
                        Label{
                            id: lblDay
                            text: tumblerDay.currentIndex+1
                            font.pointSize: 15
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: ApplicationSettings.isDarkTheme ? "silver" : "black"

                        }
                        Label{
                            id: lblMonth
                            text: arr_month[tumblerMonth.currentIndex]
                            font.pointSize: 15
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: ApplicationSettings.isDarkTheme ? "silver" : "black"

                        }

                    }
                }
            }
            ScrollablePage{
                backgr: Rectangle{
                    anchors.fill: parent
                    color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"
                }
                content: Column{
                    topPadding: 20
                    bottomPadding: 20
                    spacing: 20

                    Label{
                        text: "Список дел"
                        font.pointSize: 15
                        color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    ListView {
                        width: dialog.width
                        height: contentHeight
                        anchors.horizontalCenter: parent.horizontalCenter
                        clip: true
                        spacing: 5
                        boundsBehavior: Flickable.StopAtBounds

                        model: ListModel{
                            id: listModel
                            ListElement{added: false}
                        }

                        delegate: ListActionsComponent{}
                    }
                }
            }
        }

        footer:Column{
            id: footer
            PageIndicator{
                id: pageIndicator
                count: swipeView.count
                currentIndex: swipeView.currentIndex
                anchors.horizontalCenter: parent.horizontalCenter
                background: Rectangle{
                    anchors.fill: parent
                    color: "transparent"
                }

                delegate: Rectangle {
                    implicitWidth: 10
                    implicitHeight: 10

                    radius: width / 2
                    color: "#A3A3A3"

                    opacity: index === pageIndicator.currentIndex ? 1 : 0.5

                    Behavior on opacity {
                        OpacityAnimator {
                            duration: 200
                        }
                    }
                }
            }

            Button{
                width: parent.width
                font.pointSize: 15
                text: "Подтвердить"
                onClicked: signalAccept(arr_year[tumblerYear.currentIndex],lblMonth.text,tumblerMonth.currentIndex+1,
                                        lblDay_w.text.slice(0,2),tumblerDay.currentIndex+1)
            }
        }
    }
}
