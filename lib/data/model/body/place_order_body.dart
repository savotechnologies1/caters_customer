import 'dart:convert';

import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:flutter/material.dart';

class PlaceOrderBody {
  List<Cart>? _cart;
  double? _couponDiscountAmount;
  String? _couponDiscountTitle;
  double? _orderAmount;
  String? _orderType;
  String? _paymentMethod;
  String? _orderNote;
  String? _couponCode; // ✅ fixed type
  int? _restaurantId;
  double? _distance;
  String? _scheduleAt;
  double? _discountAmount;
  double? _taxAmount;
  String? _address;
  String? _latitude;
  String? _longitude;
  String? _contactPersonName;
  String? _contactPersonNumber;
  String? _addressType;
  String? _road;
  String? _house;
  String? _floor;
  String? _dmTips;
  String? _subscriptionOrder;
  String? _subscriptionType;
  List<SubscriptionDays>? _subscriptionDays;
  String? _subscriptionQuantity;
  String? _subscriptionStartAt;
  String? _subscriptionEndAt;

  PlaceOrderBody({
    required List<Cart> cart,
    required double couponDiscountAmount,
    required String couponDiscountTitle,
    required String? couponCode, // ✅ safe
    required double orderAmount,
    required String orderType,
    required String paymentMethod,
    required int restaurantId,
    required double distance,
    required String scheduleAt,
    required double discountAmount,
    required double taxAmount,
    required String orderNote,
    required String address,
    required String latitude,
    required String longitude,
    required String contactPersonName,
    required String contactPersonNumber,
    required String addressType,
    required String road,
    required String house,
    required String floor,
    required String dmTips,
    required String subscriptionOrder,
    required String subscriptionType,
    required List<SubscriptionDays> subscriptionDays,
    required String subscriptionQuantity,
    required String subscriptionStartAt,
    required String subscriptionEndAt,
  }) {
    _cart = cart;
    _couponDiscountAmount = couponDiscountAmount;
    _couponDiscountTitle = couponDiscountTitle;
    _couponCode = couponCode;
    _orderAmount = orderAmount;
    _orderType = orderType;
    _paymentMethod = paymentMethod;
    _orderNote = orderNote;
    _restaurantId = restaurantId;
    _distance = distance;
    _scheduleAt = scheduleAt;
    _discountAmount = discountAmount;
    _taxAmount = taxAmount;
    _address = address;
    _latitude = latitude;
    _longitude = longitude;
    _contactPersonName = contactPersonName;
    _contactPersonNumber = contactPersonNumber;
    _addressType = addressType;
    _road = road;
    _house = house;
    _floor = floor;
    _dmTips = dmTips;
    _subscriptionOrder = subscriptionOrder;
    _subscriptionType = subscriptionType;
    _subscriptionDays = subscriptionDays;
    _subscriptionQuantity = subscriptionQuantity;
    _subscriptionStartAt = subscriptionStartAt;
    _subscriptionEndAt = subscriptionEndAt;
  }

  // getters ...

  PlaceOrderBody.fromJson(Map<String, dynamic> json) {
    if (json['cart'] != null) {
      _cart = [];
      json['cart'].forEach((v) {
        _cart!.add(Cart.fromJson(v));
      });
    }
    _couponDiscountAmount = (json['coupon_discount_amount'] as num?)?.toDouble();
    _couponDiscountTitle = json['coupon_discount_title'];
    _orderAmount = (json['order_amount'] as num?)?.toDouble();
    _orderType = json['order_type'];
    _paymentMethod = json['payment_method'];
    _orderNote = json['order_note'];
    _couponCode = json['coupon_code'];
    _restaurantId = json['restaurant_id'];
    _distance = (json['distance'] as num?)?.toDouble();
    _scheduleAt = json['schedule_at'];
    _discountAmount = (json['discount_amount'] as num?)?.toDouble();
    _taxAmount = (json['tax_amount'] as num?)?.toDouble();
    _address = json['address'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _contactPersonName = json['contact_person_name'];
    _contactPersonNumber = json['contact_person_number'];
    _addressType = json['address_type'];
    _road = json['road'];
    _house = json['house'];
    _floor = json['floor'];
    _dmTips = json['dm_tips'];
    _subscriptionOrder = json['subscription_order'];
    _subscriptionType = json['subscription_type'];
    if (json['subscription_days'] != null) {
      _subscriptionDays = <SubscriptionDays>[];
      json['subscription_days'].forEach((v) {
        _subscriptionDays!.add(SubscriptionDays.fromJson(v));
      });
    }
    _subscriptionQuantity = json['subscription_quantity'];
    _subscriptionStartAt = json['subscription_start_at'];
    _subscriptionEndAt = json['subscription_end_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (_cart != null) {
      data['cart'] = _cart!.map((v) => v.toJson()).toList();
    }
    data['coupon_discount_amount'] = _couponDiscountAmount;
    data['coupon_discount_title'] = _couponDiscountTitle;
    data['coupon_code'] = _couponCode;
    data['order_amount'] = _orderAmount;
    data['order_type'] = _orderType;
    data['payment_method'] = _paymentMethod;
    data['order_note'] = _orderNote;
    data['restaurant_id'] = _restaurantId;
    data['distance'] = _distance;
    data['schedule_at'] = _scheduleAt;
    data['discount_amount'] = _discountAmount;
    data['tax_amount'] = _taxAmount;
    data['address'] = _address;
    data['latitude'] = _latitude;
    data['longitude'] = _longitude;
    data['contact_person_name'] = _contactPersonName;
    data['contact_person_number'] = _contactPersonNumber;
    data['address_type'] = _addressType;
    data['road'] = _road;
    data['house'] = _house;
    data['floor'] = _floor;
    data['dm_tips'] = _dmTips;
    data['subscription_order'] = _subscriptionOrder;
    data['subscription_type'] = _subscriptionType;
    if (_subscriptionDays != null) {
      data['subscription_days'] =
          _subscriptionDays!.map((v) => v.toJson()).toList();
    }
    data['subscription_quantity'] = _subscriptionQuantity;
    data['subscription_start_at'] = _subscriptionStartAt;
    data['subscription_end_at'] = _subscriptionEndAt;
    return data;
  }
}

class Cart {
  int? _foodId;
  int? _itemCampaignId;
  String? _price;
  String? _variant;
  List<OrderVariation>? _variation;
  int? _quantity;
  List<int>? _addOnIds;
  List<AddOns>? _addOns;
  List<int>? _addOnQtys;

