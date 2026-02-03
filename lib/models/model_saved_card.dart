class ModelSavedCard {
  final String? id;
  final String? paymentMethodId; // Stripe payment_method_id (e.g., "pm_1SsO7r1TEtKJh83bycQpyL2c")
  final String? last4; // Last 4 digits of card
  final String? brand; // Card brand (visa, mastercard, etc.)
  final String? expiryMonth;
  final String? expiryYear;
  final String? cardholderName;
  final bool? isDefault;

  ModelSavedCard({
    this.id,
    this.paymentMethodId,
    this.last4,
    this.brand,
    this.expiryMonth,
    this.expiryYear,
    this.cardholderName,
    this.isDefault,
  });

  factory ModelSavedCard.fromJson(Map<String, dynamic> json) {
    return ModelSavedCard(
      id: json['id']?.toString(),
      paymentMethodId: json['payment_method_id']?.toString() ?? json['paymentMethodId']?.toString(),
      last4: json['last4']?.toString() ?? json['last_4']?.toString(),
      brand: json['brand']?.toString(),
      expiryMonth: json['expiry_month']?.toString() ?? json['expiryMonth']?.toString(),
      expiryYear: json['expiry_year']?.toString() ?? json['expiryYear']?.toString(),
      cardholderName: json['cardholder_name']?.toString() ?? json['cardholderName']?.toString(),
      isDefault: json['is_default'] == 1 || json['is_default'] == true || json['isDefault'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'payment_method_id': paymentMethodId,
      'last4': last4,
      'brand': brand,
      'expiry_month': expiryMonth,
      'expiry_year': expiryYear,
      'cardholder_name': cardholderName,
      'is_default': isDefault == true ? 1 : 0,
    };
  }

  String get displayCardNumber => '•••• •••• •••• ${last4 ?? "0000"}';
  
  String get displayExpiry {
    if (expiryMonth != null && expiryYear != null) {
      final month = expiryMonth!.padLeft(2, '0');
      final year = expiryYear!.length == 4 ? expiryYear!.substring(2) : expiryYear!;
      return '$month/$year';
    }
    return '';
  }

  String get brandDisplayName {
    switch (brand?.toLowerCase()) {
      case 'visa':
        return 'VISA';
      case 'mastercard':
        return 'MC';
      case 'amex':
      case 'american_express':
        return 'AMEX';
      case 'discover':
        return 'DIS';
      default:
        return 'CARD';
    }
  }
}

class ModelSavedCardsList {
  final bool? status;
  final String? message;
  final List<ModelSavedCard>? cards;

  ModelSavedCardsList({
    this.status,
    this.message,
    this.cards,
  });

  factory ModelSavedCardsList.fromJson(Map<String, dynamic> json) {
    List<ModelSavedCard> cardsList = [];
    if (json['data'] != null && json['data'] is List) {
      cardsList = (json['data'] as List)
          .map((item) => ModelSavedCard.fromJson(item))
          .toList();
    } else if (json['cards'] != null && json['cards'] is List) {
      cardsList = (json['cards'] as List)
          .map((item) => ModelSavedCard.fromJson(item))
          .toList();
    }
    
    return ModelSavedCardsList(
      status: json['status'] == true || json['status'] == 1,
      message: json['message']?.toString(),
      cards: cardsList,
    );
  }
}

