import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tafasa/core/error/failure.dart';
import 'package:tafasa/core/utils/logger.dart';
import 'package:tafasa/features/favorites/data/datasource/favorites_datasource.dart';
import 'package:tafasa/features/favorites/domain/repository/favorites_repository.dart';
import 'package:tafasa/features/suggestions/data/model/recipe_model.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesDatasource _favoritesDatasource;

  FavoritesRepositoryImpl(this._favoritesDatasource);

  @override
  Future<Either<Failure, List<RecipeModel>>> getAllFavorites() async {
    try {
      final response = await _favoritesDatasource.getAllFavorites();
      Logger.log('✅ Favorites fetched successfully');
      Logger.debug(response.data.toString());

      if (response.data == null) {
        return const Right([]);
      }

      final List<dynamic> favoritesData = response.data as List;
      final favorites = favoritesData
          .map((item) => RecipeModel.fromJson(item))
          .toList();

      return Right(favorites);
    } on DioException catch (e) {
      Logger.error('❌ Failed to fetch favorites', e, StackTrace.current);
      return Left(
        Failure(e.response?.data['message'] ?? 'Failed to fetch favorites'),
      );
    } catch (e) {
      Logger.error(
        '❌ Unexpected error fetching favorites',
        e,
        StackTrace.current,
      );
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addFavorite(int mealId) async {
    try {
      await _favoritesDatasource.addFavorite(mealId);
      Logger.log('✅ Favorite added successfully');
      return const Right(null);
    } on DioException catch (e) {
      Logger.error('❌ Failed to add favorite', e, StackTrace.current);
      return Left(
        Failure(e.response?.data['message'] ?? 'Failed to add favorite'),
      );
    } catch (e) {
      Logger.error('❌ Unexpected error adding favorite', e, StackTrace.current);
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(int mealId) async {
    try {
      await _favoritesDatasource.removeFavorite(mealId);
      Logger.log('✅ Favorite removed successfully');
      return const Right(null);
    } on DioException catch (e) {
      Logger.error('❌ Failed to remove favorite', e, StackTrace.current);
      return Left(
        Failure(e.response?.data['message'] ?? 'Failed to remove favorite'),
      );
    } catch (e) {
      Logger.error(
        '❌ Unexpected error removing favorite',
        e,
        StackTrace.current,
      );
      return Left(Failure(e.toString()));
    }
  }
}
