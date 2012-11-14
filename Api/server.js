
/**
 * @fileoverview This file contains the main runner which will initialize an
 * HTTP-Server and listen for requests using Node.js and the Express library.
 * @author kaktus621@gmail.com (Martin Matysiak)
 */

var express = require('express');
var database = require('./database');



/**
 * The main server class.
 * @constructor
 */
var Server = exports.Server = function() {
  /**
   * @type {Express}
   * @private
   */
  this.app_ = express();
  this.app_.use(express.bodyParser());

  // URL handler
  this.app_.get('/meetme/register', MeetMe.createUser);
  this.app_.get('/meetme/list', MeetMe.listUsers);
  this.app_.get('/meetme/position', MeetMe.addPosition);

  // Launch the server!
  this.app_.listen(Server.PORT);
};


/**
 * The port on which to run.
 * @const
 * @type {number}
 */
Server.PORT = 10101;


MeetMe = {};

/**
 * Approx. length of one degree latitude.
 */
MeetMe.KM_PER_LAT = 111.325;


/**
 * Very approx. length of one degree longitude (probably wrong for most parts
 * of the world).
 */
MeetMe.KM_PER_LNG = 110; // TODO


/**
 * Creates a new user in the database. No security stuff for now.
 * @param {Object} request The request object.
 * @param {Object} response The response object.
 */
MeetMe.createUser = function(request, response) {

  var dbCallback = function(err, rows) {
    var responseObject = {
      success: !err
    };

    if (err) {
      responseObject.error = err;
    }

    response.json(responseObject);
  };

  database.getInstance().query(
    'INSERT INTO `user`(`id`, `name`) VALUES(?, ?)',
    [request.param('id'), request.param('name')], dbCallback);
};


/**
 * Returns a list of users in the given area.
 * @param {Object} request The request object.
 * @param {Object} response The response object.
 */
MeetMe.listUsers = function(request, response) {

  var dbCallback = function(err, rows) {
    var responseObject = {
      success: !err,
      users: []
    };

    if (!err) {
      for (var i in rows) {
        responseObject.users.push(rows[i]);
      }
    } else {
      responseObject.error = err;
    }

    response.json(responseObject);
  };

  var latitude = parseFloat(request.param('latitude'));
  var longitude = parseFloat(request.param('longitude'));
  var distance = parseFloat(request.param('distance'));

  var bounds = {
    north: latitude + (distance / MeetMe.KM_PER_LAT),
    west: longitude - (distance / MeetMe.KM_PER_LNG),
    south: latitude - (distance / MeetMe.KM_PER_LAT),
    east: longitude + (distance / MeetMe.KM_PER_LNG)
  };

  console.dir(bounds);

  database.getInstance().query(
    'SELECT * FROM `message` JOIN `user` USING (`id`) ' +
    'WHERE `latitude` < ? AND `latitude` > ? ' +
    'AND `longitude` > ? AND `longitude` < ?',
    [bounds.north, bounds.south, bounds.west, bounds.east],
    dbCallback);
};


/**
 * Updates the user's position.
 * @param {Object} request The request object.
 * @param {Object} response The response object.
 */
MeetMe.addPosition = function(request, response) {
  var dbCallback = function(err, rows) {
    response.json({success: true});
  };

  database.getInstance().query(
    'INSERT INTO ' +
    '`message`(`id`, `timestamp`, `latitude`, `longitude`, `status`) ' +
    'VALUES(?, FROM_UNIXTIME(?), ?, ?, ?)',
    [
      request.param('id'), request.param('timestamp'),
      request.param('latitude'), request.param('longitude'),
      request.param('status')
    ], dbCallback);};
