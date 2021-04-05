const express = require("express");
const router = express.Router();
const ProductService = require("../services/ProductService.js");

/* GET product listing. */
router.get("/", async (req, res, next) => {
  try {
    const queryParams = req.query;

    const response = await ProductService.list(queryParams);
    res.status(200).send(response);
  } catch (err) {
    next(err);
  }
});

/* GET single product by id*/
router.get("/:id", async (req, res, next) => {
  try {
    const { id } = req.params;

    const response = await ProductService.get(id);

    res.status(200).send(response);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
