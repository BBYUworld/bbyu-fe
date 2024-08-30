class MoneyDto {
  final int money;

  MoneyDto({required this.money});

  factory MoneyDto.fromJson(Map<String, dynamic> json) {
    return MoneyDto(
      money: json['money'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'money': money,
    };
  }
}