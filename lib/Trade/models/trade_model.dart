// ignore_for_file: avoid_dynamic_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum TradeStatus { waiting, verified, unverified, outdated }

TradeStatus? fromString(String? statusText) {
  switch (statusText) {
    case 'waiting':
      return TradeStatus.waiting;
    case 'verified':
      return TradeStatus.verified;
    case 'unverified':
      return TradeStatus.unverified;
    case 'outdated':
      return TradeStatus.outdated;
    default:
      return null;
  }
}

extension TradeStatusExtension on TradeStatus? {
  String? get explanation {
    switch (this) {
      case TradeStatus.waiting:
        return 'DOĞRULANIYOR';
      case TradeStatus.verified:
        return 'ETKİN';
      case TradeStatus.unverified:
        return 'ONAYLANMAMIŞ';
      case TradeStatus.outdated:
        return 'SÜRESİ DOLMUŞ';
      case null:
        return 'HATA OLUŞTU';
    }
  }
}

class TradeModel extends Equatable {
  TradeModel({
    this.category,
    this.subcategory,
    this.city,
    this.country,
    this.createdAt,
    this.explanation,
    this.photos,
    this.price,
    this.region,
    this.title,
    this.uid,
    this.docID,
    this.savedIDs,
    this.isSold,
  });
  TradeModel.fromJson(Map<String, dynamic> json) {
    status =
        json['status'] != null ? fromString(json['status'] as String?) : null;
    category = json['category'] as String?;
    subcategory = json['subcategory'] as String?;
    city = json['city'] as String?;
    country = json['country'] as String?;
    createdAt = json['created_at'] as Timestamp?;
    explanation = json['explanation'] as String?;
    region = json['region'] as String?;
    title = json['title'] as String?;
    uid = json['uid'] as String?;
    docID = json['doc_id'] as String?;
    isSold = json['is_sold'] as bool?;
    savedIDs = (json['saved_ids'] as List? ?? [])
        .map((item) => item as String)
        .toList();
    photos = json['photos'] != null
        ? (json['photos'] as List).map((item) => item as String).toList()
        : null;
    price = json['price'].runtimeType == int
        ? double.parse(json['price'].toString())
        : json['price'] as double?;
  }
  String? category;
  String? subcategory;
  String? city;
  String? country;
  Timestamp? createdAt;
  String? explanation;
  List<String>? photos;
  double? price;
  String? region;
  String? title;
  String? uid;
  String? docID;
  List<String?>? savedIDs;
  TradeStatus? status;
  bool? isSold;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['category'] = category;
    data['subcategory'] = subcategory;
    data['city'] = city;
    data['country'] = country;
    data['created_at'] = createdAt;
    data['explanation'] = explanation;
    data['photos'] = photos;
    data['price'] = price;
    data['region'] = region;
    data['title'] = title;
    data['uid'] = uid;
    data['doc_id'] = docID;
    data['saved_ids'] = savedIDs;
    data['is_sold'] = isSold;
    data['status'] = status != null ? status!.name : null;
    return data;
  }

  @override
  List<Object?> get props => [
        category,
        subcategory,
        city,
        country,
        createdAt,
        explanation,
        photos,
        price,
        region,
        title,
        uid,
        docID,
        savedIDs,
        status,
        isSold,
      ];
}
