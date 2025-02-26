const mysql = require("mysql2");

const pool = mysql.createPool({
    connectionLimit:10,
    host:'10.89.234.160',
    user:'alunods',
    password:'senai@604',
    database:'vio_guilherme11'
})

module.exports = pool;