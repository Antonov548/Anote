import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.impl 2.4

Item{
    id: item

    property alias text: field.text
    property bool isIncorrect: false

    width: parent.width/1.2
    height: field.height + 20
    anchors.horizontalCenter: parent.horizontalCenter

    function clear(){
        field.text = ""
    }

    ListView.onAdd: NumberAnimation {
        target: item
        property: "opacity"
        from: 0
        to: 1
        duration: 300
        easing.type: Easing.InOutQuad
    }

    Column{
        width: item.width
        height: item.height
        spacing: 5
        Row{
            width: parent.width
            TextArea{
                id: field
                width: parent.width - 20
                height: text.length == 0 ? implicitHeight + 1 : implicitHeight
                topPadding: 0
                bottomPadding: 0
                leftPadding: 10
                rightPadding: 10
                font.pixelSize: 16
                font.family: "Arial"
                color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                wrapMode: TextArea.Wrap
                placeholderText: "Текст заметки"
                onTextChanged: {
                    if(item.isIncorrect)
                        item.isIncorrect = false
                }
            }
            IconImage{
                width: 18
                height: 18
                name: "field"
                color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                opacity: item.isIncorrect ? 1 : 0
                Behavior on opacity {
                    NumberAnimation{
                        duration: 150
                    }
                }
            }
        }
        Rectangle{
            width: parent.width
            height: 1
            color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
        }
        Text {
            text: "Введите текст"
            font.family: ApplicationSettings.font
            font.pixelSize: 14
            color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
            leftPadding: 10
            opacity: item.isIncorrect ? 1 : 0
            Behavior on opacity {
                NumberAnimation{
                    duration: 150
                }
            }
        }
    }
}
