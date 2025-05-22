import 'package:flutter/material.dart';

class ContactForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController companyController;
  final TextEditingController phoneController;
  final TextEditingController messageController;
  final String messageLabel;
  final String messagePlaceholder;

  const ContactForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.companyController,
    required this.phoneController,
    required this.messageController,
    required this.messageLabel,
    required this.messagePlaceholder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            hintText: 'Enter your full name',
            prefixIcon: Icon(Icons.person_outline),
          ),
          validator:
              (value) =>
          value == null || value.isEmpty
              ? 'Please enter your name'
              : null,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: companyController,
          decoration: const InputDecoration(
            labelText: 'Company Name',
            hintText: 'Enter your company name',
            prefixIcon: Icon(Icons.business_outlined),
          ),
          validator:
              (value) =>
          value == null || value.isEmpty
              ? 'Please enter your company name'
              : null,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email Address',
            hintText: 'Enter your email address',
            prefixIcon: Icon(Icons.email_outlined),
          ),
          validator:
              (value) =>
          value == null || value.isEmpty
              ? 'Please enter your email'
              : !value.contains('@') || !value.contains('.')
              ? 'Please enter a valid email'
              : null,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            hintText: 'Enter your phone number',
            prefixIcon: Icon(Icons.phone_outlined),
          ),
          validator:
              (value) =>
          value == null || value.isEmpty
              ? 'Please enter your phone number'
              : null,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: messageController,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: messageLabel,
            hintText: messagePlaceholder,
            alignLabelWithHint: true,
          ),
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}
