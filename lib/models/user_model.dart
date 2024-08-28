import 'package:flutter/foundation.dart';

enum Gender { male, female, other }

class UserDto {
  final int? userId;
  final int? coupleId;
  final String? name;
  final String? gender;
  final int? age;
  final String? address;
  final int? monthlyIncome;
  final String? ratingName;
  final bool isDeleted;
  final String? phone;
  final bool isLogin;
  final String? email;
  final String? password;
  final String? nickname;
  final int? monthlyTargetAmount;
  final String? refreshToken;
  final String? accessToken;
  final String? apiKey;

  UserDto({
    this.userId,
    this.coupleId,
    this.name,
    this.gender,
    this.age,
    this.address,
    this.monthlyIncome,
    this.ratingName,
    this.isDeleted = false,
    this.phone,
    this.isLogin = false,
    this.email,
    this.password,
    this.nickname,
    this.monthlyTargetAmount,
    this.refreshToken,
    this.accessToken,
    this.apiKey,
  });

  UserDto copyWith({
    int? userId,
    int? coupleId,
    String? name,
    String? gender,
    int? age,
    String? address,
    int? monthlyIncome,
    String? ratingName,
    bool? isDeleted,
    String? phone,
    bool? isLogin,
    String? email,
    String? password,
    String? nickname,
    int? monthlyTargetAmount,
    String? refreshToken,
    String? accessToken,
    String? apiKey,
  }) {
    return UserDto(
      userId: userId ?? this.userId,
      coupleId: coupleId ?? this.coupleId,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      address: address ?? this.address,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      ratingName: ratingName ?? this.ratingName,
      isDeleted: isDeleted ?? this.isDeleted,
      phone: phone ?? this.phone,
      isLogin: isLogin ?? this.isLogin,
      email: email ?? this.email,
      password: password ?? this.password,
      nickname: nickname ?? this.nickname,
      monthlyTargetAmount: monthlyTargetAmount ?? this.monthlyTargetAmount,
      refreshToken: refreshToken ?? this.refreshToken,
      accessToken: accessToken ?? this.accessToken,
      apiKey: apiKey ?? this.apiKey,
    );
  }

  @override
  String toString() {
    return 'UserDto{userId: $userId, coupleId: $coupleId, name: $name, gender: $gender, age: $age, address: $address, monthlyIncome: $monthlyIncome, ratingName: $ratingName, isDeleted: $isDeleted, phone: $phone, isLogin: $isLogin, email: $email, password: $password, nickname: $nickname, monthlyTargetAmount: $monthlyTargetAmount, refreshToken: $refreshToken, accessToken: $accessToken, apiKey: $apiKey}';
  }

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      userId: json['userId'] as int?,
      coupleId: json['coupleId'] as int?,
      name: json['name'] as String?,
      gender: json['gender'] as String?,
      age: json['age'] as int?,
      address: json['address'] as String?,
      monthlyIncome: json['monthlyIncome'] as int?,
      ratingName: json['ratingName'] as String?,
      isDeleted: json['isDeleted'] as bool? ?? false,
      phone: json['phone'] as String?,
      isLogin: json['isLogin'] as bool? ?? false,
      email: json['email'] as String?,
      password: json['password'] as String?,
      nickname: json['nickname'] as String?,
      monthlyTargetAmount: json['monthlyTargetAmount'] as int?,
      refreshToken: json['refreshToken'] as String?,
      accessToken: json['accessToken'] as String?,
      apiKey: json['apiKey'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'coupleId': coupleId,
      'name': name,
      'gender': gender,
      'age': age,
      'address': address,
      'monthlyIncome': monthlyIncome,
      'ratingName': ratingName,
      'isDeleted': isDeleted,
      'phone': phone,
      'isLogin': isLogin,
      'email': email,
      'password': password,
      'nickname': nickname,
      'monthlyTargetAmount': monthlyTargetAmount,
      'refreshToken': refreshToken,
      'accessToken': accessToken,
      'apiKey': apiKey,
    };
  }
}
