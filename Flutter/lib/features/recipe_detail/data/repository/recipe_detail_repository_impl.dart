import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:food_gpt/core/error/failure.dart';
import 'package:food_gpt/core/managers/failure_handler.dart';
import 'package:food_gpt/core/utils/logger.dart';
import 'package:food_gpt/features/recipe_detail/data/datasource/recipe_detail_datasource.dart';
import 'package:food_gpt/features/recipe_detail/domain/repository/recipe_detail_repository.dart';
import 'package:food_gpt/features/suggestions/data/model/recipe_model.dart';

class RecipeDetailRepositoryImpl implements RecipeDetailRepository {
  final RecipeDetailDatasource _datasource;

  RecipeDetailRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, RecipeModel>> getRecipeById(int recipeId) async {
    try {
      final response = await _datasource.getRecipeById(recipeId);
      Logger.debug(response.data.toString());
      final recipe = RecipeModel.fromJson(response.data);
      return Right(recipe);
    } on DioException catch (e) {
      return Left(FailureHandler.fromDioError(e));
    }
  }
}
