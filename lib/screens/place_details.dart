import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "package:favorite_places/models/place.dart";

class PlaceDetailsScreen extends ConsumerWidget {
  final Place place;

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
        ],
      ),
    );
  }
}
