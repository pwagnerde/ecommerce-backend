"use strict";
// Include our "db"
const db = require("../db");

// Exports all the functions to perform on the db
module.exports = { getProductsAll };

//GET /products operationId
async function getProductsAll(req, res, next) {
  try {
    const { rows } = await db.query(
      "SELECT * FROM public.product"
    );
    if (rows[0]) {
      res.status(200).send(rows);
    } else {
      res.status(204).send(`No product data found in database`);
    }
  } catch (e) {
    res.status(500).send(e);
  }
}
