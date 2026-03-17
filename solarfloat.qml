import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

Window {
    id: mainWindow

    readonly property color base3: "#fdf6e3"
    readonly property color base2: "#eee8d5"
    readonly property color base1: "#93a1a1"
    readonly property color base01: "#586e75"
    readonly property color blue: "#268bd2"
    property int currentFontSize: 16

    visible: true
    width: 900
    height: 600
    flags: Qt.FramelessWindowHint | Qt.Window
    color: "#fdf6e3"
    // Логика получения текста из аргументов командной строки
    Component.onCompleted: {
        var args = Qt.application.arguments;
        // В режиме 'qml' аргумент после '--' обычно идет под индексом 2 или 3
        if (args.length >= 3)
            editor.text = args[args.length - 1];

    }

    Row {
        anchors.fill: parent

        // --- 1. ПАНЕЛЬ ДЛЯ ПЕРЕТАСКИВАНИЯ ---
        Rectangle {
            id: dragHandle

            width: 40
            height: parent.height
            color: base2

            Column {
                anchors.centerIn: parent
                spacing: 8

                Repeater {
                    model: 12

                    Rectangle {
                        width: 4
                        height: 4
                        radius: 2
                        color: base1
                    }

                }

            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.SizeAllCursor
                onPressed: {
                    mainWindow.startSystemMove();
                }
            }

        }

        // --- 2. ОБЛАСТЬ РЕДАКТОРА ---
        Rectangle {
            id: editorContainer

            width: parent.width - dragHandle.width
            height: parent.height
            color: "transparent"

            ScrollView {
                id: scrollView

                anchors.fill: parent
                anchors.margins: 25
                clip: true

                TextEdit {
                    // Перенос по словам

                    id: editor

                    // ВАЖНО: привязываем ширину к ScrollView для корректного Wrap
                    width: scrollView.availableWidth
                    focus: true
                    selectByMouse: true
                    // --- WORD WRAP ---
                    wrapMode: TextEdit.Wrap
                    font.family: "Fira Code"
                    font.pixelSize: currentFontSize
                    font.weight: Font.DemiBold
                    color: base01
                    selectionColor: blue
                    selectedTextColor: base3
                    text: "Если ты видишь этот текст, значит аргументы не передались."

                    WheelHandler {
                        // Логика масштабирования будет добавлена на следующем шаге

                        acceptedModifiers: Qt.ControlModifier
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.NoButton
                        cursorShape: Qt.IBeamCursor
                    }

                    cursorDelegate: Rectangle {
                        width: 2
                        height: editor.cursorRectangle.height
                        color: "#2aa198"

                        SequentialAnimation on opacity {
                            loops: Animation.Infinite

                            NumberAnimation {
                                from: 1
                                to: 0
                                duration: 500
                            }

                            NumberAnimation {
                                from: 0
                                to: 1
                                duration: 500
                            }

                        }

                    }

                }

                // Чтобы текст не уезжал под скроллбар
                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AlwaysOn

                    contentItem: Rectangle {
                        implicitWidth: 6
                        radius: 3
                        color: base1
                    }

                }

            }

        }

    }

    // Горячие клавиши
    Shortcut {
        sequence: "Escape"
        onActivated: Qt.quit()
    }

    Shortcut {
        sequences: ["Ctrl+Plus", "Ctrl+="]
        onActivated: {
            if (currentFontSize < 70)
                currentFontSize += 2;

        }
    }

    Shortcut {
        sequence: "Ctrl+-"
        onActivated: {
            if (currentFontSize > 6)
                currentFontSize -= 2;

        }
    }

    Shortcut {
        sequence: "Ctrl+0"
        onActivated: currentFontSize = 16
    }

}
