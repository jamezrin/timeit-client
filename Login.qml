import QtQuick 2.14
import QtQuick.Controls 2.5
import "Styles.js" as Styles

Page {
    id: loginPage
    width: 360
    height: 450
    title: qsTr("Inicio de Sesión")

    Component.onCompleted: {
        mainWindow.resizeTo(this)

        // If already logged in
        backend.js_fetchCurrentUser(function(res, err) {
            if (!err) stackView.push("ProjectList.qml");
        });
    }

    background: Rectangle {
        color: Styles._bgColor
    }

    property alias warningNoticeText: warningNoticeText

    Label {
        id: warningNoticeText
        width: 308
        height: 24
        color: Styles._redColor
        text: qsTr("Lorem ipsum dolor sit amet")
        anchors.top: parent.top
        anchors.topMargin: 151
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 275
        anchors.right: parent.right
        anchors.rightMargin: 26
        anchors.left: parent.left
        anchors.leftMargin: 26
        horizontalAlignment: Text.AlignHCenter
        Component.onCompleted: visible = false
    }

    TextField {
        id: emailTextField
        width: 308
        height: 50
        anchors.top: parent.top
        anchors.topMargin: 184
        anchors.right: parent.right
        anchors.rightMargin: 26
        anchors.left: parent.left
        anchors.leftMargin: 26
        placeholderText: qsTr("Correo electrónico")
        font.pointSize: 14
        selectByMouse: true
        selectionColor: Styles._lightBlueColor
        background: Rectangle {
            color: Styles._whiteColor
            border.width: parent.focus && 2
            border.color: parent.focus
                            ? Styles._blueColor
                            : Styles._whiteColor
            radius: 5
        }
    }

    TextField {
        id: passwordTextField
        y: 246
        width: 308
        height: 50
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 154
        anchors.right: parent.right
        anchors.rightMargin: 26
        anchors.left: parent.left
        anchors.leftMargin: 26
        placeholderText: qsTr("Contraseña")
        echoMode: TextField.Password
        font.pointSize: 14
        selectByMouse: true
        selectionColor: Styles._lightBlueColor
        background: Rectangle {
            color: Styles._whiteColor
            border.width: parent.focus && 2
            border.color: parent.focus
                            ? Styles._blueColor
                            : Styles._whiteColor
            radius: 5
        }
    }

    Button {
        id: loginButton
        width: 270
        height: 37
        text: qsTr("Iniciar sesión")
        display: AbstractButton.TextBesideIcon
        font.pixelSize: 20

        background: Rectangle {
            id: background
            color: Styles._blueColor
            radius: 10
        }

        contentItem: Text {
            text: parent.text
            font: parent.font
            color: Styles._darkestGrayColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        states: [
            State {
                name: "Hovering"
                PropertyChanges {
                    target: background
                    color: Styles._lightBlueColor
                }
            },
            State {
                name: "Pressed"
                PropertyChanges {
                    target: background
                    color: Styles._darkBlueColor
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

        onClicked: {
            backend.js_authenticateUser(emailTextField.text,
                                        passwordTextField.text,
                                        function(res, err) {
                if (err) {
                    if (err === "INVALID_CREDENTIALS") {
                        warningNoticeText.text = "Tu correo o contraseña son incorrectos";
                    } else if (err === "INACTIVE_ACCOUNT") {
                        warningNoticeText.text = "Tu cuenta todavía no ha sido confirmada";
                    } else {
                        warningNoticeText.text = "Error desconocido: " + err;
                    }

                    warningNoticeText.visible = true;
                } else {
                    warningNoticeText.visible = false;
                    stackView.push("ProjectList.qml");
                }
            });
        }

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 55
        anchors.top: parent.top
        anchors.topMargin: 338
        anchors.right: parent.right
        anchors.rightMargin: 52
        anchors.left: parent.left
        anchors.leftMargin: 52

        Text {
            id: websiteLink
            width: 292
            height: 10
            text: qsTr("Accede a otras operaciones a través del navegador")
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -25
            anchors.right: parent.right
            anchors.rightMargin: -25
            anchors.left: parent.left
            anchors.leftMargin: -25
            anchors.top: parent.top
            anchors.topMargin: 75
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 12

            MouseArea {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                anchors.leftMargin:  0
                anchors.rightMargin: 0
                anchors.bottomMargin: -10
                anchors.topMargin: -10
                anchors.fill: parent

                hoverEnabled: true
                onHoveredChanged: parent.font.underline = containsMouse
                onClicked: Qt.openUrlExternally(TIMEIT_FRONTEND_URL)
                cursorShape: Qt.PointingHandCursor
            }
        }
    }

    Image {
        id: appLogo
        width: 299
        height: 56
        anchors.bottom: mottoText.top
        anchors.bottomMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 30
        anchors.right: parent.right
        anchors.rightMargin: 26
        anchors.left: parent.left
        anchors.leftMargin: 26
        fillMode: Image.PreserveAspectFit
        source: "assets/logo/default-monochrome.svg"
    }

    Label {
        id: mottoText
        width: 308
        color: Styles._blueColor
        text: qsTr("Inicia sesión para empezar a controlar tu tiempo")
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 305
        verticalAlignment: Text.AlignTop
        wrapMode: Text.WordWrap
        font.pointSize: 12
        anchors.top: parent.top
        anchors.topMargin: 95
        anchors.right: parent.right
        anchors.rightMargin: 59
        anchors.left: parent.left
        anchors.leftMargin: 59
        horizontalAlignment: Text.AlignHCenter
    }
}

/*##^##
Designer {
    D{i:2;anchors_x:26;anchors_y:151}D{i:4;anchors_height:50;anchors_x:26;anchors_y:271}
D{i:3;anchors_height:50;anchors_x:26;anchors_y:183}D{i:5;anchors_height:50;anchors_x:26;anchors_y:245}
}
##^##*/
