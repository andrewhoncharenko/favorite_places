import "dart:io";

import "package:favorite_places/models/place.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:path_provider/path_provider.dart" as syspath;
import "package:path/path.dart" as path;
import "package:sqflite/sqflite.dart" as sql;
import "package:sqflite/sqlite_api.dart";

Future<Database> _getDatabase() async {
  final String dbPath = await sql.getDatabasesPath();
  final databaseFuture = sql.openDatabase(
    path.join(dbPath, "places.db"),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE user_places(id TEXT PRINARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)",
      );
    },
    version: 1,
  );
  return databaseFuture;
}

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super(const []);
  Future<void> loadPlaces() async {
    final Database db = await _getDatabase();
    final data = await db.query("user_places");
    final List<Place> places =
        data
            .map(
              (row) => Place(
                id: row["id"] as String,
                title: row["title"] as String,
                image: File(row["image"] as String),
                location: PlaceLocation(
                  latitude: row["lat"] as double,
                  longitude: row["lng"] as double,
                  address: row["address"] as String,
                ),
              ),
            )
            .toList();
    state = places;
  }

  void addPlace(String title, File image, PlaceLocation location) async {
    final Directory appDir = await syspath.getApplicationDocumentsDirectory();
    final String fileName = path.basename(image.path);
    final File copiedImage = await image.copy("${appDir.path}/$fileName");
    Place newPlace = Place(
      title: title,
      image: copiedImage,
      location: location,
    );
    final Database db = await _getDatabase();

    db.insert("user_places", {
      "id": newPlace.id,
      "title": newPlace.title,
      "image": newPlace.image.path,
      "lat": newPlace.location.latitude,
      "lng": newPlace.location.longitude,
      "address": newPlace.location.address,
    });
    state = [...state, newPlace];
  }
}

final placesProvider = StateNotifierProvider<PlacesNotifier, List<Place>>((
  Ref ref,
) {
  return PlacesNotifier();
});
