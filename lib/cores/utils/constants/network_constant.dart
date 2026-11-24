// Free API: https://www.weatherapi.com/ (current weather)
const weatherUrl = "https://api.weatherapi.com/v1/current.json";

// Flutter reads this build-time value from .env via --dart-define-from-file.
const weatherApiKey = String.fromEnvironment('WEATHER_API_KEY');
