import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {
    id: root
    width: 1920
    height: 1080
    
    property string backgroundColor: "#282a36"
    property string accentColor: "#bd93f9"
    property string textColor: "#f8f8f2"
    property string inputFont: "monospace"  // Monospace font property
    
    // Use the custom Background component instead of a simple Image
    Background {
        id: background
        anchors.fill: parent
        imagePath: "assets/background.jpg"
        enableRainEffect: true
        enableVinylEffect: false  // Disable vinyl effect
        overlayOpacity: 0.3
        blurBackground: true      // Enable background blur
        blurRadius: 30            // Set blur intensity
    }
    
    // Clock display that floats on the top right - now with monospace font
    Item {
        anchors {
            top: parent.top
            right: parent.right
            margins: 40
        }
        
        Text {
            id: timeText
            anchors.right: parent.right
            text: Qt.formatDateTime(new Date(), "hh:mm")
            color: root.textColor
            font.pixelSize: 64
            font.weight: Font.Light
            font.family: root.inputFont  // Changed to monospace
            
            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: {
                    timeText.text = Qt.formatDateTime(new Date(), "hh:mm")
                    dateText.text = Qt.formatDateTime(new Date(), "dddd, MMMM d")
                }
            }
        }
        
        Text {
            id: dateText
            anchors.right: parent.right
            anchors.top: timeText.bottom
            anchors.topMargin: 5
            text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
            color: root.textColor
            font.pixelSize: 18
            font.family: root.inputFont  // Changed to monospace
            opacity: 0.8
        }
    }
    
    // Lofi-themed quote
    Text {
        id: quoteText
        anchors {
            left: parent.left
            bottom: parent.bottom
            margins: 40
        }
        text: "\"take a breath, slow down\""
        color: root.textColor
        font.pixelSize: 24
        font.family: "Segoe UI"
        font.italic: true
        opacity: 0.7
    }
    
    // Main login card
    Rectangle {
        id: loginCardBlur
        width: 420
        height: 520
        radius: 15
        color: Qt.rgba(0, 0, 0, 0.4)
        anchors.centerIn: parent
        
        Rectangle {
            id: loginCard
            width: 400
            height: 500
            radius: 15
            color: Qt.rgba(40/255, 42/255, 54/255, 0.75)
            anchors.centerIn: parent
            border.width: 1
            border.color: root.accentColor
            
            Rectangle {
                anchors.fill: parent
                radius: 15
                color: "transparent"
                border.width: 1
                border.color: Qt.rgba(1, 1, 1, 0.1)
                
                Column {
                    anchors.fill: parent
                    anchors.margins: 30
                    spacing: 20
                    
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "welcome back"
                        color: root.textColor
                        font.pixelSize: 24
                        font.family: "Segoe UI"
                        font.weight: Font.Light
                    }
                    
                    Image {
                        id: avatarImage
                        source: userModel.lastUser ? "file:///var/lib/AccountsService/icons/" + userModel.lastUser : "assets/avatar.png"
                        width: 120
                        height: 120
                        anchors.horizontalCenter: parent.horizontalCenter
                        fillMode: Image.PreserveAspectCrop
                        
                        Rectangle {
                            id: mask
                            anchors.fill: parent
                            radius: width / 2
                            visible: false
                        }
                        
                        Rectangle {
                            anchors.fill: parent
                            radius: width / 2
                            border.width: 2
                            border.color: "#ffffff"
                            color: "transparent"
                        }
                    }
                    
                    Item { height: 20; width: 1 } // Spacer
                    
                    Column {
                        width: parent.width
                        spacing: 12
                        
                        TextField {
                            id: usernameField
                            width: parent.width
                            height: 40
                            placeholderText: "Username"
                            text: userModel.lastUser
                            color: root.textColor
                            font.family: root.inputFont
                            font.pixelSize: 14
                            
                            background: Rectangle {
                                radius: 5
                                color: Qt.rgba(68/255, 71/255, 90/255, 0.8)
                                border.width: 1
                                border.color: parent.focus ? root.accentColor : "#6272a4"
                            }
                        }
                        
                        TextField {
                            id: passwordField
                            width: parent.width
                            height: 40
                            placeholderText: "Password"
                            echoMode: TextInput.Password
                            color: root.textColor
                            font.family: root.inputFont
                            font.pixelSize: 14
                            
                            background: Rectangle {
                                radius: 5
                                color: Qt.rgba(68/255, 71/255, 90/255, 0.8)
                                border.width: 1
                                border.color: parent.focus ? root.accentColor : "#6272a4"
                            }
                            
                            Keys.onReturnPressed: {
                                loginRequest()
                            }
                        }
                        
                        Button {
                            width: parent.width
                            height: 40
                            text: "Login"
                            
                            contentItem: Text {
                                text: parent.text
                                color: root.textColor
                                font.pixelSize: 14
                                font.family: root.inputFont
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            background: Rectangle {
                                radius: 5
                                color: parent.down ? "#6272a4" : "#bd93f9"
                            }
                            
                            onClicked: {
                                loginRequest()
                            }
                        }
                        
                        ComboBox {
                            id: sessionSelector
                            width: parent.width
                            height: 40
                            model: sessionModel
                            currentIndex: sessionModel.lastIndex
                            textRole: "name"
                            
                            delegate: ItemDelegate {
                                width: sessionSelector.width
                                height: 36
                                
                                contentItem: Text {
                                    text: model.name
                                    color: "#f8f8f2"
                                    font.family: root.inputFont
                                    font.pixelSize: 14
                                    elide: Text.ElideRight
                                    verticalAlignment: Text.AlignVCenter
                                    leftPadding: 12
                                }
                                
                                background: Rectangle {
                                    color: highlighted ? "#44475a" : "#282a36"
                                }
                                
                                highlighted: sessionSelector.highlightedIndex === index
                            }
                            
                            indicator: Canvas {
                                id: canvas
                                x: sessionSelector.width - width - 10
                                y: sessionSelector.height / 2 - height / 2
                                width: 12
                                height: 8
                                contextType: "2d"
                                
                                onPaint: {
                                    context.reset();
                                    context.moveTo(0, 0);
                                    context.lineTo(width, 0);
                                    context.lineTo(width / 2, height);
                                    context.closePath();
                                    context.fillStyle = "#bd93f9";
                                    context.fill();
                                }
                            }
                            
                            contentItem: Text {
                                leftPadding: 12
                                rightPadding: sessionSelector.indicator.width + 12
                                text: sessionSelector.displayText
                                font.pixelSize: 14
                                font.family: root.inputFont
                                color: root.textColor
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            background: Rectangle {
                                implicitWidth: 280
                                implicitHeight: 40
                                color: Qt.rgba(68/255, 71/255, 90/255, 0.8)
                                radius: 5
                                border.width: 1
                                border.color: "#6272a4"
                            }
                            
                            popup: Popup {
                                y: sessionSelector.height
                                width: sessionSelector.width
                                implicitHeight: Math.min(contentItem.implicitHeight, 200)
                                padding: 1
                                
                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: sessionSelector.popup.visible ? sessionSelector.delegateModel : null
                                    currentIndex: sessionSelector.highlightedIndex
                                    
                                    ScrollIndicator.vertical: ScrollIndicator { }
                                }
                                
                                background: Rectangle {
                                    color: "#282a36"
                                    border.color: "#bd93f9"
                                    border.width: 1
                                    radius: 5
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    function loginRequest() {
        console.log("Login requested for: " + usernameField.text)
        sddm.login(usernameField.text, passwordField.text, sessionSelector.currentIndex)
    }
    
    // Power buttons at the bottom right
    Row {
        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: 20
        }
        spacing: 15
        
        // Restart button
        Rectangle {
            width: 36
            height: 36
            radius: 18
            color: restartMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.2) : Qt.rgba(1, 1, 1, 0.1)
            
            Text {
                anchors.centerIn: parent
                text: "⟳"
                color: "#ffffff"
                font.pixelSize: 20
            }
            
            MouseArea {
                id: restartMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: sddm.reboot()
            }
        }
        
        // Shutdown button
        Rectangle {
            width: 36
            height: 36
            radius: 18
            color: shutdownMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.2) : Qt.rgba(1, 1, 1, 0.1)
            
            Text {
                anchors.centerIn: parent
                text: "⏻"
                color: "#ffffff"
                font.pixelSize: 20
            }
            
            MouseArea {
                id: shutdownMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: sddm.powerOff()
            }
        }
        
        // Sleep button
        Rectangle {
            width: 36
            height: 36
            radius: 18
            color: suspendMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.2) : Qt.rgba(1, 1, 1, 0.1)
            
            Text {
                anchors.centerIn: parent
                text: "⏾"
                color: "#ffffff"
                font.pixelSize: 20
            }
            
            MouseArea {
                id: suspendMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: sddm.suspend()
            }
        }
    }
}
