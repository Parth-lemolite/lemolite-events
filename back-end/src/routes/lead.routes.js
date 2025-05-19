const express = require("express");
const router = express.Router();
const leadController = require("../controllers/lead.controller");
const { validateLead } = require("../middleware/validation");

// Create a new lead
router.post("/", validateLead, leadController.createLead);

// Get all leads
router.get("/", leadController.getLeads);

// Get lead by ID
router.get("/:id", leadController.getLeadById);

// Update lead status
router.patch("/:id/status", leadController.updateLeadStatus);

// Calculate pricing
router.post("/calculate-pricing", leadController.calculatePricing);

// Payment callback
router.get("/payment/callback", leadController.handlePaymentCallback);

// Payment webhook
router.post("/payment/webhook", leadController.handlePaymentWebhook);

module.exports = router;
