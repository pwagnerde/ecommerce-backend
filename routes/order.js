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

/**
 * @swagger
 * securitySchemes:
 *   cookieAuth:
 *     type: apiKey
 *     in: cookie
 *     name: connect.sid
 * definitions:
 *   OrderSummary:
 *     properties:
 *       order_id:
 *         type: integer
 *         example: 15
 *       customer_id:
 *         type: integer
 *         example: 55
 *       status_code_id:
 *         type: integer
 *         example: 2
 *       customer_comments:
 *         type: integer
 *         example: "Payment via bankwire"
 *       created_at:
 *         type: string
 *         format: date-time
 *         example: "2021-04-08T06:47:04.791Z"
 *       total:
 *         type: integer
 *         example: 90.0 
 *   Order:
 *     properties:
 *       order_id:
 *         type: integer
 *         example: 15
 *       customer_id:
 *         type: integer
 *         example: 55
 *       status_code_id:
 *         type: integer
 *         example: 2
 *       customer_comments:
 *         type: integer
 *         example: "Payment via bankwire"
 *       created_at:
 *         type: string
 *         format: date-time
 *         example: "2021-04-08T06:47:04.791Z"
 *       total:
 *         type: integer
 *         example: 90.0
 *       order_items:
 *         type: array
 *         items:
 *            $ref: '#/definitions/OrderItem' 
 *   OrderItem:
 *     properties:
 *       order_id:
 *         type: integer
 *         example: 15
 *       order_item_id:
 *         type: integer
 *         example: 55
 *       product_id:
 *         type: integer
 *         example: 5
 *       quantity:
 *         type: integer
 *         example: 5
 *       final_price:
 *         type: number
 *         example: 90.0
 *       vendor_id:
 *         type: integer
 *         example: 3
 *       sku:
 *         type: string
 *         example: "p2021l01"
 *       name:
 *         type: string
 *         example: "Lorem ipsum small product 2"
 *       price:
 *         type: number
 *         example: 100.0
 *       discount:
 *         type: number
 *         example: 10
 *       offerEnd:
 *         type: string
 *         format: date-time
 *         example: "2021-10-05T10:11:00.000Z"
 *       new:
 *         type: boolean
 *         example: true
 *       rating:
 *         type: integer
 *         example: 5
 *       saleCount:
 *         type: integer
 *         example: 55
 *       category:
 *         type: array
 *         items:
 *            type: string
 *            example: "electronics" 
 *       tag:
 *         type: array
 *         items:
 *            type: string
 *            example: "accessories" 
 *       stock:
 *         type: integer
 *         example: 15
 *       image:
 *         type: array
 *         items:
 *            type: string
 *            example: "/assets/img/product/electronics/5.jpg" 
 *       shortDescription:
 *         type: string
 *       fullDescription:
 *         type: string
 *       weight:
 *         type: string
 *         example: "400 g"
 *       dimensions:
 *         type: string
 *         example: "10 x 10 x 15 cm"
 *       materials:
 *         type: string
 *         example: "Brushed stainless steel and plastic"
 *       otherInfo:
 *         type: string
 *       affiliateLink:
 *         type: string  
 *         example: "//www.amazon.com"
 *   ErrorResponse:
 *     required:
 *       - message
 *     properties:
 *       message:
 *         type: string
 */

/**
 * @swagger
 * /orders:
 *   get:
 *     tags:
 *       - Order
 *     security:
 *       - cookieAuth: []
 *     description: Returns all orders of a logged in user
 *     produces:
 *       - application/json
 *     responses:
 *       200:
 *         description: An array of order objects
 *         schema:
 *           type: array
 *           items:
 *            $ref: '#/definitions/OrderSummary'
 *       204:
 *         description: No orders found message object
 *         schema:
 *           $ref: '#/definitions/ErrorResponse'
 *       401:
 *         description: Unauthorized message object
 *         schema:
 *           $ref: '#/definitions/ErrorResponse'
 */

router.get("/", authCheck, async (req, res, next) => {
  try {
    const { id } = req.user;

    const response = await OrderService.list(id);
    res.status(200).send(response);
  } catch (err) {
    next(err);
  }
});

/**
 * @swagger
 * /orders/{orderId}:
 *   get:
 *     tags:
 *       - Order
 *     security:
 *       - cookieAuth: []
 *     description: Returns a single order
 *     produces:
 *       - application/json
 *     parameters:
 *      - name: orderId
 *        type: integer
 *        in: path
 *        required: true
 *     responses:
 *       200:
 *         description: A single order object
 *         schema:
 *           $ref: '#/definitions/Order'
 *       401:
 *         description: Unauthorized message object
 *         schema:
 *           $ref: '#/definitions/ErrorResponse'
 *       404:
 *         description: Order not found message object
 *         schema:
 *           $ref: '#/definitions/ErrorResponse'
 */

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
