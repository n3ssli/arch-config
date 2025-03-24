import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12

Rectangle {
    id: iconButton
    width: 40
    height: 40
    radius: 20
    color: mouseArea.containsMouse ? Qt.rgba(1, 1, 1, 0.2) : Qt.rgba(1, 1, 1, 0.1)
    
    property string icon: ""
    property string tooltipText: ""
    signal clicked()
    
    Image {
        id: iconImage
        anchors.centerIn: parent
        width: parent.width * 0.6
        height: parent.height * 0.6
        source: iconButton.icon
        
        ColorOverlay {
            anchors.fill: parent
            source: parent
            color: "#ffffff"
        }
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: iconButton.clicked()
        
        ToolTip {
            visible: mouseArea.containsMouse
            text: iconButton.tooltipText
            delay: 500
        }
    }
    
    Behavior on color {
        ColorAnimation { duration: 150 }
    }
}
