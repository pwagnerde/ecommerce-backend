"use strict";
const createError = require("http-errors");
const customerController = require("../controller/customers");

// Exports all the functions to perform on the db
module.exports = { register, login };

async function register(data) {
  const { username, email_address } = data;

  try {
    // Check if username already exists
    const user = await customerController.findOnePasswordByUsername(
      username
    );

    // If username already exists, reject
    if (user) {
      throw createError(409, "Username already in use");
    }
    // Check if email already exists
    const email = await customerController.findOneByEmail(email_address);

    // If email already exists, reject
    if (email) {
      throw createError(409, "Email already in use");
    }

    // User doesn't exist, create new user record
    return await customerController.create(data, "loc");
  } catch (err) {
    throw createError(500, err);
  }
}

async function login(data) {
  const { username, password } = data;

  try {
    // Check if user exists
    let user = await customerController.findOnePasswordByUsername(username);

    // If no customer record found, reject
    if (!user) {
      throw createError(401, "Incorrect username or password");
    }

    // Check for matching passwords
    // ----TO DO ADD BYCRYPT ------
    if (user.password_hash !== password) {
      throw createError(401, "Incorrect username or password");
    }

    // Get user record data
    user = await customerController.findOneByUsername(username);

    return user;
  } catch (err) {
    throw createError(500, err);
  }
}
