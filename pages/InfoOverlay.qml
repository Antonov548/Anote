import QtQuick 2.11
import QtQuick.Controls 2.4
import "../components"

Item{
    id: item

    function show(info){
        info.text = info
        showAnimation.start()
    }

    Rectangle{
        parent: ApplicationWindow.overlay
        color: "transparent"

        Page{
            id: page
            visible: false
            x: (item.width - width)/2

            SequentialAnimation{
                id: showAnimation
                alwaysRunToEnd: true
                PropertyAction{
                    target: page; property: "visible"; value: true
                }
                YAnimator{
                    target: page
                    from: item.height
                    to: item.height - page.height - 20
                    easing.type: Easing.OutCirc
                }
                PauseAnimation{
                    duration: 1000
                }
                YAnimator{
                    target: page
                    from: item.height - page.height - 20
                    to: item.height
                    easing.type: Easing.OutCirc
                }
                PropertyAction{
                    target: page; property: "visible"; value: false
                }
            }

            background: Rectangle{
                anchors.fill: parent
                color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                radius: height/2
            }
            contentItem: Text{
                id: info
                text: "Неверный пароль"
                font.family: ApplicationSettings.font
                font.pixelSize: 14
                color: ApplicationSettings.isDarkTheme ? "#454545" : "silver"
                leftPadding: 15
                rightPadding: 15
                topPadding: 8
                bottomPadding: 8
            }
        }
    }
}
