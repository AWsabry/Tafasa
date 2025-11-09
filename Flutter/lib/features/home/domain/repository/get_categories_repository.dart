import 'package:dartz/dartz.dart';
import 'package:food_gpt/core/error/failure.dart';
import 'package:food_gpt/features/home/data/model/categories_model.dart';

abstract class GetCategoriesRepository {
  Future<Either<Failure, CategoriesResponse>> getCategories();
}
