const express = require("express");
const router = express.Router();
const CartService = require("../services/CartService.js");

const authCheck = (req, res, next) => {
  if (!req.user) {
    res.status(401).send({ message: "Please login with username & password." });
  } else {
    next();
  }
};

router.get("/mine", authCheck, async (req, res, next) => {
  try {
    const { id } = req.user;

    const response = await CartService.loadCart(id);

    res.status(200).send(response);
  } catch (err) {
    next(err);
  }
});

router.post("/mine", authCheck, async (req, res, next) => {
  try {
    const { id } = req.user;

    const response = await CartService.create({ customer_id: id });

    res.status(200).send(response);
  } catch (err) {
    next(err);
  }
});

router.post("/mine/items", authCheck, async (req, res, next) => {
  try {
    const { id } = req.user;
    const data = req.body;

    const response = await CartService.addItem(id, data);

    res.status(200).send(response);
  } catch (err) {
    next(err);
  }
});

router.put("/mine/items/:cartItemId", authCheck, async (req, res, next) => {
  try {
    const { cartItemId } = req.params;
    const data = req.body;

    const response = await CartService.updateItem(cartItemId, data);

    res.status(200).send(response);
  } catch (err) {
    next(err);
  }
});

router.delete("/mine/items/:cartItemId", authCheck, async (req, res, next) => {
  try {
    const { cartItemId } = req.params;

    const response = await CartService.removeItem(cartItemId);

    res.status(200).send(response);
  } catch (err) {
    next(err);
  }
});

router.post("/mine/checkout", authCheck, async (req, res, next) => {
  try {
    const { id } = req.user;

    const { cartId, paymentInfo } = req.body;

    const response = await CartService.checkout(cartId, id, paymentInfo);

    res.status(200).send(response);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
