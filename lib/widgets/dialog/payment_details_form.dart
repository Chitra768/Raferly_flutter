// import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/services.dart';
// import 'package:referaly/languages/languagekeys.dart';
// import 'package:referaly/resources/app_colors.dart';
// import 'package:referaly/resources/text_style.dart';
// import 'package:referaly/utils/translations.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:referaly/apis/rest_auth.dart';
// import 'package:referaly/apis/api_result.dart';
// import 'package:referaly/models/model_saved_card.dart';

// class PaymentDetailsForm extends StatefulWidget {
//   final String? totalAmount;
//   final String? currencySymbol;
//   final VoidCallback? onPaymentComplete;
//   final VoidCallback? onCancel;
//   final bool loadSavedCards; // Flag to control whether to load saved cards

//   const PaymentDetailsForm({
//     super.key,
//     this.totalAmount,
//     this.currencySymbol,
//     this.onPaymentComplete,
//     this.onCancel,
//     this.loadSavedCards =
//         true, // Default to true, set to false for "Change" button
//   });

//   @override
//   State<PaymentDetailsForm> createState() => _PaymentDetailsFormState();
// }

// class _PaymentDetailsFormState extends State<PaymentDetailsForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _cardNumberController = TextEditingController();
//   final _cardholderNameController = TextEditingController();
//   final _expiryDateController = TextEditingController();
//   final _cvvController = TextEditingController();

//   bool _isProcessing = false;
//   bool _isLoadingCards = true;
//   List<ModelSavedCard> _savedCards = [];
//   ModelSavedCard? _selectedCard;
//   bool _showNewCardForm = false;
//   bool _saveCardForFuture = true;

//   @override
//   void initState() {
//     super.initState();
//     // Only load saved cards if flag is true
//     if (widget.loadSavedCards) {
//       _loadSavedCards();
//     } else {
//       // For "Change" button scenario, show new card form directly
//       setState(() {
//         _isLoadingCards = false;
//         _showNewCardForm = true;
//         _savedCards = [];
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _cardNumberController.dispose();
//     _cardholderNameController.dispose();
//     _expiryDateController.dispose();
//     _cvvController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadSavedCards() async {
//     setState(() {
//       _isLoadingCards = true;
//     });

   

//   String _formatCardNumber(String value) {
//     // Remove all non-digits
//     final digitsOnly = value.replaceAll(RegExp(r'\D'), '');

//     // Add spaces every 4 digits
//     final buffer = StringBuffer();
//     for (int i = 0; i < digitsOnly.length; i++) {
//       if (i > 0 && i % 4 == 0) {
//         buffer.write(' ');
//       }
//       buffer.write(digitsOnly[i]);
//     }
//     return buffer.toString();
//   }

//   String _formatExpiryDate(String value) {
//     // Remove all non-digits
//     final digitsOnly = value.replaceAll(RegExp(r'\D'), '');

//     // Format as MM/YY
//     if (digitsOnly.length >= 2) {
//       return '${digitsOnly.substring(0, 2)}/${digitsOnly.substring(2)}';
//     }
//     return digitsOnly;
//   }

//   double _parseAmount(String? value) {
//     if (value == null || value.isEmpty) return 0;
//     // Remove currency symbol and parse
//     final sanitized =
//         value.replaceAll(',', '.').replaceAll(RegExp(r'[^\d.]'), '');
//     return double.tryParse(sanitized) ?? 0;
//   }

//   String _getCurrencyCode(String? symbol) {
//     // Map currency symbols to currency codes
//     switch (symbol) {
//       case '€':
//         return 'eur';
//       case '\$':
//         return 'usd';
//       case '£':
//         return 'gbp';
//       default:
//         return 'eur'; // Default to EUR
//     }
//   }

//   Future<Map<String, dynamic>?> _createPaymentIntent({
//     required int amount,
//     required String currency,
//   }) async {
//     try {
//       // NOTE: In production, this should be done on your backend server
//       // The secret key should NEVER be exposed in client-side code
//       final response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/payment_intents'),
//         headers: {
//           'Authorization':
//               'Bearer <STRIPE_SECRET_KEY>  // Use backend or env; never commit real key',
//           'Content-Type': 'application/x-www-form-urlencoded',
//         },
//         body: {
//           'amount': amount.toString(),
//           'currency': currency.toLowerCase(),
//           'payment_method_types[]': 'card',
//         },
//       );

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         throw Exception('Failed to create payment intent: ${response.body}');
//       }
//     } catch (e) {
//       debugPrint('Error creating payment intent: $e');
//       return null;
//     }
//   }

