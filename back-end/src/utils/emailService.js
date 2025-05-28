const nodemailer = require("nodemailer");

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL,
    pass: process.env.PASS,
  },
});

const sendEmail = async (to, subject, html) => {
  try {
    const mailOptions = {
      from: process.env.EMAIL,
      to,
      subject,
      html,
    };

    const info = await transporter.sendMail(mailOptions);
    console.log("Email sent:", info.messageId);
    return true;
  } catch (error) {
    console.error("Error sending email:", error);
    throw error;
  }
};

const sendLeadNotification = async (lead) => {
  const subject = "New Lead Submission";

  // Helper function to format selected products with plan details
  const formatSelectedProducts = (products) => {
    if (!products || products.length === 0) return "";

    return products
      .map((product) => {
        let productInfo = product.productName;
        if (product.planName) {
          productInfo += ` (${product.planName})`;
        }
        if (product.userCountRange) {
          productInfo += ` - Users: ${product.userCountRange}`;
        }
        if (product.totalPrice) {
          productInfo += ` - Price: $${product.totalPrice}`;
        }
        return productInfo;
      })
      .join("<br>");
  };

  const html = `
        <h2>New Lead Details</h2>
        <p><strong>Company Name:</strong> ${lead.companyName}</p>
        <p><strong>Full Name:</strong> ${lead.fullName}</p>
        <p><strong>Email:</strong> ${lead.email}</p>
        <p><strong>Phone:</strong> ${lead.phoneNumber}</p>
        <p><strong>Interested In:</strong> ${lead.interestedIn}</p>
        ${
          lead.engagementModel
            ? `<p><strong>Engagement Model:</strong> ${lead.engagementModel}</p>`
            : ""
        }
        ${
          lead.selectedProducts?.length
            ? `<p><strong>Selected Products:</strong><br>${formatSelectedProducts(
                lead.selectedProducts
              )}</p>`
            : ""
        }
    `;

  await sendEmail(process.env.SALES_EMAIL, subject, html);
};

const sendAcknowledgment = async (lead) => {
  const subject = "Thank you for your interest in Lemolite";

  // Helper function to format selected products for customer email
  const formatSelectedProductsForCustomer = (products) => {
    if (!products || products.length === 0) return "";

    return products
      .map((product) => {
        let productInfo = `• ${product.productName}`;
        if (product.planName) {
          productInfo += ` - ${product.planName}`;
        }
        if (product.userCountRange) {
          productInfo += ` (${product.userCountRange} users)`;
        }
        return productInfo;
      })
      .join("<br>");
  };

  const html = `
        <h2>Thank you for your interest!</h2>
        <p>Dear ${lead.fullName},</p>
        <p>We have received your inquiry and will get back to you shortly.</p>
        <p>Here's a summary of your submission:</p>
        <p><strong>Company Name:</strong> ${lead.companyName}</p>
        <p><strong>Interested In:</strong> ${lead.interestedIn}</p>
        ${
          lead.engagementModel
            ? `<p><strong>Engagement Model:</strong> ${lead.engagementModel}</p>`
            : ""
        }
        ${
          lead.selectedProducts?.length
            ? `<p><strong>Selected Products:</strong><br>${formatSelectedProductsForCustomer(
                lead.selectedProducts
              )}</p>`
            : ""
        }
      
        <p>Our sales team will contact you within 24 hours to discuss your requirements in detail.</p>
        <p>Best regards,<br>Lemolite Team</p>
    `;

  await sendEmail(lead.email, subject, html);
};

module.exports = {
  sendLeadNotification,
  sendAcknowledgment,
};
