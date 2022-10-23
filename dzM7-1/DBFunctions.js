
function tableIsExist(tx, tabl) {
    const sql = 'SELECT name FROM sqlite_master'+
     ' WHERE type="table" AND name="%1";'.arg(tabl);
    var result = ((tx.executeSql(sql)).rows.length == 0 ? false : true);
    return result;
}

function createContactTable(tx) {
   const sql =
    'CREATE TABLE IF NOT EXISTS contacts (' +
    'contact_id INTEGER PRIMARY KEY,' +
    'first_name TEXT NOT NULL,' +
    'last_name TEXT NOT NULL,' +
    'email TEXT NOT NULL UNIQUE,' +
    'phone TEXT NOT NULL UNIQUE' +
    ');'
   tx.executeSql(sql)
}

function createBookTable(tx) {
   const sql =
    'CREATE TABLE IF NOT EXISTS books (' +
    'book_id INTEGER PRIMARY KEY,' +
    'autor_name TEXT NOT NULL,' +
    'book_name TEXT NOT NULL,' +
    'page TEXT NOT NULL UNIQUE' +
    ');'
   tx.executeSql(sql)
}

function addContact(tx, first_name, last_name, email, phone) {
    const sql =
     'INSERT INTO contacts (first_name, last_name, email, phone)' +
     'VALUES("%1", "%2", "%3", "%4");'.arg(first_name).arg(last_name).arg(email).arg(phone)
    return tx.executeSql(sql)
}

function addBook(tx, autor_name, book_name, page) {
    const sql =
     'INSERT INTO books (autor_name, book_name, page)' +
     'VALUES("%1", "%2", "%3");'.arg(autor_name).arg(book_name).arg(page)
    return tx.executeSql(sql)
}

function readContacts(tx, model) {
    const sql =
     'SELECT * FROM contacts';
    var result = tx.executeSql(sql);

    for (var i = 0; i < result.rows.length; ++i) {
        model.appendRow({
                            id:result.rows.item(i).contact_id,
                            first_name:result.rows.item(i).first_name,
                            last_name:result.rows.item(i).last_name,
                            email:result.rows.item(i).email,
                            phone:result.rows.item(i).phone
                        })
    }
}

function readBooks(tx, model) {
    const sql =
     'SELECT * FROM books';
    var result = tx.executeSql(sql);

    for (var i = 0; i < result.rows.length; ++i) {
        model.appendRow({
                            id:result.rows.item(i).book_id,
                            autor_name:result.rows.item(i).autor_name,
                            book_name:result.rows.item(i).book_name,
                            page:result.rows.item(i).page
                        })
    }
}


