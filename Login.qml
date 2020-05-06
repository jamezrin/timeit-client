import QtQuick 2.14
import QtQuick.Controls 2.5

Page {
    id: loginPage
    width: 360
    title: qsTr("Inicio de Sesión")
    height: 450

    // https://chakra-ui.com/theme
    property string _textColor: "#A0AEC0"
    property string _bgColor: "#E2E8F0"
    property string _whiteColor: "#F7FAFC"
    property string _blueColor: "#63B3ED"
    property string _lightBlueColor: "#90CDF4"
    property string _darkBlueColor: "#4299E1"
    property string _redColor: "#E53E3E"

    background: Rectangle {
        color: _bgColor
    }

    Label {
        id: incorrectDetailsText
        width: 308
        height: 10
        color: _redColor
        text: qsTr("Tu correo o contraseña son incorrectos")
        anchors.bottom: emailTextField.top
        anchors.bottomMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 163
        anchors.left: parent.left
        anchors.leftMargin: 26
        anchors.right: parent.right
        anchors.rightMargin: 26
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
        background: Rectangle {
            color: _whiteColor
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
        background: Rectangle {
            color: _whiteColor
            radius: 5
        }
    }

    Button {
        id: loginButton
        width: 270
        height: 37
        text: qsTr("Iniciar sesión")
        font.pixelSize: 20

        background: Rectangle {
            id: background
            color: _blueColor
            radius: 10
        }

        states: [
            State {
                name: "Hovering"
                PropertyChanges {
                    target: background
                    color: _lightBlueColor
                }
            },
            State {
                name: "Pressed"
                PropertyChanges {
                    target: background
                    color: _darkBlueColor
                }
            }
        ]

        hoverEnabled: true
        HoverHandler {
            onHoveredChanged: {
                loginButton.state = hovered ? "Hovering" : ""
            }
        }

        onPressedChanged: {
            loginButton.state = pressed ? "Pressed" : (hovered ? "Hovering" :"")
        }

        onClicked: {
            if (true) {
                incorrectDetailsText.visible = true
            } else {

            }
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
                cursorShape: Qt.PointingHandCursor

                onHoveredChanged: {
                    parent.font.underline = containsMouse
                }

                onClicked: {
                    console.log("Hola")
                }
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
        source: "default-monochrome.svg"
    }

    Label {
        id: mottoText
        width: 308
        color: _blueColor
        text: qsTr("Inicia sesion para empezar a controlar tu tiempo")
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 305
        verticalAlignment: Text.AlignTop
        wrapMode: Text.WordWrap
        font.pointSize: 12
        anchors.top: parent.top
        anchors.topMargin: 95
        anchors.right: parent.right
        anchors.rightMargin: 62
        anchors.left: parent.left
        anchors.leftMargin: 62
        horizontalAlignment: Text.AlignHCenter
    }
}



/*##^##
Designer {
    D{i:4;anchors_height:50;anchors_x:26;anchors_y:271}D{i:3;anchors_height:50;anchors_x:26;anchors_y:183}
D{i:5;anchors_height:50;anchors_x:26;anchors_y:245}
}
##^##*/
