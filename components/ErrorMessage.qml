import QtQuick 2.11
import QtQuick.Controls 2.4

Page{
    id: errorMess
    height: 50
    visible: false
    x:0
    y: fullHeight - height

    property string errorString: ""
    property bool showed: false
    property real fullHeight: 0
    property var onCloseError: function(){}

    function showMessage(text){
        errorString = text
        animShow.start()
    }

    function show(){
        animShow.start()
    }

    function hide(){
        animClose.start()
    }


    SequentialAnimation{
        id: animShow
        PropertyAction {
            target: errorMess; property: "visible"; value: true }
        PropertyAnimation{
            target: errorMess
            property: "y"
            from: errorMess.showed ? fullHeight - height : fullHeight
            to: fullHeight - height
            duration: 150
        }
        PropertyAction {
            target: errorMess; property: "showed"; value: true }
    }

    SequentialAnimation{
        id: animClose
        PropertyAnimation{
            target: errorMess
            property: "y"
            from: fullHeight - height
            to: fullHeight
            duration: 150
        }
        PropertyAction {
            target: errorMess; property: "visible"; value: false }
        PropertyAction {
            target: errorMess; property: "showed"; value: false }
    }

    Row{
        width: errorMess.width
        height: errorMess.height
        Label{
            height: parent.height
            width: parent.width - parent.height
            text: errorString
            color: "#454545"
            font.pixelSize: 16
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        Button{
            id: button
            width: parent.height
            height: parent.height
            background: Rectangle{
                anchors.fill: button
                color: "transparent"
                Rectangle{
                    height: 16
                    width: 2
                    color: "silver"
                    anchors.centerIn: parent
                    transform: Rotation { origin.x: 1; origin.y: 8; angle: 45}
                }
                Rectangle{
                    height: 16
                    width: 2
                    color: "silver"
                    anchors.centerIn: parent
                    transform: Rotation { origin.x: 1; origin.y: 8; angle: 135}
                }
            }
            onClicked: onCloseError()
        }
    }
    Rectangle{
        height: 1
        width: errorMess.width
        color: ApplicationSettings.isDarkTheme ? "#D2D2D2" : "black"
        opacity: 0.2
        anchors.top: parent.top
    }
}
