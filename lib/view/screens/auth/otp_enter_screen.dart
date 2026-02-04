import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/auth_controller.dart';
import '../../../helper/route_helper.dart';

class EnterOtpScreen extends StatefulWidget {
  final String? otp;
  final String? phone;

  const EnterOtpScreen(this.otp, this.phone);

  @override
  State<EnterOtpScreen> createState() => _EnterOtpScreenState();
}

class _EnterOtpScreenState extends State<EnterOtpScreen> {
  var textEditingController = TextEditingController();
  String? currentText;
  bool? _isLoading = false;
  String ?newOtp;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newOtp = widget.otp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify Phone Number"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Enter OTP to Verify",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: TextFormField(
              controller: textEditingController,
              maxLength: 4,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(

                border: OutlineInputBorder(),
                counterText: '',
              ),
            ),
          ),
          _isLoading!
              ? CircularProgressIndicator()
              : GetBuilder<AuthController>(builder: (authController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: CustomButton(
                    buttonText: "Verify OTP",
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });
                      String _numberWithCountryCode = widget.phone!;
                      if (newOtp == textEditingController.text) {
                        authController
                            .loginWithPhone(_numberWithCountryCode, true)
                            .then((status) {
                          setState(() {
                            _isLoading = false;
                          });
                          if (status.isSuccess) {
                            Get.toNamed(RouteHelper.getAccessLocationRoute('sign-in'));
                          } else {
                            showCustomSnackBar(status.message);
                          }
                        });
                      } else {
                        setState(() {
                          _isLoading = false;
                        });
                        showCustomSnackBar("Wrong OTP");
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: CustomButton(
                    buttonText: "Resend OTP",
                    onPressed: () {
                      authController.sendOtp(widget.phone!).then((status) {
                        if (status.isSuccess) {
                          newOtp = status.message;
                          showCustomSnackBar("OTP Resent", isError: false);
                        } else {
                          showCustomSnackBar(status.message);
                        }
                      });
                    },
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
