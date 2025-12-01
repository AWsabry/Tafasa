import mongoose from 'mongoose';
import Meal from '../models/Meal.js';
import Category from '../models/Category.js';
import Favorite from '../models/Favorite.js';

const transformMeal = (meal, favoriteIds = new Set()) => {
    if (!meal) return meal;
    const obj = meal.toJSON ? meal.toJSON() : meal;
    if (obj.categoryId && typeof obj.categoryId === 'object') {
        obj.categoryId = {
            id: obj.categoryId.id || obj.categoryId._id?.toString(),
            name: obj.categoryId.name,
            description: obj.categoryId.description || null
        };
    }
    obj.isFavorite = favoriteIds.has(obj.id);
    return obj;
};

class MealService {
    static async createMeal(data) {
        try {
            const category = await Category.findById(data.categoryId);
            if (!category) {
                throw new Error('Category not found');
            }

            const meal = await Meal.create(data);
            const populated = await Meal.findById(meal.id).populate('categoryId', 'id name description');
            return transformMeal(populated);
        } catch (error) {
            throw error;
        }
    }

    static async getAllMeals(userId = null) {
        try {
            const meals = await Meal.find().populate('categoryId', 'id name description');
            let favoriteIds = new Set();
            if (userId) {
                const favs = await Favorite.find({ userId, mealId: { $in: meals.map(m => m.id) } }).select('mealId');
                favoriteIds = new Set(favs.map(f => f.mealId.toString()));
            }
            return meals.map((m) => transformMeal(m, favoriteIds));
        } catch (error) {
            throw error;
        }
    }

    static async getMealById(id, userId = null) {
        try {
            const meal = await Meal.findById(id).populate('categoryId', 'id name description');
            if (!meal) {
                throw new Error('Meal not found');
            }
            let favoriteIds = new Set();
            if (userId) {
                const fav = await Favorite.findOne({ userId, mealId: id });
                if (fav) favoriteIds.add(id.toString());
            }
            return transformMeal(meal, favoriteIds);
        } catch (error) {
            throw error;
        }
    }

    static async getMealsByCategory(categoryId, userId = null) {
        try {
            const meals = await Meal.find({ categoryId }).populate('categoryId', 'id name description');
            let favoriteIds = new Set();
            if (userId) {
                const favs = await Favorite.find({ userId, mealId: { $in: meals.map(m => m.id) } }).select('mealId');
                favoriteIds = new Set(favs.map(f => f.mealId.toString()));
            }
            return meals.map((m) => transformMeal(m, favoriteIds));
        } catch (error) {
            throw error;
        }
    }

    static async getRandomMeal(userId = null) {
        try {
            const meals = await Meal.aggregate([{ $sample: { size: 1 } }]);
            if (!meals.length) {
                throw new Error('No meals available');
            }
            const mealDoc = await Meal.findById(meals[0]._id).populate('categoryId', 'id name description');
            let favoriteIds = new Set();
            if (userId) {
                const fav = await Favorite.findOne({ userId, mealId: mealDoc.id });
                if (fav) favoriteIds.add(mealDoc.id.toString());
            }
            return transformMeal(mealDoc, favoriteIds);
        } catch (error) {
            throw error;
        }
    }

    static async getRandomMealByCategory(categoryId, userId = null) {
        try {
            const catObjectId = new mongoose.Types.ObjectId(categoryId);
            const meals = await Meal.aggregate([{ $match: { categoryId: catObjectId } }, { $sample: { size: 1 } }]);
            if (!meals.length) {
                throw new Error('No meals available for this category');
            }
            const mealDoc = await Meal.findById(meals[0]._id).populate('categoryId', 'id name description');
            let favoriteIds = new Set();
            if (userId) {
                const fav = await Favorite.findOne({ userId, mealId: mealDoc.id });
                if (fav) favoriteIds.add(mealDoc.id.toString());
            }
            return transformMeal(mealDoc, favoriteIds);
        } catch (error) {
            throw error;
        }
    }

    static async addIngredientToMeal(id, ingredient) {
        try {
            const meal = await Meal.findById(id);
            if (!meal) {
                throw new Error('Meal not found');
            }

            meal.ingredients = Array.isArray(meal.ingredients) ? meal.ingredients : [];
            meal.ingredients.push(ingredient);

            await meal.save();
            const updated = await Meal.findById(id).populate('categoryId', 'id name description');
            return transformMeal(updated);
        } catch (error) {
            throw error;
        }
    }

    static async updateMealIngredients(id, ingredients) {
        try {
            const meal = await Meal.findById(id);
            if (!meal) {
                throw new Error('Meal not found');
            }

            if (!Array.isArray(ingredients)) {
                throw new Error('Ingredients must be an array');
            }

            meal.ingredients = ingredients;
            await meal.save();

            const updated = await Meal.findById(id).populate('categoryId', 'id name description');
            return transformMeal(updated);
        } catch (error) {
            throw error;
        }
    }

    static async deleteMeal(id) {
        try {
            const meal = await Meal.findById(id);
            if (!meal) {
                throw new Error('Meal not found');
            }

            await meal.deleteOne();
            await Favorite.deleteMany({ mealId: id });
            return { message: 'Meal deleted successfully' };
        } catch (error) {
            throw error;
        }
    }

    static async updateMeal(id, data) {
        try {
            if (data.categoryId) {
                const category = await Category.findById(data.categoryId);
                if (!category) {
                    throw new Error('Category not found');
                }
            }

            const meal = await Meal.findByIdAndUpdate(id, data, { new: true }).populate('categoryId', 'id name description');
            if (!meal) {
                throw new Error('Meal not found');
            }
            return transformMeal(meal);
        } catch (error) {
            throw error;
        }
    }

    static async searchMeals(query, userId = null) {
        try {
            const regex = new RegExp(query, 'i');
            const meals = await Meal.find({
                $or: [
                    { name: regex },
                    { description: regex }
                ]
            }).populate('categoryId', 'id name description');

            let favoriteIds = new Set();
            if (userId) {
                const favs = await Favorite.find({ userId, mealId: { $in: meals.map(m => m.id) } }).select('mealId');
                favoriteIds = new Set(favs.map(f => f.mealId.toString()));
            }

            return meals.map((m) => transformMeal(m, favoriteIds));
        } catch (error) {
            throw error;
        }
    }
}

export default MealService;
