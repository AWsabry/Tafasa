import Favorite from '../models/Favorite.js';
import Meal from '../models/Meal.js';
import Category from '../models/Category.js';

class FavoriteService {
    static async addFavorite(userId, mealId) {
        try {
            const meal = await Meal.findById(mealId);
            if (!meal) {
                throw new Error('Meal not found');
            }

            const existingFavorite = await Favorite.findOne({ userId, mealId });
            if (existingFavorite) {
                throw new Error('Meal is already in favorites');
            }

            const favorite = await Favorite.create({ userId, mealId });
            return favorite;
        } catch (error) {
            throw error;
        }
    }

    static async removeFavorite(userId, mealId) {
        try {
            const favorite = await Favorite.findOne({ userId, mealId });

            if (!favorite) {
                throw new Error('Favorite not found');
            }

            await favorite.deleteOne();
            return { message: 'Favorite removed successfully' };
        } catch (error) {
            throw error;
        }
    }

    static async getAllFavorites(userId) {
        try {
            const favorites = await Favorite.find({ userId })
                .populate({
                    path: 'mealId',
                    populate: { path: 'categoryId', select: 'id name' }
                });

            const formattedFavorites = favorites.map((favorite) => {
                const meal = favorite.mealId;
                return {
                    id: favorite.id,
                    mealId: meal.id,
                    name: meal.name,
                    description: meal.description,
                    image: meal.image,
                    ingredients: meal.ingredients,
                    preparationSteps: meal.preparationSteps,
                    categoryId: meal.categoryId?.id || meal.categoryId,
                    category: meal.categoryId
                };
            });

            return formattedFavorites;
        } catch (error) {
            throw error;
        }
    }
}

export default FavoriteService;
