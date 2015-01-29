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
            text: qsTr("About CodeReader")
            onClicked: {
                pageStack.push("AboutPage.qml");
            }
        }
    }
}
}
