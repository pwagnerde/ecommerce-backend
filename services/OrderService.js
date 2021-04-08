"use strict";
const createError = require("http-errors");
const orderController = require("../controller/order");
const orderItemController = require("../controller/orderItems");

// Exports all the functions to perform on the db
module.exports = {
  list,
  findById,
};

async function list(customerId) {
  try {
    // Load user orders based on ID
    const orders = await orderController.findByCustomer(customerId);

    // If no orders found
    if (!orders) {
      throw createError(204, "No orders found");
    }

    return orders;
  } catch (err) {
    throw err;
  }
}

async function findById(orderId) {
  try {
    // Load user orders based on ID
    const order = await orderController.findOneById(orderId);

    // If no order found, reject
    if (!order) {
      throw createError(404, "Order not found");
    }

    // Load order items and add them to the order record
    const items = await orderItemController.find(order.order_id);
    order.items = items;

    return order;
  } catch (err) {
    throw err;
  }
}
