import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

Window {
    id: mainWindow
    visible: true
    width: 900
    height: 600
    flags: Qt.FramelessWindowHint | Qt.Window
    color: "#fdf6e3"

    readonly property color base3: "#fdf6e3"
    readonly property color base2: "#eee8d5"
    readonly property color base1: "#93a1a1"
    readonly property color base01: "#586e75"
    readonly property color blue: "#268bd2"
    property int currentFontSize: 16

    Component.onCompleted: {
        var args = Qt.application.arguments;
        if (args.length >= 3)
            editor.text = args[args.length - 1];
    }

    Row {
        anchors.fill: parent

        // 1. ПАНЕЛЬ ПЕРЕТАСКИВАНИЯ (Светло-серый)
        Rectangle {
            id: dragHandle
            width: 40
            height: parent.height
            color: "#e0e0e0" // Подсветка панели

            Column {
                anchors.centerIn: parent
                spacing: 8
                Repeater {
                    model: 12
                    Rectangle { width: 4; height: 4; radius: 2; color: base1 }
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.SizeAllCursor
                onPressed: mainWindow.startSystemMove()
            }
        }

        // 2. КОНТЕЙНЕР РЕДАКТОРА (Розовый)
        Rectangle {
            id: editorContainer
            width: parent.width - dragHandle.width
            height: parent.height
            color: "#ffe0f0" // Видим всю область справа от панели

            ScrollView {
                id: scrollView
                anchors.fill: parent
                anchors.margins: 25
                clip: true
                
                // ФОН SCROLLVIEW (Светло-синий)
                background: Rectangle { color: "#e0f0ff" }

                TextEdit {
                    id: editor
                    width: scrollView.availableWidth
                    focus: true
                    selectByMouse: true
                    wrapMode: TextEdit.Wrap
                    font.family: "Fira Code"
                    font.pixelSize: currentFontSize
                    color: base01
                    
                    // ФОН САМОГО ТЕКСТА (Желтоватый)
                    // Поможет увидеть, куда растягивается текст
                    Rectangle {
                        anchors.fill: parent
                        color: "#ffffd0"
                        z: -1 // Чтобы цвет был под текстом
                    }

                    WheelHandler {
                        acceptedModifiers: Qt.ControlModifier
                        onWheel: (event) => {
                            if (event.angleDelta.y > 0 && currentFontSize < 70) currentFontSize += 2;
                            else if (event.angleDelta.y < 0 && currentFontSize > 6) currentFontSize -= 2;
                        }
                    }
                }
            }
        }
    }

    // Горячие клавиши (без изменений)
    Shortcut { sequence: "Escape"; onActivated: Qt.quit() }
    Shortcut { sequences: ["Ctrl+Plus", "Ctrl+="]; onActivated: if (currentFontSize < 70) currentFontSize += 2 }
    Shortcut { sequence: "Ctrl+-"; onActivated: if (currentFontSize > 6) currentFontSize -= 2 }
    Shortcut { sequence: "Ctrl+0"; onActivated: currentFontSize = 16 }
}