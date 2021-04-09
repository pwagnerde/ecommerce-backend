"use strict";
const createError = require("http-errors");
const cartController = require("../controller/carts");
const cartItemController = require("../controller/cartItems");
const orderController = require("../controller/order");
const orderItemController = require("../controller/orderItems");

// Exports all the functions to perform on the db
module.exports = {
  create,
  loadCart,
  addItem,
  removeItem,
  updateItem,
  checkout,
};

async function create(data) {
  const { customer_id } = data;

  try {
    // Check if product exists
    let cart = await cartController.findOneByCustomer(customer_id);

    // If open card found, load full card items
    if (cart) {
      const items = await cartItemController.find(cart.cart_id);
      cart.items = items;

      return cart;
    }

    // Instantiate new cart and save
    cart = await cartController.create(customer_id);

    cart.items = [];

    return cart;
  } catch (err) {
    throw err;
  }
}

async function loadCart(customerId) {
  try {
    // Load user cart based on ID
    let cart = await cartController.findOneByCustomer(customerId);

    // If no card found, create cart
    if (!cart) {
      cart = await cartController.create(customerId);
    }

    // Load cart items and add them to the cart record
    const items = await cartItemController.find(cart.cart_id);
    cart.items = items;

    return cart;
  } catch (err) {
    throw err;
  }
}

async function addItem(customerId, item) {
  try {
    // Load user cart based on ID
    let cart = await cartController.findOneByCustomer(customerId);

    // If no card found, create new cart
    if (!cart) {
      cart = await cartController.create(customer_id);
    }

    // Create cart item
    const cartItem = await cartItemController.create({
      cart_id: cart.cart_id,
      ...item,
    });

    return cartItem;
  } catch (err) {
    throw err;
  }
}

async function removeItem(cartItemId) {
  try {
    // Remove cart item by line ID
    const cartItem = await cartItemController.remove(cartItemId);

    return cartItem;
  } catch (err) {
    throw err;
  }
}

async function updateItem(cartItemId, data) {
  try {
    // Remove cart item by line ID
    const cartItem = await cartItemController.update(cartItemId, data);

    return cartItem;
  } catch (err) {
    throw err;
  }
}

async function checkout(cartId, customerId, paymentInfo) {
  try {
      
    // Load cart items
    const cartItems = await cartItemController.find(cartId);

    if (!cartItems || cartItems.length < 1) {
      throw createError(409, "No items in shopping cart");
    }

    // Generate total price from cart items
    const total = cartItems.reduce((total, item) => {
      let itemTotal = (
        item.price *
        (1 - item.discount / 100) *
        item.quantity
      ).toFixed(2);
      return (total += Number(itemTotal));
    }, 0);

    // Generate initial order
    let order = await orderController.create(
      customerId,
      total.toFixed(2),
      cartItems,
      "Payment via bankwire"
    );

    // On successful order creation, update cart status to CHECKED OUT
    await cartController.update(cartId, 3);

    // Make charge to payment method (not required in this project)
    /*
    const stripe = require('stripe')('TO BE ADDED');
    const charge = await stripe.charges.create({
      amount: total,
      currency: 'eur',
      source: paymentInfo.id,
      description: `PNEW.digital charge for order: #${order.order_id}`
    });
    */

    // On successful charge to payment method, update order status to COMPLETE

    order = await orderController.update(order.order_id, 2);

    // Load order items and add them to the order record
    const items = await orderItemController.find(order.order_id);
    order.items = items;

    return order;
  } catch (err) {
    throw err;
  }
}
