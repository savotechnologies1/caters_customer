import 'dart:convert';
import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/banner_controller.dart';
import 'package:efood_multivendor/controller/campaign_controller.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/controller/chat_controller.dart';
import 'package:efood_multivendor/controller/coupon_controller.dart';
import 'package:efood_multivendor/controller/cuisine_controller.dart';
import 'package:efood_multivendor/controller/localization_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/notification_controller.dart';
import 'package:efood_multivendor/controller/onboarding_controller.dart';
import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/theme_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/controller/wallet_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/data/repository/auth_repo.dart';
import 'package:efood_multivendor/data/repository/banner_repo.dart';
import 'package:efood_multivendor/data/repository/campaign_repo.dart';
import 'package:efood_multivendor/data/repository/cart_repo.dart';
import 'package:efood_multivendor/data/repository/category_repo.dart';
import 'package:efood_multivendor/data/repository/chat_repo.dart';
import 'package:efood_multivendor/data/repository/coupon_repo.dart';
import 'package:efood_multivendor/data/repository/cuisine_repo.dart';
import 'package:efood_multivendor/data/repository/language_repo.dart';
import 'package:efood_multivendor/data/repository/location_repo.dart';
import 'package:efood_multivendor/data/repository/notification_repo.dart';
import 'package:efood_multivendor/data/repository/onboarding_repo.dart';
import 'package:efood_multivendor/data/repository/order_repo.dart';
import 'package:efood_multivendor/data/repository/product_repo.dart';
import 'package:efood_multivendor/data/repository/restaurant_repo.dart';
import 'package:efood_multivendor/data/repository/search_repo.dart';
import 'package:efood_multivendor/data/repository/splash_repo.dart';
import 'package:efood_multivendor/data/api/api_client.dart';
import 'package:efood_multivendor/data/repository/user_repo.dart';
import 'package:efood_multivendor/data/repository/wallet_repo.dart';
import 'package:efood_multivendor/data/repository/wishlist_repo.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/data/model/response/language_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:efood_multivendor/controller/search_controller.dart' as pre;

