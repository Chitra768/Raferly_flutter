import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/models/model_profile.dart';
import 'package:referaly/models/model_subscription.dart' show SubscriptionModel;
import 'package:referaly/resources/app_preference.dart';

class InAppPurchaseService {
  static final InAppPurchaseService _instance =
      InAppPurchaseService._internal();
  factory InAppPurchaseService() => _instance;
  InAppPurchaseService._internal();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  SKPaymentQueueWrapper? _paymentQueue;

  // Product IDs
  static const String androidMonthlyAgencySubscription = 'referaly_agency_monthly';
  static const String androidYearlyAgencySubscription = 'referaly_agency_yearly';
  static const String androidMonthlySubscription = 'com.referaly.app.monthly_60';
  static const String androidYearlySubscription = 'com.referaly.app.annual_540';
  static const String iosMonthlyAgenySubscription = 'referaly_agency_monthly';
  static const String iosYearlyAgenySubscription = 'referaly_agency_yearly';
  static const String iosMonthlySubscription = 'com.referaly.app.monthly_60';
  static const String iosYearlySubscription = 'com.referaly.app.annual_540';

  // Add callback for purchase status
  Function(bool success, String? error)? onPurchaseStatusChanged;

  String getMonthlySubscriptionId() {
    return Platform.isIOS ? iosMonthlySubscription :
   androidMonthlySubscription;
  }


  String getYearlyAgencySubscriptionId() {
    return Platform.isIOS ? iosYearlyAgenySubscription:
   androidYearlyAgencySubscription;
  }
  String getMonthlyAgencySubscriptionId() {
    return Platform.isIOS ? iosMonthlyAgenySubscription :
    androidMonthlyAgencySubscription;
  }


  String getYearlySubscriptionId() {
    return Platform.isIOS ? iosYearlySubscription :
    androidYearlySubscription;
  }

