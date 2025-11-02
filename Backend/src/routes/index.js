import express from 'express';
import AuthController from '../controllers/authController.js';
import CategoryController from '../controllers/categoryController.js';
import MealController from '../controllers/mealController.js';
import auth from '../middleware/auth.js';
import { validateRegistration, validateMeal, validateCategory, validate } from '../middleware/validation.js';
import { authLimiter, apiLimiter } from '../middleware/rateLimiter.js';

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

// Category routes
router.post('/categories', auth, validateCategory, validate, CategoryController.createCategory);

// Get all categories
router.get('/categories', CategoryController.getAllCategories);

// Get category by ID
router.get('/categories/:id', CategoryController.getCategoryById);

// Meal routes
router.post('/meals', auth, validateMeal, validate, MealController.createMeal);

// Get all meals
router.get('/meals', MealController.getAllMeals);

// Get meal by ID
router.get('/meals/:id', MealController.getMealById);

// Add ingredient to meal
router.patch('/meals/:id/ingredients', auth, MealController.addIngredient);

// Get meals by category
router.get('/categories/:categoryId/meals', MealController.getMealsByCategory);

// Recommended meal (random)
router.get('/meals/recommended', MealController.getRecommendedMeal);

// Recommended meal for a category (random)
router.get('/categories/:categoryId/recommended', MealController.getRecommendedMealByCategory);

export default router;