Future<Map<String, Map<String, String>>> init() async {
  // Core
  WidgetsFlutterBinding.ensureInitialized();

  // Get SharedPreferences instance and register it as NON-NULLABLE
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(sharedPreferences); // Register as non-nullable

  // Core dependencies
  Get.lazyPut<ApiClient>(() => ApiClient(
    appBaseUrl: AppConstants.BASE_URL,
    sharedPreferences: Get.find<SharedPreferences>(), // Use non-nullable type
  ));
// Repo register
  Get.lazyPut<SplashRepo>(() => SplashRepo(
    sharedPreferences: Get.find<SharedPreferences>(),
    apiClient: Get.find<ApiClient>(),
  ));

// Controller register
  Get.lazyPut<SplashController>(() => SplashController(
    splashRepo: Get.find<SplashRepo>(),
  ));

  Get.lazyPut(() => SearchRepo(
      apiClient: Get.find<ApiClient>(),
      sharedPreferences: Get.find<SharedPreferences>()
  ));

// Register SearchController
  Get.lazyPut(() => pre.SearchController(searchRepo: Get.find<SearchRepo>()));

  Get.lazyPut(() => LanguageRepo());

  // Core Controllers
  Get.lazyPut(() => ThemeController(
      sharedPreferences: Get.find<SharedPreferences>() // Use non-nullable type
  ));



  Get.lazyPut(() => SplashController(
      splashRepo: Get.find<SplashRepo>()
  ));

  Get.lazyPut(() => LocalizationController(
      sharedPreferences: Get.find<SharedPreferences>(), // Use non-nullable type
      apiClient: Get.find<ApiClient>()
  ));


  // Repositories
  Get.lazyPut(() => OnBoardingRepo());

  Get.lazyPut(() => AuthRepo(
      apiClient: Get.find<ApiClient>(),
      sharedPreferences: Get.find<SharedPreferences>() // Use non-nullable type
  ));

  Get.lazyPut(() => LocationRepo(
      apiClient: Get.find<ApiClient>(),
      sharedPreferences: Get.find<SharedPreferences>() // Use non-nullable type
  ));

  Get.lazyPut(() => UserRepo(
      apiClient: Get.find<ApiClient>()
  ));

  Get.lazyPut(() => BannerRepo(
      apiClient: Get.find<ApiClient>()
  ));

  Get.lazyPut(() => CategoryRepo(
      apiClient: Get.find<ApiClient>()
  ));

  Get.lazyPut(() => RestaurantRepo(
      apiClient: Get.find<ApiClient>()
  ));

  Get.lazyPut(() => WishListRepo(
      apiClient: Get.find<ApiClient>()
  ));

  Get.lazyPut(() => ProductRepo(
      apiClient: Get.find<ApiClient>()
  ));

  Get.lazyPut(() => CartRepo(
      sharedPreferences: Get.find<SharedPreferences>() // Use non-nullable type
  ));

  Get.lazyPut(() => SearchRepo(
      apiClient: Get.find<ApiClient>(),
      sharedPreferences: Get.find<SharedPreferences>() // Use non-nullable type
  ));

  Get.lazyPut(() => CouponRepo(
      apiClient: Get.find<ApiClient>()
  ));

  Get.lazyPut(() => OrderRepo(
      apiClient: Get.find<ApiClient>(),
      sharedPreferences: Get.find<SharedPreferences>() // Use non-nullable type
  ));

  Get.lazyPut(() => NotificationRepo(
      apiClient: Get.find<ApiClient>(),
      sharedPreferences: Get.find<SharedPreferences>() // Use non-nullable type
  ));

  Get.lazyPut(() => CampaignRepo(
      apiClient: Get.find<ApiClient>()
  ));

  Get.lazyPut(() => WalletRepo(
      apiClient: Get.find<ApiClient>()
  ));

  Get.lazyPut(() => ChatRepo(
      apiClient: Get.find<ApiClient>(),
      sharedPreferences: Get.find<SharedPreferences>() // Use non-nullable type
  ));

  Get.lazyPut(() => CuisineRepo(
      apiClient: Get.find<ApiClient>()
  ));

  // Controllers
  Get.lazyPut(() => OnBoardingController(
      onboardingRepo: Get.find<OnBoardingRepo>()
  ));

  Get.lazyPut(() => AuthController(
      authRepo: Get.find<AuthRepo>()
  ));

  Get.lazyPut(() => LocationController(
      locationRepo: Get.find<LocationRepo>()
  ));

  Get.lazyPut(() => UserController(
      userRepo: Get.find<UserRepo>()
  ));

  Get.lazyPut(() => BannerController(
      bannerRepo: Get.find<BannerRepo>()
  ));

  Get.lazyPut(() => CategoryController(
      categoryRepo: Get.find<CategoryRepo>()
  ));

  Get.lazyPut(() => ProductController(
      productRepo: Get.find<ProductRepo>()
  ));

  Get.lazyPut(() => CartController(
      cartRepo: Get.find<CartRepo>()
  ));

  Get.lazyPut(() => RestaurantController(
      restaurantRepo: Get.find<RestaurantRepo>()
  ));

  Get.lazyPut(() => WishListController(
      wishListRepo: Get.find<WishListRepo>(),
      productRepo: Get.find<ProductRepo>()
  ));

  Get.lazyPut(() => CouponController(
      couponRepo: Get.find<CouponRepo>()
  ));

  Get.lazyPut(() => OrderController(
      orderRepo: Get.find<OrderRepo>()
  ));

  Get.lazyPut(() => NotificationController(
      notificationRepo: Get.find<NotificationRepo>()
  ));

  Get.lazyPut(() => CampaignController(
      campaignRepo: Get.find<CampaignRepo>()
  ));

  Get.lazyPut(() => WalletController(
      walletRepo: Get.find<WalletRepo>()
  ));

  Get.lazyPut(() => ChatController(
      chatRepo: Get.find<ChatRepo>()
  ));


  Get.lazyPut(() => CuisineController(
      cuisineRepo: Get.find<CuisineRepo>()
  ));


  // Translations
  Map<String, Map<String, String>> languages = {};
  for (LanguageModel lang in AppConstants.languages) {
    String jsonString = await rootBundle.loadString('assets/language/${lang.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    Map<String, String> langMap = {};
    jsonMap.forEach((key, value) => langMap[key] = value.toString());
    languages['${lang.languageCode}_${lang.countryCode}'] = langMap;
  }

  return languages;
}