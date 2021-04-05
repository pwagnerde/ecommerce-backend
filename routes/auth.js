const router = require("express").Router();
//const passport = require("passport");
const AuthService = require("../services/AuthService.js");


// Registration Endpoint
  router.post('/register', async (req, res, next) => {
  
    try {
      const data = req.body;
      const response = await AuthService.register(data);
      res.status(200).send(response);
    } catch(err) {
      next(err);
    }
  
  });
  
  // Login Endpoint
//router.post('/login', passport.authenticate('local'), async (req, res, next) => {
    router.post('/login', async (req, res, next) => {
    try {
      const { username, password } = req.body;
    
      const response = await AuthService.login({ username: username, password: password });
    
      res.status(200).send(response);
    } catch(err) {
      next(err);
    }
  });

// auth logout
router.get("/logout", (req, res) => {
  req.logout();
  res.redirect("/");
});

module.exports = router;
