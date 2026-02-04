import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/data/model/response/zone_response_model.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_loader.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/screens/address/widget/address_widget.dart';
import 'package:efood_multivendor/view/screens/location/widget/permission_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class AccessLocationScreen extends StatelessWidget {
  final bool? fromSignUp;
  final bool? fromHome;
  final String? route;

  const AccessLocationScreen({
    Key? key,
    this.fromSignUp = false,
    this.fromHome = false,
    this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locationController = Get.find<LocationController>();
    final authController = Get.find<AuthController>();

    // Auto navigate if already has address
    if ((fromHome ?? false) == false &&
        locationController.getUserAddress() != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.dialog( CustomLoader(), barrierDismissible: false);
        locationController.autoNavigate(
          locationController.getUserAddress()!,
          fromSignUp ?? false,
          route ?? RouteHelper.accessLocation,
          route != null,
        );
      });
    }

    bool isLoggedIn = authController.isLoggedIn();
    if (isLoggedIn) {
      locationController.getAddressList();
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'set_location'.tr,
        isBackButtonExist: fromHome ?? false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: GetBuilder<LocationController>(
            builder: (locationController) {
              if (isLoggedIn) {
                if (locationController.addressList == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    locationController.addressList!.isNotEmpty
                        ? Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: locationController.addressList!.length,
                        itemBuilder: (context, index) {
                          AddressModel address =
                          locationController.addressList![index];
                          return Center(
                            child: SizedBox(
                              width: 700,
                              child: AddressWidget(
                                address: address,
                                fromAddress: false,
                                onTap: () {
                                  Get.dialog( CustomLoader(),
                                      barrierDismissible: false);
                                  locationController
                                      .saveAddressAndNavigate(
                                    address,
                                    fromSignUp ?? false,
                                    route ?? RouteHelper.accessLocation,
                                    route != null,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    )
                        : NoDataScreen(text: 'no_saved_address_found'.tr),
                    const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                    BottomButton(
                      locationController: locationController,
                      fromSignUp: fromSignUp ?? false,
                      route: route,
                    ),
                  ],
                );
              } else {
                return Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Center(
                      child: SizedBox(
                        width: 700,
                        child: Column(
                          children: [
                            Image.asset(Images.delivery_location, height: 220),
                            const SizedBox(
                                height: Dimensions.PADDING_SIZE_LARGE),
                            Text(
                              'find_restaurants_and_foods'
                                  .tr
                                  .toUpperCase(),
                              textAlign: TextAlign.center,
                              style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeExtraLarge,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(
                                  Dimensions.PADDING_SIZE_LARGE),
                              child: Text(
                                'by_allowing_location_access'.tr,
                                textAlign: TextAlign.center,
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).disabledColor,
                                ),
                              ),
                            ),
                            const SizedBox(
                                height: Dimensions.PADDING_SIZE_LARGE),
                            BottomButton(
                              locationController: locationController,
                              fromSignUp: fromSignUp ?? false,
                              route: route,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class BottomButton extends StatelessWidget {
  final LocationController locationController;
  final bool fromSignUp;
  final String? route;

  const BottomButton({
    Key? key,
    required this.locationController,
    required this.fromSignUp,
    this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 700,
        child: Column(
          children: [
            CustomButton(
              buttonText: 'user_current_location'.tr,
              onPressed: () async {
                _checkPermission(() async {
                  Get.dialog( CustomLoader(), barrierDismissible: false);
                  AddressModel address =
                  await locationController.getCurrentLocation(true);
                  ZoneResponseModel response = await locationController.getZone(
                    address.latitude!,
                    address.longitude!,
                    false,
                  );
                  if (response.isSuccess ?? false) {
                    locationController.saveAddressAndNavigate(
                      address,
                      fromSignUp,
                      route ?? RouteHelper.accessLocation,
                      route != null,
                    );
                  } else {
                    Get.back();
                    Get.toNamed(
                      RouteHelper.getPickMapRoute(
                        fromSignUp: fromSignUp,
                        fromAddAddress: true,
                        canRoute: route != null,
                        route: route ?? RouteHelper.accessLocation,
                      ),
                    );
                    showCustomSnackBar(
                        'service_not_available_in_current_location'.tr);
                  }
                });
              },
              icon: Icons.my_location,
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 2,
                    color: Theme.of(context).primaryColor,
                  ),
                  borderRadius:
                  BorderRadius.circular(Dimensions.RADIUS_SMALL),
                ),
                minimumSize: const Size(Dimensions.WEB_MAX_WIDTH, 50),
                padding: EdgeInsets.zero,
              ),
              onPressed: () =>  Get.toNamed(
                  RouteHelper.getPickMapRoute(
                    fromSignUp: false,
                    fromAddAddress: false,
                    canRoute: false,
                    route: 'add-address',
                  ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        right: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    child: Icon(Icons.map,
                        color: Theme.of(context).primaryColor),
                  ),
                  Text(
                    'set_from_map'.tr,
                    textAlign: TextAlign.center,
                    style: robotoBold.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: Dimensions.fontSizeLarge,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkPermission(Function onTap) async {
    await Geolocator.requestPermission();
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      showCustomSnackBar('you_have_to_allow'.tr);
    } else if (permission == LocationPermission.deniedForever) {
      Get.dialog( PermissionDialog());
    } else {
      onTap();
    }
  }
}
