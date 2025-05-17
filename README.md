# Lemolite Lead Capture Backend

This is the backend service for the Lemolite Lead Capture system, handling lead submissions, product/service flows, and email notifications.

## Features

- Lead capture form processing
- Service and Product flow handling
- Dynamic pricing calculation for SaaS subscriptions
- Email notifications for leads and acknowledgments
- MongoDB database integration
- Input validation
- RESTful API endpoints

## Prerequisites

- Node.js (v14 or higher)
- MongoDB
- SMTP server access for email functionality

## Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   npm install
   ```
3. Create a `.env` file in the root directory with the following variables:
   ```
   PORT=3000
   MONGODB_URI=mongodb://localhost:27017/lemolite
   JWT_SECRET=your_jwt_secret_key
   SMTP_HOST=smtp.gmail.com
   SMTP_PORT=587
   SMTP_USER=your_email@gmail.com
   SMTP_PASS=your_email_password
   SALES_EMAIL=sales@lemolite.com
   ```

## Running the Application

Development mode:

```bash
npm run dev
```

Production mode:

```bash
npm start
```

## API Endpoints

### Leads

- `POST /api/leads` - Create a new lead
- `GET /api/leads` - Get all leads
- `GET /api/leads/:id` - Get lead by ID
- `PATCH /api/leads/:id/status` - Update lead status
- `POST /api/leads/calculate-pricing` - Calculate pricing for SaaS subscription

## Lead Submission Flow

1. Initial Lead Capture:

   - Company Name
   - Full Name
   - Email Address
   - Phone Number
   - Interested In (Product/Service)

2. Service Flow:

   - If "Service" is selected, sends notifications and ends flow

3. Product Flow:
   - Select Engagement Model (SaaS/Other)
   - Select Products
   - For SaaS: Calculate pricing based on user count
   - For Other Models: Request service agreement

## Error Handling

The API includes comprehensive error handling for:

- Validation errors
- Database errors
- Email sending failures
- Invalid requests

## Security

- Input validation using Joi
- CORS enabled
- Environment variables for sensitive data
- Error messages sanitized in production

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request
