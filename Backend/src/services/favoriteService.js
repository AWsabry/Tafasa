import Favorite from '../models/Favorite.js';
import Meal from '../models/Meal.js';
import Category from '../models/Category.js';

class FavoriteService {
    static async addFavorite(userId, mealId) {
        try {
            // Check if meal exists
            const meal = await Meal.findByPk(mealId);
            if (!meal) {
                throw new Error('Meal not found');
            }

            // Check if favorite already exists
            const existingFavorite = await Favorite.findOne({
                where: { userId, mealId }
            });

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
            const favorite = await Favorite.findOne({
                where: { userId, mealId }
            });

            if (!favorite) {
                throw new Error('Favorite not found');
            }

            await favorite.destroy();
            return { message: 'Favorite removed successfully' };
        } catch (error) {
            throw error;
        }
    }

    static async getAllFavorites(userId) {
        try {
            const favorites = await Favorite.findAll({
                where: { userId },
                include: [
                    {
                        model: Meal,
                        attributes: ['id', 'name', 'description', 'price', 'image', 'ingredients', 'preparationSteps', 'categoryId'],
                        include: [
                            {
                                model: Category,
                                attributes: ['id', 'name']
                            }
                        ]
                    }
                ]
            });

            // Format the response to include all required meal details
            const formattedFavorites = favorites.map(favorite => ({
                id: favorite.id,
                mealId: favorite.mealId,
                name: favorite.Meal.name,
                description: favorite.Meal.description,
                price: favorite.Meal.price,
                image: favorite.Meal.image,
                ingredients: favorite.Meal.ingredients,
                preparationSteps: favorite.Meal.preparationSteps,
                categoryId: favorite.Meal.categoryId,
                category: favorite.Meal.Category
            }));

            return formattedFavorites;
        } catch (error) {
            throw error;
        }
    }
}

export default FavoriteService;
