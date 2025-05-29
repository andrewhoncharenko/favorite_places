import "package:favorite_places/screens/place_details.dart";
import "package:flutter/material.dart";
import "package:favorite_places/models/place.dart";

class PlaceItem extends StatelessWidget {
  final Place place;
  final void Function(Place place) onSelectPlace;

  const PlaceItem({
    super.key,
    required this.place,
    required this.onSelectPlace,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 26,
        backgroundImage: FileImage(place.image),
      ),
      title: Text(
        place.title,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        place.location.address,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => PlaceDetailsScreen(place: place)),
        );
      },
    );
  }
}
