import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item{

    id: item

    width: parent.width
    height: 60 + bottomSpacing.height
    anchors.horizontalCenter: parent.horizontalCenter
    clip: true

    ListView.onRemove: SequentialAnimation {
        PropertyAction { target: item; property: "ListView.delayRemove"; value: true }
        PropertyAnimation {
            property: "height"
            target: item
            to: 0
            duration: 300
            easing.type: Easing.InOutQuad
        }
        PropertyAction { target: item; property: "ListView.delayRemove"; value: false }
    }

    Column{
        id: mainColumn
        width: parent.width
        Rectangle{
            width: parent.width/1.05
            height: 60
            radius: 8
            anchors.horizontalCenter: parent.horizontalCenter

            color: ApplicationSettings.isDarkTheme ?  mouseArea.pressed ? "#292929" : "#323232" : mouseArea.pressed ? "#DEDEDE" : "white"

            Row{
                anchors.fill: parent
                leftPadding: 40
                Column{
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2
                    Label{
                        text: model.day + " " + model.month + ", " + model.day_w
                        font.family: ApplicationSettings.font
                        font.pixelSize: 16
                        color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                    }
                    Label{
                        text: "10 не завершенных дел"
                        font.family: "Arial"
                        font.pixelSize: 12
                        color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                    }
                }
            }

            MouseArea{
                id: mouseArea
                width: parent.width
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                hoverEnabled: true
                onPressAndHold: {stackInitial.indexChange = index}
                pressAndHoldInterval: 300
                onClicked: {tableAction.getActionsDatabase(model.date); stackView.notePage = stackView.push("qrc:/qml/pages/NotePage.qml",{"month":model.month, "day":model.day, "day_w":model.day_w, "date":model.date})}
            }
        }
        Rectangle{
            id: bottomSpacing
            height: 8
            width: parent.width
            color: "transparent"
        }
    }
    DropShadow{
        anchors.fill: mainColumn
        horizontalOffset: 1
        verticalOffset: 2
        radius: 4.0
        samples: 20
        color: ApplicationSettings.isDarkTheme ? "#151515" : "silver"
        source: mainColumn
    }
}

/*
                    onClicked: {
                        var data = listModel.getProperty("date",stackInitial.indexChange)
                        tableNote.deleteNote(data,stackInitial.indexChange)
                        tableAction.deleteActionsDatabase(data)
                        stackInitial.indexChange = -1
                    }
*/
