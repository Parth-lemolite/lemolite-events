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
      Joi.string().valid(
        "Scan2Hire",
        "Nexstaff",
        "Integrated",
        "CRM",
        "IMS",
        "Dukadin"
      )
    )
    .when("interestedIn", {
      is: "Product",
      then: Joi.required(),
      otherwise: Joi.forbidden(),
    }),
  userCount: Joi.number().integer().min(1).when("engagementModel", {
    is: "SaaS-Based Subscription",
    then: Joi.required(),
    otherwise: Joi.forbidden(),
  }),
  totalAmount: Joi.number().integer().default(0).optional(),
});

const validateLead = (req, res, next) => {
  const { error } = leadSchema.validate(req.body, { abortEarly: false });
  if (error) {
    const errors = error.details.map((detail) => ({
      field: detail.path[0],
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
