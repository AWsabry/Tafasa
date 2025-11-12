import MealService from '../services/mealService.js';
import Category from '../models/Category.js';
import xlsx from 'xlsx';

const parseIngredients = (value) => {
    if (!value) return [];

    if (typeof value === 'string') {
        const trimmed = value.trim();
        if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
            try {
                const parsed = JSON.parse(trimmed);
                return parseIngredients(parsed);
            } catch (error) {
                // fall back to delimiter parsing
            }
        }
    }

    if (Array.isArray(value)) {
        return value
            .map(item => (typeof item === 'string' ? item : `${item.name || ''}`))
            .filter(Boolean)
            .map((item) => {
                if (typeof item === 'string') {
                    const parts = item.split('|').map(part => part.trim());
                    return {
                        name: parts[0],
                        amount: parts[1] ? Number(parts[1]) : undefined,
                        unit: parts[2] || undefined
                    };
                }
                return item;
            });
    }

    const segments = String(value).split(';').map(segment => segment.trim()).filter(Boolean);
    return segments.map((segment) => {
        const parts = segment.split('|').map(part => part.trim());
        return {
            name: parts[0],
            amount: parts[1] ? Number(parts[1]) : undefined,
            unit: parts[2] || undefined
        };
    });
};

const parsePreparationSteps = (value) => {
    if (!value) return [];

    if (typeof value === 'string') {
        const trimmed = value.trim();
        if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
            try {
                const parsed = JSON.parse(trimmed);
                return parsePreparationSteps(parsed);
            } catch (error) {
                // fall back to delimiter parsing
            }
        }
    }

    if (Array.isArray(value)) {
        return value.map((step, index) => ({
            step: step.step || index + 1,
            description: step.description || String(step)
        })).filter(step => step.description && step.description.trim() !== '');
    }

    const raw = String(value).split(/;|\n/).map(item => item.trim()).filter(Boolean);
    return raw.map((description, index) => ({
        step: index + 1,
        description
    }));
};

