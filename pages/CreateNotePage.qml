import QtQuick 2.11
import QtQuick.Controls 2.4
import QtModel 1.0
import QtQuick.Window 2.11
import QtGraphicalEffects 1.0
import QtQuick.Controls.impl 2.4
import "../components/"

ScrollablePage{
    id: page

    signal signalClose()

    property bool date_valid: false
    property bool list_valid: false
    property bool isEdit: false
    property string str_date: ""
    property var date_array: str_date.split(/[^0-9]/)
    property real appHeight: 0

    function popSignal(){
        if(calendar.isOpen){
            calendar.isOpen = false
            return
        }

        var sql_date = getSQLDateFormat(calendar.arr_year[calendar.year],calendar.month+1,calendar.day+1)
        var note_index = tableNote.getIndexByDate(sql_date)
        if(isEdit){
            tableAction.rewriteActionsDatabase(sql_date);
            ApplicationSettings.showSnackBar("Заметка изменена")
            signalClose()
        }
        else{
            if(createNoteModel.rowCount() === 0){
                signalClose()
                return
            }
            if(tableNote.addNote(sql_date,lblMonth.text,lblDay_w.text,calendar.day + 1,createNoteModel.rowCount())){
                tableAction.initAddActionsDatabase(sql_date)
                ApplicationSettings.showSnackBar("Создана заметка")
                signalClose()
            }
            else{
                tableNote.setNotCompletedActionsCount(sql_date,note_index,createNoteModel.rowCount() + tableNote.getCountNotCompletedByIndex(note_index))
                tableAction.initAddActionsDatabase(sql_date)
                ApplicationSettings.showSnackBar("Дела добавлены")
                signalClose()
            }
        }
    }

    FontLoader{
        id: titleFont
        source: "qrc:/font/header_font.ttf"
    }

    Connections{
        target: ApplicationSettings
        onKeyboardChanged: {
            page.height = appHeight - keyboardHeight/Screen.devicePixelRatio
        }
    }

    CalendarPage{
        id: calendar
        date: isEdit ? new Date(date_array[0], date_array[1] - 1, date_array[2]) : new Date()
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

        Button{
            id: btn_back
            width: height
            height: parent.height/1.8
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            icon.name: "back"
            icon.color: ApplicationSettings.isDarkTheme ? "#D7D7D7" : "#444444"
            padding: 0
            background: Rectangle{
                width: Math.max(btn_back.height,btn_back.width)+10
                height: Math.max(btn_back.height,btn_back.width)+10
                color: ApplicationSettings.isDarkTheme ? "#3F3F3F" : "#E4E4E4"
                radius: height/2
                anchors.centerIn: parent
                opacity: btn_back.pressed ? 1 : 0

                Behavior on opacity{
                    NumberAnimation{
                        duration: 500
                        easing.type: Easing.OutExpo
                    }
                }
            }

            onClicked: {popSignal()}
        }

        Rectangle{
            width: parent.width
            height: 1
            visible: page.contentYPosition
            color: ApplicationSettings.isDarkTheme ? "#505050" : "#C5C5C5"
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
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter

            Column{
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width

                MouseArea{
                    width: childrenRect.width
                    height: childrenRect.height
                    enabled: !isEdit
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {forceActiveFocus(); calendar.isOpen = true}
                    Row{
                        padding: 0
                        spacing: 0
                        Row{
                            spacing: 10
                            Label{
                                id: lblDay
                                text: calendar.day + 1
                                font.pixelSize: 30
                                font.family: titleFont.name
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                color: ApplicationSettings.isDarkTheme ? "silver" : "#4E4E4E"
                            }
                            Label{
                                id: lblMonth
                                text: ApplicationSettings.getMonth(calendar.month)
                                font.pixelSize: 30
                                font.family: titleFont.name
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                color: ApplicationSettings.isDarkTheme ? "silver" : "#4E4E4E"
                            }
                        }
                        Label{
                            text: ", "
                            font.pixelSize: 30
                            font.family: titleFont.name
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: ApplicationSettings.isDarkTheme ? "silver" : "#4E4E4E"
                        }
                        Label{
                            id: lblDay_w
                            text: ApplicationSettings.getDayOfWeek(new Date(calendar.arr_year[calendar.year],calendar.month,calendar.day+1).getDay())
                            font.pixelSize: 30
                            font.family: titleFont.name
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: ApplicationSettings.isDarkTheme ? "silver" : "#4E4E4E"
                        }
                    }
                }
                Label{
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: isEdit ? "Редактирование записи" : "Создание заметки"
                    color: "#909090"
                    font.family: ApplicationSettings.font
                    font.pixelSize: 14
                }
            }

            Column{
                spacing: 12
                topPadding: 40
                bottomPadding: 30
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                TextEditAction{id: fieldAction; anchors.horizontalCenter: parent.horizontalCenter}
                AddActionsComponent{anchors.horizontalCenter: parent.horizontalCenter}
            }

            ListView{
                id: listActions
                width: parent.width
                height: contentHeight
                spacing: 0
                anchors.horizontalCenter: parent.horizontalCenter
                boundsBehavior: Flickable.StopAtBounds
                moveDisplaced: Transition {
                    YAnimator{easing.type: Easing.OutCirc; duration: 200 }
                }
                delegate: ListActionComponent{}
                model: ActionModel{
                    id: createNoteModel
                    list: tableAction
                }
            }
        }
    }
}
