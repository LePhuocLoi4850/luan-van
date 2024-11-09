import 'package:get/get.dart';
import 'package:jobapp/models/favorites.dart';

class FavoritesController extends GetxController {
  final _favorites = Favorites();

  final _favoritesData = <Favorite>[].obs;

  List<Favorite> get favoritesData => _favoritesData;
  bool isLoad = true;
  void addFavorites(Favorite favorites) {
    _favorites.addFavorites(favorites.toMap());
    _favoritesData.add(favorites);

    printFavorites();
  }

  void removeFavorites(int uid, int jid) {
    _favorites.removeFavorites(uid, jid);
    _favoritesData.removeWhere(
        (favorites) => favorites.uid == uid && favorites.jid == jid);
    printFavorites();
  }

  void clearFavoritesData() {
    _favorites.clearFavoritesData();
    _favoritesData.clear();
  }

  void fetchFavoritesData() {
    _favoritesData.assignAll(
        _favorites.favoritesData.map((map) => Favorite.fromMap(map)));
  }

  void printFavorites() {
    print("Current favorites:");
    for (var favorite in _favoritesData) {
      print(
          "UID: ${favorite.uid}, JID: ${favorite.jid}, Title: ${favorite.title}");
    }
  }
}

class Favorites {
  List<Map<String, dynamic>> _favoritesData = [];

  List<Map<String, dynamic>> get favoritesData => _favoritesData;

  void addFavorites(Map<String, dynamic> favorites) {
    _favoritesData.add(favorites);
  }

  void removeFavorites(int uid, int jid) {
    _favoritesData.removeWhere(
        (favorites) => favorites['uid'] == uid && favorites['jid'] == jid);
  }

  void clearFavoritesData() {
    _favoritesData.clear();
  }

  Map<String, dynamic>? getFavoritesById(int cvId) {
    final cv = _favoritesData.firstWhere((cv) => cv['cv_id'] == cvId,
        orElse: () => {});
    return cv.isNotEmpty ? cv : null;
  }
}
