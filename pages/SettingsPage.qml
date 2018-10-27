import QtQuick 2.11
import QtQuick.Controls 2.4
import "../components"

ScrollablePage{

    Connections{
        id: connectionDialogPass
        ignoreUnknownSignals: true
        onSignalClose: stackView.pop()
    }

    header: Rectangle{

        width: parent.width
        height: 50
        color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"
        visible: true

        Row{
            anchors.fill: parent
            spacing: 20
            padding: 0

            Button{
                id: button
                width: parent.height
                height: parent.height
                background: Rectangle{
                    anchors.fill: parent
                    color: ApplicationSettings.isDarkTheme ?  button.pressed ? "#292929" : "#1B1B1B" : button.pressed ? "#DEDEDE" : "white"
                    Rectangle{
                        height: 16
                        width: 2
                        color: ApplicationSettings.isDarkTheme? "silver" : "black"
                        anchors.centerIn: parent
                        transform: Rotation { origin.x: 1; origin.y: 8; angle: 45}
                    }
                    Rectangle{
                        height: 16
                        width: 2
                        color: ApplicationSettings.isDarkTheme? "silver" : "black"
                        anchors.centerIn: parent
                        transform: Rotation { origin.x: 1; origin.y: 8; angle: 135}
                    }

                }

                onClicked: { stackView.pop()}

            }

            Label{
                text: "Настройки"
                color: ApplicationSettings.isDarkTheme? "silver" : "black"
                width: contentWidth
                height: parent.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 15

            }

        }

        Rectangle{
            width: parent.width
            height: 1
            color: ApplicationSettings.isDarkTheme ? "silver" : "black"
            anchors.bottom: parent.bottom
            opacity: 0.2

        }

    }

    backgr: Rectangle{
        anchors.fill: parent
        color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"
    }

    content: Column{
        anchors.fill: parent
        topPadding: 40
        spacing: 30
        bottomPadding: 40

        ListView{
            id: listView

            property var sett_pages: {
                "Использовать пароль": btn_password,
                        "Изменить пароль": btn_change_password,
                        "Темное оформление": btn_dark_theme,
                        "Сортировать по дате": btn_note_sort
            }

            property var handlers : {"Использовать пароль": function(){if(!ApplicationSettings.isBlock)handlers["Изменить пароль"](); else ApplicationSettings.setIsBlock(false)},
                "Изменить пароль": function(){var dialog = Qt.createComponent("qrc:/qml/pages/SetPasswordDialog.qml").createObject(); connectionDialogPass.target = dialog; stackView.push(dialog);},
                "Темное оформление": function(){ApplicationSettings.setIsDarkTheme(!ApplicationSettings.isDarkTheme)},
                "Сортировать по дате": function(){}
            }

            property var check: {"Использовать пароль": ApplicationSettings.isBlock,
                                 "Изменить пароль": ApplicationSettings.isBlock,
                                 "Темное оформление": ApplicationSettings.isDarkTheme,
                                 "Сортировать по дате": false
            }

            SettingsCheckComponent{id: btn_password}
            SettingsCheckComponent{id: btn_dark_theme}
            SettingsCheckComponent{id: btn_note_sort}
            SettingsButtonCompoment{id: btn_change_password}

            height: contentHeight
            width: parent.width

            section.criteria: ViewSection.FullString
            section.property: "type"
            section.delegate: Component{
                Rectangle{
                    width: parent.width
                    height: 40
                    color: "#2D395B"
                    Label{
                        anchors.fill: parent
                        text: section
                        font.pointSize: 15
                        color: ApplicationSettings.isDarkTheme ? "silver" : "white"
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 30
                    }
                }
            }

            boundsBehavior: Flickable.StopAtBounds

            model: ListModel{
                ListElement{text:"Использовать пароль"; type:"Пароль"}
                ListElement{text:"Изменить пароль"; type:"Пароль"}
                ListElement{text:"Темное оформление"; type:"Тема"}
                ListElement{text:"Сортировать по дате"; type: "Записи"}
            }

            delegate: Loader{
                id: loader
                width: listView.width

                property string delegateTitle: model.text
                property var delegateHandler: listView.handlers[model.text]
                property bool delegateCheck: listView.check[model.text]

                sourceComponent: listView.sett_pages[model.text]
            }
        }
    }
}
