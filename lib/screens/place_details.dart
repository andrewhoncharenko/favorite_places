import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "package:favorite_places/models/place.dart";

class PlaceDetailsScreen extends ConsumerWidget {
  final Place place;

  const PlaceDetailsScreen({super.key, required this.place});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(place.title);
  }
}
