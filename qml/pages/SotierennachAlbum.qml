import QtQuick 2.0
import QtQuick 2.1
import Sailfish.Silica 1.0
import "../components"

Page {

    LabelText {
        anchors {
            left: parent.left
            margins: Theme.paddingLarge
        }
        label: qsTr("Ueberschrift")
        text: qsTr("Mein Name ist Sotiere nach Album")
        separator: true
    }



}
