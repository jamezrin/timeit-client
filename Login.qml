import QtQuick 2.14
import QtQuick.Controls 2.5
import QtQuick.Extras 1.4

Page {
    id: loginPage
    width: 360
    title: qsTr("Inicio de Sesión")
    height: 450

    background: Rectangle {
        color: _bgColor
    }

    TextField {
        id: emailTextField
        width: 308
        anchors.top: parent.top
        anchors.topMargin: 200
        anchors.right: parent.right
        anchors.rightMargin: 26
        anchors.left: parent.left
        anchors.leftMargin: 26
        anchors.bottom: passwordTextField.top
        anchors.bottomMargin: 21
        placeholderText: qsTr("Correo electrónico")
        font.pointSize: 14
        background: Rectangle {
            color: _whiteColor
            radius: 5
        }
    }

    TextField {
        id: passwordTextField
        width: 308
        anchors.top: parent.top
        anchors.topMargin: 271
        anchors.right: parent.right
        anchors.rightMargin: 26
        anchors.left: parent.left
        anchors.leftMargin: 26
        anchors.bottom: loginButton.top
        anchors.bottomMargin: 22
        font.pointSize: 14
        placeholderText: qsTr("Contraseña")
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
            color: "#123"
            radius: 10
        }

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50
        anchors.top: parent.top
        anchors.topMargin: 343
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
            anchors.bottomMargin: -26
            anchors.right: parent.right
            anchors.rightMargin: -25
            anchors.left: parent.left
            anchors.leftMargin: -25
            anchors.top: parent.top
            anchors.topMargin: 65
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 12

            MouseArea {
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.topMargin: 0
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
        verticalAlignment: Text.AlignTop
        wrapMode: Text.WordWrap
        font.pointSize: 12
        anchors.bottom: emailTextField.top
        anchors.bottomMargin: 54
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
    D{i:2;anchors_height:50;anchors_x:26;anchors_y:200}D{i:4;anchors_height:50;anchors_x:26;anchors_y:271}
}
##^##*/
