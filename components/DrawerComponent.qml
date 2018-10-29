import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Component{

    Rectangle{

        width: parent.width
        height: 60

        color: mouseArea.pressed ? "#41507D" : "transparent"

        Image{

            id: image
            width: parent.height/3
            height: parent.height/3
            source: delegateSourceImage
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 30

        }

        ColorOverlay{

            anchors.fill: image
            source: image
            color: "white"

        }

        Label{

            width: parent.width - parent.height
            height: parent.height
            anchors.left: image.right
            anchors.leftMargin: 20
            text: delegateTitle
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            color: "white"
            font.pixelSize: 16
            opacity: delegateEnabled ? 1 : 0.5

        }

        MouseArea{

            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: onClick()

            function onClick(){

                if(delegateEnabled){
                    drawer.enabled = false
                    delegateHandler(delegateTitle)
                }
                else{
                    return
                }
            }
        }
    }
}
