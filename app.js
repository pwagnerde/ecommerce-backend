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
const passport = require("passport");
const LocalStrategy = require("passport-local");
const AuthService = require("./services/AuthService.js");

// Initialize passport
app.use(passport.initialize());
app.use(passport.session());

// Set method to serialize data to store in cookie
passport.serializeUser((user, done) => {
  done(null, user.customer_id);
});

// Set method to deserialize data stored in cookie and attach to req.user
passport.deserializeUser((id, done) => {
  done(null, { id });
});

// Configure local strategy to be use for local login
passport.use(
  new LocalStrategy(async (username, password, done) => {
    try {
      const user = await AuthService.login({
        username: username,
        password: password,
      });
      return done(null, user);
    } catch (err) {
      return done(err);
    }
  })
);

/*__________API route handler______________*/
const indexRouter = require("./routes/index");
const authRouter = require("./routes/auth");
const customerRouter = require("./routes/customer");
const productRouter = require("./routes/product");
const cartRouter = require("./routes/cart");
const orderRouter = require("./routes/order");

app.use("/", indexRouter);
app.use("/auth", authRouter);
app.use("/customers", customerRouter);
app.use("/products", productRouter);
app.use("/carts", cartRouter);
app.use("/orders", orderRouter);

/*__________Swagger middlewares___________*/
const swaggerJsdoc = require("swagger-jsdoc");
// swagger definition
const swaggerDefinition = {
  info: {
    title: "PNEW.digital Node API",
    version: "1.0.1",
    description: "Swagger documentation of RESTful API for ecommerce apps",
  },
  basePath: "/",
};

// options for the swagger docs
const options = {
  // import swaggerDefinitions
  swaggerDefinition: swaggerDefinition,
  // path to the API docs
  apis: ["./routes/product.js", "./routes/order.js"],
};

// initialize swagger-jsdoc
const swaggerSpec = swaggerJsdoc(options);

// serve swagger
app.get("/swagger.json", function (req, res) {
  res.setHeader("Content-Type", "application/json");
  res.send(swaggerSpec);
});

/*__________Error handler__________________*/
app.use((err, req, res, next) => {
  res.status(err.status || 500).send({ message: err.message });
});

module.exports = app;
