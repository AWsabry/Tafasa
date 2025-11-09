import 'package:food_gpt/core/managers/secure_storage.dart';
import 'package:food_gpt/core/services/api/api_service.dart';
import 'package:food_gpt/features/favorites/data/datasource/favorites_datasource.dart';
import 'package:food_gpt/features/favorites/data/repository/favorites_repository_impl.dart';
import 'package:food_gpt/features/favorites/domain/repository/favorites_repository.dart';
import 'package:food_gpt/features/favorites/presentation/controller/favorites_cubit.dart';
import 'package:food_gpt/features/home/data/datasource/get_categories_datasource.dart';
import 'package:food_gpt/features/home/data/repository/get_categories_repository_impl.dart';
import 'package:food_gpt/features/home/domain/repository/get_categories_repository.dart';
import 'package:food_gpt/features/home/presentation/controller/home_cubit.dart';
import 'package:food_gpt/features/login/data/datasource/login_datasource.dart';
import 'package:food_gpt/features/login/data/repository/login_repository_impl.dart';
import 'package:food_gpt/features/login/domain/repository/login_repository.dart';
import 'package:food_gpt/features/login/presentation/controller/login_cubit.dart';
import 'package:food_gpt/features/recipe_detail/data/datasource/recipe_detail_datasource.dart';
import 'package:food_gpt/features/recipe_detail/data/repository/recipe_detail_repository_impl.dart';
import 'package:food_gpt/features/recipe_detail/domain/repository/recipe_detail_repository.dart';
import 'package:food_gpt/features/recipe_detail/presentation/controller/recipe_detail_cubit.dart';
import 'package:food_gpt/features/register/data/datasource/register_datasource.dart';
import 'package:food_gpt/features/register/data/repository/register_repository_impl.dart';
import 'package:food_gpt/features/register/domain/repository/register_repository.dart';
import 'package:food_gpt/features/register/presentation/controller/register_cubit.dart';
import 'package:food_gpt/features/suggestions/data/datasource/suggestions_datasource.dart';
import 'package:food_gpt/features/suggestions/data/repository/suggestions_repository_impl.dart';
import 'package:food_gpt/features/suggestions/domain/repository/suggestions_repository.dart';
import 'package:food_gpt/features/suggestions/presentation/controller/suggestions_cubit.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;
final getIt = sl; // Alias for consistency

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  ServiceLocator._internal();
  factory ServiceLocator() {
    return _instance;
  }
  Future<void> init() async {
    // Core Services (singleton)
    sl.registerLazySingleton<DioClient>(() => DioClient());
    sl.registerLazySingleton<SecureStorageService>(
      () => SecureStorageService(),
    );

    // Register
    sl.registerLazySingleton<RegisterDatasource>(
      () => RegisterDatasource(dioClient: sl<DioClient>()),
    );
    sl.registerLazySingleton<RegisterRepository>(
      () => RegisterRepositoryImpl(sl<RegisterDatasource>()),
    );

    // Login
    sl.registerLazySingleton<LoginDatasource>(
      () => LoginDatasource(dioClient: sl<DioClient>()),
    );
    sl.registerLazySingleton<LoginRepository>(
      () => LoginRepositoryImpl(
        sl<LoginDatasource>(),
        sl<SecureStorageService>(),
      ),
    );

    // Home (Categories)
    sl.registerLazySingleton<GetCategoriesDatasource>(
      () => GetCategoriesDatasource(sl<DioClient>()),
    );
    sl.registerLazySingleton<GetCategoriesRepository>(
      () => GetCategoriesRepositoryImpl(sl<GetCategoriesDatasource>()),
    );

    // Suggestions
    sl.registerLazySingleton<SuggestionsDatasource>(
      () => SuggestionsDatasource(sl<DioClient>()),
    );
    sl.registerLazySingleton<SuggestionsRepository>(
      () => SuggestionsRepositoryImpl(sl<SuggestionsDatasource>()),
    );

    // Recipe Detail
    sl.registerLazySingleton<RecipeDetailDatasource>(
      () => RecipeDetailDatasource(sl<DioClient>()),
    );
    sl.registerLazySingleton<RecipeDetailRepository>(
      () => RecipeDetailRepositoryImpl(sl<RecipeDetailDatasource>()),
    );

    // Favorites
    sl.registerLazySingleton<FavoritesDatasource>(
      () => FavoritesDatasource(sl<DioClient>()),
    );
    sl.registerLazySingleton<FavoritesRepository>(
      () => FavoritesRepositoryImpl(sl<FavoritesDatasource>()),
    );

    // Cubits
    sl.registerFactory<RegisterCubit>(
      () => RegisterCubit(sl<RegisterRepository>()),
    );
    sl.registerFactory<LoginCubit>(
      () => LoginCubit(sl<LoginRepository>()),
    );
    sl.registerFactory<HomeCubit>(
      () => HomeCubit(sl<GetCategoriesRepository>()),
    );
    sl.registerFactory<SuggestionsCubit>(
      () => SuggestionsCubit(sl<SuggestionsRepository>()),
    );
    sl.registerFactory<RecipeDetailCubit>(
      () => RecipeDetailCubit(sl<RecipeDetailRepository>()),
    );
    sl.registerFactory<FavoritesCubit>(
      () => FavoritesCubit(sl<FavoritesRepository>()),
    );
  }
}
