import QtQuick 2.0
import QtQuick 2.1
import Sailfish.Silica 1.0
import "../components"

Page {
    id: archive

    SilicaFlickable {
        id: scanPageFlickable
        anchors.fill: parent
        contentHeight: flickableColumn.height

        PullDownMenu {


            MenuItem {
                text: qsTr("list")
                onClicked: {
                    cddatabase.clearSql()
                    cddatabase.insertSql({"artist": "tote hosen", "album":"reich und sexy", "year":1999, "code": 4321987})
                    cddatabase.insertSql({"artist": "benjamin blümchen", "album":"Elefant", "year":1985, "code": 53874123})
                    cddatabase.insertSql({"artist": "Bibi Blocksberg", "album":"Besen fliegen leicht gemacht", "year":2010, "code": 0815349})
                    listView.visible = true
                }
            }
            MenuItem {
                text: qsTr("clear all")
                onClicked: {
                     listView.visible = false
                }
            }

        }

        SqLiteModel{
            id: cddatabase

            databaseName: "cddatabase"
            tableName: "CDtable"
            selectStatement: ""
            createStatement: "CREATE TABLE if not exists CDtable (artist text, album text, year int, code int); "

        }


        SilicaListView {
            id: listView
            model: cddatabase
            visible: false
            anchors.fill: parent
            header: PageHeader {
                title: "Übersicht"
            }
            delegate: BackgroundItem {
                id: delegate


                Label {
                    x: Theme.paddingLarge
                    text: artist +" - "+album +" - "+year +" - "+ code
                    anchors.verticalCenter: parent.verticalCenter
                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                }

                onClicked: console.log("Clicked " + index)
            }
            VerticalScrollDecorator {}
        }
    }
}

