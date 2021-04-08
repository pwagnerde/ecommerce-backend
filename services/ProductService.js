"use strict";
const createError = require("http-errors");
const productController = require("../controller/products");

// Exports all the functions to perform on the db
module.exports = { list, get };

async function list(options) {
  try {
    // Load products
    const products = await productController.find(options);

    // If no products found, reject
    if (!products) {
      throw createError(204, "No products found");
    }

    return products;
  } catch (err) {
    throw err;
  }
}

async function get(productId) {
  try {
    // Check if product exists
    const product = await productController.findOne(productId);

    // If no product found, reject
    if (!product) {
      throw createError(404, "Product not found");
    }

    return product;
  } catch (err) {
    throw err;
  }
}
