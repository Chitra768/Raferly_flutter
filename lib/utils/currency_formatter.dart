import 'package:intl/intl.dart';

class CurrencyFormatter {
  // Default currency code - can be changed based on payment processing
  static String _currentCurrencyCode = 'INR';

  // Set the currency code based on payment processing
  static void setCurrencyCode(String currencyCode) {
    _currentCurrencyCode = currencyCode;
  }

  static String formatCurrency(double amount, {String? locale}) {
    // Get the currency symbol and format based on the current currency code
    final Map<String, Map<String, dynamic>> currencyConfig = {
      'INR': {
        'symbol': '₹',
        'locale': 'en_IN',
        'decimalDigits': 2,
      },
      'USD': {
        'symbol': '\$',
        'locale': 'en_US',
        'decimalDigits': 2,
      },
      'EUR': {
        'symbol': '€',
        'locale': 'fr_FR',
        'decimalDigits': 2,
      },
      'GBP': {
        'symbol': '£',
        'locale': 'en_GB',
        'decimalDigits': 2,
      },
      'JPY': {
        'symbol': '¥',
        'locale': 'ja_JP',
        'decimalDigits': 0,
      },
      'AUD': {
        'symbol': 'A\$',
        'locale': 'en_AU',
        'decimalDigits': 2,
      },
      'CAD': {
        'symbol': 'C\$',
        'locale': 'en_CA',
        'decimalDigits': 2,
      },
      'SGD': {
        'symbol': 'S\$',
        'locale': 'en_SG',
        'decimalDigits': 2,
      },
      'AED': {
        'symbol': 'د.إ',
        'locale': 'ar_AE',
        'decimalDigits': 2,
      },
    };

    // Get configuration for current currency
    final config =
        currencyConfig[_currentCurrencyCode] ?? currencyConfig['INR']!;

    // Create formatter with the correct configuration
    final formatter = NumberFormat.currency(
      locale: config['locale'],
      symbol: config['symbol'],
      decimalDigits: config['decimalDigits'],
    );

    // Format the number
    String formattedNumber = formatter.format(amount);

    // Remove any extra spaces
    formattedNumber = formattedNumber.replaceAll(' ', '');

    return formattedNumber;
  }

  static String getCurrentCurrencySymbol() {
    final Map<String, String> currencySymbols = {
      'INR': '₹',
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'AUD': 'A\$',
      'CAD': 'C\$',
      'SGD': 'S\$',
      'AED': 'د.إ',
    };

    return currencySymbols[_currentCurrencyCode] ?? '₹';
  }

  static String getCurrentCurrencyCode() {
    return _currentCurrencyCode;
  }
}
