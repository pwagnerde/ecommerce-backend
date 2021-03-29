const products = require('../db/products.json');
const express = require("express");
const router = express.Router();


/* GET users listing. */
router.get("/", function (req, res, next) {
  res.send(products);
});

module.exports = router;
