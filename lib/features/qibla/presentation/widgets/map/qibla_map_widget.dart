import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entities.dart';

class QiblaMapWidget extends StatefulWidget {
  const QiblaMapWidget({
    required this.userLat,
    required this.userLng,
    required this.isDarkMode,
    required this.qiblaDirection,
    this.compassData,
    super.key,
  });

  final double userLat;
  final double userLng;
  final bool isDarkMode;
  final double qiblaDirection;
  final QiblaCompassDataEntity? compassData;

  @override
  State<QiblaMapWidget> createState() => _QiblaMapWidgetState();
}

class _QiblaMapWidgetState extends State<QiblaMapWidget> {
  final MapController _mapController = MapController();

  void _zoomIn() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, currentZoom + 1);
  }

  void _zoomOut() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, currentZoom - 1);
  }

  void _centerToUser() {
    _mapController.move(LatLng(widget.userLat, widget.userLng), 14);
  }

  @override
  void didUpdateWidget(covariant QiblaMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.compassData != null) {
      final mapRotationDegrees =
          widget.compassData!.compassRotation * (180 / 3.141592653589793);
      _mapController.rotate(mapRotationDegrees);
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const kaabaLat = 21.422487;
    const kaabaLng = 39.826206;

    final userPoint = LatLng(widget.userLat, widget.userLng);
    const kaabaPoint = LatLng(kaabaLat, kaabaLng);

    final urlTemplate = context.image.mapUrlTemplate;

    final isNearQibla =
        widget.compassData?.qiblaMessage.type == QiblaMessageType.perfect ||
        widget.compassData?.qiblaMessage.type == QiblaMessageType.close;
    final activeColor = isNearQibla
        ? context.color.secondary
        : context.color.primary;

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: userPoint,
            initialZoom: 14,
            initialRotation: widget.compassData != null
                ? widget.compassData!.compassRotation *
                      (180 / 3.141592653589793)
                : -widget.qiblaDirection,
            maxZoom: 18,
            minZoom: 2,
          ),
          children: [
            TileLayer(
              urlTemplate: urlTemplate,
              subdomains: const ['a', 'b', 'c', 'd'],
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: [userPoint, kaabaPoint],
                  color: activeColor,
                  strokeWidth: 4,
                  pattern: StrokePattern.dashed(segments: const [10, 10]),
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: userPoint,
                  width: 24.r(context),
                  height: 24.r(context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: activeColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.color.scaffoldBackgroundColor,
                        width: 3.r(context),
                      ),
                    ),
                  ),
                ),
                Marker(
                  point: kaabaPoint,
                  width: 40.r(context),
                  height: 40.r(context),
                  child: Icon(
                    FlutterIslamicIcons.kaaba,
                    color: Colors.black,
                    size: 40.r(context),
                  ),
                ),
              ],
            ),
          ],
        ),
        Positioned(
          right: AppSpacing.v10,
          bottom: AppSpacing.v20,
          child: Column(
            children: [
              _QiblaMapButton(
                icon: Icons.my_location,
                onTap: _centerToUser,
              ),
              const SizedBox(height: AppSpacing.v10),
              _QiblaMapButton(
                icon: Icons.add,
                onTap: _zoomIn,
              ),
              const SizedBox(height: AppSpacing.v10),
              _QiblaMapButton(
                icon: Icons.remove,
                onTap: _zoomOut,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QiblaMapButton extends StatelessWidget {
  const _QiblaMapButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.color.scaffoldBackgroundColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: context.color.textPrimary),
        onPressed: onTap,
      ),
    );
  }
}
