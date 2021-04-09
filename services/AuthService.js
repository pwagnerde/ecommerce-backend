"use strict";
const createError = require("http-errors");
const customerController = require("../controller/customers");
const bcrypt = require("bcrypt");
const saltRounds = 14;

// Exports all the functions to perform on the db
module.exports = { register, login };


// See: https://swagger.io/docs/specification/authentication/cookie-authentication/

async function register(data) {
  const { username, email_address } = data;

  try {
    // Check if username already exists
    let user = await customerController.findOnePasswordByUsername(username);

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

    // User doesn't exist, create new user record and hash password
    const hashedPassword = await bcrypt.hash(data.password, saltRounds);
    return await customerController.create(
      { ...data, password: hashedPassword },
      "loc"
    );


  } catch (err) {
    throw err;
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
    const match = await bcrypt.compare(password, user.password_hash);
    if (!match) {
      throw createError(401, "Incorrect username or password");
    }

    // Get user record data
    user = await customerController.findOneByUsername(username);

    return user;
  } catch (err) {
    throw err;
  }
}
