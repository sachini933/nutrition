import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class PaymentController {
  //-----create a payment function
  Future<Map<String, dynamic>?> createPaymentIntent(String amount) async {
    try {
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          //----All API requests expect amounts to be provided in a currency’s smallest unit.
          // For example, to charge 10 USD, provide an amount value of 1000 (that is, 1000 cents).

          //--minimum payment amount is = 0.50 USD === 182.00 LKR
          'amount': (int.parse(amount) * 100).toString(),
          'currency': 'LKR',
        },
      );

      Logger().i(response.body);

      return json.decode(response.body);
    } catch (e) {
      Logger().e(e);
      // throw Exception(e.toString());
      return null;
    }
  }
}
