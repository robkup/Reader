import QtQuick 2.0
import QtQuick 2.1
import Sailfish.Silica 1.0

Page {
    id: archive

    SilicaFlickable {
        id: scanPageFlickable
        anchors.fill: parent
        contentHeight: flickableColumn.height

        PullDownMenu {

            MenuItem {
                text: qsTr("Suche")
                onClicked: {
                    pageStack.push("Suche.qml");
                }
            }
            MenuItem {
                text: qsTr("Sotieren nach Interpret")
                onClicked: {
                    pageStack.push("SotierennachInterpret.qml");
                }
            }
            MenuItem {
                text: qsTr("Sotieren nach Album")
                onClicked: {
                    pageStack.push("SotierennachAlbum.qml");
                }

            }
        }


        SilicaListView {
            id: listView
            model: 20
            anchors.fill: parent
            header: PageHeader {
                title: "Übersicht"
            }
            delegate: BackgroundItem {
                id: delegate


                Label {
                    x: Theme.paddingLarge
                    text: "Item " + index
                    anchors.verticalCenter: parent.verticalCenter
                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                }
                onClicked: console.log("Clicked " + index)
            }
            VerticalScrollDecorator {}
        }
    }
}

