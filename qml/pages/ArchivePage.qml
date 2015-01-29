import QtQuick 2.0
import QtQuick 2.1
import Sailfish.Silica 1.0

Page {

SilicaFlickable {
    id: scanPageFlickable
    anchors.fill: parent
    contentHeight: flickableColumn.height

    PullDownMenu {
        id: menu
        MenuItem {
            text: qsTr("Suche")
            onClicked: {
                pageStack.push("AboutPage.qml");
            }
        }
        MenuItem {
            text: qsTr("Sotieren nach Interpret")
            onClicked: {
                pageStack.push("AboutPage.qml");
            }
        }
        MenuItem {
            text: qsTr("Sotieren nach Album")
            onClicked: {
                pageStack.push("AboutPage.qml");
            }
        }
    }
}
}
