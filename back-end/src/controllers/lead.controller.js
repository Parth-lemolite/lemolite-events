const Lead = require("../models/lead.model");
const {
  sendLeadNotification,
  sendAcknowledgment,
} = require("../utils/emailService");
const paymentService = require("../services/payment.service");

// Create a new lead
exports.createLead = async (req, res) => {
  try {
    const leadData = { ...req.body };

    // If SaaS subscription, process the products
    if (leadData.engagementModel === "SaaS-Based Subscription") {
      // Transform selectedProducts to include pricing details
      leadData.selectedProducts = leadData.selectedProducts.map((product) => ({
        productName: product.productName,
        planName: product.planName, // Store the plan name as is
        userCountRange: product.userCountRange, // Store the range as is
        totalPrice: product.totalPrice, // Use total price from frontend
      }));

      const lead = new Lead(leadData);
      await lead.save();

      await Promise.all([sendLeadNotification(lead), sendAcknowledgment(lead)]);

      console.log("Lead created 26:", lead);
      // Create payment order
      // const paymentOrder = await paymentService.createOrder(
      //   lead,
      //   leadData.totalAmount
      // );

      // // Update lead with payment details
      // lead.payment = {
      //   orderId: paymentOrder.orderId,
      //   amount: leadData.totalAmount,
      //   status: "pending",
      // };
      // await lead.save();

      return res.status(201).json({
        success: true,
        data: lead,
        // paymentLink: paymentOrder.paymentLink,
        // paymentSessionId: paymentOrder.paymentSessionId,
        message: "Lead created successfully. Please complete the payment.",
      });
    }

    // For non-SaaS leads
    const lead = new Lead(leadData);
    await lead.save();

    // Send notifications
    await Promise.all([sendLeadNotification(lead), sendAcknowledgment(lead)]);

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

// Calculate pricing for selected products
exports.calculatePricing = async (req, res) => {
  try {
    const { products } = req.body;

    const calculations = products.map((product) => ({
      productName: product.productName,
      userCount: product.userCount,
      pricePerUser: PRODUCT_PRICING[product.productName],
      totalPrice: PRODUCT_PRICING[product.productName] * product.userCount,
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

    console.log("Payment Status 112:", paymentStatus.status);

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
