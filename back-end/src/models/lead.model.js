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
    enum: ["Product", "Service", "Enquiry"],
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
      productName: {
        type: String,
        enum: [
          "Scan2Hire (S2H)",
          "Nexstaff",
          "Integrated (S2H + Nexstaff)",
          "CRM",
          "IMS",
          "Dukadin",
        ],
        required: true,
      },
      userCountRange: {
        type: String,
        required: function () {
          return this.parent().engagementModel === "SaaS-Based Subscription";
        },
      },
      planName: {
        type: String,
        required: function () {
          return this.parent().engagementModel === "SaaS-Based Subscription";
        },
      },
      totalPrice: {
        type: Number,
        required: function () {
          return this.parent().engagementModel === "SaaS-Based Subscription";
        },
      },
    },
  ],
  totalAmount: {
    type: Number,
    default: 0,
  },
  payment: {
    orderId: {
      type: String,
    },
    amount: {
      type: Number,
    },
    currency: {
      type: String,
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
