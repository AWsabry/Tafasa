import 'package:dartz/dartz.dart';
import 'package:tafasa/core/error/failure.dart';
import 'package:tafasa/features/home/data/model/categories_model.dart';

abstract class GetCategoriesRepository {
  Future<Either<Failure, CategoriesResponse>> getCategories();
}
