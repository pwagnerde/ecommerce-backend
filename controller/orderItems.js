"use strict";
// Include our "db"
const db = require("../db");

// Exports all the functions to perform on the db
module.exports = { create, find };

/**
 * Creates a new order line item
 * @param  {Object}      data [Order item data]
 * @return {Object|null}      [Created order item]
 */
async function create(data) {
  try {
    // Generate SQL statement - using helper for dynamic parameter injection
    const statement =
      "INSERT INTO order_item (order_id, product_id, quantity, final_price) VALUES ($1, $2, $3, $4) RETURNING *";
    const values = [
      data.order_id,
      data.product_id,
      data.quantity || 1,
      data.final_price || 0,
    ];

    // Execute SQL statment
    const result = await db.query(statement, values);

    if (result.rows?.length) {
      return result.rows[0];
    }

    return null;
  } catch (err) {
    throw err;
  }
}

/**
 * Retrieve order items for an order
 * @param  {number} orderId [Order ID]
 * @return {Array}         [All order items]
 */
async function find(orderId) {
  try {
    // Generate SQL statement
    const statement =
      "SELECT * FROM order_item JOIN product ON order_item.product_id = product.product_id AND order_id = $1";
    const values = [orderId];

    // Execute SQL statment
    const result = await db.query(statement, values);

    if (result.rows?.length) {
      return result.rows;
    }

    return [];
  } catch (err) {
    throw err;
  }
}
