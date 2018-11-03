import QtQuick 2.11
import QtQuick.Controls 2.4
import Qt.labs.calendar 1.0
import QtModel 1.0
import "../components/"

Page{
    id: modal

    property var arr_month: ["Января","Февраля","Марта","Апреля","Мая","Июня","Июля","Августа","Сентября","Октября","Ноября","Декабря"]
    property var arr_year: [2018,2019,2020,2021,2022,2023,2024,2025]
    property var arr_week: ["Вс","Пн","Вт","Ср","Чт","Пт","Сб"]

    property bool date_valid: false
    property bool list_valid: false

    signal signalClose()

    function getSQLDateFormat(year,month,day){
        var sql_format_date = year
        if(month<10) sql_format_date += "-0" + month
        else sql_format_date += "-" + month

        if(day<10) sql_format_date += "-0" +day
        else sql_format_date += "-" + day

        return sql_format_date;
    }

    Component.onCompleted: {
        tumblerDay.currentIndex = new Date().getDate()-1
        tumblerMonth.currentIndex = new Date().getMonth()
        tumblerYear.currentIndex = arr_year.indexOf(new Date().getFullYear())
    }

    MouseArea{
        anchors.fill: parent
        onClicked: modal.signalClose()
    }

    background: Rectangle{
        anchors.fill: modal
        color: ApplicationSettings.isDarkTheme ? "#3F3F3F" : "black"
        opacity: 0.3
    }

    ErrorMessage{
        id: msgError
        width: parent.width
        fullHeight: parent.height
        onCloseError: function(){msgError.hide()}
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
                        font.pixelSize: 16
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
                                    font.pixelSize: 16
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
                                    font.pixelSize: 16
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
                                    font.pixelSize: 16
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
                            font.pixelSize: 16
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: ApplicationSettings.isDarkTheme ? "silver" : "black"
                        }
                        Label{
                            id: lblDay
                            text: tumblerDay.currentIndex+1
                            font.pixelSize: 16
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: ApplicationSettings.isDarkTheme ? "silver" : "black"

                        }
                        Label{
                            id: lblMonth
                            text: arr_month[tumblerMonth.currentIndex]
                            font.pixelSize: 16
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
                    spacing: 30

                    Label{
                        text: "Список дел"
                        font.pixelSize: 16
                        color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Column{
                        width: parent.width
                        spacing: 8

                        AddActionsComponent{}

                        ListView{
                            width: parent.width/1.1
                            height: contentHeight
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 8
                            boundsBehavior: Flickable.StopAtBounds

                            delegate: ListActionComponent{}
                            model: ActionModel{
                                list: tableAction
                            }
                        }
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
                font.pixelSize: 20
                text: "Подтвердить"
                onClicked: {
                    var sql_date = getSQLDateFormat(arr_year[tumblerYear.currentIndex],tumblerMonth.currentIndex+1,tumblerDay.currentIndex+1)
                    if(tableNote.addNote(sql_date,lblMonth.text,lblDay_w.text.slice(0,2),tumblerDay.currentIndex+1)){
                        tableAction.addActionsDatabase(sql_date)
                        signalClose()
                    }
                    else
                        msgError.showMessage("Текущая дата занята")
                }
            }
        }
    }
}
