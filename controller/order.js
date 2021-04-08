"use strict";
// Include our "db"
const db = require("../db");
//const orderItemController = require("./orderItems");
const openOrderStatus = 1; //open

// Exports all the functions to perform on the db
module.exports = { create, findByCustomer, findOneById, update };

/**
 * Creates a new order for a customer
 * @param  {number}      id [Customer ID]
 * @param  {DoubleRange}      total [Total order value]
 * @param  {Array}      cartItems [Cart items]
 * @param  {string}      comments [Customer comments]
 * @return {Object|null}      [Created order record]
 */
async function create(
  customerId,
  total = 0,
  cartItems = [],
  comments = "No comments"
) {
  if (!cartItems) {
    return null;
  }
  try {
    const timestamp = new Date();
    const created_at = timestamp.toISOString();

    await db.query("BEGIN");
    // Generate SQL statement
    let statement =
      "INSERT INTO public.order (customer_id, status_code_id, created_at, total, customer_comments) VALUES($1,$2,$3,$4,$5) RETURNING *";
    let values = [customerId, openOrderStatus, created_at, total, comments];

    // Execute SQL statment
    const result = await db.query(statement, values);
    const orderId = result.rows[0].order_id;

    if (result.rows?.length && orderId) {
      for (let i = 0; i < cartItems.length; i++) {
        let cartItem = cartItems[i];
        let final_price = cartItem.price * (1 - cartItem.discount / 100) || 0;
        statement =
          "INSERT INTO order_item (order_id, product_id, quantity, final_price) VALUES ($1, $2, $3, $4) RETURNING *";
        values = [
          orderId,
          cartItem.product_id,
          cartItem.quantity || 1,
          final_price.toFixed(2),
        ];
        // Execute SQL statment
        await db.query(statement, values);
      }

      await db.query("COMMIT");
      return result.rows[0];
    }

    await db.query("ROLLBACK");
    return null;
  } catch (err) {
    await db.query("ROLLBACK");
    throw err;
  }
}

/**
 * Updates order with new order status code
 * @param  {number}      id [Order ID]
 * @param  {number}      status_code [Status Code ID]
 * @return {Object|null}      [Updated order record]
 */
async function update(orderId, statusCode = 2) {
  //statusCode 1 = pending, checkout started
  //statusCode 2 = checkout completed, waiting for payment
  //statusCode 14 = shipped and receipt confirmed
  try {
    // Generate SQL statement
    const statement =
      "UPDATE public.order SET status_code_id = $1 WHERE order_id = $2 RETURNING *";
    const values = [statusCode, orderId];

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
 * Loads orders for a customer
 * @param  {number}      id [Customer ID]
 * @return {Array}         [Order records]
 */
async function findByCustomer(customerId) {
  try {
    // Generate SQL statement
    const statement = "SELECT * FROM public.order WHERE customer_id = $1";
    const values = [customerId];

    // Execute SQL statment
    const result = await db.query(statement, values);

    if (result.rows?.length) {
      return result.rows;
    }

    return null;
  } catch (err) {
    throw err;
  }
}

/**
 * Retrieve order by ID
 * @param  {number}      orderId [Order ID]
 * @return {Object|null}    [Order record]
 */
async function findOneById(orderId) {
  try {
    // Generate SQL statement
    const statement = "SELECT * FROM public.order WHERE order_id = $1";
    const values = [orderId];

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
