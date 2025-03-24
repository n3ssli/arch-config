import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: background
    anchors.fill: parent
    
    // Properties for customization
    property string imagePath: "assets/background.jpg"
    property bool enableRainEffect: true
    property bool enableVinylEffect: false  // Disabled by default now
    property real overlayOpacity: 0.4
    property bool blurBackground: true      // New property to enable blur
    property int blurRadius: 30             // Blur intensity
    
    // Main background image
    Image {
        id: backgroundImage
        anchors.fill: parent
        source: background.imagePath
        fillMode: Image.PreserveAspectCrop
        
        // Apply blur if enabled (without requiring QtGraphicalEffects)
        layer.enabled: background.blurBackground
        layer.effect: ShaderEffect {
            property variant source: backgroundImage
            property real radius: background.blurRadius
            
            fragmentShader: "
                varying highp vec2 qt_TexCoord0;
                uniform sampler2D source;
                uniform lowp float radius;
                uniform lowp float qt_Opacity;
                
                void main() {
                    lowp vec4 sum = vec4(0.0);
                    
                    // Simple radial blur approximation
                    sum += texture2D(source, qt_TexCoord0 - 0.008 * radius) * 0.1;
                    sum += texture2D(source, qt_TexCoord0 - 0.005 * radius) * 0.2;
                    sum += texture2D(source, qt_TexCoord0) * 0.4;
                    sum += texture2D(source, qt_TexCoord0 + 0.005 * radius) * 0.2;
                    sum += texture2D(source, qt_TexCoord0 + 0.008 * radius) * 0.1;
                    
                    gl_FragColor = sum * qt_Opacity;
                }
            "
        }
        
        // Subtle zoom animation for a "living" feel
        NumberAnimation on scale {
            from: 1.00
            to: 1.03
            duration: 100000
            easing.type: Easing.InOutSine
            loops: Animation.Infinite
            running: true
            alwaysRunToEnd: true
        }
    }
    
    // Color grading effect - gives the lofi warm/cool tint
    Rectangle {
        id: colorGrading
        anchors.fill: backgroundImage
        color: "#3a2b4a"  // Slight purple hue
        opacity: 0.2
    }
    
    // Film grain effect
    ShaderEffect {
        id: filmGrain
        anchors.fill: parent
        property real time: 0
        
        NumberAnimation on time {
            from: 0
            to: 100
            duration: 10000
            loops: Animation.Infinite
            running: true
        }
        
        fragmentShader: "
            varying highp vec2 qt_TexCoord0;
            uniform highp float time;
            uniform sampler2D source;
            
            highp float rand(vec2 co) {
                return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
            }
            
            void main() {
                highp vec2 coord = qt_TexCoord0;
                highp vec4 texColor = vec4(0, 0, 0, 1);
                highp float noise = rand(coord * time * 0.01) * 0.1;
                gl_FragColor = vec4(noise, noise, noise, 0.06);
            }
        "
    }
    
    // Vinyl record effect (creates subtle circular noise in corner)
    Item {
        id: vinylEffect
        visible: background.enableVinylEffect  // This will be false based on property
        width: parent.width * 0.2
        height: width
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 40
        opacity: 0.2
    }
    
    // Rain effect
    Item {
        id: rainContainer
        anchors.fill: parent
        visible: background.enableRainEffect
        
        // This component creates a single raindrop
        Component {
            id: raindrop
            
            Rectangle {
                id: drop
                width: Math.random() * 1.5 + 0.5
                height: Math.random() * 15 + 10
                radius: width / 2
                opacity: Math.random() * 0.4 + 0.2
                color: "#c4e0f9"
                
                property real speedFactor: Math.random() * 1.5 + 0.5
                
                x: Math.random() * parent.width
                y: -height
                
                NumberAnimation on y {
                    from: -drop.height
                    to: background.height + drop.height
                    duration: 2000 / drop.speedFactor
                    loops: Animation.Infinite
                    running: true
                }
                
                transform: Rotation {
                    origin.x: drop.width / 2
                    origin.y: drop.height / 2
                    angle: 10
                }
            }
        }
        
        // Create many raindrops
        Timer {
            interval: 100
            running: background.enableRainEffect
            repeat: true
            onTriggered: {
                // Limit the number of raindrops to prevent performance issues
                if (rainContainer.children.length < 100) {
                    var drop = raindrop.createObject(rainContainer);
                }
            }
        }
    }
    
    // Final overlay for mood
    Rectangle {
        id: overlay
        anchors.fill: parent
        color: "#000000"
        opacity: background.overlayOpacity
        
        // Gradient overlay for vignette effect
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.5) }
            GradientStop { position: 0.5; color: Qt.rgba(0, 0, 0, 0.1) }
            GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.5) }
        }
    }
}
