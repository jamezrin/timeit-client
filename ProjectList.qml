import QtQuick 2.14
import QtQuick.Controls 2.5

Page {
    id: loginPage
    width: 400
    height: 600
    title: qsTr("Hello World")
    background: Rectangle {
        color: _bgColor
    }

    Component.onCompleted: {
        mainWindow.resizeTo(this)

        // TODO: fetch projects
        for (var i = 0; i < 200; i++) {
            listView.model.append({projectId: i, projectName: `Proyecto ${i}`})
        }
    }

    property string _textColor: "#A0AEC0"
    property string _bgColor: "#E2E8F0"
    property string _whiteColor: "#F7FAFC"
    property string _blueColor: "#63B3ED"

    property int selectedProjectId: -1

    ListView {
        id: listView

        anchors.topMargin: 60
        anchors.rightMargin: 30
        anchors.bottomMargin: 80
        anchors.leftMargin: 30

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: button.top
        anchors.left: parent.left

        ScrollBar.vertical: ScrollBar {
            id: verticalScrollbar
        }

        clip: true
        Label {
            anchors.fill: parent
            text: qsTr("Todavía no eres miembro de un proyecto")
            wrapMode: Text.WrapAnywhere
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            visible: parent.count == 0
            font.bold: true
        }

        spacing: 10
        model: ListModel {}

        delegate: RadioDelegate {
            id: control
            text: projectName
            width: parent.width - (verticalScrollbar.width * 1.25)

            onCheckedChanged: selectedProjectId = projectId

            contentItem: Text {
                text: parent.text
                elide: Text.ElideRight

                leftPadding: control.indicator.width + 10
                verticalAlignment: Text.AlignVCenter

                opacity: enabled ? 1.0 : 0.3
                color: _textColor
            }

            hoverEnabled: true
            indicator: Rectangle {
                width: 20

                // Circle
                radius: 90
                height: width

                x: control.leftPadding
                y: parent.height / 2 - height / 2

                color: _bgColor

                Rectangle {
                    width: 12

                    // Circle
                    radius: 90
                    height: width

                    x: parent.width / 2 - width / 2
                    y: parent.height / 2 - height / 2

                    opacity: control.checked || 0.5
                    color: control.hovered || control.checked ? _blueColor : _whiteColor
                    visible: control.hovered || control.checked
                }
            }

            background: Rectangle {
                color: _whiteColor
                radius: 5

                border.width: control.checked && 2
                border.color: control.checked ? _blueColor : _whiteColor
            }
        }
    }

    Button {
        id: button
        text: qsTr("Button")
        anchors.top: parent.top
        anchors.topMargin: 542
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30
        anchors.right: parent.right
        anchors.rightMargin: 158
        anchors.left: parent.left
        anchors.leftMargin: 158
        onClicked: {
            console.log(selectedProjectId)
        }
    }

    Text {
        id: timeCounter
        x: 176
        y: 505
        width: 49
        height: 24
        text: qsTr("Text")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 18

        property real secondsElapsed: 0

        Timer {
            running: true
            repeat: true
            interval: 1000
            triggeredOnStart: true

            function z(number) {
                if (number < 10) {
                    return "0" + number;
                }

                return number;
            }

            onTriggered: {
                const hours = Math.floor(timeCounter.secondsElapsed / 3600);
                const minutes = Math.floor((timeCounter.secondsElapsed % 3600) / 60);
                const seconds = (timeCounter.secondsElapsed % 3600) % 60;
                timeCounter.text = `${z(hours)}:${z(minutes)}:${z(seconds)}`;
                timeCounter.secondsElapsed = timeCounter.secondsElapsed + 1;
            }
        }
    }
}
