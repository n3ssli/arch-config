import QtQuick 2.12
import QtQuick.Controls 2.12

Button {
    id: control
    
    contentItem: Text {
        text: control.text
        font.pixelSize: 16
        font.family: "Segoe UI"
        color: "#f8f8f2"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    
    background: Rectangle {
        implicitWidth: 280
        implicitHeight: 40
        opacity: control.down ? 0.7 : 1.0
        color: control.down ? "#6272a4" : "#bd93f9"
        radius: 5
        
        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }
}
