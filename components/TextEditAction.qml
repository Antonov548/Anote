import QtQuick 2.11
import QtQuick.Controls 2.4

Item{
    id: item

    property alias text: field.text
    property bool isReadyToAccept: false

    function clear(){
        isReadyToAccept = false;
        field.isTextChanged = false
        field.text = field.placeholderText
        field.focus = false
    }

    width: parent.width/1.2
    height: field.height + 12
    anchors.horizontalCenter: parent.horizontalCenter

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
        TextEdit{
            property bool isTextChanged: false
            property string placeholderText: "Текст заметки"

            id: field
            width: parent.width/1.1
            topPadding: 5
            bottomPadding: 5
            leftPadding: 10
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
            color: ApplicationSettings.isDarkTheme ? field.isTextChanged ? "silver" : "#747474"  :  field.isTextChanged ? "#454545" : "#A5A5A5"
            wrapMode: TextArea.Wrap
            text: placeholderText

            onTextChanged: {
                isReadyToAccept = false
                if(text.length !== 0 && isTextChanged)
                    isReadyToAccept = true
            }

            onActiveFocusChanged: {
                if(activeFocus && !isTextChanged){
                    isTextChanged = true
                    text = ""
                }else if(!field.activeFocus && text.length == 0){
                    isTextChanged = false
                    text = placeholderText
                }
            }
        }
    }
}
