import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:logger/logger.dart';
import 'package:nutrition/controllers/payment_controller.dart';
import 'package:nutrition/providers/auth/auth_provider.dart';
import 'package:nutrition/utils/alert_helper.dart';
import 'package:provider/provider.dart';

class PaymentProvider extends ChangeNotifier {
  //--payment conroller

  final PaymentController _paymentController = PaymentController();

  //----make payment
  Future<void> makePayment(
    BuildContext context,
    String coachUid,
    String coachToken,
  ) async {
    try {
      //---send payment intent req to stripe
      Map<String, dynamic>? paymentIntent = await _paymentController.createPaymentIntent("500");

      if (paymentIntent != null) {
        //-------initialize payment sheet
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent['client_secret'],
            style: ThemeMode.dark,
            merchantDisplayName: "nutrition",
          ),
        );

        //---show the payment sheet in order to enter card details
        await Stripe.instance.presentPaymentSheet().then(
          (value) {
            //----create the order here
            Logger().w("payment success");
            Provider.of<AuthProvider>(context, listen: false).savePaidUsers(
              coachUid,
              coachToken,
              context,
            );
          },
        );
      } else {
        // ignore: use_build_context_synchronously
        AlertHelper.showAlert(context, "Error", "Something went wrong !");
      }
    } on StripeException catch (e) {
      Logger().e(e);
    } catch (e) {
      Logger().e(e);
    }
  }
}