//   Future<void> _handlePayment() async {
//     // If using saved card, no need to validate form
//     if (_selectedCard == null && !_showNewCardForm && _savedCards.isNotEmpty) {
//       // User must select a card or add a new one (only if there are saved cards)
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please select a card or add a new one'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       return;
//     }

//     // If adding new card, validate form
//     if (_showNewCardForm || _savedCards.isEmpty) {
//       if (!_formKey.currentState!.validate()) {
//         return;
//       }
//     }

//     if (_isProcessing) return;

//     setState(() {
//       _isProcessing = true;
//     });

//     try {
//       // Parse amount from totalAmount string
//       final amount = _parseAmount(widget.totalAmount);
//       if (amount <= 0) {
//         throw Exception('Invalid amount');
//       }

//       // Convert amount to cents (Stripe uses smallest currency unit)
//       final amountInCents = (amount * 100).toInt();
//       final currency = _getCurrencyCode(widget.currencySymbol);

//       // Step 1: Create PaymentIntent to get client_secret
//       final paymentIntent = await _createPaymentIntent(
//         amount: amountInCents,
//         currency: currency,
//       );

//       if (paymentIntent == null) {
//         throw Exception('Failed to create payment intent');
//       }

//       final clientSecret = paymentIntent['client_secret'] as String?;
//       final paymentIntentId = paymentIntent['id'] as String?;
//       if (clientSecret == null || paymentIntentId == null) {
//         throw Exception('Invalid payment intent response');
//       }

//       // Step 2: Handle saved card or new card - Confirm payment with Stripe API
//       Map<String, dynamic> confirmedPaymentData;

//       if (_selectedCard != null && !_showNewCardForm) {
//         // Use saved card's payment method ID from backend
//         final paymentMethodId = _selectedCard!.paymentMethodId;
//         if (paymentMethodId == null || paymentMethodId.isEmpty) {
//           throw Exception('Saved card does not have a valid payment method ID');
//         }
//         debugPrint('💳 Using saved card from backend: $paymentMethodId');

//         // Confirm payment with saved card's payment method ID using Stripe API
//         final confirmResponse = await http.post(
//           Uri.parse(
//               'https://api.stripe.com/v1/payment_intents/$paymentIntentId/confirm'),
//           headers: {
//             'Authorization':
//                 'Bearer <STRIPE_SECRET_KEY>  // Use backend or env; never commit real key',
//             'Content-Type': 'application/x-www-form-urlencoded',
//           },
//           body: {
//             'payment_method': paymentMethodId,
//           },
//         );

//         if (confirmResponse.statusCode != 200) {
//           final errorData = jsonDecode(confirmResponse.body);
//           throw Exception(
//               'Failed to confirm payment: ${errorData['error']?['message'] ?? confirmResponse.body}');
//         }

//         confirmedPaymentData = jsonDecode(confirmResponse.body);
//       } else {
//         // For new card: Use Stripe SDK to create PaymentMethod and confirm payment
//         final expiryParts = _expiryDateController.text.split('/');
//         if (expiryParts.length != 2) {
//           throw Exception('Invalid expiry date format');
//         }

//         final month = int.tryParse(expiryParts[0]);
//         final year = int.tryParse('20${expiryParts[1]}');

//         if (month == null || year == null || month < 1 || month > 12) {
//           throw Exception('Invalid expiry date');
//         }

//         final cardNumberDigits =
//             _cardNumberController.text.replaceAll(RegExp(r'\D'), '');

//         debugPrint('💳 Processing payment with new card details...');
//         debugPrint(
//             '   Card Number: ****${cardNumberDigits.substring(cardNumberDigits.length - 4)}');
//         debugPrint('   Expiry: $month/$year');

