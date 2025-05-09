import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

class InAppPurchaseService {
  static final InAppPurchaseService _instance =
      InAppPurchaseService._internal();
  factory InAppPurchaseService() => _instance;
  InAppPurchaseService._internal();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  SKPaymentQueueWrapper? _paymentQueue;

  // Product IDs
  static const String monthlySubscription = 'com.referaly.monthly';
  static const String yearlySubscription = 'com.referaly.yearly';

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
        monthlySubscription,
        yearlySubscription,
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
    // Here you would typically verify the purchase with your backend
    // For now, we'll just mark it as verified
    debugPrint('Purchase verified: ${purchaseDetails.productID}');
  }

  Future<void> buySubscription(String productId) async {
    if (!_isAvailable) {
      debugPrint('Store not available');
      return;
    }

    try {
      final product = _products.firstWhere(
        (element) => element.id == productId,
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
