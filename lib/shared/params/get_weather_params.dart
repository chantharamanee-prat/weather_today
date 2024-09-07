class GetWeatherParams {
  final String city;

  const GetWeatherParams({required this.city});


  Map<String,dynamic> toJson() => {
    'city': city,
  };

  // override toString for cached propose
  @override
  String toString() {
    return '$city-';
  }
}