class MealController {
    static async createMeal(req, res) {
        try {
            const { name, description, price, image, categoryId, ingredients, preparationSteps } = req.body;
            
            if (!name || !price || !categoryId) {
                return res.status(400).json({ error: 'Name, price, and category are required' });
            }

            const meal = await MealService.createMeal({
                name,
                description,
                price,
                image,
                categoryId,
                ingredients: ingredients || [],
                preparationSteps: preparationSteps || []
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
            // Extract userId from query params or authenticated user
            const userId = req.query.userId || (req.user ? req.user.id : null);
            const meals = await MealService.getAllMeals(userId);
            res.json(meals);
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    }

    static async getMealById(req, res) {
        try {
            const { id } = req.params;
            // Extract userId from query params or authenticated user
            const userId = req.query.userId || (req.user ? req.user.id : null);
            const meal = await MealService.getMealById(id, userId);
            res.json(meal);
        } catch (error) {
            res.status(404).json({ error: error.message });
        }
    }

    static async getMealsByCategory(req, res) {
        try {
            const { categoryId } = req.params;
            // Extract userId from query params or authenticated user
            const userId = req.query.userId || (req.user ? req.user.id : null);
            const meals = await MealService.getMealsByCategory(categoryId, userId);
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
            // Extract userId from query params or authenticated user
            const userId = req.query.userId || (req.user ? req.user.id : null);
            const meal = await MealService.getRandomMeal(userId);
            if (!meal) return res.status(404).json({ error: 'No meals available' });
            res.json({ message: 'Recommended meal', meal });
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    }

    static async getRecommendedMealByCategory(req, res) {
        try {
            const { categoryId } = req.params;
            // Extract userId from query params or authenticated user
            const userId = req.query.userId || (req.user ? req.user.id : null);
            const meal = await MealService.getRandomMealByCategory(categoryId, userId);
            if (!meal) return res.status(404).json({ error: 'No meals available for this category' });
            res.json({ message: 'Recommended meal for category', meal });
        } catch (error) {
            if (error.message && error.message.includes('No meals')) {
                return res.status(404).json({ error: error.message });
            }
            res.status(500).json({ error: error.message });
        }
    }

    static async deleteMeal(req, res) {
        try {
            const { id } = req.params;
            const result = await MealService.deleteMeal(id);
            res.json(result);
        } catch (error) {
            if (error.message === 'Meal not found') {
                return res.status(404).json({ error: error.message });
            }
            res.status(500).json({ error: error.message });
        }
    }

    static async updateIngredients(req, res) {
        try {
            const { id } = req.params;
            const { ingredients } = req.body;

            if (!ingredients) {
                return res.status(400).json({ error: 'Ingredients array is required' });
            }

            if (!Array.isArray(ingredients)) {
                return res.status(400).json({ error: 'Ingredients must be an array' });
            }

            const updatedMeal = await MealService.updateMealIngredients(id, ingredients);
            res.json({ 
                message: 'Ingredients updated successfully', 
                meal: updatedMeal 
            });
        } catch (error) {
            if (error.message && error.message.includes('not found')) {
                return res.status(404).json({ error: error.message });
            }
            if (error.message && error.message.includes('must be')) {
                return res.status(400).json({ error: error.message });
            }
            res.status(500).json({ error: error.message });
        }
    }

    static async uploadMealsFromExcel(req, res) {
        try {
            if (!req.file) {
                return res.status(400).json({ error: 'No file provided. Please upload an Excel file.' });
            }

            const workbook = xlsx.read(req.file.buffer, { type: 'buffer' });
            const sheetName = workbook.SheetNames[0];
            if (!sheetName) {
                return res.status(400).json({ error: 'The uploaded file does not contain any sheets.' });
            }

            const worksheet = workbook.Sheets[sheetName];
            const rows = xlsx.utils.sheet_to_json(worksheet, { defval: '' });

            if (!rows.length) {
                return res.status(400).json({ error: 'The uploaded sheet is empty.' });
            }

            const summary = { processed: rows.length, created: 0, failed: 0 };
            const createdMeals = [];
            const errors = [];

            const normalizeRow = (row) => {
                const normalized = {};
                Object.keys(row).forEach((key) => {
                    normalized[key.trim().toLowerCase()] = row[key];
                });
                return normalized;
            };

            for (let index = 0; index < rows.length; index += 1) {
                const row = normalizeRow(rows[index]);

                try {
                    const name = String(row['name'] || '').trim();
                    const priceRaw = row['price'];
                    const description = row['description'] ? String(row['description']).trim() : null;
                    const image = row['image'] ? String(row['image']).trim() : null;
                    const categoryIdRaw = row['categoryid'];
                    const categoryName = row['categoryname'] ? String(row['categoryname']).trim() : null;

                    if (!name) {
                        throw new Error('Name is required');
                    }

                    if (priceRaw === undefined || priceRaw === null || String(priceRaw).trim() === '') {
                        throw new Error('Price is required');
                    }

                    const price = Number(priceRaw);
                    if (Number.isNaN(price)) {
                        throw new Error('Price must be a valid number');
                    }

                    let categoryId = categoryIdRaw !== undefined && categoryIdRaw !== null && String(categoryIdRaw).trim() !== ''
                        ? Number(categoryIdRaw)
                        : null;

                    if (categoryId !== null && Number.isNaN(categoryId)) {
                        throw new Error('CategoryId must be a valid number');
                    }

                    if (!categoryId && categoryName) {
                        const category = await Category.findOne({
                            where: { name: categoryName }
                        });
                        if (!category) {
                            throw new Error(`Category with name "${categoryName}" was not found`);
                        }
                        categoryId = category.id;
                    }

                    if (!categoryId) {
                        throw new Error('Either CategoryId or CategoryName is required');
                    }

                    const ingredients = parseIngredients(row['ingredients']);
                    const preparationSteps = parsePreparationSteps(row['preparationsteps']);

                    const meal = await MealService.createMeal({
                        name,
                        description,
                        price,
                        image,
                        categoryId,
                        ingredients,
                        preparationSteps
                    });

                    createdMeals.push(meal);
                    summary.created += 1;
                } catch (error) {
                    summary.failed += 1;
                    errors.push({
                        row: index + 2, // account for header row in Excel
                        error: error.message || 'Unknown error'
                    });
                }
            }

            const status = summary.failed > 0 ? 207 : 201;
            res.status(status).json({
                message: 'Meal upload processed',
                summary,
                meals: createdMeals,
                errors
            });
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    }
}

export default MealController;