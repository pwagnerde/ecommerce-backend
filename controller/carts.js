"use strict";
// Include our "db"
const db = require("../db");
const openShoppingCardStatus = 1; //open

// Exports all the functions to perform on the db
module.exports = { create, findOneByCustomer, findOneById, update };

/**
 * Creates a new cart for a customer
 * @param  {number}      id [Customer ID]
 * @return {Object|null}      [Created card record]
 */
async function create(customerId) {
  try {
    const timestamp = new Date();
    const created_at = timestamp.toISOString();

    // Generate SQL statement
    const statement =
      "INSERT INTO shopping_cart (customer_id, status_code_id, created_at) VALUES($1,$2,$3) RETURNING *";
    const values = [customerId, openShoppingCardStatus, created_at];

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
 * Updates cart with new cart status code
 * @param  {number}      id [Cart ID]
 * @param  {number}      status_code [Status Code ID]
 * @return {Object|null}      [Updated cart record]
 */
async function update(cartId, statusCode = 3) {
  //statusCode 1 = open
  //statusCode 3 = checked out
  try {
    // Generate SQL statement
    const statement =
      "UPDATE shopping_cart SET status_code_id = $1 WHERE cart_id = $2 RETURNING *";
    const values = [statusCode, cartId];

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
 * Loads an open cart by Customer ID
 * @param  {number}      id [Customer ID]
 * @return {Object|null}    [Cart record]
 */
async function findOneByCustomer(customerId) {
  try {
    // Generate SQL statement
    const statement =
      "SELECT * FROM shopping_cart WHERE customer_id = $1 AND status_code_id = $2";
    const values = [customerId, openShoppingCardStatus];

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
 * Loads a open cart by Cart ID
 * @param  {number}      id [Cart ID]
 * @return {Object|null}    [Cart record]
 */
async function findOneById(cartId) {
  try {
    // Generate SQL statement
    const statement =
      "SELECT * FROM shopping_cart WHERE cart_id = $1 AND status_code_id = $2";
    const values = [cartId, openShoppingCardStatus];

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