  Future<void> initialize() async {
    try {
      _isAvailable = await _inAppPurchase.isAvailable();
      debugPrint('Store availability: $_isAvailable');

      if (!_isAvailable) {
        debugPrint('Store not available. Please check:');
        debugPrint('1. Device has Google Play Store installed (Android)');
        debugPrint('2. Device is signed in to Google Play Store (Android)');
        debugPrint('3. Device is signed in to App Store (iOS)');
        debugPrint(
            '4. App is properly configured in Play Console/App Store Connect');
        return;
      }

      if (Platform.isIOS) {
        final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
            _inAppPurchase
                .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();

        // Set up StoreKit delegate
        final delegate = StoreKitDelegate();
        await iosPlatformAddition.setDelegate(delegate);
        debugPrint('iOS in-app purchase delegate set');

        // Initialize payment queue
        _paymentQueue = SKPaymentQueueWrapper();
        debugPrint('Payment queue initialized');
      }

      _subscription = _inAppPurchase.purchaseStream.listen(
        _handlePurchaseUpdates,
        onDone: () {
          debugPrint('Purchase stream closed');
          _subscription?.cancel();
        },
        onError: (error) {
          debugPrint('Error in purchase stream: $error');
        },
      );
      debugPrint('Purchase stream listener set up');

      await loadProducts();
      debugPrint('Products loaded: ${_products.length}');
    } catch (e, stackTrace) {
      debugPrint('Error initializing in-app purchase: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  Future<void> loadProducts() async {
    if (!_isAvailable) {
      debugPrint('Cannot load products: Store not available');
      return;
    }

    try {
      final Set<String> ids = <String>{
        getMonthlySubscriptionId(),
        getYearlySubscriptionId(),
        getMonthlyAgencySubscriptionId(),
        getYearlyAgencySubscriptionId(),
      };

      debugPrint('Querying products with IDs: $ids');
      final ProductDetailsResponse response =
          await _inAppPurchase.queryProductDetails(ids);

      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('Products not found: ${response.notFoundIDs}');
        debugPrint(
            'Please check if these product IDs are properly configured in:');
        debugPrint('- Google Play Console (Android)');
        debugPrint('- App Store Connect (iOS)');
      }

      if (response.error != null) {
        debugPrint('Error querying products: ${response.error}');
      }

      _products = response.productDetails;
      debugPrint('Successfully loaded ${_products.length} products');
      for (var product in _products) {
        debugPrint(
            'Product: ${product.id} - ${product.title} - ${product.price}');
      }
    } catch (e, stackTrace) {
      debugPrint('Error loading products: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  Future<void> _handlePurchaseUpdates(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        debugPrint('Purchase pending');
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        debugPrint('Purchase error: ${purchaseDetails.error}');
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        await _verifyPurchase(purchaseDetails);
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  Future<void> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    try {
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        // Verify the purchase with your backend
        // TODO: Add your backend verification logic here

        await updateSubscription(
          amount: "7700.00", // Fixed amount for monthly subscription
          receipt: purchaseDetails.verificationData.localVerificationData,
          device_type: Platform.isIOS ? 'IOS' : 'ANDROID',
          currency: 'INR',
          product_id: purchaseDetails.productID,
        );

        // Log the purchase details for debugging
        debugPrint('Purchase Details:');
        debugPrint('Product ID: ${purchaseDetails.productID}');
        debugPrint('Transaction Date: ${purchaseDetails.transactionDate}');
        debugPrint(
            'Verification Data: ${purchaseDetails.verificationData.localVerificationData}');

        // Notify about successful purchase
        onPurchaseStatusChanged?.call(true, null);
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        debugPrint('Purchase failed: ${purchaseDetails.error}');
        onPurchaseStatusChanged?.call(false, purchaseDetails.error?.message);
      } else if (purchaseDetails.status == PurchaseStatus.restored) {
        debugPrint(
            'Purchase restored for product: ${purchaseDetails.productID}');
        onPurchaseStatusChanged?.call(true, null);
      }
    } catch (e) {
      debugPrint('Error verifying purchase: $e');
      onPurchaseStatusChanged?.call(false, e.toString());
    }
  }

  Future<void> buySubscription(String productId) async {
    if (!_isAvailable) {
      debugPrint('Store not available');
      onPurchaseStatusChanged?.call(false, 'Store not available');
      return;
    }

    try {
      final product = _products.firstWhere(
        (element) => element.id == productId,
        orElse: () => throw Exception('Product not found'),
      );

      if (Platform.isIOS) {
        // For iOS, we need to handle the purchase through StoreKit
        final payment = SKPaymentWrapper(productIdentifier: product.id);
        await _paymentQueue?.addPayment(payment);
        debugPrint('Payment added to queue for product: ${product.id}');
      } else {
        final PurchaseParam purchaseParam = PurchaseParam(
          productDetails: product,
        );
        await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      }
    } catch (e) {
      debugPrint('Error buying subscription: $e');
      onPurchaseStatusChanged?.call(false, e.toString());
    }
  }
  Future<void> getProfile() async {
    try {
   

      final response = await RESTAuth.getProfile();

      if (response is ApiSuccess<ModelProfile>) {
        if (response.data.status == true) {
                    await AppPreference.writeString(
              AppPreference.isPaid, response.data.data!.isPaid.toString());
          await AppPreference.writeString(AppPreference.productId,
              response.data.data!.productId.toString());
        } else {
        }
      } else if (response is ApiFailure) {
      }
    } catch (e) {
    }
  }
  Future<SubscriptionModel> updateSubscription(
      {required String amount,
      required String receipt,
      required String device_type,
      required String currency,
      required String product_id}) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await RESTAuth.updateSubscription(
        amount: amount,
        receipt: receipt,
        device_type: device_type,
        currency: currency,
        product_id: product_id,
      );

      if (response.status == true) {
        // Show success message
        Get.snackbar(
          'Success',
          response.message ?? '',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
          getProfile();
        return response.data as SubscriptionModel;
      } else {
        errorMessage.value = response.message ?? '';
        return SubscriptionModel(
          status: false,
          message: response.message ?? 'Subscription update failed',
        );
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      return SubscriptionModel(
        status: false,
        message: 'An unexpected error occurred',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void dispose() {
    if (Platform.isIOS) {
      _paymentQueue?.setDelegate(null);
    }
    _subscription?.cancel();
  }
}

class StoreKitDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    debugPrint('Transaction: ${transaction.transactionIdentifier}');
    debugPrint('Storefront: ${storefront.identifier}');
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
