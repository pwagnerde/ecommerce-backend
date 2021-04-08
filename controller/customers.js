"use strict";
// Include our "db"
const db = require("../db");

// Exports all the functions to perform on the db
module.exports = {
  create,
  find,
  findOneById,
  findOneByUsername,
  findOnePasswordByUsername,
  findOneByEmail,
  update
};

/**
 * List customers
 * @param  {Object} options [Query options]
 * @return {Array}          [Array of products]
 */
async function find(options = {}) {
  try {
    const statement =
      "SELECT * FROM customer JOIN customer_address ON customer.customer_id = customer_address.customer_id";
    const values = [];

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
 * Finds a customer record by ID
 * @param  {String}      id [Customer ID]
 * @return {Object|null}    [Customer Record]
 */
async function findOneById(customerId) {
  try {
    // Generate SQL statement
    const statement =
      "SELECT * FROM customer JOIN customer_address ON customer.customer_id = customer_address.customer_id AND customer.customer_id = $1";
    const values = [customerId];

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
 * Finds a customer record by username
 * @param  {String}      username [Username]
 * @return {Object|null}       [Customer record]
 */
async function findOneByUsername(username) {
  try {
    // Generate SQL statement
    const statement =
      "SELECT * FROM customer JOIN customer_address ON customer.customer_id = customer_address.customer_id AND customer.username = $1";
    const values = [username];

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
 * Finds a customer record by email
 * @param  {String}      email [Email address]
 * @return {Object|null}       [Customer record]
 */
async function findOneByEmail(email) {
  try {
    // Generate SQL statement
    const statement =
      "SELECT * FROM customer JOIN customer_address ON customer.customer_id = customer_address.customer_id AND customer.email_address = $1";
    const values = [email];

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
 * Finds a customer record (incl. password) by username
 * @param  {String}      username [Username]
 * @return {Object|null}       [Customer record incl. password]
 */
async function findOnePasswordByUsername(username) {
  try {
    // Generate SQL statement
    const statement =
      "SELECT * FROM customer JOIN customer_login ON customer.customer_id = customer_login.customer_id AND customer.username = $1";
    const values = [username];

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
 * Creates a new customer record
 * @param  {Object}      data [User data]
 * @return {Object|null}      [Created customer record]
 */
async function create(data, user_type = "loc") {
  try {
    ///-------------  TO DO ----------------
    const {
      first_name,
      middle_name,
      last_name,
      email_address,
      username,
      password,
      address_street_no,
      address_street_name,
      address_city,
      address_state,
      address_postal_code,
      address_country_code,
    } = data;
    const timestamp = new Date();
    const created_at = timestamp.toISOString();

    await db.query("BEGIN");
    // Generate SQL statement
    let statement =
      "INSERT INTO customer (first_name, middle_name, last_name, email_address, username, user_type, created_at) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING customer_id, first_name, middle_name, last_name, email_address, username, user_type,created_at";
    let values = [
      first_name,
      middle_name,
      last_name,
      email_address,
      username,
      user_type,
      created_at,
    ];
    // Execute SQL statment
    const result = await db.query(statement, values);

    // Generate SQL statement
    statement =
      "INSERT INTO customer_login (customer_id, password_hash, locked_out) VALUES ($1, $2, false) RETURNING login_id";
    values = [result.rows[0].customer_id, password];
    // Execute SQL statment
    const loginId = await db.query(statement, values);

    // Generate SQL statement
    statement =
      "INSERT INTO customer_address (customer_id, address_street_no, address_street_name, address_city, address_state, address_postal_code, address_country_code) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING address_id";
    values = [
      result.rows[0].customer_id,
      address_street_no,
      address_street_name,
      address_city,
      address_state,
      address_postal_code,
      address_country_code,
    ];
    // Execute SQL statment
    const addressId = await db.query(statement, values);

    if (result.rows?.length && loginId.rows?.length && addressId.rows?.length) {
      await db.query("COMMIT");

      // Returns full data record incl. address information
      //return result.rows[0];
      return await findOneById(result.rows[0].customer_id);
    }

    await db.query("ROLLBACK");
    return null;
  } catch (err) {
    await db.query("ROLLBACK");
    throw err;
  }
}

/**
 * Updates a user record
 * @param  {Object}      data [User data]
 * @return {Object|null}      [Updated user record]
 */
async function update(data) {
  try {
    const {
      id,
      customer_id,
      first_name,
      middle_name,
      last_name,
      email_address,
      // created_at, no update
      // username, no update of username possible
      // user_type, no update
      address_id,
      address_street_no,
      address_street_name,
      address_city,
      address_state,
      address_postal_code,
      address_country_code,
    } = data;

    // Make sure req body data belongs to req params
    if (parseInt(id) !== parseInt(customer_id)) throw {message: "Parameter mismatch request"};

    await db.query("BEGIN");
    // Generate SQL statement
    let statement =
      "UPDATE customer SET first_name = $1, middle_name = $2, last_name = $3, email_address = $4 WHERE customer_id = $5";
    let values = [
      first_name,
      middle_name,
      last_name,
      email_address,
      customer_id
    ];
    // Execute SQL statment
    await db.query(statement, values);

    // Generate SQL statement
    statement =
      "UPDATE customer_address SET address_street_no = $1, address_street_name = $2, address_city = $3, address_state = $4, address_postal_code = $5, address_country_code = $6  WHERE address_id = $7";
    values = [
      address_street_no,
      address_street_name,
      address_city,
      address_state,
      address_postal_code,
      address_country_code,
      address_id
    ];
    // Execute SQL statment
    await db.query(statement, values);

    await db.query("COMMIT");

    return await findOneById(customer_id);

  } catch (err) {
    await db.query("ROLLBACK");
    throw err;
  }
}