  Cart({
    int? foodId,
    int? itemCampaignId,
    String? price,
    String? variant,
    List<OrderVariation>? variation,
    int? quantity,
    List<int>? addOnIds,
    List<AddOns>? addOns,
    List<int>? addOnQtys,
  }) {
    _foodId = foodId ?? 0;
    _itemCampaignId = itemCampaignId ?? 0;
    _price = price ?? '0';
    _variant = variant ?? '';
    _variation = variation ?? [];
    _quantity = quantity ?? 1;
    _addOnIds = addOnIds ?? [];
    _addOns = addOns ?? [];
    _addOnQtys = addOnQtys ?? [];
  }

  int? get foodId => _foodId;
  int? get itemCampaignId => _itemCampaignId;
  String? get price => _price;
  String? get variant => _variant;
  List<OrderVariation>? get variation => _variation;
  int? get quantity => _quantity;
  List<int>? get addOnIds => _addOnIds;
  List<AddOns>? get addOns => _addOns;
  List<int>? get addOnQtys => _addOnQtys;

  Cart.fromJson(Map<String, dynamic> json) {
    _foodId = json['food_id'] ?? 0;
    _itemCampaignId = json['item_campaign_id'] ?? 0;
    _price = json['price'] ?? '0';
    _variant = json['variant'] ?? '';
    if (json['variations'] != null) {
      _variation = [];
      json['variations'].forEach((v) {
        _variation!.add(OrderVariation.fromJson(v));
      });
    } else {
      _variation = [];
    }
    _quantity = json['quantity'] ?? 1;
    _addOnIds = json['add_on_ids'] != null ? List<int>.from(json['add_on_ids']) : [];
    if (json['add_ons'] != null) {
      _addOns = [];
      json['add_ons'].forEach((v) {
        _addOns!.add(AddOns.fromJson(v));
      });
    } else {
      _addOns = [];
    }
    _addOnQtys = json['add_on_qtys'] != null ? List<int>.from(json['add_on_qtys']) : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['food_id'] = _foodId;
    data['item_campaign_id'] = _itemCampaignId;
    data['price'] = _price;
    data['variant'] = _variant;
    data['variations'] = _variation?.map((v) => v.toJson()).toList() ?? [];
    data['quantity'] = _quantity;
    data['add_on_ids'] = _addOnIds ?? [];
    data['add_ons'] = _addOns?.map((v) => v.toJson()).toList() ?? [];
    data['add_on_qtys'] = _addOnQtys ?? [];
    return data;
  }
}

class OrderVariation {
  String ?name;
  OrderVariationValue? values;

  OrderVariation({this.name, this.values});

  OrderVariation.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    values =
    json['values'] != null ? new OrderVariationValue.fromJson(json['values']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.values != null) {
      data['values'] = this.values!.toJson();
    }
    return data;
  }
}

class OrderVariationValue {
  List<String> ?label;

  OrderVariationValue({this.label});

  OrderVariationValue.fromJson(Map<String, dynamic> json) {
    label = json['label'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    return data;
  }
}

class SubscriptionDays {
  String ?_day;
  String ?_time;

  SubscriptionDays({String? day, String ?time}) {
    if (day != null) {
      this._day = day;
    }
    if (time != null) {
      this._time = time;
    }
  }

  String? get day => _day;
  String? get time => _time;

  SubscriptionDays.fromJson(Map<String, dynamic> json) {
    _day = json['day'];
    _time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this._day;
    data['time'] = this._time;
    return data;
  }
}