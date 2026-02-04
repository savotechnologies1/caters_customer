import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/location/widget/location_search_dialog.dart';
import 'package:efood_multivendor/view/screens/location/widget/permission_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickMapScreen extends StatefulWidget {
  final bool fromSignUp;
  final bool fromAddAddress;
  final bool canRoute;
  final String route;
  final GoogleMapController? googleMapController;

  PickMapScreen({
    required this.fromSignUp,
    required this.fromAddAddress,
    required this.canRoute,
    required this.route,
    this.googleMapController,
  });

  @override
  State<PickMapScreen> createState() => _PickMapScreenState();
}

class _PickMapScreenState extends State<PickMapScreen> {
  GoogleMapController? _mapController;
  CameraPosition? _cameraPosition;
  late LatLng _initialPosition;

  @override
  void initState() {
    super.initState();

    if (widget.fromAddAddress) {
      Get.find<LocationController>().setPickData();
    }

    final defaultLocation = Get.find<SplashController>().configModel?.defaultLocation;
    _initialPosition = LatLng(
      double.tryParse(defaultLocation?.lat ?? '22.7186') ??  22.7186,

      double.tryParse(defaultLocation?.lng ?? ' 75.8557') ??   75.8557,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: Dimensions.WEB_MAX_WIDTH,
            child: GetBuilder<LocationController>(builder: (locationController) {
              final pickAddress = locationController.pickAddress ?? '';
              final pickPosition = locationController.pickPosition;

              return Stack(
                children: [
                  // Google Map
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: widget.fromAddAddress
                          ? LatLng(
                        pickPosition?.latitude ?? 22.7186,
                        pickPosition?.longitude ?? 75.8557,
                      )
                          : _initialPosition,
                      zoom: 16,
                    ),
                    minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                    onMapCreated: (GoogleMapController mapController) {
                      _mapController = mapController;
                      if (!widget.fromAddAddress) {
                        Get.find<LocationController>()
                            .getCurrentLocation(false, mapController: mapController);
                      }
                    },
                    zoomControlsEnabled: false,
                    onCameraMove: (CameraPosition cameraPosition) {
                      _cameraPosition = cameraPosition;
                    },
                    onCameraMoveStarted: () {
                      locationController.disableButton();
                    },
                      onCameraIdle: () {
                        if (_cameraPosition != null &&
                            locationController.isLocationFetched) {
                          locationController.updatePosition(_cameraPosition!, false);
                        }
                      }

                  ),

                  // Center Marker
                  Center(
                    child: !(locationController.loading ?? false)
                        ? Image.asset(Images.pick_marker, height: 50, width: 50)
                        : const CircularProgressIndicator(),
                  ),

                  // Search Bar
                  Positioned(
                    top: Dimensions.PADDING_SIZE_LARGE,
                    left: Dimensions.PADDING_SIZE_SMALL,
                    right: Dimensions.PADDING_SIZE_SMALL,
                    child: InkWell(
                      onTap: () {
                        if (_mapController != null) {
                          Get.dialog(LocationSearchDialog(mapController: _mapController!));
                        }
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_SMALL),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 25, color: Theme.of(context).primaryColor),
                            const SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            Expanded(
                              child: Text(
                                pickAddress,
                                style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeLarge),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                            Icon(Icons.search,
                                size: 25, color: Theme.of(context).textTheme.bodyLarge?.color),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Current Location Button
                  Positioned(
                    bottom: 80,
                    right: Dimensions.PADDING_SIZE_SMALL,
                    child: FloatingActionButton(
                      child: Icon(Icons.my_location,
                          color: Theme.of(context).primaryColor),
                      mini: true,
                      backgroundColor: Theme.of(context).cardColor,
                      onPressed: () => _checkPermission(() {
                        if (_mapController != null) {
                          Get.find<LocationController>()
                              .getCurrentLocation(false, mapController: _mapController!);
                        }
                      }),
                    ),
                  ),

                  // Pick Location / Address Button
                  Positioned(
                    bottom: Dimensions.PADDING_SIZE_LARGE,
                    left: Dimensions.PADDING_SIZE_SMALL,
                    right: Dimensions.PADDING_SIZE_SMALL,
                    child: !(locationController.isLoading ?? false)
                        ? CustomButton(
                      buttonText: (locationController.inZone ?? false)
                          ? widget.fromAddAddress
                          ? 'pick_address'.tr
                          : 'pick_location'.tr
                          : 'service_not_available_in_this_area'.tr +
                          "\n(Try Searching Indore, Madhya Pradesh, India)",
                      onPressed: (locationController.buttonDisabled ?? false ||
                          (locationController.loading ?? false))
                          ? null
                          : () {
                        if ((pickPosition?.latitude ?? 0) != 0 &&
                            pickAddress.isNotEmpty) {
                          if (widget.fromAddAddress) {
                            if (widget.googleMapController != null) {
                              widget.googleMapController!.moveCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: LatLng(
                                      pickPosition?.latitude?? 22.7186,
                                      pickPosition?.longitude?? 75.8557,
                                    ),
                                    zoom: 17,
                                  ),
                                ),
                              );
                              locationController.setAddAddressData();
                            }
                            Get.back();
                          } else {
                            final address = AddressModel(
                              latitude: pickPosition!.latitude.toString(),
                              longitude: pickPosition.longitude.toString(),
                              addressType: 'others',
                              address: pickAddress,
                            );
                            locationController.saveAddressAndNavigate(
                              address,
                              widget.fromSignUp,
                              widget.route,
                              widget.canRoute,
                            );
                          }
                        } else {
                          showCustomSnackBar('pick_an_address'.tr);
                        }
                      },
                    )
                        : const Center(child: CircularProgressIndicator()),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      showCustomSnackBar('you_have_to_allow'.tr);
    } else if (permission == LocationPermission.deniedForever) {
      Get.dialog(PermissionDialog());
    } else {
      onTap();
    }
  }
}
