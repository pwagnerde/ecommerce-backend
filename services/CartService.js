"use strict";
const createError = require("http-errors");
const cartController = require("../controller/carts");
const cartItemController = require("../controller/cartItems");

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

    /*
        // If open card found, reject
        if (cart) {
          throw createError(409, "Open shopping card already available");
        }
        */

    // If open card found, load full card
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

    /*
    // If no card found, reject
    if (!cart) {
      throw createError(404, "Cart not found");
    }
    */

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

    // Generate total price from cart items
    const total = cartItems.reduce((total, item) => {
      return (total += Number(item.price));
    }, 0);

    // TO DO AFTER ORDER SERVICE SETUP + STRIPE SERVICE
    return {
      message: `Checkout of cart ${cartId} [total price: ${total}] for customer ${customerId} with payment ${paymentInfo} successful!`,
    };
  } catch (err) {
    throw err;
  }
}
