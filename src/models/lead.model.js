const mongoose = require("mongoose");

const leadSchema = new mongoose.Schema({
  companyName: {
    type: String,
    required: true,
    trim: true,
  },
  fullName: {
    type: String,
    required: true,
    trim: true,
  },
  email: {
    type: String,
    required: true,
    trim: true,
    lowercase: true,
  },
  phoneNumber: {
    type: String,
    required: true,
    trim: true,
  },
  interestedIn: {
    type: String,
    enum: ["Product", "Service"],
    required: true,
  },
  engagementModel: {
    type: String,
    enum: ["SaaS-Based Subscription", "Reseller", "Partner", "Whitelabel"],
    required: function () {
      return this.interestedIn === "Product";
    },
  },
  selectedProducts: [
    {
      type: String,
      enum: ["Scan2Hire", "Nexstaff", "Integrated", "CRM", "IMS", "Dukadin"],
    },
  ],
  userCount: {
    type: Number,
    required: function () {
      return this.engagementModel === "SaaS-Based Subscription";
    },
  },
  payment: {
    orderId: {
      type: String,
      required: function () {
        return this.engagementModel === "SaaS-Based Subscription";
      },
    },
    amount: {
      type: Number,
      required: function () {
        return this.engagementModel === "SaaS-Based Subscription";
      },
    },
    currency: {
      type: String,
      default: "INR",
    },
    status: {
      type: String,
      enum: ["pending", "completed", "failed"],
      default: "pending",
    },
    paymentId: String,
    paymentDate: Date,
    paymentDetails: {
      type: Map,
      of: mongoose.Schema.Types.Mixed,
    },
  },
  status: {
    type: String,
    enum: ["pending", "contacted", "qualified", "closed"],
    default: "pending",
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model("Lead", leadSchema);
