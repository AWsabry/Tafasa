import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:food_gpt/core/error/failure.dart';
import 'package:food_gpt/core/managers/failure_handler.dart';
import 'package:food_gpt/core/utils/logger.dart';
import 'package:food_gpt/features/home/data/datasource/get_categories_datasource.dart';
import 'package:food_gpt/features/home/data/model/categories_model.dart';
import 'package:food_gpt/features/home/domain/repository/get_categories_repository.dart';

class GetCategoriesRepositoryImpl implements GetCategoriesRepository {
  final GetCategoriesDatasource _datasource;

  GetCategoriesRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, CategoriesResponse>> getCategories() async {
    try {
      final response = await _datasource.getCategories();
      Logger.debug(response.data.toString());

      final data = response.data;

      if (data is List && data.isNotEmpty) {
        final categoriesResponse = CategoriesResponse.fromJson(data);
        return Right(categoriesResponse);
      } else {
        return Left(Failure("لا يوجد أصناف حاليا"));
      }
    } on DioException catch (e) {
      return Left(FailureHandler.fromDioError(e));
    }
  }
}
