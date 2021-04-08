const express = require('express');
const router = express.Router();


/**
 * @openapi
 * /:
 *   get:
 *     message: Welcome to PNEW.digital API!
 *     responses:
 *       200:
 *         message: Returns a welcome message.
 */

/* GET home page. */
router.get('/', function(req, res, next) {
  //res.status(200).send({ message: "Welcome to the PNEW.digital API!" });
  res.render('index');
});

module.exports = router;
