import QtQuick 2.14
import QtQuick.Controls 2.5
import "Styles.js" as Styles

Page {
    id: projectListPage
    width: 400
    height: 600
    background: Rectangle {
        color: Styles._bgColor
    }

    function updateProjectList() {
        backend.js_fetchProjectList(function(res, err) {
            if (!err) {
                const projects = JSON.parse(res);

                listView.model.clear();
                selectedProjectId = -1;
                for (const project of projects) {
                    listView.model.append({
                        projectName: project.name || "Proyecto sin nombre",
                        projectId: project.id
                    });
                }
            } else {
                console.log('Unexpected error occurred:', err);
            }
        });
    }

    Component.onCompleted: {
        mainWindow.resizeTo(this);
        updateProjectList();
    }

    property int selectedProjectId: -1

    ListView {
        id: listView

        anchors.topMargin: 60
        anchors.rightMargin: 30
        anchors.bottomMargin: 19
        anchors.leftMargin: 30

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: startCounterButton.top
        anchors.left: parent.left

        ScrollBar.vertical: ScrollBar {
            id: verticalScrollbar
        }

        clip: true
        Label {
            anchors.fill: parent
            text: qsTr("Todavía no eres miembro de un proyecto")
            anchors.bottomMargin: 0
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

            onCheckedChanged: selectedProjectId = projectId;

            contentItem: Text {
                text: parent.text
                elide: Text.ElideRight

                leftPadding: control.indicator.width + 10
                verticalAlignment: Text.AlignVCenter

                opacity: enabled ? 1.0 : 0.3
                color: Styles._textColor
            }

            hoverEnabled: true
            indicator: Rectangle {
                width: 20

                // Circle
                radius: 90
                height: width

                x: control.leftPadding
                y: parent.height / 2 - height / 2

                color: Styles._bgColor

                Rectangle {
                    width: 12

                    // Circle
                    radius: 90
                    height: width

                    x: parent.width / 2 - width / 2
                    y: parent.height / 2 - height / 2

                    opacity: control.checked || 0.5
                    color: control.hovered || control.checked ? Styles._blueColor : Styles._whiteColor
                    visible: control.hovered || control.checked
                }
            }

            background: Rectangle {
                color: Styles._whiteColor
                radius: 5

                border.width: control.checked && 2
                border.color: control.checked ? Styles._blueColor : Styles._whiteColor
            }
        }
    }

    Button {
        id: startCounterButton
        text: qsTr("Iniciar contador")
        font.pointSize: 20
        anchors.top: parent.top
        anchors.topMargin: 519
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 19
        anchors.right: parent.right
        anchors.rightMargin: 46
        anchors.left: parent.left
        anchors.leftMargin: 46
        enabled: selectedProjectId != -1

        onClicked: {
            backend.js_createSession(selectedProjectId, function(res, err) {
                if (!err) {
                    const session = JSON.parse(res);
                    stackView.push("Session.qml", {
                        sessionId: session.id
                    });
                } else {
                    console.log('Unexpected error occurred:', err);
                }
            });
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
            color: enabled ? Styles._greenColor : Styles._textColor
            radius: 10
        }

        states: [
            State {
                name: "Hovering"
                PropertyChanges {
                    target: background
                    color: Styles._lightGreenColor
                }
            },
            State {
                name: "Pressed"
                PropertyChanges {
                    target: background
                    color: Styles._darkGreenColor
                }
            }
        ]

        hoverEnabled: true
        HoverHandler {
            onHoveredChanged: parent.state = hovered ? "Hovering" : "";
        }

        onPressedChanged: state = pressed ? "Pressed" : (hovered ? "Hovering" :"");
    }

    Label {
        id: projectsPageTitleLabel
        width: 100
        color: Styles._blueColor
        text: qsTr("Proyectos")
        font.pointSize: 16
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.bottom: listView.top
        anchors.bottomMargin: 14
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.right: parent.right
        anchors.rightMargin: 206
    }

    Image {
        id: image
        width: 34
        height: 36
        anchors.top: parent.top
        anchors.topMargin: 23
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 552
        anchors.left: parent.left
        anchors.leftMargin: 325
        anchors.right: parent.right
        anchors.rightMargin: 48
        source: "assets/icons/logout.svg"
        fillMode: Image.PreserveAspectFit

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                backend.js_deauthenticateUser(function (res, err) {
                    if (!err) {
                        stackView.pop();
                        mainWindow.resizeTo(stackView.currentItem);
                    } else {
                        console.log('Unexpected error occurred:', err);
                    }
                });
            }
        }
    }

    Image {
        id: image1
        width: 27
        height: 27
        anchors.top: parent.top
        anchors.topMargin: 21
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 552
        anchors.left: parent.left
        anchors.leftMargin: 290
        anchors.right: image.left
        anchors.rightMargin: 10
        source: "assets/icons/globe-grid.svg"
        fillMode: Image.PreserveAspectFit

        MouseArea {
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.top: parent.top
            cursorShape: Qt.PointingHandCursor
            onClicked: Qt.openUrlExternally(TIMEIT_FRONTEND_URL);
        }
    }

    Image {
        id: image2
        width: 27
        height: 27
        anchors.top: parent.top
        anchors.topMargin: 21
        anchors.right: image1.left
        anchors.rightMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 252
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 552
        source: "assets/icons/refresh.svg"
        fillMode: Image.PreserveAspectFit

        MouseArea {
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.top: parent.top
            cursorShape: Qt.PointingHandCursor
            onClicked: updateProjectList();
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:3}D{i:15;anchors_x:290;anchors_y:21}D{i:14;anchors_x:336;anchors_y:18}
D{i:13;anchors_height:33;anchors_width:97;anchors_x:30;anchors_y:21}D{i:19;anchors_height:33;anchors_width:97;anchors_x:30;anchors_y:21}
D{i:21;anchors_x:290;anchors_y:21}D{i:20;anchors_x:336;anchors_y:18}D{i:22;anchors_x:290;anchors_y:21}
D{i:24;anchors_x:290;anchors_y:21}
}
##^##*/
