const express = require("express");
const router = express.Router();
const CustomerService = require("../services/CustomerService.js");

/* GET customer listing. */
router.get("/", async (req, res, next) => {
  try {
    const queryParams = req.query;

    const response = await CustomerService.list(queryParams);
    res.status(200).send(response);
  } catch (err) {
    next(err);
  }
});

/* GET single customer by id*/
router.get("/:id", async (req, res, next) => {
  try {
    const { id } = req.params;

    const response = await CustomerService.get({ id: id });
    res.status(200).send(response);
  } catch (err) {
    next(err);
  }
});

/* Update single customer data (email & postal address) by id */
  router.put("/:id", async (req, res, next) => {
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
