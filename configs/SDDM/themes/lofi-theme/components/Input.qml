import QtQuick 2.12
import QtQuick.Controls 2.12

TextField {
    id: input
    
    background: Rectangle {
        implicitWidth: 280
        implicitHeight: 40
        color: Qt.rgba(68/255, 71/255, 90/255, 0.8)
        radius: 5
        border.width: input.activeFocus ? 2 : 1
        border.color: input.activeFocus ? "#bd93f9" : "#6272a4"
    }
    
    color: "#f8f8f2"
    selectionColor: "#bd93f9"
    selectedTextColor: "#f8f8f2"
    placeholderTextColor: "#6272a4"
    
    font.family: "Segoe UI"
    
    leftPadding: 12
    rightPadding: 12
}
