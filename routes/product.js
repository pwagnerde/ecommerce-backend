const express = require("express");
const router = express.Router();
const ProductService = require("../services/ProductService.js");

/**
 * @swagger
 * definitions:
 *   Product:
 *     properties:
 *       product_id:
 *         type: integer
 *         example: 5
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
 *         example: 99.5
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
 * /products:
 *   get:
 *     tags:
 *       - Product
 *     security: []
 *     description: Returns all products
 *     produces:
 *       - application/json
 *     responses:
 *       200:
 *         description: An array of product objects
 *         schema:
 *           type: array
 *           items:
 *            $ref: '#/definitions/Product'
  *       204:
 *         description: No products found message object
 *         schema:
 *           $ref: '#/definitions/ErrorResponse'
 */

router.get("/", async (req, res, next) => {
  try {
    const queryParams = req.query;

    const response = await ProductService.list(queryParams);
    res.status(200).send(response);
  } catch (err) {
    next(err);
  }
});

/**
 * @swagger
 * /products/{productId}:
 *   get:
 *     tags:
 *       - Product
 *     security: []
 *     description: Returns a single product
 *     produces:
 *       - application/json
 *     parameters:
 *      - name: productId
 *        type: integer
 *        in: path
 *        required: true
 *     responses:
 *       200:
 *         description: A single product object
 *         schema:
 *           $ref: '#/definitions/Product'
 *       404:
 *         description: Product not found message object
 *         schema:
 *           $ref: '#/definitions/ErrorResponse'
 */
router.get("/:id", async (req, res, next) => {
  try {
    const { id } = req.params;

    const response = await ProductService.get(id);

    res.status(200).send(response);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
