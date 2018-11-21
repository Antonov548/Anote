import QtQuick 2.11
import QtQuick.Controls 2.4

Item{
    id: item
    visible: true
    anchors.fill: parent

    property bool isOpen: false

    Page{
        id: page
        anchors.fill: item
        visible: false
        background: Rectangle{
            anchors.fill: page
            color: "black"
            opacity: isOpen ? 0.7 : 0
            Behavior on opacity {
                OpacityAnimator{
                    duration: 150
                }
            }
        }

        MouseArea{
            anchors.fill: parent
            onClicked: isOpen = false
        }

        ScrollablePage{
            x: button.x - 10
            y: button.y - 10
            width: isOpen ? item.width/1.7 : 0
            height: isOpen ? item.height/2 : 0

            Behavior on width {
                NumberAnimation{
                    duration: 200
                    easing.type: Easing.OutCirc//OutBack
                }
            }

            Behavior on height {
                NumberAnimation{
                    duration: 200
                    easing.type: Easing.OutCirc//OutBack
                }
            }

            clip: true
            background: Rectangle{
                anchors.fill: parent
                radius: 8
                color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "#E9E9E9"
            }
        }
    }

    Button{
        id: button
        x: 20
        y: 20
        width: 22
        height: 16
        state: isOpen ? "opened" : "default"
        onClicked: isOpen = !isOpen
        states: [
            State{
                name: "default"
                PropertyChanges{target: humb_1; y: 0; x: 0; width: button.width}
                PropertyChanges{target: humb_3; x: 0; width: button.width}
                PropertyChanges{target: humb_2; width: button.width}
                PropertyChanges{target: transf_1; angle: 0}
                PropertyChanges{target: transf_2; angle: 0}
            },
            State{
                name: "opened"
                PropertyChanges{target: humb_1; y: -1; x: (button.width - button.height)/2; width: Math.sqrt(2*Math.pow(button.height,2))}
                PropertyChanges{target: humb_3; x: (button.width - button.height)/2; width: Math.sqrt(2*Math.pow(button.height,2))}
                PropertyChanges{target: humb_2; width: 0}
                PropertyChanges{target: transf_1; angle: 45}
                PropertyChanges{target: transf_2; angle: -45}
            }
        ]

        transitions: [
            Transition {
                from: "default"
                to: "opened"
                SequentialAnimation{
                    PropertyAction{target: page; property: "visible"; value: true}
                    ParallelAnimation{
                        PropertyAnimation{ targets: [humb_3,humb_1] ; properties: "width,y,x"; duration: 200; easing.type: Easing.InOutQuad}
                        PropertyAnimation{ targets: [transf_1,transf_2] ; properties: "angle"; duration: 200; easing.type: Easing.OutCirc}
                        PropertyAnimation{ target: humb_2; property: "width"; duration: 100; easing.type: Easing.InOutQuad}
                    }
                }
            },
            Transition {
                from: "opened"
                to: "default"
                SequentialAnimation{
                    ParallelAnimation{
                        PropertyAnimation{ targets: [humb_3,humb_1] ; properties: "width,y"; duration: 200; easing.type: Easing.InOutQuad}
                        PropertyAnimation{ targets: [transf_1,transf_2] ; properties: "angle"; duration: 200; easing.type: Easing.OutCirc}
                        PropertyAnimation{ target: humb_2; property: "width"; duration: 100; easing.type: Easing.InOutQuad}
                    }
                    PropertyAction{target: page; property: "visible"; value: false}
                }
            }
        ]

        background: Rectangle{
            anchors.fill: parent
            color: "transparent"
        }
        contentItem: Rectangle{
            anchors.fill: parent
            color: "transparent"
            Rectangle{
                id: humb_1
                width: button.width
                height: 2
                color: ApplicationSettings.isDarkTheme ? "#D7D7D7" : "#2B2B2B"
                transform: Rotation {id: transf_1; origin.x: 0; origin.y: 1;}
            }
            Rectangle{
                id: humb_2
                x:0
                y: (button.height - height)/2
                width: button.width
                height: 2
                color: ApplicationSettings.isDarkTheme ? "#D7D7D7" : "#2B2B2B"
            }
            Rectangle{
                id: humb_3
                width: button.width
                y: button.height-height;
                height: 2
                color: ApplicationSettings.isDarkTheme ? "#D7D7D7" : "#2B2B2B"
                transform: Rotation {id: transf_2; origin.x: 0; origin.y: 1;}
            }
        }
    }
}
