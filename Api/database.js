
/**
 * @fileoverview This module contains a singleton class for communicating with
 * the MySQL database.
 */

var mysql = require('mysql');


var Database = function() {
  /**
   * @type {mysql.Connection}
   * @private
   */
  this.db_ = this.createDbHandle_();
};


/**
 * @type {Database}
 * @private
 */
Database.instance_ = null;


/**
 * Creates a new MySQL connection and attaches all kinds of internal listeners
 * to it.
 * @return {mysql.Connection} The connection handle.
 * @private
 */
Database.prototype.createDbHandle_ = function() {
  console.log('Creating Database connection.');
  var db = mysql.createConnection({
    host: 'martinmatysiak.de',
    user: 'mohack',
    password: 'mohack',
    database: 'mohack'
  });

  db.on('error', this.onError.bind(this));
  db.connect(function(err) {
    if (err) {
      console.error('[FATAL] DB connection failed!');
      console.dir(err);
    }
  });

  return db;
};


/**
 * If a connection error occurred, this method takes care of creating a new
 * connection.
 * @param {Object} err The error.
 */
Database.prototype.onError = function(err) {
  if (!err.fatal) {
    return;
  }
};


/**
 * Passes through to the internal Conncetion object.
 * @param {string} sql The query.
 * @param {Object} values Values for the query.
 * @param {function} cb A callback method.
 * @return {Object} The query object.
 */
Database.prototype.query = function(sql, values, cb) {
  return this.db_.query(sql, values, cb);
};


/**
 * Singleton-getter.
 * @return {Database} The database class.
 */
Database.getInstance = exports.getInstance = function() {
  if (Database.instance_ === null) {
    Database.instance_ = new Database();
  }

  return Database.instance_;
};
