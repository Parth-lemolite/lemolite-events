class GetPaymentData {
  bool? success;
  Data? data;
  String? paymentLink;
  String? paymentSessionId;
  String? message;

  GetPaymentData({
    this.success,
    this.data,
    this.paymentLink,
    this.paymentSessionId,
    this.message,
  });

  factory GetPaymentData.fromJson(Map<String, dynamic> json) {
    return GetPaymentData(
      success: json['success'] as bool?,
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      paymentLink: json['paymentLink'] as String?,
      paymentSessionId: json['paymentSessionId'] as String?,
      message: json['message'] as String?,
    );
  }
}

class Data {
  String? companyName;
  String? fullName;
  String? email;
  String? phoneNumber;
  String? interestedIn;
  String? engagementModel;
  List<SelectedProduct>? selectedProducts;
  int? totalAmount;
  Payment? payment;
  String? status;
  String? id;
  DateTime? createdAt;
  int? v;

  Data({
    this.companyName,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.interestedIn,
    this.engagementModel,
    this.selectedProducts,
    this.totalAmount,
    this.payment,
    this.status,
    this.id,
    this.createdAt,
    this.v,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      companyName: json['companyName'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      interestedIn: json['interestedIn'] as String?,
      engagementModel: json['engagementModel'] as String?,
      selectedProducts: json['selectedProducts'] != null
          ? (json['selectedProducts'] as List<dynamic>)
          .map((e) => SelectedProduct.fromJson(e as Map<String, dynamic>))
          .toList()
          : null,
      totalAmount: json['totalAmount'] as int?,
      payment: json['payment'] != null ? Payment.fromJson(json['payment']) : null,
      status: json['status'] as String?,
      id: json['_id'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      v: json['__v'] as int?,
    );
  }
}

class Payment {
  String? orderId;
  int? amount;
  String? status;

  Payment({
    this.orderId,
    this.amount,
    this.status,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      orderId: json['orderId'] as String?,
      amount: json['amount'] as int?,
      status: json['status'] as String?,
    );
  }
}

class SelectedProduct {
  String? productName;
  String? userCountRange;
  String? planName;
  int? totalPrice;
  String? id;

  SelectedProduct({
    this.productName,
    this.userCountRange,
    this.planName,
    this.totalPrice,
    this.id,
  });

  factory SelectedProduct.fromJson(Map<String, dynamic> json) {
    return SelectedProduct(
      productName: json['productName'] as String?,
      userCountRange: json['userCountRange'] as String?,
      planName: json['planName'] as String?,
      totalPrice: json['totalPrice'] as int?,
      id: json['_id'] as String?,
    );
  }
}