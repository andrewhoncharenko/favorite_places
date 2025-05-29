import "package:flutter/material.dart";
import "package:favorite_places/models/place.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";

class MapScreen extends StatefulWidget {
  final PlaceLocation location;
  final bool isSelecting;

  const MapScreen({
    super.key,
    this.location = const PlaceLocation(
      latitude: 37.422,
      longitude: -122.084,
      address: "",
    ),
    this.isSelecting = true,
  });
  @override
  State<MapScreen> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isSelecting ? "Pick your location" : "Your location",
        ),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
              icon: Icon(Icons.save),
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.location.latitude, widget.location.longitude),
          zoom: 16,
        ),
        onTap:
            !widget.isSelecting
                ? null
                : (position) => {
                  setState(() {
                    _pickedLocation = position;
                  }),
                },
        markers:
            (_pickedLocation == null && widget.isSelecting)
                ? {}
                : {
                  Marker(
                    markerId: MarkerId("m1"),
                    position:
                        _pickedLocation ??
                        LatLng(
                          widget.location.latitude,
                          widget.location.longitude,
                        ),
                  ),
                },
      ),
    );
  }
}
