import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nutrition/components/custom_button.dart';
import 'package:nutrition/model/user_model.dart';
import 'package:nutrition/providers/auth/auth_provider.dart';
import 'package:nutrition/providers/payments/payment_provider.dart';
import 'package:provider/provider.dart';

class AvailableCoacheslist extends StatefulWidget {
  const AvailableCoacheslist({super.key});

  @override
  State<AvailableCoacheslist> createState() => _AvailableCoacheslistState();
}

class _AvailableCoacheslistState extends State<AvailableCoacheslist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Coaches'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, value, child) {
          return value.isFetchingCoaches
              ? const SpinKitDoubleBounce(
                  color: Colors.green,
                  size: 60.0,
                )
              : value.coaches.isEmpty
                  ? const Center(
                      child: Text(
                        "No coaches yet",
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: value.coaches.length,
                      itemBuilder: (context, index) {
                        return CoachCard(model: value.coaches[index]);
                      },
                    );
        },
      ),
    );
  }
}

class CoachCard extends StatelessWidget {
  const CoachCard({
    super.key,
    required this.model,
  });

  final UserModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(4),
      height: 80,
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child: Column(
        children: [
          ListTile(
            title: Text(
              model.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            subtitle: Row(
              children: [
                const Icon(
                  Icons.phone,
                  size: 17,
                ),
                Text(model.phoneNumber),
              ],
            ),
            leading: const Image(
              image: AssetImage('assets/images/men.png'),
            ),
            trailing: IconButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Coachdetails(model: model)),
                )
              },
              icon: const Icon(
                Icons.forward_outlined,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//anothor screen
class Coachdetails extends StatefulWidget {
  const Coachdetails({
    super.key,
    required this.model,
  });

  final UserModel model;

  @override
  State<Coachdetails> createState() => _CoachdetailsState();
}

class _CoachdetailsState extends State<Coachdetails> {
  String message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Info'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 60),
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              widget.model.img,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.model.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.model.phoneNumber,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.email),
              const SizedBox(width: 10),
              Text(
                widget.model.email,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.phone),
              const SizedBox(width: 10),
              Text(
                widget.model.phoneNumber,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          CustomButton(
            text: "Pay Now to get service",
            isLoading: Provider.of<AuthProvider>(context).isLoading,
            onTap: () {
              Provider.of<PaymentProvider>(context, listen: false).makePayment(
                context,
                widget.model.uid,
                widget.model.token!,
              );
            },
          )
          // ElevatedButton(
          //   onPressed: () {
          //     // Navigator.of(context).push(
          //     //   MaterialPageRoute(
          //     //     builder: (BuildContext context) => UsePaypal(
          //     //         sandboxMode: true,
          //     //         clientId: "AW1TdvpSGbIM5iP4HJNI5TyTmwpY9Gv9dYw8_8yW5lYIbCqf326vrkrp0ce9TAqjEGMHiV3OqJM_aRT0",
          //     //         secretKey: "EHHtTDjnmTZATYBPiGzZC_AZUfMpMAzj2VZUeqlFUrRJA_C0pQNCxDccB5qoRQSEdcOnnKQhycuOWdP9",
          //     //         returnURL: Constants.returnURL,
          //     //         cancelURL: Constants.cancelURL,
          //     //         transactions: const [
          //     //           {
          //     //             "amount": {
          //     //               "total": '10.12',
          //     //               "currency": "USD",
          //     //               "details": {"subtotal": '10.12', "shipping": '0', "shipping_discount": 0}
          //     //             },
          //     //             "description": "The payment transaction description.",
          //     //             // "payment_options": {
          //     //             //   "allowed_payment_method":
          //     //             //       "INSTANT_FUNDING_SOURCE"
          //     //             // },
          //     //             "item_list": {
          //     //               "items": [
          //     //                 {"name": "A demo product", "quantity": 1, "price": '10.12', "currency": "USD"}
          //     //               ],

          //     //               // shipping address is not required though
          //     //               "shipping_address": {
          //     //                 "recipient_name": "Jane Foster",
          //     //                 "line1": "Travis County",
          //     //                 "line2": "",
          //     //                 "city": "Austin",
          //     //                 "country_code": "US",
          //     //                 "postal_code": "73301",
          //     //                 "phone": "+00000000",
          //     //                 "state": "Texas"
          //     //               },
          //     //             }
          //     //           }
          //     //         ],
          //     //         note: "Contact us for any questions on your order.",
          //     //         onSuccess: (Map params) async {
          //     //           print("onSuccess: $params");
          //     //           UtilFunctions.navigateTo(context, const Dashboard());
          //     //         },
          //     //         onError: (error) {
          //     //           print("onError: $error");
          //     //         },
          //     //         onCancel: (params) {
          //     //           print('cancelled: $params');
          //     //         }),
          //     //   ),
          //     // );

          //     Provider.of<AuthProvider>(context, listen: false).savePaidUsers(widget.model.uid, context);
          //   },
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: const Color(0xff14c38e),
          //     shape: const RoundedRectangleBorder(),
          //   ),
          //   child: const Text('Pay Now to get service'),
          // ),
        ],
      ),
    );
  }
}
