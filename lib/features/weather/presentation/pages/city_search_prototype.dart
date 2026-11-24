// Design prototype with sample weather and simulated location permission.
import 'package:flutter/material.dart';
import 'package:weather_today/cores/theme/theme.dart';
import 'package:weather_today/features/weather/presentation/widgets/weather_info_card_item.dart';

void main() => runApp(MaterialApp(
      title: 'Weather Today · City search prototype',
      theme: theme,
      home: const CitySearchPrototype(),
    ));

const _sampleLocation = (name: 'Bangkok', region: 'Thailand', temp: 32);

const _cities = [
  (name: 'New York', region: 'New York, United States', temp: 17),
  _sampleLocation,
  (name: 'Chiang Mai', region: 'Thailand', temp: 27),
  (name: 'London', region: 'United Kingdom', temp: 14),
  (name: 'Tokyo', region: 'Japan', temp: 23),
  (name: 'Singapore', region: 'Singapore', temp: 31),
  (name: 'Springfield', region: 'Illinois, United States', temp: 21),
  (name: 'Springfield', region: 'Missouri, United States', temp: 24),
];

class CitySearchPrototype extends StatefulWidget {
  const CitySearchPrototype({super.key});

  @override
  State<CitySearchPrototype> createState() => _CitySearchPrototypeState();
}

class _CitySearchPrototypeState extends State<CitySearchPrototype> {
  final _search = TextEditingController();
  var _city = _cities.first;
  var _usesLocation = false;
  var _locationDenied = false;

  void _selectCity(
    ({String name, String region, int temp}) city, {
    bool usesLocation = false,
  }) {
    _search.clear();
    FocusScope.of(context).unfocus();
    setState(() {
      _city = city;
      _usesLocation = usesLocation;
      _locationDenied = false;
    });
  }

  Future<void> _useCurrentLocation() async {
    FocusScope.of(context).unfocus();
    final allowed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Use your current location?'),
        content: const Text(
          'This preview simulates location access and shows Bangkok weather.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Don’t allow'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Allow'),
          ),
        ],
      ),
    );
    if (!mounted || allowed == null) return;
    if (allowed) {
      _selectCity(_sampleLocation, usesLocation: true);
    } else {
      setState(() => _locationDenied = true);
    }
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = switch (_city.temp) {
      > 30 => Colors.yellow.shade600,
      < 20 => const Color(0xFF219EBC),
      _ => Colors.pink.shade400,
    };
    final query = _search.text.trim().toLowerCase();
    final matches = _cities.where(
      (city) => city.name.toLowerCase().contains(query),
    );

    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        backgroundColor: color,
        centerTitle: true,
        title: Text(_city.name, style: theme.textTheme.titleLarge),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(30, 8, 30, 24),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _search,
                        onChanged: (_) => setState(() {}),
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) {
                          if (query.isNotEmpty && matches.length == 1) {
                            _selectCity(matches.single);
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Search city',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          suffixIcon: _search.text.isEmpty
                              ? null
                              : IconButton(
                                  tooltip: 'Clear search',
                                  onPressed: () => setState(_search.clear),
                                  icon: const Icon(Icons.close),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      tooltip: 'Use current location',
                      onPressed: _useCurrentLocation,
                      icon: const Icon(Icons.my_location),
                    ),
                  ],
                ),
                if (_locationDenied)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Semantics(
                      liveRegion: true,
                      child: const Text(
                          'Location access was denied. Search by city name.'),
                    ),
                  ),
                if (query.isNotEmpty)
                  Card(
                    margin: const EdgeInsets.only(top: 8),
                    child: Column(
                      children: [
                        if (matches.isEmpty)
                          const ListTile(
                            title: Text('No matching cities'),
                            subtitle: Text('Try Bangkok, London, or Tokyo.'),
                          ),
                        for (final city in matches)
                          ListTile(
                            leading: const Icon(Icons.place_outlined),
                            title: Text(city.name),
                            subtitle: Text(city.region),
                            onTap: () => _selectCity(city),
                          ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                if (_usesLocation || _city.region != _city.name) ...[
                  Text(
                    _usesLocation
                        ? 'Current location · ${_city.region}'
                        : _city.region,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                ],
                const Text('Partly cloudy', textAlign: TextAlign.center),
                const Icon(Icons.cloud_outlined,
                    size: 72, color: Colors.black87),
                Text(
                  '${_city.temp}°C',
                  textAlign: TextAlign.center,
                  textScaler: const TextScaler.linear(2),
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Current conditions', style: theme.textTheme.titleMedium),
                Card(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 20),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      runSpacing: 16,
                      spacing: 8,
                      children: [
                        WeatherInfoCardItem(
                            color: color,
                            icon: Icons.wind_power_rounded,
                            value: '12 km/h',
                            subtitle: 'Wind'),
                        WeatherInfoCardItem(
                            color: color,
                            icon: Icons.water_drop_outlined,
                            value: '64%',
                            subtitle: 'Humidity'),
                        WeatherInfoCardItem(
                            color: color,
                            icon: Icons.remove_red_eye_outlined,
                            value: '10 km',
                            subtitle: 'Visibility'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
