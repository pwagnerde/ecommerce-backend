const { Pool, types } = require("pg");

types.setTypeParser(1700, "text", parseFloat);

const isProduction = process.env.NODE_ENV === "production";

const connectionString = `postgresql://${process.env.PGUSER}:${process.env.PGPASSWORD}@${process.env.PGHOST}:${process.env.PGPORT}/${process.env.PGDATABASE}`;

const pool = new Pool({
  connectionString: isProduction ? process.env.DATABASE_URL : connectionString,
/*  ssl: {
    rejectUnauthorized: false,
  },*/
});

module.exports = {
  query: (text, params) => pool.query(text, params),
};
