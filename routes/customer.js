const express = require("express");
const router = express.Router();
const CustomerService = require("../services/CustomerService.js");

const authAdminCheck = (req, res, next) => {
  if (!req.user) {
    res.status(401).send({ message: "Please login with username & password." });
  } else if (parseInt(req.user.id) !== parseInt(process.env.API_ADMIN)) {
    res
      .status(401)
      .send({ message: "No authorization for requested resource" });
  } else {
    next();
  }
};

const authCheck = (req, res, next) => {
  if (!req.user) {
    res.status(401).send({ message: "Please login with username & password." });
  } else if (
    !(
      parseInt(req.user.id) === parseInt(req.params.id) ||
      parseInt(req.user.id) === parseInt(process.env.API_ADMIN)
    )
  ) {
    res
      .status(401)
      .send({ message: "No authorization for requested resource" });
  } else {
    next();
  }
};

/* GET customer listing. */
router.get("/", authAdminCheck, async (req, res, next) => {
  try {
    const queryParams = req.query;

    const response = await CustomerService.list(queryParams);
    res.status(200).send(response);
  } catch (err) {
    next(err);
  }
});

/* GET single customer by id*/
router.get("/:id", authCheck, async (req, res, next) => {
  try {
    const { id } = req.params;

    const response = await CustomerService.get({ id: id });
    res.status(200).send(response);
  } catch (err) {
    next(err);
  }
});

/* Update single customer data (email & postal address) by id */
router.put("/:id", authCheck, async (req, res, next) => {
  try {
    const { id } = req.params;
    const data = req.body;

    const response = await CustomerService.update({
      id: id,
      ...data,
    });
    res.status(200).send(response);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
