import 'package:country_code_picker/country_code_picker.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/auth_controller.dart';
import '../../../controller/localization_controller.dart';
import '../../../controller/splash_controller.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';
import '../../base/custom_snackbar.dart';
import '../../base/custom_text_field.dart';
import 'otp_enter_screen.dart';
import 'widget/code_picker_widget.dart';

class EnterPhoneScreen extends StatefulWidget {
  @override
  State<EnterPhoneScreen> createState() => _EnterPhoneScreenState();
}

class _EnterPhoneScreenState extends State<EnterPhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String? _countryDialCode;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _countryDialCode = Get.find<AuthController>().getUserCountryCode().isNotEmpty
        ? Get.find<AuthController>().getUserCountryCode()
        : CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone Number"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Enter Phone Number to Send OTP",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              CodePickerWidget(
                onChanged: (CountryCode countryCode) {
                  _countryDialCode = countryCode.dialCode!;
                },
                initialSelection: _countryDialCode != null
                    ? Get.find<AuthController>().getUserCountryCode().isNotEmpty
                    ? Get.find<AuthController>().getUserCountryCode()
                    : CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code!
                    : Get.find<LocalizationController>().locale.countryCode!,
                favorite: [
                  Get.find<AuthController>().getUserCountryCode().isNotEmpty
                      ? Get.find<AuthController>().getUserCountryCode()
                      : CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code!,
                ],
                showDropDownButton: true,
                padding: EdgeInsets.zero,
                showFlagMain: true,
                flagWidth: 30,
                dialogBackgroundColor: Theme.of(context).cardColor,
                textStyle: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
              Expanded(
                child: CustomTextField(
                  hintText: 'enter_mobile_no'.tr,
                  controller: _phoneController,
                  inputType: TextInputType.phone,
                  divider: false,
                ),
              ),
            ],
          ),
          _isLoading
              ? CircularProgressIndicator()
              : GetBuilder<AuthController>(builder: (authController) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              child: CustomButton(
                buttonText: "Send OTP",
                onPressed: () {
                  String _numberWithCountryCode = _countryDialCode! + _phoneController.text.trim();
                  if (_phoneController.text.isEmpty) {
                    showCustomSnackBar('Please enter your phone number');
                    return;
                  }

                  setState(() {
                    _isLoading = true;
                  });

                  authController.loginWithPhone(_numberWithCountryCode, false).then((value) {
                    if (value.isSuccess) {
                      authController.sendOtp(_numberWithCountryCode).then((val) {
                        setState(() {
                          _isLoading = false;
                        });
                        if (val.isSuccess) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EnterOtpScreen(val.message, _numberWithCountryCode),
                            ),
                          );
                        } else {
                          showCustomSnackBar(val.message);
                        }
                      });
                    } else {
                      setState(() {
                        _isLoading = false;
                      });
                      showCustomSnackBar(value.message);
                    }
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
