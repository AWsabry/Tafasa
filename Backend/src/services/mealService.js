import Meal from '../models/Meal.js';
import Category from '../models/Category.js';

class MealService {
    static async createMeal(data) {
        try {
            // Check if category exists
            const category = await Category.findByPk(data.categoryId);
            if (!category) {
                throw new Error('Category not found');
            }

            const meal = await Meal.create(data);
            return meal;
        } catch (error) {
            throw error;
        }
    }

    static async getAllMeals() {
        try {
            const meals = await Meal.findAll({
                include: [{
                    model: Category,
                    attributes: ['id', 'name']
                }]
            });
            return meals;
        } catch (error) {
            throw error;
        }
    }

    static async getMealById(id) {
        try {
            const meal = await Meal.findByPk(id, {
                include: [{
                    model: Category,
                    attributes: ['id', 'name']
                }]
            });
            if (!meal) {
                throw new Error('Meal not found');
            }
            return meal;
        } catch (error) {
            throw error;
        }
    }

    static async getMealsByCategory(categoryId) {
        try {
            const meals = await Meal.findAll({
                where: { categoryId },
                include: [{
                    model: Category,
                    attributes: ['id', 'name']
                }]
            });
            return meals;
        } catch (error) {
            throw error;
        }
    }

    static async getRandomMeal() {
        try {
            const count = await Meal.count();
            if (count === 0) {
                throw new Error('No meals available');
            }

            const randomOffset = Math.floor(Math.random() * count);
            const meals = await Meal.findAll({
                include: [{ model: Category, attributes: ['id', 'name'] }],
                offset: randomOffset,
                limit: 1
            });

            return meals[0] || null;
        } catch (error) {
            throw error;
        }
    }

    static async getRandomMealByCategory(categoryId) {
        try {
            const count = await Meal.count({ where: { categoryId } });
            if (count === 0) {
                throw new Error('No meals available for this category');
            }

            const randomOffset = Math.floor(Math.random() * count);
            const meals = await Meal.findAll({
                where: { categoryId },
                include: [{ model: Category, attributes: ['id', 'name'] }],
                offset: randomOffset,
                limit: 1
            });

            return meals[0] || null;
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
                include: [{ model: Category, attributes: ['id', 'name'] }]
            });
            return updated;
        } catch (error) {
            throw error;
        }
    }
}

export default MealService;