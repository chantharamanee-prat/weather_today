// Free API: https://www.weatherapi.com/ (current weather + forecast)
const weatherUrl = "https://api.weatherapi.com/v1/forecast.json";

// Flutter reads this build-time value from .env via --dart-define-from-file.
const weatherApiKey = String.fromEnvironment('WEATHER_API_KEY');
