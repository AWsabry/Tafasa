import MealService from '../services/mealService.js';

class MealController {
    static async createMeal(req, res) {
        try {
            const { name, description, price, image, categoryId } = req.body;
            
            if (!name || !price || !categoryId) {
                return res.status(400).json({ error: 'Name, price, and category are required' });
            }

            const meal = await MealService.createMeal({
                name,
                description,
                price,
                image,
                categoryId
            });
            
            res.status(201).json({
                message: 'Meal created successfully',
                meal
            });
        } catch (error) {
            res.status(400).json({ error: error.message });
        }
    }

    static async getAllMeals(req, res) {
        try {
            const meals = await MealService.getAllMeals();
            res.json(meals);
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    }

    static async getMealById(req, res) {
        try {
            const { id } = req.params;
            const meal = await MealService.getMealById(id);
            res.json(meal);
        } catch (error) {
            res.status(404).json({ error: error.message });
        }
    }

    static async getMealsByCategory(req, res) {
        try {
            const { categoryId } = req.params;
            const meals = await MealService.getMealsByCategory(categoryId);
            res.json(meals);
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    }

    static async addIngredient(req, res) {
        try {
            const { id } = req.params;
            const { name, amount, unit } = req.body;

            if (!name) {
                return res.status(400).json({ error: 'Ingredient name is required' });
            }

            const updatedMeal = await MealService.addIngredientToMeal(id, { name, amount, unit });
            res.json({ message: 'Ingredient added', meal: updatedMeal });
        } catch (error) {
            if (error.message && error.message.includes('not found')) {
                return res.status(404).json({ error: error.message });
            }
            res.status(400).json({ error: error.message });
        }
    }

    static async getRecommendedMeal(req, res) {
        try {
            const meal = await MealService.getRandomMeal();
            if (!meal) return res.status(404).json({ error: 'No meals available' });
            res.json({ message: 'Recommended meal', meal });
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    }

    static async getRecommendedMealByCategory(req, res) {
        try {
            const { categoryId } = req.params;
            const meal = await MealService.getRandomMealByCategory(categoryId);
            if (!meal) return res.status(404).json({ error: 'No meals available for this category' });
            res.json({ message: 'Recommended meal for category', meal });
        } catch (error) {
            if (error.message && error.message.includes('No meals')) {
                return res.status(404).json({ error: error.message });
            }
            res.status(500).json({ error: error.message });
        }
    }
}

export default MealController;