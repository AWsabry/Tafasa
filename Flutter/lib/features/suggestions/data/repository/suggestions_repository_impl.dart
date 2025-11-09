import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:food_gpt/core/error/failure.dart';
import 'package:food_gpt/core/managers/failure_handler.dart';
import 'package:food_gpt/core/utils/logger.dart';
import 'package:food_gpt/features/suggestions/data/datasource/suggestions_datasource.dart';
import 'package:food_gpt/features/suggestions/data/model/recipe_model.dart';
import 'package:food_gpt/features/suggestions/domain/repository/suggestions_repository.dart';

class SuggestionsRepositoryImpl implements SuggestionsRepository {
  final SuggestionsDatasource _datasource;

  SuggestionsRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, SuggestionsResponse>> getSuggestions({
    int? categoryId,
  }) async {
    try {
      final response = await _datasource.getSuggestions(categoryId: categoryId);
      final suggestionsResponse = SuggestionsResponse.fromJson(response.data);
      return Right(suggestionsResponse);
    } on DioException catch (e) {
      return Left(FailureHandler.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, RecipeModel>> getRandomSuggestion({
    int? categoryId,
  }) async {
    try {
      final response = await _datasource.getRandomSuggestion(
        categoryId: categoryId,
      );
      // API returns the meal directly, not wrapped in 'recipe' key
      Logger.debug(response.data.toString());
      final recipe = RecipeModel.fromJson(response.data["meal"]);
      return Right(recipe);
    } on DioException catch (e) {
      return Left(FailureHandler.fromDioError(e));
    }
  }
}
