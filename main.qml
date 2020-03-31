import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Shapes 1.14
import QtQuick.Controls 2.13
import QtQuick.Dialogs 1.2

Window {
    id: window
    visible: true
    height: 700
    color: "#00000000"
    width: 500

    minimumHeight: height
    maximumHeight: height
    minimumWidth: width
    maximumWidth: width

    title: qsTr("Prueba 3 Botones")

    Rectangle {
        id: rectangle
        color: "#ffffff"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 552
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
    }

    Rectangle {
        id: rectangle1
        color: "#ffffff"
        anchors.right: parent.right
        anchors.rightMargin: 355
        anchors.bottom: rectangle3.top
        anchors.bottomMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: rectangle.bottom
        anchors.topMargin: 0
    }

    Rectangle {
        id: rectangle2
        y: 148
        color: "#ffffff"
        anchors.bottom: rectangle3.top
        anchors.bottomMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 355
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.top: rectangle.bottom
        anchors.topMargin: 0
    }

    Rectangle {
        id: rectangle3
        width: 500
        color: "#ffffff"
        anchors.top: parent.top
        anchors.topMargin: 418
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0

        Button {
            id: button
            width: 177
            height: 98
            text: qsTr("Hacer algo")
            font.pointSize: 20
            anchors.right: parent.right
            anchors.rightMargin: 162
            anchors.left: parent.left
            anchors.leftMargin: 162
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 92
            anchors.top: parent.top
            anchors.topMargin: 92
        }
    }
}



/*##^##
Designer {
    D{i:1;anchors_height:148;anchors_width:500;anchors_x:0;anchors_y:0}D{i:2;anchors_height:271;anchors_width:145;anchors_x:0;anchors_y:154}
D{i:3;anchors_height:271;anchors_width:145;anchors_x:355;anchors_y:154}D{i:5;anchors_x:150;anchors_y:108}
D{i:4;anchors_height:282;anchors_width:500;anchors_x:0;anchors_y:418}
}
##^##*/
