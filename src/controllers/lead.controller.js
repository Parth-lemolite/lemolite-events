const Lead = require("../models/lead.model");
const {
  sendLeadNotification,
  sendAcknowledgment,
} = require("../utils/emailService");
const paymentService = require("../services/payment.service");

// Create a new lead
exports.createLead = async (req, res) => {
  try {
    const lead = new Lead(req.body);
    await lead.save();

    // If SaaS subscription, create payment order
    if (lead.engagementModel === "SaaS-Based Subscription") {
      const paymentOrder = await paymentService.createOrder(
        lead,
        req.body?.totalAmount || 0
      );

      // Update lead with payment details
      lead.payment = {
        orderId: paymentOrder.orderId,
        amount: totalAmount,
        status: "pending",
      };
      await lead.save();

      return res.status(201).json({
        success: true,
        data: lead,
        paymentLink: paymentOrder.paymentLink,
        message: "Lead created successfully. Please complete the payment.",
      });
    }

    // For non-SaaS leads, just send notifications
    // await Promise.all([sendLeadNotification(lead), sendAcknowledgment(lead)]);

    res.status(201).json({
      success: true,
      data: lead,
      message: "Lead created successfully",
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: "Error creating lead",
      error: error.message,
    });
  }
};

// Handle payment callback
exports.handlePaymentCallback = async (req, res) => {
  try {
    const { order_id, payment_id } = req.query;

    const lead = await Lead.findOne({ "payment.orderId": order_id });
    if (!lead) {
      return res.status(404).json({
        success: false,
        message: "Lead not found",
      });
    }

    const paymentStatus = await paymentService.verifyPayment(
      order_id,
      payment_id
    );

    lead.payment = {
      ...lead.payment,
      status: paymentStatus.status === "PAID" ? "completed" : "failed",
      paymentId: payment_id,
      paymentDate: new Date(),
      paymentDetails: paymentStatus.paymentDetails,
    };

    await lead.save();

    // Send notifications only after successful payment
    if (paymentStatus.status === "PAID") {
      await Promise.all([sendLeadNotification(lead), sendAcknowledgment(lead)]);
    }

    res.status(200).json({
      success: true,
      data: lead,
      message:
        paymentStatus.status === "PAID"
          ? "Payment successful"
          : "Payment failed",
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: "Error processing payment callback",
      error: error.message,
    });
  }
};

// Handle payment webhook
exports.handlePaymentWebhook = async (req, res) => {
  try {
    const signature = req.headers["x-webhook-signature"];
    const webhookData = await paymentService.handleWebhook(req.body, signature);

    const lead = await Lead.findOne({ "payment.orderId": webhookData.orderId });
    if (!lead) {
      return res.status(404).json({
        success: false,
        message: "Lead not found",
      });
    }

    lead.payment = {
      ...lead.payment,
      status: webhookData.status === "PAID" ? "completed" : "failed",
      paymentId: webhookData.paymentId,
      paymentDate: new Date(),
      paymentDetails: webhookData.paymentDetails,
    };

    await lead.save();

    res.status(200).json({ success: true });
  } catch (error) {
    console.error("Webhook error:", error);
    res.status(400).json({
      success: false,
      message: "Error processing webhook",
      error: error.message,
    });
  }
};

// Get all leads
exports.getLeads = async (req, res) => {
  try {
    const leads = await Lead.find().sort({ createdAt: -1 });
    res.status(200).json({
      success: true,
      data: leads,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Error fetching leads",
      error: error.message,
    });
  }
};

// Get lead by ID
exports.getLeadById = async (req, res) => {
  try {
    const lead = await Lead.findById(req.params.id);
    if (!lead) {
      return res.status(404).json({
        success: false,
        message: "Lead not found",
      });
    }
    res.status(200).json({
      success: true,
      data: lead,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Error fetching lead",
      error: error.message,
    });
  }
};

// Update lead status
exports.updateLeadStatus = async (req, res) => {
  try {
    const { status } = req.body;
    const lead = await Lead.findByIdAndUpdate(
      req.params.id,
      { status },
      { new: true, runValidators: true }
    );

    if (!lead) {
      return res.status(404).json({
        success: false,
        message: "Lead not found",
      });
    }

    res.status(200).json({
      success: true,
      data: lead,
      message: "Lead status updated successfully",
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: "Error updating lead status",
      error: error.message,
    });
  }
};

// Calculate pricing for SaaS subscription
exports.calculatePricing = async (req, res) => {
  try {
    const { products, userCount } = req.body;

    // Pricing per user per month (in INR)
    const pricing = {
      Scan2Hire: 500,
      Nexstaff: 400,
      Integrated: 800,
      CRM: 300,
      IMS: 350,
      Dukadin: 450,
    };

    const calculations = products.map((product) => ({
      product,
      pricePerUser: pricing[product],
      totalPrice: pricing[product] * userCount,
    }));

    const totalAmount = calculations.reduce(
      (sum, calc) => sum + calc.totalPrice,
      0
    );

    res.status(200).json({
      success: true,
      data: {
        calculations,
        totalAmount,
      },
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: "Error calculating pricing",
      error: error.message,
    });
  }
};
