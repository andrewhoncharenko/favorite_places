import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "package:favorite_places/models/place.dart";
import "package:favorite_places/googlekey.dart";
import "package:favorite_places/screens/map.dart";

class PlaceDetailsScreen extends ConsumerWidget {
  final Place place;

  String get locationImage {
    final double lat = place.location.latitude;
    final double lng = place.location.longitude;
    return "https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=400x400&key=$key&markers=color:red%7Clabel:A%7C$lat,$lng";
  }

  const PlaceDetailsScreen({super.key, required this.place});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(place.title)),
      body: Stack(
        children: [
          Image.file(
            place.image,
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (ctx) => MapScreen(
                              location: place.location,
                              isSelecting: false,
                            ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(locationImage),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.transparent, Colors.black54],
                    ),
                  ),
                  child: Text(
                    place.location.address,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
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
