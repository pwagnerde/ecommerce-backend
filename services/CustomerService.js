"use strict";
const createError = require("http-errors");
const customerController = require("../controller/customers");

// Exports all the functions to perform on the db
module.exports = { list, get, update };

async function list(options) {
  try {
    // Load customers
    const customers = await customerController.find(options);

    return customers;
  } catch (err) {
    throw err;
  }
}

async function get(data) {
  const { id } = data;
  try {
    // Check if customer exists
    const customer = await customerController.findOneById(id);

    // If no customer found, reject
    if (!customer) {
      throw createError(404, "Customer record not found");
    }

    return customer;
  } catch (err) {
    throw err;
  }
}

  async function update(data) {

    try {
      // Check if user already exists
      const user = await customerController.update(data);

      return user;

    } catch(err) {
      throw err;
    }

  };
