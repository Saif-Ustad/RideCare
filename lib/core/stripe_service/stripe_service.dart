import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeService {
  static const _secretKey =
      'sk_test_51RD0HWSDKFrBGSJ1ry3xT49Bivw8KTDfreEUGFQpdsEr17ESdcprJpEbqzliYRcZR3OJMAEwcpBgHYtxZn9xyn1R00T08DMbrd'; // Use your test secret key
  static const _endpoint = 'https://api.stripe.com/v1/payment_intents';

  Future<void> init() async {
    Stripe.publishableKey =
        'pk_test_51RD0HWSDKFrBGSJ1WRefaEF9GKB6CjaROPk0Kl9MNPJ6K9b7mdhTcCiFcrg3dLkzJb4iUfdmO3YBIZhG0hgjWwt800vQPuOFvA'; // Use your test publishable key
    await Stripe.instance.applySettings();
  }

  Future<PaymentIntentResult> createPaymentIntent(
    double amount,
    String currency,
    String? customerId,
  ) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Authorization': 'Bearer $_secretKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'amount': (amount * 100).toInt().toString(),
        'currency': currency,
        'payment_method_types[]': 'card',
        'description': 'Payment for Services Booked',
        'setup_future_usage': 'off_session',
        if (customerId != null) 'customer': customerId,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create PaymentIntent: ${response.body}');
    }

    final json = jsonDecode(response.body);
    return PaymentIntentResult(clientSecret: json['client_secret']);
  }

  Future<void> makePayment({
    required double amount,
    required String? customerId,
    required String? ephemeralKeySecret,
  }) async {
    try {
      final intent = await createPaymentIntent(amount, 'inr', customerId);

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: intent.clientSecret,
          merchantDisplayName: 'RideCare',
          customerId: customerId,
          customerEphemeralKeySecret: ephemeralKeySecret,
          style: ThemeMode.light,
          billingDetailsCollectionConfiguration:
              BillingDetailsCollectionConfiguration(
                name: CollectionMode.always,
                address: AddressCollectionMode.full,
              ),
        ),
      );

      // Present the payment sheet to the user
      await Stripe.instance.presentPaymentSheet();
      print('Payment successful');
    } catch (e) {
      print('Error during payment: $e');
      rethrow;
    }
  }
}

class PaymentIntentResult {
  final String clientSecret;

  PaymentIntentResult({required this.clientSecret});
}
