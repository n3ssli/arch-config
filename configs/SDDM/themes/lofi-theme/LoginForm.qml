import QtQuick 2.12
import QtQuick.Controls 2.12
import "components"

Column {
    id: loginForm
    width: parent.width
    spacing: 16
    
    Input {
        id: usernameInput
        width: parent.width
        placeholderText: "username"
        text: userModel.lastUser
        font.pixelSize: 16
    }
    
    Input {
        id: passwordInput
        width: parent.width
        placeholderText: "password"
        echoMode: TextInput.Password
        font.pixelSize: 16
        
        Keys.onReturnPressed: {
            sddm.login(usernameInput.text, passwordInput.text, sessionModel.currentIndex)
        }
    }
    
    Button {
        text: "login"
        width: parent.width
        onClicked: sddm.login(usernameInput.text, passwordInput.text, sessionModel.currentIndex)
    }
}