//         // Step 1: Confirm payment directly with card details using Stripe API
//         // This is the correct way - confirm PaymentIntent with payment_method_data
//         debugPrint('💳 Confirming payment with card details directly...');
//         final confirmResponse = await http.post(
//           Uri.parse(
//               'https://api.stripe.com/v1/payment_intents/$paymentIntentId/confirm'),
//           headers: {
//             'Authorization':
//                 'Bearer <STRIPE_SECRET_KEY>  // Use backend or env; never commit real key',
//             'Content-Type': 'application/x-www-form-urlencoded',
//           },
//           body: {
//             'payment_method_data[type]': 'card',
//             'payment_method_data[card][number]': cardNumberDigits,
//             'payment_method_data[card][exp_month]': month.toString(),
//             'payment_method_data[card][exp_year]': year.toString(),
//             'payment_method_data[card][cvc]': _cvvController.text,
//             'payment_method_data[billing_details][name]':
//                 _cardholderNameController.text,
//             'return_url':
//                 'referaly://payment-return', // Required for some payment methods
//           },
//         );

//         if (confirmResponse.statusCode != 200) {
//           final errorData = jsonDecode(confirmResponse.body);
//           throw Exception(
//               'Failed to confirm payment: ${errorData['error']?['message'] ?? confirmResponse.body}');
//         }

//         confirmedPaymentData = jsonDecode(confirmResponse.body);
//       }

//       // ✅ Payment successful in Stripe - Show detailed logs
//       debugPrint('');
//       debugPrint('═══════════════════════════════════════════════════════════');
//       debugPrint('✅ ✅ ✅ PAYMENT SUCCESSFUL IN STRIPE ✅ ✅ ✅');
//       debugPrint('═══════════════════════════════════════════════════════════');
//       debugPrint('📋 Payment Details:');
//       debugPrint('   Payment Intent ID: ${confirmedPaymentData['id']}');
//       debugPrint('   Payment Status: ${confirmedPaymentData['status']}');
//       debugPrint(
//           '   Amount: ${confirmedPaymentData['amount']} ${confirmedPaymentData['currency']?.toString().toUpperCase()}');
//       debugPrint(
//           '   Payment Method ID: ${confirmedPaymentData['payment_method']}');
//       if (confirmedPaymentData['charges'] != null &&
//           confirmedPaymentData['charges']['data'] != null &&
//           (confirmedPaymentData['charges']['data'] as List).isNotEmpty) {
//         final charge = (confirmedPaymentData['charges']['data'] as List)[0];
//         debugPrint('   Charge ID: ${charge['id']}');
//         debugPrint('   Charge Status: ${charge['status']}');
//       }
//       debugPrint('═══════════════════════════════════════════════════════════');
//       debugPrint('');

//       // Get payment_method_id from Stripe response (this is the one we should save)
//       final stripePaymentMethodId =
//           confirmedPaymentData['payment_method'] as String?;

//       if (stripePaymentMethodId != null) {
//         debugPrint('📝 Payment Method ID from Stripe: $stripePaymentMethodId');

//         // Step 4: Save card to backend AFTER successful payment
//         // Only save if it's a new card and user opted to save it
//         if ((_showNewCardForm || _savedCards.isEmpty) && _saveCardForFuture) {
//           try {
//             debugPrint('💾 Saving card to backend after successful payment...');
//             debugPrint('   Endpoint: POST /payment-methods');
//             debugPrint(
//                 '   Body: {"payment_method_id": "$stripePaymentMethodId"}');

//             // final saveResult = await RESTAuth.saveCard(
//             //   paymentMethodId: stripePaymentMethodId,
//             // );

//             // if (saveResult is ApiSuccess) {
//             //   debugPrint('✅ Card saved successfully to backend');
//             //   // Reload saved cards to show the newly added card
//             //   if (widget.loadSavedCards) {
//             //     await _loadSavedCards();
//             //   }
//             // } else {
//             //   debugPrint(
//             //       '❌ Failed to save card: ${(saveResult as ApiFailure).error.message}');
//             //   // Don't fail payment if saving card fails - payment was successful
//             // }
//           } catch (e) {
//             debugPrint('❌ Error saving card to backend: $e');
//             // Don't fail payment if saving card fails - payment was successful
//           }
//         } else {
//           debugPrint(
//               'ℹ️ Card not saved (saved card used or user opted not to save)');
//         }
//       } else {
//         debugPrint('⚠️ Warning: No payment_method_id in Stripe response');
//       }

//       // Payment successful
//       if (mounted) {
//         setState(() {
//           _isProcessing = false;
//         });

//         // Show success message
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Payment successful!'),
//             backgroundColor: Colors.green,
//           ),
//         );

