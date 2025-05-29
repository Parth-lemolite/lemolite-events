enum InterestedIn { PRODUCT, SERVICE, ENQUIRY }
enum Status { PENDING }
enum EngagementModel { SAAS_BASED_SUBSCRIPTION, RESELLER, WHITELABEL }

const interestedInValues = {
  InterestedIn.PRODUCT: 'Product',
  InterestedIn.SERVICE: 'Service',
  InterestedIn.ENQUIRY: 'Enquiry',
};

const statusValues = {
  Status.PENDING: 'Pending',
};

const productNameValues = {
  'Scan2Hire (S2H)': 'Scan2Hire',
  'Nexstaff': 'Nexstaff',
};

const userCountRangeValues = {
  '1-10': '1-10 Users',
  '11-50': '11-50 Users',
  '51-100': '51-100 Users',
};

class Lead {
  final bool? success;
  final List<Datum>? data;

  Lead({this.success, this.data});

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      success: json['success'] as bool?,
      data: json['data'] != null
          ? List<Datum>.from(json['data'].map((x) => Datum.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.map((x) => x.toJson()).toList(),
    };
  }
}

class Datum {
  final String? id;
  final String? companyName;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final InterestedIn? interestedIn;
  final EngagementModel? engagementModel;
  final List<SelectedProduct>? selectedProducts;
  final int? totalAmount;
  final Status? status;
  final DateTime? createdAt;
  final int? v;
  final Payment? payment;

  Datum({
    this.id,
    this.companyName,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.interestedIn,
    this.engagementModel,
    this.selectedProducts,
    this.totalAmount,
    this.status,
    this.createdAt,
    this.v,
    this.payment,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json['_id'] as String?,
      companyName: json['companyName'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      interestedIn: json['interestedIn'] == 'Product'
          ? InterestedIn.PRODUCT
          : json['interestedIn'] == 'Service'
          ? InterestedIn.SERVICE
          : json['interestedIn'] == 'Enquiry'
          ? InterestedIn.ENQUIRY
          : null,
      engagementModel: json['engagementModel'] == 'SaaS-Based Subscription'
          ? EngagementModel.SAAS_BASED_SUBSCRIPTION
          : json['engagementModel'] == 'Reseller'
          ? EngagementModel.RESELLER
          : json['engagementModel'] == 'Whitelabel'
          ? EngagementModel.WHITELABEL
          : null,
      selectedProducts: json['selectedProducts'] != null
          ? List<SelectedProduct>.from(
          json['selectedProducts'].map((x) => SelectedProduct.fromJson(x)))
          : null,
      totalAmount: json['totalAmount'] as int?,
      status: json['status'] == 'pending' ? Status.PENDING : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      v: json['__v'] as int?,
      payment: json['payment'] != null
          ? Payment.fromJson(json['payment'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'companyName': companyName,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'interestedIn': interestedIn == InterestedIn.PRODUCT
          ? 'Product'
          : interestedIn == InterestedIn.SERVICE
          ? 'Service'
          : interestedIn == InterestedIn.ENQUIRY
          ? 'Enquiry'
          : null,
      'engagementModel': engagementModel == EngagementModel.SAAS_BASED_SUBSCRIPTION
          ? 'SaaS-Based Subscription'
          : engagementModel == EngagementModel.RESELLER
          ? 'Reseller'
          : engagementModel == EngagementModel.WHITELABEL
          ? 'Whitelabel'
          : null,
      'selectedProducts': selectedProducts?.map((x) => x.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status == Status.PENDING ? 'pending' : null,
      'createdAt': createdAt?.toIso8601String(),
      '__v': v,
      'payment': payment?.toJson(),
    };
  }
}

class SelectedProduct {
  final String? productName;
  final String? userCountRange;
  final int? totalPrice;
  final String? id;

  SelectedProduct({
    this.productName,
    this.userCountRange,
    this.totalPrice,
    this.id,
  });

  factory SelectedProduct.fromJson(Map<String, dynamic> json) {
    return SelectedProduct(
      productName: json['productName'] as String?,
      userCountRange: json['userCountRange'] as String?,
      totalPrice: json['totalPrice'] as int?,
      id: json['_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'userCountRange': userCountRange,
      'totalPrice': totalPrice,
      '_id': id,
    };
  }
}

class Payment {
  final String? currency;
  final String? status;

  Payment({this.currency, this.status});

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      currency: json['currency'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'status': status,
    };
  }
}