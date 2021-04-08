"use strict";
// Include our "db"
const db = require("../db");

// Exports all the functions to perform on the db
module.exports = { create, find, update, remove };

/**
 * Creates a new cart line item
 * @param  {Object}      data [Cart item data]
 * @return {Object|null}      [Created cart item]
 */
async function create(data) {
  try {
    // Generate SQL statement - using helper for dynamic parameter injection
    const statement =
      "INSERT INTO shopping_cart_item (cart_id, product_id, quantity) VALUES ($1, $2, $3) RETURNING *";
    const values = [
      data.cart_id,
      data.product_id,
      data.quantity || 1,
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
 * Updates existing cart item
 * @param  {Object}      data [Cart item data]
 * @param  {number}      cartItemId   [Cart item id]
 * @return {Object|null}      [Updated cart item]
 */
async function update(cartItemId, data) {
  try {
    // Generate SQL statement
    const statement =
      "UPDATE shopping_cart_item SET quantity = $1 WHERE cart_item_id = $2 RETURNING *";

    const values = [ data.quantity || 0, cartItemId];

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
 * Retrieve cart items for a cart
 * @param  {number} cartId [Cart ID]
 * @return {Array}         [All cart items]
 */
async function find(cartId) {
  try {
    // Generate SQL statement
    const statement = "SELECT * FROM shopping_cart_item JOIN product ON shopping_cart_item.product_id = product.product_id AND cart_id = $1";
    const values = [cartId];

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

/**
 * Deletes a cart line item
 * @param  {number}      cardItemId [Cart item ID]
 * @return {Object|null}    [Deleted cart item]
 */
async function remove(cartItemId) {
  try {
    // Generate SQL statement
    const statement =
      "DELETE FROM shopping_cart_item WHERE cart_item_id = $1 RETURNING *";
    const values = [cartItemId];

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
