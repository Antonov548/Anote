import QtQuick 2.11
import QtQuick.Controls 2.4

Item{
    id: item

    property alias text: field.text
    property bool isReadyToAccept: false

    width: parent.width/1.2
    height: field.height + 20
    anchors.horizontalCenter: parent.horizontalCenter

    function clear(){
        field.clear()
    }

    ListView.onAdd: NumberAnimation {
        target: item
        property: "opacity"
        from: 0
        to: 1
        duration: 300
        easing.type: Easing.InOutQuad
    }

    Rectangle{
        width: item.width
        height: item.height
        color: ApplicationSettings.isDarkTheme ? "#3A3A3A" : "#E1E1E1"
        radius: 4
        TextArea{

            id: field
            width: parent.width/1.1
            topPadding: 0
            bottomPadding: 0
            leftPadding: 10
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
            color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
            wrapMode: TextArea.Wrap
            placeholderText: "Текст заметки"

            onTextChanged: {
                isReadyToAccept = false
                if(text.length !== 0)
                    isReadyToAccept = true
            }
        }
    }
}
