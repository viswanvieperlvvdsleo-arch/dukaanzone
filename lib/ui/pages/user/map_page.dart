import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:dukaan_zone_flutter/dukaan.dart';

class UserMapPage extends StatefulWidget {
  const UserMapPage({super.key});

@override
  State<UserMapPage> createState() => _UserMapPageState();
}

class _UserMapPageState extends State<UserMapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  bool _showDetails = false;

static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(17.7292, 83.3150), // Approx coords for Visakhapatnam (based on image)
    zoom: 14.4746,
  );

final Set<Polyline> _polylines = {
    const Polyline(
      polylineId: PolylineId('route'),
      points: [
        LatLng(17.7292, 83.3150),
        LatLng(17.7320, 83.3200),
        LatLng(17.7350, 83.3220),
      ],
      color: Colors.blue,
      width: 5,
    )
  };

@override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<MapState>(
      valueListenable: globalMapState,
      builder: (context, mapState, _) {
        final isRouting = mapState.mode == MapMode.routing;

return Stack(
          children: [
            // 1. Google Map Layer
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _initialPosition,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              polylines: isRouting ? _polylines : const <Polyline>{},
              onMapCreated: (GoogleMapController controller) {
                if (!_controller.isCompleted) _controller.complete(controller);
              },
            ),
            
            // 2. Top UI Layer (Overlays / Pills)
            if (isRouting) ...[
              // Routing Top Overlay
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.my_location, color: Colors.blue, size: 20),
                          const SizedBox(width: 12),
                          const Expanded(child: Text('Your Location', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16))),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => globalMapState.value = MapState(mode: MapMode.standard),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.red, size: 20),
                          const SizedBox(width: 12),
                          Expanded(child: Text(mapState.destinationName ?? 'Destination', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              // Standard Top Pills
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildPill('Ask Maps', Icons.search_rounded, active: true, onTap: () {}),
                      const SizedBox(width: 8),
                      _buildPill('Set home', Icons.home_filled),
                      const SizedBox(width: 8),
                      _buildPill('Restaurants', Icons.restaurant),
                      const SizedBox(width: 8),
                      _buildPill('Groceries', Icons.shopping_cart),
                    ],
                  ),
                ),
              ),
            ],

// 3. Right Floating Buttons
            Positioned(
              top: isRouting ? 160 : 80,
              right: 16,
              child: Column(
                children: [
                  _buildMapActionButton(Icons.layers_outlined),
                ],
              ),
            ),
            Positioned(
              bottom: isRouting ? 240 : 120, // Move up when sheet is visible
              right: 16,
              child: Column(
                children: [
                  _buildMapActionButton(Icons.explore_outlined),
                  const SizedBox(height: 16),
                  if (!isRouting)
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF007A87),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: const Icon(Icons.directions, color: Colors.white, size: 28),
                    ),
                ],
              ),
            ),

// 4. Bottom Sheets
            if (isRouting) ...[
              // Routing Drive Sheet
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Drive', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildTransportTab(Icons.directions_car, '14 min', active: true),
                          _buildTransportTab(Icons.two_wheeler, '12 min'),
                          _buildTransportTab(Icons.directions_walk, '45 min'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              onPressed: () {},
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF007A87),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                              ),
                              child: const Text('Start', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton.filledTonal(
                            onPressed: () {},
                            icon: const Icon(Icons.add),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              padding: const EdgeInsets.all(16),
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton.filledTonal(
                            onPressed: () {},
                            icon: const Icon(Icons.share),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              padding: const EdgeInsets.all(16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              // Standard Mode Handle / Details Drawer
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                bottom: _showDetails ? 0 : 24,
                left: 0,
                right: 0,
                child: _showDetails
                    ? Container(
                        padding: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Current Location', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                                IconButton(icon: const Icon(Icons.keyboard_arrow_down), onPressed: () => setState(() => _showDetails = false)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text('Bapuji Nagar, Visakhapatnam', style: TextStyle(color: Colors.grey, fontSize: 16)),
                            const SizedBox(height: 24),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.share),
                              label: const Text('Share Location'),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                                side: const BorderSide(color: Color(0x33628ECB), width: 2),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: InkWell(
                          onTap: () => setState(() => _showDetails = true),
                          child: Container(
                            width: 64,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                            ),
                            child: const Icon(Icons.keyboard_arrow_up, color: Colors.black54),
                          ),
                        ),
                      ),
              ),
            ],
          ],
        );
      },
    );
  }

Widget _buildTransportTab(IconData icon, String time, {bool active = false}) {
    return Column(
      children: [
        Icon(icon, color: active ? const Color(0xFF007A87) : Colors.grey, size: 28),
        const SizedBox(height: 4),
        Text(time, style: TextStyle(color: active ? const Color(0xFF007A87) : Colors.grey, fontWeight: active ? FontWeight.w900 : FontWeight.normal)),
      ],
    );
  }

Widget _buildPill(String text, IconData icon, {bool active = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? Colors.blue[100]! : Colors.grey[300]!, width: 1.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: active ? Colors.blue[700] : Colors.black87),
            const SizedBox(width: 8),
            Text(text, style: TextStyle(color: active ? Colors.blue[800] : Colors.black87, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

Widget _buildMapActionButton(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Icon(icon, color: Colors.black87, size: 22),
    );
  }
}

