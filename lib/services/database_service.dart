import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _moviesCollection(
    String userId,
  ) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('movies');
  }

  Future<void> updateMovieList({
    required String userId,
    required Movie movie,
    required String listName,
    required bool value,
  }) async {
    final movieDocument = _moviesCollection(userId).doc(
      movie.id.toString(),
    );

    await movieDocument.set(
      {
        ...movie.toMap(),
        listName: value,
      },
      SetOptions(merge: true),
    );
  }

  Future<List<Movie>> getMoviesByList({
    required String userId,
    required String listName,
  }) async {
    final snapshot = await _moviesCollection(userId)
        .where(listName, isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => Movie.fromMap(doc.data()))
        .toList();
  }

  Future<Map<String, bool>> getMovieLists({
    required String userId,
    required int movieId,
  }) async {
    final document = await _moviesCollection(userId)
        .doc(movieId.toString())
        .get();

    if (!document.exists) {
      return {
        'favorite': false,
        'watched': false,
        'watching': false,
        'wantToWatch': false,
      };
    }

    final data = document.data()!;

    return {
      'favorite': data['favorite'] == true,
      'watched': data['watched'] == true,
      'watching': data['watching'] == true,
      'wantToWatch': data['wantToWatch'] == true,
    };
  }

  Future<void> deleteMovie({
    required String userId,
    required int movieId,
  }) async {
    await _moviesCollection(userId)
        .doc(movieId.toString())
        .delete();
  }
}