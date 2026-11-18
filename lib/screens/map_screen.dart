import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.initialCenter});

  final LatLng initialCenter;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng _selectedPosition = widget.initialCenter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choisir sur la carte'),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF4B2A8B),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter: widget.initialCenter,
                    initialZoom: 13,
                    onTap: (_, point) {
                      setState(() => _selectedPosition = point);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.immofinder',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _selectedPosition,
                          width: 48,
                          height: 48,
                          child: const Icon(
                            Icons.location_pin,
                            color: Color(0xFF4B2A8B),
                            size: 44,
                          ),
                        ),
                      ],
                    ),
                    RichAttributionWidget(
                      alignment: AttributionAlignment.bottomRight,
                      attributions: [
                        TextSourceAttribution('OpenStreetMap contributors'),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: 12,
                  left: 16,
                  right: 16,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'Touchez la carte pour déplacer le repère.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              children: [
                Text(
                  '${_selectedPosition.latitude.toStringAsFixed(5)}, '
                  '${_selectedPosition.longitude.toStringAsFixed(5)}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => Navigator.pop(context, _selectedPosition),
                    icon: const Icon(Icons.check),
                    label: const Text('Utiliser cette position'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
