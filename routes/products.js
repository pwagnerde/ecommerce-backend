const products = require('../db/products.json');
const express = require("express");
const router = express.Router();
const product = require("../controller/products.js");


/* GET users listing. */
router.get("/sample", function (req, res, next) {
  res.send(products);
});

router.get("/", product.getProductsAll);

module.exports = router;
