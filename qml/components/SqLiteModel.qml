//SqLiteModel
//Copyright (C) 2015 Timo Zimmermann
//
//This program is free software: you can redistribute it and/or modify
//it under the terms of the GNU General Public License as published by
//the Free Software Foundation, either version 3 of the License, or
//(at your option) any later version.
//This program is distributed in the hope that it will be useful,
//but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//GNU General Public License for more details.
//You should have received a copy of the GNU General Public License
//along with this program. If not, see <http://www.gnu.org/licenses/>.

import QtQuick 2.0
import QtQuick.LocalStorage 2.0

ListModel {
    id: root

    property string databaseName: ""
    property string databaseVersion: "1.0"
    property string tableName: ""
    property string primaryKeyName: "rowid"
    property string selectStatement: ""
    property string createStatement: "" //CREATE TABLE Persons
                                        //(
                                        //PersonID int,
                                        //LastName varchar(255),
                                        //FirstName varchar(255),
                                        //Address varchar(255),
                                        //City varchar(255)
                                        //);

    property var db: LocalStorage.openDatabaseSync(root.databaseName, root.databaseVersion);

    function load() {
        var selectStatement = root.selectStatement.length === 0 ? ("SELECT rowid,* FROM " + tableName) : root.selectStatement;

        db.transaction(
            function(tx) {
                if(createStatement.length > 0) tx.executeSql(root.createStatement);
                var rs = tx.executeSql(selectStatement);

                root.clear();
                for(var i = 0; i < rs.rows.length; i++) {
                    var entry = rs.rows.item(i);
                    root.append(entry);
                }
            }
        )
    }

    function findSql(primaryKey) {
        //Suche in allen Elementen nach dem PrimaryKey
        for(var i = 0; i < root.count; i++) {
            var modelEntry = root.get(i);
            if(modelEntry[root.primaryKeyName] === primaryKey)
                return i;
        }
        return -1;
    }

    function clearSql() {
        db.transaction(
            function(tx) {
                //SQL-DELETE ausführen
                var insertStatement = "DELETE FROM " + root.tableName;
                var rs = tx.executeSql(insertStatement);
                root.clear();
            }
        )
    }

    function insertSql(row) {
        db.transaction(
            function(tx) {
                //Keys und Values in Javascript-Arrays umwandeln
                var keys = Object.keys(row);
                var valuesArray = Object.keys(row).map(function (key) { return row[key]; });

                //Javascript-Arrays in Strings umwandeln
                var valueNames = JSON.stringify(keys);      //Wandelt das Array in ein Komma-getrennten String um
                valueNames = valueNames.replace("[", "(");  //Eckige Klammern in runde umwandeln
                valueNames = valueNames.replace("]", ")");
                var values = JSON.stringify(valuesArray);
                values = values.replace("[", "(");
                values = values.replace("]", ")");

                //SQL-Insert ausführen
                var insertStatement = "INSERT INTO " + root.tableName + " " + valueNames + " VALUES " + values;
                var rs = tx.executeSql(insertStatement);

                if(!row.hasOwnProperty(root.primaryKeyName)) {
                    row[root.primaryKeyName] = parseInt(rs.insertId); //TODO: Feste Annahme das der Primär-Key ein Integer ist
                }
                root.append(row);
            }
        )
    }

    function setPropertySql(primaryKey, row) {
        var index = findSql(primaryKey);
        if(index === -1) return;

        db.transaction(
            function(tx) {
                //Zuweisungen in Strings umwandeln
                var setArray = Object.keys(row).map(function (key) {
                    //Gegebenenfalls doppelte Anführungszeichen von JSON-Strings in einfache Anführungszeichen umwandeln
                    return (key + "=" + JSON.stringify(row[key])).replace(/\"/g, "'");
                });

                //Primär-Key in String umwandeln
                var primaryKeyValue = JSON.stringify(primaryKey).replace(/\"/g, "'");

                //Javascript-Array in String umwandeln
                var set = JSON.stringify(setArray);
                set = set.replace(/"/g, "");
                set = set.replace("[", "");
                set = set.replace("]", "");

                //SQL-Update ausführen
                var updateStatement = "UPDATE " + root.tableName + " SET " + set + " WHERE " + root.primaryKeyName + "=" + primaryKeyValue;
                var rs = tx.executeSql(updateStatement);

                //Keys und Values in Javascript-Arrays umwandeln
                var keys = Object.keys(row);
                var valuesArray = Object.keys(row).map(function (key) { return row[key]; });

                //Jedes Property im Model aktualisieren
                for(var i=0; i<keys.length; i++)
                    root.setProperty(index, keys[i], row[keys[i]]);
            }
        )
    }

    function setSql(primaryKey, row) {
        var index = findSql(primaryKey);
        //if(index === -1) return;

        //REPLACE INTO benötigt den Primär-Key in den Values
        row[root.primaryKeyName] = primaryKey;

        db.transaction(
            function(tx) {
                //Keys und Values in Javascript-Arrays umwandeln
                var keys = Object.keys(row);
                var valuesArray = Object.keys(row).map(function (key) { return row[key]; });

                //Javascript-Arrays in Strings umwandeln
                var valueNames = JSON.stringify(keys);      //Wandelt das Array in ein Komma-getrennten String um
                valueNames = valueNames.replace("[", "(");  //Eckige Klammern in runde umwandeln
                valueNames = valueNames.replace("]", ")");
                var values = JSON.stringify(valuesArray);
                values = values.replace("[", "(");
                values = values.replace("]", ")");

                //SQL-Replace ausführen
                var replaceStatement = "REPLACE INTO " + root.tableName + " " + valueNames + " VALUES " + values;
                var rs = tx.executeSql(replaceStatement);
                if(index === -1) root.append(row);
                else root.set(index, row);
            }
        )
    }

    function removeSql(primaryKey) {
        var index = findSql(primaryKey);
        if(index === -1) return;

        db.transaction(
            function(tx) {
                //Primär-Key in String umwandeln
                var primaryKeyValue = JSON.stringify(primaryKey).replace(/\"/g, "'");

                //SQL-Insert ausführen
                var deleteStatement = "DELETE FROM " + root.tableName + " WHERE " + root.primaryKeyName + "=" + primaryKeyValue;

                var rs = tx.executeSql(deleteStatement);
                root.remove(index, 1);
            }
        )
    }

    Component.onCompleted: load();
}
