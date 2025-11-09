import express from 'express';
import AuthController from '../controllers/authController.js';
import CategoryController from '../controllers/categoryController.js';
import MealController from '../controllers/mealController.js';
import FavoriteController from '../controllers/favoriteController.js';
import auth from '../middleware/auth.js';
import { apiLimiter, authLimiter } from '../middleware/rateLimiter.js';
import { validate, validateCategory, validateMeal, validateRegistration } from '../middleware/validation.js';

const router = express.Router();

// Apply rate limiting to all routes
router.use(apiLimiter);

// Home route
router.get('/', (req, res) => {
    res.status(200).json({ message: 'Welcome to Express API' });
});

// Auth routes
router.post('/auth/register', validateRegistration, validate, AuthController.register);
router.post('/auth/login', authLimiter, AuthController.login);
router.post('/auth/logout', auth, AuthController.logout);

// User routes (protected by auth)
router.get('/users', auth, AuthController.getAllUsers);
// Current authenticated user
router.get('/users/me', auth, AuthController.getCurrentUser);
router.get('/users/:id', auth, AuthController.getUserById);
router.delete('/users/:id', auth, AuthController.deleteUser);

// Category routes
router.post('/categories', auth, validateCategory, validate, CategoryController.createCategory);

// Get all categories
router.get('/categories', CategoryController.getAllCategories);

// Get category by ID
router.get('/categories/:id', CategoryController.getCategoryById);

// Delete category
router.delete('/categories/:id', auth, CategoryController.deleteCategory);

// Get meals by category
router.get('/categories/:categoryId/meals', MealController.getMealsByCategory);

// Recommended meal for a category (random)
router.get('/categories/:categoryId/recommended', MealController.getRecommendedMealByCategory);

// Meal routes
router.post('/meals', auth, validateMeal, validate, MealController.createMeal);

// Get all meals
router.get('/meals', MealController.getAllMeals);

// Recommended meal (random) - MUST be before /meals/:id
router.get('/meals/recommended', MealController.getRecommendedMeal);

// Get meal by ID
router.get('/meals/:id', MealController.getMealById);

// Add ingredient to meal
router.patch('/meals/:id/ingredients', auth, MealController.addIngredient);

// Update ingredients (PUT - replaces entire ingredients array)
router.put('/meals/:id/ingredients', auth, MealController.updateIngredients);



// Delete meal
router.delete('/meals/:id', auth, MealController.deleteMeal);

// Favorite routes (protected by auth)
router.post('/favorites', auth, FavoriteController.addFavorite);
router.get('/favorites', auth, FavoriteController.getAllFavorites);
router.delete('/favorites/:mealId', auth, FavoriteController.removeFavorite);

export default router;
