import 'dart:convert';
import 'package:http/http.dart' as http;

class StripeCustomer {
  static const _secretKey =
      'sk_test_51RD0HWSDKFrBGSJ1ry3xT49Bivw8KTDfreEUGFQpdsEr17ESdcprJpEbqzliYRcZR3OJMAEwcpBgHYtxZn9xyn1R00T08DMbrd'; // YOUR TEST SECRET KEY

  Future<String?> createStripeCustomer({
    required String name,
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/customers'),
      headers: {
        'Authorization': 'Bearer $_secretKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'name': name,
        'email': email,
        'description': 'Test customer for Flutter',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['id'];
    } else {
      print('Failed to create customer: ${response.body}');
      return null;
    }
  }

  Future<String?> createEphemeralKey(String customerId) async {
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/ephemeral_keys'),
      headers: {
        'Authorization': 'Bearer $_secretKey',
        'Stripe-Version': '2023-10-16',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'customer': customerId,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['secret'];
    } else {
      throw Exception('Failed to create ephemeral key: ${response.body}');
    }
  }


  // Fetch customer by email
  Future<String?> getCustomerByEmail(String email) async {
    final response = await http.get(
      Uri.parse('https://api.stripe.com/v1/customers?email=$email'),
      headers: {
        'Authorization': 'Bearer $_secretKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['data'].isNotEmpty) {
        return json['data'][0]['id'];
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to fetch customer: ${response.body}');
    }
  }
}
