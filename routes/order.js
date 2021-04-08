const express = require("express");
const router = express.Router();
const OrderService = require("../services/OrderService.js");

const authCheck = (req, res, next) => {
  if (!req.user) {
    res.status(401).send({ message: "Please login with username & password." });
  } else {
    next();
  }
};

router.get("/", authCheck, async (req, res, next) => {
  try {
    const { id } = req.user;

    const response = await OrderService.list(id);
    res.status(200).send(response);
  } catch (err) {
    next(err);
  }
});

router.get("/:orderId", authCheck, async (req, res, next) => {
  try {
    const { orderId } = req.params;

    const response = await OrderService.findById(orderId);
    res.status(200).send(response);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
