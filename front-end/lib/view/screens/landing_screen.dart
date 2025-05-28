import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lemolite_events/view/screens/payment_success_screen.dart';
import 'package:lemolite_events/view/screens/product_inquiry_flow.dart';
import '../../controller/app_controller.dart';
// import '../../models/enums.dart';
// import '../../main.dart';
import '../../models/enums.dart';
import '../widgets/gradient_button.dart';
import '../widgets/policy_pages.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  RxString selectedOption = ''.obs;

  @override
  void initState() {
    // TODO: implement initState
    final Uri uri = Uri.base;
    final String? orderId = uri.queryParameters['order_id'];

    // Check if the URI is for the success route and has order_id
    final isSuccessRoute = uri.path.contains('/checkout') && orderId != null;

    if (isSuccessRoute) {
      Get.to(() => PaymentSuccessScreen(orderId: orderId));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();

    return Stack(
      children: [
        Container(decoration: BoxDecoration(color: Colors.grey.shade200)),
        Container(color: Colors.white.withValues(alpha: 0.1)),
        SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: controller.landingFormKey, // Use landingFormKey
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Center(child: SvgPicture.asset("assets/banner.svg")),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                    'Lemolite Technologies LLP',
                                  ),
                                  content: const Text(
                                    'Lemolite Technologies LLP is engaged in the development and sale of cloud-based enterprise software solutions. We offer Applicant Tracking Systems (ATS), Human Resource and Employee Management Systems (HREMS), Customer Relationship Management (CRM) platforms, and Inventory Management Systems (IMS).\n\n'
                                    'Our services are delivered under a subscription-based and white-label model, enabling businesses to use or resell our solutions under their own brand name. The products are accessible through secure web portals and are primarily used by SMEs and enterprises to streamline operations in hiring, HR management, sales and customer service, and inventory control.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: SvgPicture.asset(
                              "assets/lemologo.svg",
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'n"AI"robi BizTech',
                          style: GoogleFonts.montserrat(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F1C35),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    Text(
                      'Get Started with n"AI"robi BizTech',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tell us about yourself to explore our solutions.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: controller.nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        hintText: 'Enter your full name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter your name'
                          : null,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controller.companyController,
                      decoration: const InputDecoration(
                        labelText: 'Company Name',
                        hintText: 'Enter your company name',
                        prefixIcon: Icon(Icons.business_outlined),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter your company name'
                          : null,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        hintText: 'Enter your email address',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter your email'
                          : !value.contains('@') || !value.contains('.')
                              ? 'Please enter a valid email'
                              : null,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'Enter your phone number',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter your phone number'
                          : null,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Interested In',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: const Text('Service'),
                            leading: Radio<String>(
                              value: 'Service',
                              groupValue: selectedOption.value,
                              onChanged: (value) {
                                selectedOption.value = value!;
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Product'),
                            leading: Radio<String>(
                              value: 'Product',
                              groupValue: selectedOption.value,
                              onChanged: (value) {
                                selectedOption.value = value!;
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Enquiry'),
                            leading: Radio<String>(
                              value: 'Enquiry',
                              groupValue: selectedOption.value,
                              onChanged: (value) {
                                selectedOption.value = value!;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Obx(() {
                      return GradientButton(
                        onPressed: () async {
                          if (controller.landingFormKey.currentState != null &&
                              controller.landingFormKey.currentState!
                                  .validate()) {
                            if (selectedOption.value == 'Service') {
                              final formData = {
                                'companyName':
                                    controller.companyController.text,
                                'fullName': controller.nameController.text,
                                'email': controller.emailController.text,
                                'phoneNumber': controller.phoneController.text,
                                'interestedIn': 'Service',
                              };
                              if (kDebugMode) {
                                print('data====>$formData');
                              }
                              final isSuccess = await controller.sendUserData(
                                formData,
                              );
                              if (isSuccess) {
                                showGeneralDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  barrierLabel: '',
                                  barrierColor: Colors.black.withValues(
                                    alpha: 0.2,
                                  ),
                                  pageBuilder: (
                                    context,
                                    animation1,
                                    animation2,
                                  ) {
                                    return BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 5,
                                        sigmaY: 5,
                                      ),
                                      child: Center(
                                        child: AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          backgroundColor: Colors.white
                                              .withValues(alpha: 0.9),
                                          title: Text(
                                            'Thank You!',
                                            style: GoogleFonts.montserrat(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF0F1C35),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.check_circle_outline,
                                                size: 48,
                                                color: Colors.green,
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                'Our team will contact you shortly.',
                                                style: GoogleFonts.inter(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(
                                                    0xFF404B69,
                                                  ),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            Center(
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);

                                                  // Get.offAll(
                                                  //       () => const SuccessScreen(),
                                                  // );
                                                },
                                                child: Text(
                                                  'OK',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color(
                                                      0xFF2EC4F3,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }

                              // Get.off(() => const ServiceRequestFlow());
                            } else if (selectedOption.value == 'Product') {
                              controller.selectFlowType(FlowType.product);
                              Get.off(() => const ProductInquiryFlow());
                            }
                            else if (selectedOption.value == 'Enquiry') {
                              final formData = {
                                'companyName':
                                controller.companyController.text,
                                'fullName': controller.nameController.text,
                                'email': controller.emailController.text,
                                'phoneNumber': controller.phoneController.text,
                                'interestedIn': 'Enquiry',
                              };
                              if (kDebugMode) {
                                print('data====>$formData');
                              }
                              final isSuccess = await controller.sendUserData(
                                formData,
                              );
                              if (isSuccess) {
                                showGeneralDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  barrierLabel: '',
                                  barrierColor: Colors.black.withValues(
                                    alpha: 0.2,
                                  ),
                                  pageBuilder: (
                                      context,
                                      animation1,
                                      animation2,
                                      ) {
                                    return BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 5,
                                        sigmaY: 5,
                                      ),
                                      child: Center(
                                        child: AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          backgroundColor: Colors.white
                                              .withValues(alpha: 0.9),
                                          title: Text(
                                            'Thank You!',
                                            style: GoogleFonts.montserrat(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF0F1C35),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.check_circle_outline,
                                                size: 48,
                                                color: Colors.green,
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                'Our team will contact you shortly.',
                                                style: GoogleFonts.inter(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(
                                                    0xFF404B69,
                                                  ),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            Center(
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);

                                                  // Get.offAll(
                                                  //       () => const SuccessScreen(),
                                                  // );
                                                },
                                                child: Text(
                                                  'OK',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color(
                                                      0xFF2EC4F3,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            }

                            else {
                              Get.snackbar(
                                'Selection Required',
                                'Please select Service or Product',
                                backgroundColor: Colors.red.shade50,
                                colorText: Colors.red.shade900,
                                margin: const EdgeInsets.all(16),
                                borderRadius: 10,
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          } else {
                            Get.snackbar(
                              'Error',
                              'Please fill all required fields correctly',
                              backgroundColor: Colors.red.shade50,
                              colorText: Colors.red.shade900,
                              margin: const EdgeInsets.all(16),
                              borderRadius: 10,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                        isLoading: controller.isLoading.value,
                        text: selectedOption.value == 'Service'
                            ? 'Submit Request'
                            : 'Next',
                        gradientColors: const [
                          Color(0xFFBFD633),
                          Color(0xFF2EC4F3),
                        ],
                      );
                    }),
                    const SizedBox(height: 16),
                    //create three buttons textbutton privacy policy, terms and conditions, and shiping policy
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.to(() => const PrivacyPolicyPage());
                          },
                          child: Text(
                            'Privacy Policy',
                            style: TextStyle(fontSize: 10.5),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(() => const TermsConditionsPage());
                          },
                          child: Text(
                            'Terms and Conditions',
                            style: TextStyle(fontSize: 10.5),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(() => const ShippingPolicyPage());
                          },
                          child: Text(
                            'Shipping Policy',
                            style: TextStyle(fontSize: 10.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
