import Meal from '../models/Meal.js';
import Category from '../models/Category.js';
import Favorite from '../models/Favorite.js';

// Helper function to transform meal response: categoryId becomes an object with id, name, description
const transformMealResponse = (meal, userId = null) => {
    if (!meal) return meal;

    const mealData = meal.toJSON ? meal.toJSON() : meal;
    const category = mealData.Category || mealData.category;

    if (category) {
        mealData.categoryId = {
            id: category.id,
            name: category.name,
            description: category.description || null
        };
        // Remove the nested Category object
        delete mealData.Category;
        delete mealData.category;
    }

    // Add isFavorite attribute based on Favorites relation
    if (userId !== null && mealData.Favorites) {
        mealData.isFavorite = mealData.Favorites.length > 0;
        delete mealData.Favorites;
    } else if (userId === null) {
        // If no userId provided, set isFavorite to false
        mealData.isFavorite = false;
    }

    return mealData;
};

const transformMealsResponse = (meals, userId = null) => {
    if (Array.isArray(meals)) {
        return meals.map(meal => transformMealResponse(meal, userId));
    }
    return transformMealResponse(meals, userId);
};

class MealService {
    static async createMeal(data) {
        try {
            // Check if category exists
            const category = await Category.findByPk(data.categoryId);
            if (!category) {
                throw new Error('Category not found');
            }

            const meal = await Meal.create(data);
            // Reload with category to include full category data
            const mealWithCategory = await Meal.findByPk(meal.id, {
                include: [{
                    model: Category,
                    attributes: ['id', 'name', 'description']
                }]
            });
            return transformMealResponse(mealWithCategory);
        } catch (error) {
            throw error;
        }
    }

    static async getAllMeals(userId = null) {
        try {
            const includeOptions = [
                {
                    model: Category,
                    attributes: ['id', 'name', 'description']
                }
            ];

            // Add Favorites relation if userId is provided
            if (userId) {
                includeOptions.push({
                    model: Favorite,
                    attributes: ['id'],
                    where: { userId },
                    required: false
                });
            }

            const meals = await Meal.findAll({
                include: includeOptions
            });
            return transformMealsResponse(meals, userId);
        } catch (error) {
            throw error;
        }
    }

    static async getMealById(id, userId = null) {
        try {
            const includeOptions = [
                {
                    model: Category,
                    attributes: ['id', 'name', 'description']
                }
            ];

            // Add Favorites relation if userId is provided
            if (userId) {
                includeOptions.push({
                    model: Favorite,
                    attributes: ['id'],
                    where: { userId },
                    required: false
                });
            }

            const meal = await Meal.findByPk(id, {
                include: includeOptions
            });
            if (!meal) {
                throw new Error('Meal not found');
            }
            return transformMealResponse(meal, userId);
        } catch (error) {
            throw error;
        }
    }

    static async getMealsByCategory(categoryId, userId = null) {
        try {
            const includeOptions = [
                {
                    model: Category,
                    attributes: ['id', 'name', 'description']
                }
            ];

            // Add Favorites relation if userId is provided
            if (userId) {
                includeOptions.push({
                    model: Favorite,
                    attributes: ['id'],
                    where: { userId },
                    required: false
                });
            }

            const meals = await Meal.findAll({
                where: { categoryId },
                include: includeOptions
            });
            return transformMealsResponse(meals, userId);
        } catch (error) {
            throw error;
        }
    }

    static async getRandomMeal(userId = null) {
        try {
            const count = await Meal.count();
            if (count === 0) {
                throw new Error('No meals available');
            }

            const includeOptions = [
                { model: Category, attributes: ['id', 'name', 'description'] }
            ];

            // Add Favorites relation if userId is provided
            if (userId) {
                includeOptions.push({
                    model: Favorite,
                    attributes: ['id'],
                    where: { userId },
                    required: false
                });
            }

            const randomOffset = Math.floor(Math.random() * count);
            const meals = await Meal.findAll({
                include: includeOptions,
                offset: randomOffset,
                limit: 1
            });

            return meals[0] ? transformMealResponse(meals[0], userId) : null;
        } catch (error) {
            throw error;
        }
    }

    static async getRandomMealByCategory(categoryId, userId = null) {
        try {
            const count = await Meal.count({ where: { categoryId } });
            if (count === 0) {
                throw new Error('No meals available for this category');
            }

            const includeOptions = [
                { model: Category, attributes: ['id', 'name', 'description'] }
            ];

            // Add Favorites relation if userId is provided
            if (userId) {
                includeOptions.push({
                    model: Favorite,
                    attributes: ['id'],
                    where: { userId },
                    required: false
                });
            }

            const randomOffset = Math.floor(Math.random() * count);
            const meals = await Meal.findAll({
                where: { categoryId },
                include: includeOptions,
                offset: randomOffset,
                limit: 1
            });

            return meals[0] ? transformMealResponse(meals[0], userId) : null;
        } catch (error) {
            throw error;
        }
    }

    static async addIngredientToMeal(id, ingredient) {
        try {
            const meal = await Meal.findByPk(id);
            if (!meal) {
                throw new Error('Meal not found');
            }

            const ingredients = Array.isArray(meal.ingredients) ? meal.ingredients : [];
            ingredients.push(ingredient);
            meal.ingredients = ingredients;

            await meal.save();
            // reload with category
            const updated = await Meal.findByPk(id, {
                include: [{ model: Category, attributes: ['id', 'name', 'description'] }]
            });
            return transformMealResponse(updated);
        } catch (error) {
            throw error;
        }
    }

    static async updateMealIngredients(id, ingredients) {
        try {
            const meal = await Meal.findByPk(id);
            if (!meal) {
                throw new Error('Meal not found');
            }

            // Validate that ingredients is an array
            if (!Array.isArray(ingredients)) {
                throw new Error('Ingredients must be an array');
            }

            // Validate each ingredient
            ingredients.forEach((ingredient, index) => {
                if (typeof ingredient !== 'object' || !ingredient.name) {
                    throw new Error(`Ingredient at index ${index} must be an object with a name property`);
                }
            });

            meal.ingredients = ingredients;
            await meal.save();

            // Reload with category
            const updated = await Meal.findByPk(id, {
                include: [{ model: Category, attributes: ['id', 'name', 'description'] }]
            });
            return transformMealResponse(updated);
        } catch (error) {
            throw error;
        }
    }

    static async deleteMeal(id) {
        try {
            const meal = await Meal.findByPk(id);
            if (!meal) {
                throw new Error('Meal not found');
            }

            await meal.destroy();
            return { message: 'Meal deleted successfully' };
        } catch (error) {
            throw error;
        }
    }
}

export default MealService;