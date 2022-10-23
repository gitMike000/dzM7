import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.LocalStorage 2.15
import QtQuick.Controls 2.12
import Qt.labs.qmlmodels 1.0

import "DBFunctions.js" as DbFunctions

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    property int cellHorizontalSpacing: 10
    property var db

    TableModel {
        id: contactsModel
        TableModelColumn { display: "id" }
        TableModelColumn { display: "first_name" }
        TableModelColumn { display: "last_name" }
        TableModelColumn { display: "email" }
        TableModelColumn { display: "phone" }
        rows: []
    }

    TableModel {
        id: bookModel
        TableModelColumn { display: "id" }
        TableModelColumn { display: "autor_name" }
        TableModelColumn { display: "book_name" }
        TableModelColumn { display: "page" }
        rows: []
    }

    TableView {
        id: contacts
        anchors.fill: parent
        columnSpacing: 1
        rowSpacing: 1
        model: contactsModel
        visible: false
        delegate: Rectangle {
            implicitWidth: Math.max(100, /*left*/ cellHorizontalSpacing + contactsText.width + /*right*/cellHorizontalSpacing)
            implicitHeight: 50
            border.width: 1
            Text {
                id: contactsText
                text: display
                anchors.centerIn: parent
            }
        }
    }

    TableView {
        id: books
        anchors.fill: parent
        columnSpacing: 1
        rowSpacing: 1
        model: bookModel
        visible: true
        delegate: Rectangle {
            implicitWidth: Math.max(100, /*left*/ cellHorizontalSpacing + booksText.width + /*right*/cellHorizontalSpacing)
            implicitHeight: 50
            border.width: 1
            Text {
                id: booksText
                text: display
                anchors.centerIn: parent
            }
        }
    }

    Dialog {
        id: dialog
        anchors.centerIn: parent
        title: "Add person"
        standardButtons: Dialog.Ok | Dialog.Cancel
        Column {
            anchors.fill: parent
            spacing: 5
            TextField {
                id: firstName
                placeholderText: "Имя"
            }
            TextField {
                id: lastName
                placeholderText: "Фамилия"
            }
            TextField {
                id: email
                placeholderText: "E-mail"
            }
            TextField {
                id: phone
                placeholderText: "Номер телефона"
            }
        }

        onAccepted: {
        try {
            db.transaction((tx) => {
                var resObj = DbFunctions.addContact(tx, firstName.text, lastName.text, email.text, phone.text);
                if (resObj.rowsAffected !== 0) {
                    tableModel.appendRow({ id: resObj.insertId, first_name: firstName.text, last_name: lastName.text, email: email.text,phone: phone.text})
                }
            })
        } catch (err) {
            console.log("Error creating or updating table in database: " + err)
        }
        }
    }

    Button {
        id: button
        text: "Добавить человека"
        width: parent.width
        height: 50
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: dialog.open()
    }

    Component.onCompleted: {
        var data_array = ListModel;
        db = LocalStorage.openDatabaseSync("DBExample", "1.0", "Пример локальной базы данных",
        1000)
        var temp;
        try {            
            db.transaction((tx)=>{temp = DbFunctions.tableIsExist(tx, "contacts")});

            if (!temp) {
             db.transaction(DbFunctions.createContactTable);
             db.transaction((tx) => {
                DbFunctions.addContact(tx, "Иванов", "Иван", "ivanoviv2182@mail.ru",
                "+7(988)37333112")
                DbFunctions.addContact(tx, "Заварнов", "Владимир", "zavlad@mail.ru",
                "+7(977)98373331")
                DbFunctions.addContact(tx, "Говорун", "Максим", "landlord2000@mail.ru",
                "+7(977)3311111")
             })
            }
            db.transaction((tx) => { DbFunctions.readContacts(tx, contacts.model) });
        } catch (err) {
            console.log("Error creating or updating table in database: " + err)
        }

        try {
            db.transaction((tx)=>{temp = DbFunctions.tableIsExist(tx, "books")});

            if (!temp) {
             db.transaction(DbFunctions.createBookTable);
             db.transaction((tx) => {
                DbFunctions.addBook(tx, "Лермонтов М.", "Герой нашего времени", "150")
                DbFunctions.addBook(tx, "Пушкин А.", "Сказка о рыбаке и рыбке", "15")
                DbFunctions.addBook(tx, "Чехов А.", "Рассказы", "120")
             })
            }
            db.transaction((tx) => { DbFunctions.readBooks(tx, books.model) });
        } catch (err) {
            console.log("Error creating or updating table in database: " + err)
        }
     }
}

