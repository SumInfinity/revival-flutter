import 'package:json_annotation/json_annotation.dart';


part 'event.g.dart';

@JsonSerializable()
class Event {
      Event();

  int id;
  @JsonKey(name: 'user_id') int userId;
  String address1;
  dynamic address2;
  String country;
  String state;
  String city;
  @JsonKey(name: 'postal_code') String postalCode;
  @JsonKey(name: 'default_address') int defaultAddress;
  String name;
  double longitude;
  double latitude;
  int parseable;
  @JsonKey(name: 'deleted_at') dynamic deletedAt;
  @JsonKey(name: 'created_at') String createdAt;
  @JsonKey(name: 'updated_at') String updatedAt;

  factory Event.fromJson(Map<String,dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);
}