//         // Call completion callback with payment method ID
//         widget.onPaymentComplete?.call();
//       }
//     } on StripeException catch (e) {
//       if (mounted) {
//         setState(() {
//           _isProcessing = false;
//         });

//         String errorMessage = 'Payment failed';
//         if (e.error.message != null) {
//           errorMessage = e.error.message!;
//         }

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(errorMessage),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _isProcessing = false;
//         });

//         debugPrint('Payment error: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Payment failed: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF3F4F6), // Light grey background
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: AppColors.detailsTextColor),
//           onPressed: widget.onCancel ?? () => Navigator.of(context).pop(),
//         ),
//         title: Text(
//           'Payment Details',
//           style: stylePoppins(
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//             color: AppColors.detailsTextColor,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               // Payment Icon
//               Container(
//                 width: 44,
//                 height: 44,
//                 decoration: const BoxDecoration(
//                   color: AppColors.primary,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.credit_card,
//                   color: Colors.white,
//                   size: 22,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               // Title
//               Text(
//                 'Payment Details',
//                 style: stylePoppins(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.detailsTextColor,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               // Subtitle
//               Text(
//                 'Enter your card information to complete your purchase',
//                 style: stylePoppins(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w400,
//                   color: const Color(0xFF6B7280),
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 22),
//               // Saved Cards or New Card Form
//               if (_isLoadingCards)
//                 const Center(
//                   child: Padding(
//                     padding: EdgeInsets.all(20.0),
//                     child: CircularProgressIndicator(),
//                   ),
//                 )
//               else
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Saved Cards Section
//                       if (_savedCards.isNotEmpty && !_showNewCardForm) ...[
//                         Text(
//                           'Select Payment Method',
//                           style: stylePoppins(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: AppColors.detailsTextColor,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         const SizedBox(height: 16),
//                         // Add New Card Button
//                         TextButton.icon(
//                           onPressed: () {
//                             setState(() {
//                               _showNewCardForm = true;
//                               _selectedCard = null;
//                             });
//                           },
//                           icon: const Icon(Icons.add, color: AppColors.primary),
//                           label: Text(
//                             'Add New Card',
//                             style: stylePoppins(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.primary,
//                             ),
//                           ),
//                         ),
//                       ] else ...[
//                         // New Card Form
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               _savedCards.isEmpty
//                                   ? 'Card Information'
//                                   : 'Add New Card',
//                               style: stylePoppins(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 color: AppColors.detailsTextColor,
//                               ),
//                             ),
//                             if (_savedCards.isNotEmpty)
//                               TextButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     _showNewCardForm = false;
//                                     if (_savedCards.isNotEmpty) {
//                                       _selectedCard = _savedCards.first;
//                                     }
//                                   });
//                                 },
//                                 child: Text(
//                                   'Use Saved Card',
//                                   style: stylePoppins(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                     color: AppColors.primary,
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),
//                         Form(
//                           key: _formKey,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Card Number
//                               Text(
//                                 'Card Number',
//                                 style: stylePoppins(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                   color: AppColors.detailsTextColor,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               TextFormField(
//                                 controller: _cardNumberController,
//                                 keyboardType: TextInputType.number,
//                                 inputFormatters: [
//                                   FilteringTextInputFormatter.digitsOnly,
//                                   LengthLimitingTextInputFormatter(
//                                       19), // 16 digits + 3 spaces
//                                   TextInputFormatter.withFunction(
//                                       (oldValue, newValue) {
//                                     final formatted =
//                                         _formatCardNumber(newValue.text);
//                                     return TextEditingValue(
//                                       text: formatted,
//                                       selection: TextSelection.collapsed(
//                                         offset: formatted.length,
//                                       ),
//                                     );
//                                   }),
//                                 ],
//                                 decoration: InputDecoration(
//                                   hintText: '1234 5678 9012 3456',
//                                   hintStyle: stylePoppins(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w400,
//                                     color: AppColors.textTitleHint,
//                                   ),
//                                   filled: true,
//                                   fillColor: AppColors.whiteColor,
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                     borderSide: BorderSide.none,
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                     borderSide: const BorderSide(
//                                         color: AppColors.textTitleHint,
//                                         width: 1),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                     borderSide: const BorderSide(
//                                         color: AppColors.textTitleHint,
//                                         width: 1),
//                                   ),
//                                   suffixIcon: const Icon(
//                                     Icons.credit_card,
//                                     color: Color(0xFF9CA3AF),
//                                     size: 20,
//                                   ),
//                                 ),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter card number';
//                                   }
//                                   final digitsOnly =
//                                       value.replaceAll(RegExp(r'\D'), '');
//                                   if (digitsOnly.length < 13 ||
//                                       digitsOnly.length > 19) {
//                                     return 'Invalid card number';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                               const SizedBox(height: 20),
//                               // Cardholder Name
//                               Text(
//                                 'Cardholder Name',
//                                 style: stylePoppins(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                   color: AppColors.detailsTextColor,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               TextFormField(
//                                 controller: _cardholderNameController,
//                                 keyboardType: TextInputType.name,
//                                 textCapitalization: TextCapitalization.words,
//                                 decoration: InputDecoration(
//                                   hintText: 'Enter cardholder name',
//                                   hintStyle: stylePoppins(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w400,
//                                     color: AppColors.textTitleHint,
//                                   ),
//                                   filled: true,
//                                   fillColor: AppColors.whiteColor,
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                     borderSide: const BorderSide(
//                                         color: AppColors.textTitleHint,
//                                         width: 1),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                     borderSide: const BorderSide(
//                                         color: AppColors.textTitleHint,
//                                         width: 1),
//                                   ),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                     borderSide: BorderSide.none,
//                                   ),
//                                 ),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter cardholder name';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                               const SizedBox(height: 20),
//                               // Expiry Date and CVV Row
//                               Row(
//                                 children: [
//                                   // Expiry Date
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           tr(LanguageKeys.expires),
//                                           style: stylePoppins(
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w500,
//                                             color: AppColors.detailsTextColor,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 8),
//                                         TextFormField(
//                                           controller: _expiryDateController,
//                                           keyboardType: TextInputType.number,
//                                           inputFormatters: [
//                                             FilteringTextInputFormatter
//                                                 .digitsOnly,
//                                             LengthLimitingTextInputFormatter(
//                                                 5), // MM/YY
//                                             TextInputFormatter.withFunction(
//                                                 (oldValue, newValue) {
//                                               final formatted =
//                                                   _formatExpiryDate(
//                                                       newValue.text);
//                                               return TextEditingValue(
//                                                 text: formatted,
//                                                 selection:
//                                                     TextSelection.collapsed(
//                                                   offset: formatted.length,
//                                                 ),
//                                               );
//                                             }),
//                                           ],
//                                           decoration: InputDecoration(
//                                             hintText: 'MM/YY',
//                                             hintStyle: stylePoppins(
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.w400,
//                                               color: AppColors.textTitleHint,
//                                             ),
//                                             filled: true,
//                                             fillColor: AppColors.whiteColor,
//                                             enabledBorder: OutlineInputBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(8),
//                                               borderSide: const BorderSide(
//                                                   color:
//                                                       AppColors.textTitleHint,
//                                                   width: 1),
//                                             ),
//                                             focusedBorder: OutlineInputBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(8),
//                                               borderSide: const BorderSide(
//                                                   color:
//                                                       AppColors.textTitleHint,
//                                                   width: 1),
//                                             ),
//                                             border: OutlineInputBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(8),
//                                               borderSide: const BorderSide(
//                                                   color:
//                                                       AppColors.textTitleHint,
//                                                   width: 1),
//                                             ),
//                                           ),
//                                           validator: (value) {
//                                             if (value == null ||
//                                                 value.isEmpty) {
//                                               return 'Please enter expiry date';
//                                             }
//                                             if (!RegExp(r'^\d{2}/\d{2}$')
//                                                 .hasMatch(value)) {
//                                               return 'Invalid expiry date';
//                                             }
//                                             return null;
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   const SizedBox(width: 16),
//                                   // CVV
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'CVV',
//                                           style: stylePoppins(
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w500,
//                                             color: AppColors.detailsTextColor,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 8),
//                                         TextFormField(
//                                           controller: _cvvController,
//                                           keyboardType: TextInputType.number,
//                                           obscureText: true,
//                                           inputFormatters: [
//                                             FilteringTextInputFormatter
//                                                 .digitsOnly,
//                                             LengthLimitingTextInputFormatter(4),
//                                           ],
//                                           decoration: InputDecoration(
//                                             hintText: '123',
//                                             hintStyle: stylePoppins(
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.w400,
//                                               color: AppColors.textTitleHint,
//                                             ),
//                                             filled: true,
//                                             fillColor: AppColors.whiteColor,
//                                             enabledBorder: OutlineInputBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(8),
//                                               borderSide: const BorderSide(
//                                                   color:
//                                                       AppColors.textTitleHint,
//                                                   width: 1),
//                                             ),
//                                             focusedBorder: OutlineInputBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(8),
//                                               borderSide: const BorderSide(
//                                                   color:
//                                                       AppColors.textTitleHint,
//                                                   width: 1),
//                                             ),
//                                             border: OutlineInputBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(8),
//                                               borderSide: const BorderSide(
//                                                   color:
//                                                       AppColors.textTitleHint,
//                                                   width: 1),
//                                             ),
//                                             suffixIcon: IconButton(
//                                               icon: const Icon(
//                                                 Icons.help_outline,
//                                                 color: Color(0xFF9CA3AF),
//                                                 size: 20,
//                                               ),
//                                               onPressed: () {
//                                                 // Show CVV help dialog
//                                                 showDialog(
//                                                   context: context,
//                                                   builder: (context) =>
//                                                       AlertDialog(
//                                                     title: Text(
//                                                       'CVV',
//                                                       style: stylePoppins(
//                                                         fontSize: 16,
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                         color: AppColors
//                                                             .detailsTextColor,
//                                                       ),
//                                                     ),
//                                                     content: Text(
//                                                       'The CVV is the 3-4 digit number on the back of your card.',
//                                                       style: stylePoppins(
//                                                         fontSize: 14,
//                                                         fontWeight:
//                                                             FontWeight.w400,
//                                                         color: AppColors
//                                                             .detailsTextColor,
//                                                       ),
//                                                     ),
//                                                     actions: [
//                                                       TextButton(
//                                                         onPressed: () =>
//                                                             Navigator.pop(
//                                                                 context),
//                                                         child: Text(
//                                                           'OK',
//                                                           style: stylePoppins(
//                                                             fontSize: 14,
//                                                             fontWeight:
//                                                                 FontWeight.w600,
//                                                             color: AppColors
//                                                                 .primary,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 );
//                                               },
//                                             ),
//                                           ),
//                                           validator: (value) {
//                                             if (value == null ||
//                                                 value.isEmpty) {
//                                               return 'Please enter CVV';
//                                             }
//                                             if (value.length < 3 ||
//                                                 value.length > 4) {
//                                               return 'Invalid CVV';
//                                             }
//                                             return null;
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 24),
//                               // Security Message
//                               Container(
//                                 padding: const EdgeInsets.all(12),
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFFF0FDF4),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       width: 24,
//                                       height: 24,
//                                       decoration: const BoxDecoration(
//                                         color: Color(0xFF4CAF50),
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: const Icon(
//                                         Icons.check,
//                                         color: Colors.white,
//                                         size: 16,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 12),
//                                     Expanded(
//                                       child: Text(
//                                         'Your payment information is secure and encrypted',
//                                         style: stylePoppins(
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w500,
//                                           color: const Color(0xFF4CAF50),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(height: 16),
//                               // Save Card Checkbox (only for new cards)
//                               if (_showNewCardForm || _savedCards.isEmpty)
//                                 Row(
//                                   children: [
//                                     Checkbox(
//                                       value: _saveCardForFuture,
//                                       onChanged: (value) {
//                                         setState(() {
//                                           _saveCardForFuture = value ?? true;
//                                         });
//                                       },
//                                       activeColor: AppColors.primary,
//                                     ),
//                                     Expanded(
//                                       child: Text(
//                                         'Save card for future payments',
//                                         style: stylePoppins(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w400,
//                                           color: AppColors.detailsTextColor,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               const SizedBox(height: 24),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               const SizedBox(height: 24),
//               // Complete Payment Button
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: _isProcessing
//                           ? AppColors.primary.withOpacity(0.6)
//                           : AppColors.primary,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       elevation: 0,
//                     ),
//                     onPressed: _isProcessing ? null : _handlePayment,
//                     child: _isProcessing
//                         ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor:
//                                   AlwaysStoppedAnimation<Color>(Colors.white),
//                             ),
//                           )
//                         : Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Icon(
//                                 Icons.lock,
//                                 color: Colors.white,
//                                 size: 20,
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 'Complete Payment',
//                                 style: stylePoppins(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ],
//                           ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               // Payment Method Logos
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Visa
//                     Container(
//                       width: 48,
//                       height: 32,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF1434CB),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: const Center(
//                         child: Text(
//                           'VISA',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 10,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     // Mastercard
//                     Container(
//                       width: 48,
//                       height: 32,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(4),
//                         gradient: const LinearGradient(
//                           colors: [
//                             Color(0xFFEB001B),
//                             Color(0xFFF79E1B),
//                           ],
//                         ),
//                       ),
//                       child: const Center(
//                         child: Text(
//                           'MC',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 10,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     // American Express
//                     Container(
//                       width: 48,
//                       height: 32,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF006FCF),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: const Center(
//                         child: Text(
//                           'AMEX',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 9,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     // Discover
//                     Container(
//                       width: 48,
//                       height: 32,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFFF6000),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: const Center(
//                         child: Text(
//                           'DIS',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 9,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),
//               // Terms and Privacy Policy
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Text.rich(
//                   TextSpan(
//                     style: stylePoppins(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w400,
//                       color: const Color(0xFF6B7280),
//                     ),
//                     children: [
//                       const TextSpan(
//                         text: 'By completing this payment, you agree to our ',
//                       ),
//                       TextSpan(
//                         text: tr(LanguageKeys.termsOfService),
//                         style: stylePoppins(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                           color: AppColors.primary,
//                         ),
//                         recognizer: TapGestureRecognizer()
//                           ..onTap = () {
//                             // Navigate to Terms of Service
//                             // TODO: Implement navigation
//                           },
//                       ),
//                       const TextSpan(text: ' and '),
//                       TextSpan(
//                         text: tr(LanguageKeys.privacyPolicy),
//                         style: stylePoppins(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                           color: AppColors.primary,
//                         ),
//                         recognizer: TapGestureRecognizer()
//                           ..onTap = () {
//                             // Navigate to Privacy Policy
//                             // TODO: Implement navigation
//                           },
//                       ),
//                     ],
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSavedCardItem(ModelSavedCard card) {
//     final isSelected = _selectedCard?.id == card.id;

//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedCard = card;
//         });
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color:
//               isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected ? AppColors.primary : AppColors.grey300,
//             width: isSelected ? 2 : 1,
//           ),
//         ),
//         child: Row(
//           children: [
//             // Radio button
//             Container(
//               width: 20,
//               height: 20,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: isSelected ? AppColors.primary : AppColors.grey300,
//                   width: 2,
//                 ),
//                 color: isSelected ? AppColors.primary : Colors.transparent,
//               ),
//               child: isSelected
//                   ? const Icon(
//                       Icons.check,
//                       size: 12,
//                       color: Colors.white,
//                     )
//                   : null,
//             ),
//             const SizedBox(width: 16),
//             // Card Brand Logo
//             Container(
//               width: 40,
//               height: 24,
//               decoration: BoxDecoration(
//                 color: _getCardBrandColor(card.brand),
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: Center(
//                 child: Text(
//                   card.brandDisplayName,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             // Card Details
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     card.displayCardNumber,
//                     style: stylePoppins(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                       color: AppColors.detailsTextColor,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '${tr(LanguageKeys.expires)} ${card.displayExpiry}',
//                     style: stylePoppins(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w400,
//                       color: const Color(0xFF666666),
//                     ),
//                   ),
//                   if (card.cardholderName != null) ...[
//                     const SizedBox(height: 4),
//                     Text(
//                       card.cardholderName!,
//                       style: stylePoppins(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w400,
//                         color: const Color(0xFF666666),
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//             if (card.isDefault == true)
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: AppColors.primary.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Text(
//                   'Default',
//                   style: stylePoppins(
//                     fontSize: 10,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.primary,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Color _getCardBrandColor(String? brand) {
//     switch (brand?.toLowerCase()) {
//       case 'visa':
//         return const Color(0xFF1434CB);
//       case 'mastercard':
//         return const Color(0xFFEB001B); // Will use gradient in UI
//       case 'amex':
//       case 'american_express':
//         return const Color(0xFF006FCF);
//       case 'discover':
//         return const Color(0xFFFF6000);
//       default:
//         return AppColors.primary;
//     }
//   }
// }
