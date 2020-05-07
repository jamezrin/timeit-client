import QtQuick 2.14
import QtQuick.Controls 2.5
import "Styles.js" as Styles

Page {
    id: sessionPage
    width: 400
    height: 600
    background: Rectangle {
        color: Styles._bgColor
    }

    Component.onCompleted: {
        mainWindow.resizeTo(this)

        // TODO: create new session and start timer
        timeCounter.start();
    }

    Text {
        id: timeCounterText
        width: 166
        height: 59
        text: qsTr("00:00:00")
        anchors.right: parent.right
        anchors.rightMargin: 28
        anchors.left: parent.left
        anchors.leftMargin: 256
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 551
        anchors.top: parent.top
        anchors.topMargin: 11
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 25

        property real secondsElapsed: 0

        Timer {
            id: timeCounter
            running: false
            triggeredOnStart: true
            repeat: true
            interval: 1000

            function z(number) {
                if (number < 10) {
                    return "0" + number;
                }

                return number;
            }

            onTriggered: {
                const hours = Math.floor(timeCounterText.secondsElapsed / 3600);
                const minutes = Math.floor((timeCounterText.secondsElapsed % 3600) / 60);
                const seconds = (timeCounterText.secondsElapsed % 3600) % 60;
                timeCounterText.text = `${z(hours)}:${z(minutes)}:${z(seconds)}`;
                timeCounterText.secondsElapsed = timeCounterText.secondsElapsed + 1;
            }
        }
    }

    Button {
        id: stopCounterButton
        text: qsTr("Detener contador")
        font.pointSize: 20
        anchors.top: parent.top
        anchors.topMargin: 519
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 19
        anchors.right: parent.right
        anchors.rightMargin: 46
        anchors.left: parent.left
        anchors.leftMargin: 46

        onClicked: {
            stackView.pop()
        }

        contentItem: Text {
            text: parent.text
            font: parent.font
            color: Styles._darkestGrayColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            id: background
            color: Styles._redColor
            radius: 10
        }

        states: [
            State {
                name: "Hovering"
                PropertyChanges {
                    target: background
                    color: Styles._lightRedColor
                }
            },
            State {
                name: "Pressed"
                PropertyChanges {
                    target: background
                    color: Styles._darkRedColor
                }
            }
        ]

        hoverEnabled: true
        HoverHandler {
            onHoveredChanged: {
                parent.state = hovered ? "Hovering" : ""
            }
        }

        onPressedChanged: {
            state = pressed ? "Pressed" : (hovered ? "Hovering" :"")
        }
    }

    Label {
        id: projectsPageTitleLabel
        width: 100
        color: Styles._blueColor
        text: qsTr("Sesión actual")
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 555
        font.pointSize: 16
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.right: parent.right
        anchors.rightMargin: 206
    }

    TextArea {
        id: noteTextArea
        width: 342
        height: 169
        anchors.right: parent.right
        anchors.rightMargin: 28
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: parent.top
        anchors.topMargin: 117
        placeholderText: qsTr("Lo siguiente en lo que voy a trabajar hoy es...")
        background: Rectangle {
            color: Styles._whiteColor
            radius: 6
        }
    }

    Label {
        id: noteTitleLabel
        text: qsTr("Notas sobre tu actividad actual")
        anchors.bottom: noteTextArea.top
        anchors.bottomMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 89
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.right: parent.right
        anchors.rightMargin: 298
        color: Styles._blueColor
    }

    Button {
        id: createNoteButton
        width: 70
        text: qsTr("Crear nota")
        anchors.bottom: noteTextArea.top
        anchors.bottomMargin: 6
        anchors.top: parent.top
        anchors.topMargin: 85
        anchors.left: parent.left
        anchors.leftMargin: 277
        anchors.right: parent.right
        anchors.rightMargin: 28
    }
}

/*##^##
Designer {
    D{i:2;anchors_x:200;anchors_y:15}D{i:13;anchors_x:30;anchors_y:117}D{i:15;anchors_x:30;anchors_y:89}
D{i:16;anchors_height:26;anchors_x:302;anchors_y:89}
}
##^##*/
