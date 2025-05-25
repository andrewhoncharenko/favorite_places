import "dart:convert";
import "package:flutter/material.dart";
import "package:location/location.dart";
import "package:http/http.dart" as http;

import "package:favorite_places/googlekey.dart";

import "package:favorite_places/models/place.dart";

class LocationInput extends StatefulWidget {
  final void Function(PlaceLocation location) onSelectLocation;

  const LocationInput({super.key, required this.onSelectLocation});
  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  bool _isGettingLocation = false;

  String get locationImage {
    if (_pickedLocation == null) {
      return "";
    }
    final double lat = _pickedLocation!.latitude;
    final double lng = _pickedLocation!.longitude;
    return "https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=400x400&key=$key&markers=color:red%7Clabel:A%7C$lat,$lng";
  }

  void _getCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();

    double? lat = locationData.latitude;
    double? lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }

    Uri url = Uri.parse(
      "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$key",
    );

    final http.Response response = await http.get(url);
    final responseData = json.decode(response.body);
    final String address = responseData["results"][0]["formatted_address"];

    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: lat,
        longitude: lng,
        address: address,
      );
      _isGettingLocation = false;
    });
    widget.onSelectLocation(_pickedLocation!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text(
      "No location chosen",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );

    if (_pickedLocation != null) {
      content = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_isGettingLocation) {
      content = CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: content,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: Icon(Icons.location_on),
              label: const Text("Get current location"),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.location_on),
              label: const Text("Select on map"),
            ),
          ],
        ),
      ],
    );
  }
}
