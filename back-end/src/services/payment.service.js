const axios = require("axios");
const crypto = require("crypto");

class PaymentService {
  constructor() {
    this.apiKey = process.env.CASHFREE_API_KEY;
    this.secretKey = process.env.CASHFREE_SECRET_KEY;
    this.baseUrl =
      process.env.NODE_ENV === "production"
        ? "https://api.cashfree.com/pg"
        : "https://sandbox.cashfree.com/pg";
  }

  generateSignature(data) {
    const signatureData = Object.keys(data)
      .sort()
      .map((key) => `${key}${data[key]}`)
      .join("");

    return crypto
      .createHmac("sha256", this.secretKey)
      .update(signatureData)
      .digest("hex");
  }

  async createOrder(lead, amount) {
    try {
      const orderId = `ORDER_${Date.now()}_${Math.random()
        .toString(36)
        .substr(2, 9)}`;

      const orderData = {
        order_id: orderId,
        order_amount: amount,
        order_currency: "INR",
        customer_details: {
          customer_id: lead._id.toString(),
          customer_name: lead.fullName,
          customer_email: lead.email,
          customer_phone: lead.phoneNumber,
        },
        order_meta: {
          return_url: `${process.env.FRONTEND_URL}/payment/callback?order_id={order_id}`,
        },
      };

      const signature = this.generateSignature(orderData);

      const response = await axios.post(`${this.baseUrl}/orders`, orderData, {
        headers: {
          "x-api-version": "2022-09-01",
          "x-client-id": this.apiKey,
          "x-client-secret": this.secretKey,
          "x-signature": signature,
        },
      });

      return {
        orderId: response.data.order_id,
        paymentLink: response.data.payment_link,
        orderData: response.data,
      };
    } catch (error) {
      console.error(
        "Error creating Cashfree order:",
        error.response?.data || error.message
      );
      throw new Error("Failed to create payment order");
    }
  }

  async verifyPayment(orderId, paymentId) {
    try {
      const response = await axios.get(`${this.baseUrl}/orders/${orderId}`, {
        headers: {
          "x-api-version": "2022-09-01",
          "x-client-id": this.apiKey,
          "x-client-secret": this.secretKey,
        },
      });

      return {
        status: response.data.order_status,
        paymentDetails: response.data,
      };
    } catch (error) {
      console.error(
        "Error verifying payment:",
        error.response?.data || error.message
      );
      throw new Error("Failed to verify payment");
    }
  }

  async handleWebhook(payload, signature) {
    try {
      const calculatedSignature = this.generateSignature(payload);

      if (calculatedSignature !== signature) {
        throw new Error("Invalid signature");
      }

      return {
        orderId: payload.order.order_id,
        paymentId: payload.order.payment_id,
        status: payload.order.order_status,
        paymentDetails: payload,
      };
    } catch (error) {
      console.error("Error handling webhook:", error);
      throw error;
    }
  }
}

module.exports = new PaymentService();
