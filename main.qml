import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Shapes 1.14
import QtQuick.Controls 2.13
import QtQuick.Dialogs 1.2

Window {
    id: mainWindow
    visible: true

    property string _textColor: "#A0AEC0"
    property string _bgColor: "#E2E8F0"
    property string _whiteColor: "#F7FAFC"
    property string _blueColor: "#63B3ED"

    height: 450
    width: 360

    minimumHeight: height
    maximumHeight: height
    minimumWidth: width
    maximumWidth: width

    title: qsTr("Cliente de TimeIt")

    property alias stackView: stackView

    StackView {
        id: stackView
        initialItem: "Login.qml"
        anchors.fill: parent
    }
}




