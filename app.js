//PERN App - Backend configuration
const express = require("express");
const app = express();
require("dotenv").config();

/*__________Express middlewares___________*/
const path = require("path");
const cookieParser = require("cookie-parser");
const logger = require("morgan");
const cors = require("cors");
const session = require("express-session");

// Standard configuration
app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, "public")));

// Enable Cross Origin Resource Sharing to all origins by default
app.use(cors());

// Creates a session (Option needs to be changed for production)
app.set("trust proxy", 1);
app.use(
  session({
    secret: process.env.SESSION_SECRET,
    resave: true,
    saveUninitialized: true,
    cookie: {
      secure: false,
      maxAge: 24 * 60 * 60 * 1000,
    },
  })
);

/*__________Passport middlewares___________*/

/*__________API route handler______________*/
const indexRouter = require("./routes/index");
const customersRouter = require("./routes/customer");
const productsRouter = require("./routes/product");
const authRouter = require("./routes/auth");

app.use("/", indexRouter);
app.use("/auth", authRouter);
app.use("/customers", customersRouter);
app.use("/products", productsRouter);

/*__________Swagger middlewares___________*/

/*__________Error handler__________________*/
app.use((err, req, res, next) => {
  res
    .status(err.status || 500)
    .send({ message: err.message } );
});

module.exports = app;
