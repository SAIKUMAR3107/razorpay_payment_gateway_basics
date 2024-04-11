import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  var amount = TextEditingController();
  Razorpay _razorpay = Razorpay();
  bool helperText = false;

  void amountCheckOut(int checkOut) {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': checkOut * 100,
      'name': 'Saikumar Technologies Pvt Limited',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': '+91 7382054014',
        'email': 'saikumar241297@gmail.com'
      },
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await dialogBox(
        "Payment SuccessFul",
        "You have successfully done the Payment",
        response.paymentId!,
        Colors.green);
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    await dialogBox(
        "Payment Failed",
        "Your Payment was failed Due to following reason",
        response.message!,
        Colors.red);
  }

  void _handleExternalWallet(ExternalWalletResponse response) async {
    await dialogBox(
        "External Wallet",
        "Your External Wallet details are as follows : ",
        response.walletName!,
        Colors.yellow);
  }

  Future dialogBox(String paymentStatus, String paymentStatusDescription,
      String response, Color colorValue) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Payment details"),
        content: Container(
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 10, bottom: 10),
                color: colorValue,
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(width: 3, color: Colors.white)),
                      ),
                      Positioned(
                          top: 17,
                          left: MediaQuery.of(context).size.width / 3.6,
                          child: Icon(
                            Icons.done,
                            color: Colors.white,
                            weight: 40.0,
                            size: 45,
                          ))
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Icon(
                    Icons.done,
                    color: colorValue,
                    weight: 20.0,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    paymentStatus,
                    style: TextStyle(
                        color: colorValue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(paymentStatusDescription),
              SizedBox(
                height: 10,
              ),
              Text(response.startsWith("pay")
                  ? "Payment ID : $response"
                  : "$response")
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Ok"))
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Payment Gateway",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Razor Pay Payment Gate for S TAX",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: amount,
              validator: (value) {
                if (value!.isEmpty) {
                  helperText = true;
                }
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xffF67952))),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xffF67952))),
                  hintText: "Enter amount to pay",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                  helperText: !helperText ? "" : "Field should not be empty",
                  helperStyle: TextStyle(color: Colors.red),
                  prefixIconColor: Color(0xffF67952)),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width / 2,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (amount.text.isNotEmpty) {
                        int enteredAmount = int.parse(amount.text.toString());
                        amountCheckOut(enteredAmount);
                        helperText = false;
                        amount.clear();
                      } else {
                        helperText = true;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Field should not be empty"),
                        ));
                      }
                    });
                  },
                  child: Text("Click to pay"),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.green.shade600),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)))),
                ))
          ],
        ),
      ),
    );
  }
}
