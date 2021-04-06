const router = require("express").Router();
const passport = require("passport");
const AuthService = require("../services/AuthService.js");
const { body } = require("express-validator");

// Registration Endpoint
router.post(
  "/register",
  body("email_address").trim().isEmail().normalizeEmail(),
  body("username").trim(),
  body("password").trim().isStrongPassword(),
  async (req, res, next) => {
    try {
      const data = req.body;
      const response = await AuthService.register(data);
      res.status(201).send(response);
    } catch (err) {
      next(err);
    }
  }
);

// Login Endpoint
router.post(
  "/login",
  passport.authenticate("local"),
  async (req, res, next) => {
    //router.post("/login", async (req, res, next) => {
    try {
      const { username, password } = req.body;

      const response = await AuthService.login({
        username: username,
        password: password,
      });

      res.status(200).send(response);
    } catch (err) {
      next(err);
    }
  }
);

// Logout Endpoint
router.get("/logout", (req, res) => {
  req.logout();
  //res.redirect("/");
  res.status(200).send({ message: "Logout successful" });
});

module.exports = router;
