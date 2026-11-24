class GetWeatherParams {
  final String city;

  const GetWeatherParams({required this.city});

  // days=2 so the hourly forecast can continue past midnight.
  Map<String, dynamic> toJson() => {
        'q': city,
        'days': 2,
      };

  // override toString for cached propose
  @override
  String toString() {
    return '$city-';
  }
}
