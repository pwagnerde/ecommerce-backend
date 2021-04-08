"use strict";
// Include our "db"
const db = require("../db");

// Exports all the functions to perform on the db
module.exports = { find, findOne };

/**
 * List products
 * @param  {Object} options [Query options]
 * @return {Array}          [Array of products]
 */
async function find(options = {}) {
  try {
    const statement = "SELECT * FROM product";
    const values = [];

    const result = await db.query(statement, values);

    if (result.rows?.length) {
      return result.rows;
    }

    return [];
  } catch (err) {
    throw err;
  }
}

  /**
   * Retrieve product by ID
   * @param  {Object}      id [Product ID]
   * @return {Object|null}    [Product record]
   */
  async function findOne(productId) {
    try {

      const statement = `SELECT * FROM product WHERE product_id = $1`;
      const values = [productId];
  
      const result = await db.query(statement, values);

      if (result.rows?.length) {
        return result.rows[0]
      }
  
      return null;

    } catch(err) {
      throw err;
    }
  }
