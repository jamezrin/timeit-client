import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Shapes 1.14
import QtQuick.Controls 2.13
import QtQuick.Dialogs 1.2

Window {
    id: mainWindow
    visible: true

    function resizeTo(object) {
        minimumHeight = object.height
        minimumWidth = object.width

        // disable window resize
        maximumHeight = object.height
        maximumWidth = object.width
    }

    title: qsTr("Cliente de TimeIt")

    property alias stackView: stackView

    StackView {
        id: stackView
        initialItem: "Login.qml"
        anchors.fill: parent
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
