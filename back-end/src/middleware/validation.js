const Joi = require("joi");

const leadSchema = Joi.object({
  companyName: Joi.string().required().trim(),
  fullName: Joi.string().required().trim(),
  email: Joi.string().email().required().trim().lowercase(),
  phoneNumber: Joi.string().required().trim(),
  interestedIn: Joi.string().valid("Product", "Service").required(),
  engagementModel: Joi.string()
    .valid("SaaS-Based Subscription", "Reseller", "Partner", "Whitelabel")
    .when("interestedIn", {
      is: "Product",
      then: Joi.required(),
      otherwise: Joi.forbidden(),
    }),
  selectedProducts: Joi.array()
    .items(
      Joi.object({
        productName: Joi.string()
          .valid(
            "Scan2Hire (S2H)",
            "Nexstaff",
            "Integrated (S2H + Nexstaff)",
            "CRM",
            "IMS",
            "Dukadin"
          )
          .required(),
        userCountRange: Joi.string().when("..engagementModel", {
          is: "SaaS-Based Subscription",
          then: Joi.required(),
          otherwise: Joi.optional(),
        }),
        planName: Joi.string().when("..engagementModel", {
          is: "SaaS-Based Subscription",
          then: Joi.optional(),
          otherwise: Joi.optional(),
        }),
        totalPrice: Joi.number().min(0).when("..engagementModel", {
          is: "SaaS-Based Subscription",
          then: Joi.required(),
          otherwise: Joi.optional(),
        }),
      })
    )
    .when("interestedIn", {
      is: "Product",
      then: Joi.required(),
      otherwise: Joi.forbidden(),
    }),
  totalAmount: Joi.number().min(0).default(0).when("engagementModel", {
    is: "SaaS-Based Subscription",
    then: Joi.required(),
    otherwise: Joi.optional(),
  }),
  payment: Joi.object({
    orderId: Joi.string(),
    amount: Joi.number().min(0),
    currency: Joi.string(),
    status: Joi.string()
      .valid("pending", "completed", "failed")
      .default("pending"),
    paymentId: Joi.string(),
    paymentDate: Joi.date(),
    paymentDetails: Joi.object(),
  }).optional(),
});

const validateLead = (req, res, next) => {
  const { error } = leadSchema.validate(req.body, { abortEarly: false });
  if (error) {
    const errors = error.details.map((detail) => ({
      field: detail.path.join("."),
      message: detail.message,
    }));
    return res.status(400).json({
      success: false,
      message: "Validation error",
      errors,
    });
  }
  next();
};

module.exports = {
  validateLead,
};
