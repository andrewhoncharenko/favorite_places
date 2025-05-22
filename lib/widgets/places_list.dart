import "package:flutter/material.dart";

import "package:favorite_places/models/place.dart";
import "package:favorite_places/widgets/place_item.dart";
import "package:favorite_places/screens/place_details.dart";

class PlacesList extends StatelessWidget {
  final List<Place> places;

  const PlacesList({super.key, required this.places});

  void selectPlace(BuildContext context, Place place) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => PlaceDetailsScreen(place: place)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: Text(
          "No places added yet.",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: places.length,
      itemBuilder:
          (context, index) => PlaceItem(
            place: places[index],
            onSelectPlace: (place) => {selectPlace(context, place)},
          ),
    );
  }
}
