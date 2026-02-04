import 'dart:io';

import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/cuisine_controller.dart';
import 'package:efood_multivendor/data/model/body/restaurant_body.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:efood_multivendor/view/screens/auth/widget/registration_stepper_widget.dart';
import 'package:efood_multivendor/view/screens/auth/widget/select_location_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantRegistrationScreen extends StatefulWidget {
  const RestaurantRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantRegistrationScreen> createState() =>
      _RestaurantRegistrationScreenState();
}

class _RestaurantRegistrationScreenState
    extends State<RestaurantRegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _vatController = TextEditingController();
  final TextEditingController _minTimeController = TextEditingController();
  final TextEditingController _maxTimeController = TextEditingController();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _fssaiController = TextEditingController();
  final TextEditingController _fssaiDateController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _bankBranchController = TextEditingController();
  final TextEditingController _bankHolderNameController =
      TextEditingController();
  final TextEditingController _accountNoController = TextEditingController();
  TextEditingController _c = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _vatFocus = FocusNode();
  final FocusNode _minTimeFocus = FocusNode();
  final FocusNode _maxTimeFocus = FocusNode();
  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _fssaiFocus = FocusNode();
  final FocusNode _panFocus = FocusNode();
  final FocusNode _gstInFocus = FocusNode();
  final FocusNode _fssaiDateFocus = FocusNode();
  final FocusNode _bankNameFocus = FocusNode();
  final FocusNode _bankBranchFocus = FocusNode();
  final FocusNode _bankHolderNameFocus = FocusNode();
  final FocusNode _accountNoFocus = FocusNode();
  final bool _canBack = false;
  bool gstValue = false;

  @override
  void initState() {
    super.initState();
    Get.find<AuthController>().getZoneList();
    Get.find<CuisineController>().getCuisineList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return WillPopScope(
        onWillPop: () async {
          if (_canBack) {
            return true;
          } else {
            authController
                .showBackPressedDialogue('your_registration_not_setup_yet'.tr);
            return false;
          }
        },
        child: Scaffold(
          appBar: CustomAppBar(
              title: 'restaurant_registration'.tr,
              onBackPressed: () => authController.showBackPressedDialogue(
                  'your_registration_not_setup_yet'.tr)),
          body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
            Center(
              child: SizedBox(
                width: Dimensions.WEB_MAX_WIDTH,
                child: RegistrationStepperWidget(status: '0'),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                child: Center(
                  child: SizedBox(
                    width: Dimensions.WEB_MAX_WIDTH,
                    child: Column(children: [
                      CustomTextField(
                        hintText: 'restaurant_name'.tr,
                        controller: _nameController,
                        focusNode: _nameFocus,
                        nextFocus: _addressFocus,
                        inputType: TextInputType.name,
                        capitalization: TextCapitalization.words,
                        showTitle: true,
                      ),

                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                      CustomTextField(
                        hintText: 'restaurant_address'.tr,
                        controller: _addressController,
                        focusNode: _addressFocus,
                        nextFocus: _vatFocus,
                        inputType: TextInputType.text,
                        capitalization: TextCapitalization.sentences,
                        maxLines: 3,
                        showTitle: true,
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                      CustomTextField(
                        hintText: "GST %",
                        controller: _vatController,
                        focusNode: _vatFocus,
                        nextFocus: _minTimeFocus,
                        inputType: TextInputType.number,
                        isAmount: true,
                        showTitle: true,
                      ),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'cuisine'.tr,
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall),
                        ),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      GetBuilder<CuisineController>(
                          builder: (cuisineController) {
                        List<int> _cuisines = [];
                        if (cuisineController.cuisineModel != null) {
                          for (int index = 0;
                              index <
                                  cuisineController
                                      .cuisineModel!.cuisines!.length;
                              index++) {
                            if (cuisineController
                                        .cuisineModel!.cuisines![index].status ==
                                    1 &&
                                !cuisineController.selectedCuisines!
                                    .contains(index)) {
                              _cuisines.add(index);
                            }
                          }
                        }
                        return Column(children: [
                          Autocomplete<int>(
                            optionsBuilder: (TextEditingValue value) {
                              if (value.text.isEmpty) {
                                return Iterable<int>.empty();
                              } else {
                                return _cuisines.where((cuisine) =>
                                    cuisineController
                                        .cuisineModel!.cuisines![cuisine].name!
                                        .toLowerCase()
                                        .contains(value.text.toLowerCase()));
                              }
                            },
                            fieldViewBuilder:
                                (context, controller, node, onComplete) {
                              _c = controller;
                              return Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.RADIUS_SMALL),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors
                                            .grey[Get.isDarkMode ? 800 : 200]!,
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 5))
                                  ],
                                ),
                                child: TextField(
                                  controller: controller,
                                  focusNode: node,
                                  onEditingComplete: () {
                                    onComplete();
                                    controller.text = '';
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'cuisine'.tr,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.RADIUS_SMALL),
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              );
                            },
                            displayStringForOption: (value) => cuisineController
                                .cuisineModel!.cuisines![value].name!,
                            onSelected: (int value) {
                              _c.text = '';
                              cuisineController.setSelectedCuisineIndex(
                                  value, true);
                              //_addons.removeAt(value);
                            },
                          ),
                          SizedBox(
                              height:
                                  cuisineController.selectedCuisines!.length > 0
                                      ? Dimensions.PADDING_SIZE_SMALL
                                      : 0),
                          SizedBox(
                            height:
                                cuisineController.selectedCuisines!.length > 0
                                    ? 40
                                    : 0,
                            child: ListView.builder(
                              itemCount:
                                  cuisineController.selectedCuisines!.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.only(
                                      left:
                                          Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  margin: EdgeInsets.only(
                                      right: Dimensions.PADDING_SIZE_SMALL),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.RADIUS_SMALL),
                                  ),
                                  child: Row(children: [
                                    Text(
                                      cuisineController
                                          .cuisineModel!
                                          .cuisines![cuisineController
                                              .selectedCuisines![index]]
                                          .name!,
                                      style: robotoRegular.copyWith(
                                          color: Theme.of(context).cardColor),
                                    ),
                                    InkWell(
                                      onTap: () => cuisineController
                                          .removeCuisine(index),
                                      child: Padding(
                                        padding: EdgeInsets.all(Dimensions
                                            .PADDING_SIZE_EXTRA_SMALL),
                                        child: Icon(Icons.close,
                                            size: 15,
                                            color: Theme.of(context).cardColor),
                                      ),
                                    ),
                                  ]),
                                );
                              },
                            ),
                          ),
                        ]);
                      }),

                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                      // Row(children: [
                      //   Expanded(
                      //       child: CustomTextField(
                      //     hintText: 'minimum_delivery_time'.tr,
                      //     controller: _minTimeController,
                      //     focusNode: _minTimeFocus,
                      //     nextFocus: _maxTimeFocus,
                      //     inputType: TextInputType.number,
                      //     isNumber: true,
                      //     showTitle: true,
                      //   )),
                      //   SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                      //   Expanded(
                      //       child: CustomTextField(
                      //     hintText: 'maximum_delivery_time'.tr,
                      //     controller: _maxTimeController,
                      //     focusNode: _maxTimeFocus,
                      //     inputType: TextInputType.number,
                      //     isNumber: true,
                      //     inputAction: TextInputAction.done,
                      //     showTitle: true,
                      //   )),
                      // ]),
                      // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                      Text(
                        'logo'.tr,
                        style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall),
                      ),
                      const SizedBox(
                          height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Align(
                          alignment: Alignment.center,
                          child: Stack(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.RADIUS_SMALL),
                              child: authController.pickedLogo != null
                                  ? GetPlatform.isWeb
                                      ? Image.network(
                                          authController.pickedLogo!.path,
                                          width: 150,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          File(authController.pickedLogo!.path),
                                          width: 150,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        )
                                  : Image.asset(
                                      Images.placeholder,
                                      width: 150,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              top: 0,
                              left: 0,
                              child: InkWell(
                                onTap: () =>
                                    authController.pickImage("logo", false),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.RADIUS_SMALL),
                                    border: Border.all(
                                        width: 1,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(25),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2, color: Colors.white),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.camera_alt,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ])),
                      const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                      Text(
                        'cover_photo'.tr,
                        style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall),
                      ),
                      const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      Stack(children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(Dimensions.RADIUS_SMALL),
                          child: authController.pickedCover != null
                              ? GetPlatform.isWeb
                                  ? Image.network(
                                      authController.pickedCover!.path,
                                      width: context.width,
                                      height: 170,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(authController.pickedCover!.path),
                                      width: context.width,
                                      height: 170,
                                      fit: BoxFit.cover,
                                    )
                              : Image.asset(
                                  Images.placeholder,
                                  width: context.width,
                                  height: 170,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          top: 0,
                          left: 0,
                          child: InkWell(
                            onTap: () =>
                                authController.pickImage("cover_photo", false),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(
                                    Dimensions.RADIUS_SMALL),
                                border: Border.all(
                                    width: 1,
                                    color: Theme.of(context).primaryColor),
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 3, color: Colors.white),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt,
                                    color: Colors.white, size: 50),
                              ),
                            ),
                          ),
                        ),
                      ]),
                      const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                      //Fssai
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'fssai_details'.tr,
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall),
                          ),
                        ),
                      ),
                      const SizedBox(
                          height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Text(
                        'fssai'.tr,
                        style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall),
                      ),
                      const SizedBox(
                          height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Stack(children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(Dimensions.RADIUS_SMALL),
                          child: authController.pickedFssai != null
                              ? GetPlatform.isWeb
                                  ? Image.network(
                                      authController.pickedFile!.path,
                                      width: context.width,
                                      height: 170,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(authController.pickedFssai!.path),
                                      width: context.width,
                                      height: 170,
                                      fit: BoxFit.cover,
                                    )
                              : Image.asset(
                                  Images.placeholder,
                                  width: context.width,
                                  height: 170,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          top: 0,
                          left: 0,
                          child: InkWell(
                            onTap: () =>
                                authController.pickImage("fssai", false),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(
                                    Dimensions.RADIUS_SMALL),
                                border: Border.all(
                                    width: 1,
                                    color: Theme.of(context).primaryColor),
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 3, color: Colors.white),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt,
                                    color: Colors.white, size: 50),
                              ),
                            ),
                          ),
                        ),
                      ]),
                      const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                DateTime? now = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2050));
                                if (now != null) {
                                  _fssaiDateController.text =
                                      "${now.day}-${now.month}-${now.year}";
                                }
                              },
                              child: CustomTextField(
                                hintText: 'fssai_expire_date'.tr,
                                isEnabled: false,
                                controller: _fssaiDateController,
                                focusNode: _fssaiDateFocus,
                                nextFocus: _fssaiFocus,
                                inputType: TextInputType.name,
                                capitalization: TextCapitalization.words,
                                showTitle: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                          Expanded(
                            child: CustomTextField(
                              hintText: 'enter_fssai'.tr,
                              controller: _fssaiController,
                              focusNode: _fssaiFocus,
                              inputType: TextInputType.name,
                              capitalization: TextCapitalization.words,
                              showTitle: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                      //Pancard
                      Text(
                        'pan_card_image'.tr,
                        style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall),
                      ),
                      const SizedBox(
                          height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Stack(children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(Dimensions.RADIUS_SMALL),
                          child: authController.pickedPanCard != null
                              ? GetPlatform.isWeb
                                  ? Image.network(
                                      authController.pickedFile!.path,
                                      width: context.width,
                                      height: 170,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(authController.pickedPanCard!.path),
                                      width: context.width,
                                      height: 170,
                                      fit: BoxFit.cover,
                                    )
                              : Image.asset(
                                  Images.placeholder,
                                  width: context.width,
                                  height: 170,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          top: 0,
                          left: 0,
                          child: InkWell(
                            onTap: () =>
                                authController.pickImage("pan_card", false),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(
                                    Dimensions.RADIUS_SMALL),
                                border: Border.all(
                                    width: 1,
                                    color: Theme.of(context).primaryColor),
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 3, color: Colors.white),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt,
                                    color: Colors.white, size: 50),
                              ),
                            ),
                          ),
                        ),
                      ]),
                      const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                      CustomTextField(
                        hintText: 'pan_card_detail'.tr,
                        controller: _panController,
                        focusNode: _panFocus,
                        inputType: TextInputType.name,
                        capitalization: TextCapitalization.words,
                        showTitle: true,
                      ),
                      const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                      //gstIn
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "GST",
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall),
                          ),
                          Switch(
                              value: gstValue,
                              onChanged: (value) {
                                setState(() {
                                  gstValue = value;
                                });
                              })
                        ],
                      ),
                      if (gstValue)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'gstIn'.tr,
                              style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall),
                            ),
                            const SizedBox(
                                height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            Stack(children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.RADIUS_SMALL),
                                child: authController.pickedGstIn != null
                                    ? GetPlatform.isWeb
                                        ? Image.network(
                                            authController.pickedFile!.path,
                                            width: context.width,
                                            height: 170,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(
                                            File(authController
                                                .pickedGstIn!.path),
                                            width: context.width,
                                            height: 170,
                                            fit: BoxFit.cover,
                                          )
                                    : Image.asset(
                                        Images.placeholder,
                                        width: context.width,
                                        height: 170,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                top: 0,
                                left: 0,
                                child: InkWell(
                                  onTap: () =>
                                      authController.pickImage("gstIn", false),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.RADIUS_SMALL),
                                      border: Border.all(
                                          width: 1,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.all(25),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 3, color: Colors.white),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.camera_alt,
                                          color: Colors.white, size: 50),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                            const SizedBox(
                                height: Dimensions.PADDING_SIZE_LARGE),
                            CustomTextField(
                              hintText: 'gstInDetail'.tr,
                              controller: _gstController,
                              focusNode: _gstInFocus,
                              inputType: TextInputType.name,
                              capitalization: TextCapitalization.words,
                              showTitle: true,
                            ),
                            const SizedBox(
                                height: Dimensions.PADDING_SIZE_SMALL),
                          ],
                        ),

                      authController.zoneList != null
                          ? SelectLocationView(fromView: true)
                          : Center(child: CircularProgressIndicator()),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                      Center(
                          child: Text(
                        'owner_information'.tr,
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeSmall),
                      )),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                      Row(children: [
                        Expanded(
                            child: CustomTextField(
                          hintText: 'first_name'.tr,
                          controller: _fNameController,
                          focusNode: _fNameFocus,
                          nextFocus: _lNameFocus,
                          inputType: TextInputType.name,
                          capitalization: TextCapitalization.words,
                          showTitle: true,
                        )),
                        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                        Expanded(
                            child: CustomTextField(
                          hintText: 'last_name'.tr,
                          controller: _lNameController,
                          focusNode: _lNameFocus,
                          nextFocus: _phoneFocus,
                          inputType: TextInputType.name,
                          capitalization: TextCapitalization.words,
                          showTitle: true,
                        )),
                      ]),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                      CustomTextField(
                        hintText: 'phone'.tr,
                        controller: _phoneController,
                        focusNode: _phoneFocus,
                        nextFocus: _emailFocus,
                        inputType: TextInputType.phone,
                        showTitle: true,
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                      Center(
                          child: Text(
                        'login_information'.tr,
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeSmall),
                      )),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                      CustomTextField(
                        hintText: 'email'.tr,
                        controller: _emailController,
                        focusNode: _emailFocus,
                        nextFocus: _passwordFocus,
                        inputType: TextInputType.emailAddress,
                        showTitle: true,
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                      Row(children: [
                        Expanded(
                            child: CustomTextField(
                          hintText: 'password'.tr,
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          nextFocus: _confirmPasswordFocus,
                          inputType: TextInputType.visiblePassword,
                          isPassword: true,
                          showTitle: true,
                        )),
                        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                        Expanded(
                            child: CustomTextField(
                          hintText: 'confirm_password'.tr,
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocus,
                          inputType: TextInputType.visiblePassword,
                          isPassword: true,
                          showTitle: true,
                        )),
                      ]),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

//bank

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: Text(
                            "Bank Details",
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge),
                          )),
                          Text(
                            "Bank Check Image",
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall),
                          ),
                          const SizedBox(
                              height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          Stack(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.RADIUS_SMALL),
                              child: authController.pickedCheckImage != null
                                  ? GetPlatform.isWeb
                                      ? Image.network(
                                          authController.pickedFile!.path,
                                          width: context.width,
                                          height: 170,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          File(authController
                                              .pickedCheckImage!.path),
                                          width: context.width,
                                          height: 170,
                                          fit: BoxFit.cover,
                                        )
                                  : Image.asset(
                                      Images.placeholder,
                                      width: context.width,
                                      height: 170,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              top: 0,
                              left: 0,
                              child: InkWell(
                                onTap: () =>
                                    authController.pickImage("check", false),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.RADIUS_SMALL),
                                    border: Border.all(
                                        width: 1,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(25),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 3, color: Colors.white),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.camera_alt,
                                        color: Colors.white, size: 50),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                          const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          CustomTextField(
                            hintText: "Bank Name",
                            controller: _bankNameController,
                            focusNode: _bankNameFocus,
                            inputType: TextInputType.name,
                            capitalization: TextCapitalization.words,
                            showTitle: true,
                          ),
                          const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          CustomTextField(
                            hintText: "Bank Branch",
                            controller: _bankBranchController,
                            focusNode: _bankBranchFocus,
                            inputType: TextInputType.name,
                            capitalization: TextCapitalization.words,
                            showTitle: true,
                          ),
                          const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          CustomTextField(
                            hintText: "Account Holder Name",
                            controller: _bankHolderNameController,
                            focusNode: _bankHolderNameFocus,
                            inputType: TextInputType.name,
                            capitalization: TextCapitalization.words,
                            showTitle: true,
                          ),
                          const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          CustomTextField(
                            hintText: "Account Number",
                            controller: _accountNoController,
                            focusNode: _accountNoFocus,
                            inputType: TextInputType.name,
                            capitalization: TextCapitalization.words,
                            showTitle: true,
                          ),
                          const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        ],
                      ),

                      !authController.isLoading!
                          ? CustomButton(
                              buttonText: 'submit'.tr,
                              onPressed: () {
                                String _name = _nameController.text.trim();
                                String _address =
                                    _addressController.text.trim();
                                String _vat = _vatController.text.trim();
                                // String _minTime =
                                //     _minTimeController.text.trim();
                                // String _maxTime =
                                //     _maxTimeController.text.trim();
                                String _fName = _fNameController.text.trim();
                                String _lName = _lNameController.text.trim();
                                String _phone = _phoneController.text.trim();
                                String _email = _emailController.text.trim();
                                String _password =
                                    _passwordController.text.trim();
                                String _confirmPassword =
                                    _confirmPasswordController.text.trim();
                                String fssaiExpDate =
                                    _fssaiDateController.text.trim();
                                String fssaiDetail =
                                    _fssaiController.text.trim();
                                String panCardDetail =
                                    _panController.text.trim();
                                String gstInDetail = _gstController.text.trim();

                                String bankName =
                                    _bankNameController.text.trim();
                                String bankBranch =
                                    _bankBranchController.text.trim();
                                String bankHolderName =
                                    _bankHolderNameController.text.trim();
                                String bankAccountNo =
                                    _accountNoController.text.trim();

                                if (_name.isEmpty) {
                                  showCustomSnackBar(
                                      'enter_restaurant_name'.tr);
                                } else if (_address.isEmpty) {
                                  showCustomSnackBar(
                                      'enter_restaurant_address'.tr);
                                } else if (_vat.isEmpty) {
                                  showCustomSnackBar('enter_vat_amount'.tr);
                                } else if (fssaiDetail.isEmpty) {
                                  showCustomSnackBar('enter_fssai'.tr);
                                } else if (panCardDetail.isEmpty) {
                                  showCustomSnackBar('pan_card_detail'.tr);
                                } else if (gstInDetail.isEmpty && gstValue) {
                                  showCustomSnackBar('gstInDetail'.tr);
                                } else if (bankName.isEmpty) {
                                  showCustomSnackBar("Enter Bank Name");
                                } else if (bankBranch.isEmpty) {
                                  showCustomSnackBar("Enter Bank Branch Name");
                                } else if (bankHolderName.isEmpty) {
                                  showCustomSnackBar(
                                      "Enter Bank Holder Name Name");
                                } else if (bankAccountNo.isEmpty) {
                                  showCustomSnackBar(
                                      "Enter Bank Account Number Name");
                                }
                                // else if (_minTime.isEmpty) {
                                //   showCustomSnackBar(
                                //       'enter_minimum_delivery_time'.tr);
                                // } else if (_maxTime.isEmpty) {
                                //   showCustomSnackBar(
                                //       'enter_maximum_delivery_time'.tr);
                                // } else if (double.parse(_minTime) >
                                //     double.parse(_maxTime)) {
                                //   showCustomSnackBar(
                                //       'maximum_delivery_time_can_not_be_smaller_then_minimum_delivery_time'
                                //           .tr);
                                // }

                                else if (authController.pickedLogo == null) {
                                  showCustomSnackBar(
                                      'select_restaurant_logo'.tr);
                                } else if (authController.pickedCover == null) {
                                  showCustomSnackBar(
                                      'select_restaurant_cover_photo'.tr);
                                } else if (authController.pickedFssai == null) {
                                  showCustomSnackBar('selectFssaiImage'.tr);
                                } else if (authController.pickedPanCard ==
                                    null) {
                                  showCustomSnackBar('selectPanImage'.tr);
                                } else if (authController.pickedGstIn == null &&
                                    gstValue) {
                                  showCustomSnackBar('selectGstInImage'.tr);
                                } else if (authController.restaurantLocation ==
                                    null) {
                                  showCustomSnackBar(
                                      'set_restaurant_location'.tr);
                                } else if (authController.pickedCheckImage ==
                                    null) {
                                  showCustomSnackBar(
                                      "Please Insert Bank Check For Verification");
                                } else if (_fName.isEmpty) {
                                  showCustomSnackBar(
                                      'enter_your_first_name'.tr);
                                } else if (_lName.isEmpty) {
                                  showCustomSnackBar('enter_your_last_name'.tr);
                                } else if (_phone.isEmpty) {
                                  showCustomSnackBar('enter_phone_number'.tr);
                                } else if (_email.isEmpty) {
                                  showCustomSnackBar('enter_email_address'.tr);
                                } else if (!GetUtils.isEmail(_email)) {
                                  showCustomSnackBar(
                                      'enter_a_valid_email_address'.tr);
                                } else if (_password.isEmpty) {
                                  showCustomSnackBar('enter_password'.tr);
                                } else if (_password.length < 6) {
                                  showCustomSnackBar('password_should_be'.tr);
                                } else if (_password != _confirmPassword) {
                                  showCustomSnackBar(
                                      'confirm_password_does_not_matched'.tr);
                                }
                                /*else if(Get.find<CuisineController>().cuisineIndex-1 == -1) {
                              showCustomSnackBar('please_select_cuisine_for_the_restaurant'.tr);
                            }*/
                                else {
                                  List<String> cuisines = [];
                                  Get.find<CuisineController>()
                                      .selectedCuisines
                                      !.forEach((index) {
                                    cuisines.add(Get.find<CuisineController>()
                                        .cuisineModel
                                       ! .cuisines![index]
                                        .id
                                        .toString());
                                  });
                                  // String _cuisine = '';
                                  // for(int index=0; index<cuisines.length; index++) {
                                  //   _cuisine = _cuisine + '${index == 0 ? cuisines[index].id : ',${cuisines[index].id}'}';
                                  // }

                                  authController
                                      .registerRestaurant(RestaurantBody(
                                    restaurantName: _name,
                                    restaurantAddress: _address,
                                    vat: _vat,
                                    // minDeliveryTime: _minTime,
                                    // maxDeliveryTime: _maxTime,
                                    lat: authController
                                        .restaurantLocation!.latitude
                                        .toString(),
                                    email: _email,
                                    lng: authController
                                        .restaurantLocation!.longitude
                                        .toString(),
                                    fName: _fName,
                                    lName: _lName,
                                    phone: _phone,
                                    password: _password,
                                    zoneId: authController
                                        .zoneList![
                                            authController.selectedZoneIndex!]
                                        .id
                                        .toString(),
                                    fssaiExpDate: fssaiExpDate.toString(),
                                    fssaiRegNo: fssaiDetail.toString(),
                                    panCardDetail: panCardDetail.toString(),
                                    gstInDetail: gstInDetail.toString(),

                                    bankName: bankName.toString(),
                                    bankBranchName: bankBranch.toString(),
                                    bankHolderName: bankHolderName.toString(),
                                    bankAccountNumber: bankAccountNo.toString(),
                                    cuisineId: cuisines,
                                  ));
                                }
                              },
                            )
                          : Center(child: CircularProgressIndicator()),
                    ]),
                  ),
                ),
              ),
            ),
          ]),
        ),
      );
    });
  }
}
