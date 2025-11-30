import { body, validationResult } from 'express-validator';

export const validateRegistration = [
    body('username')
        .trim()
        .isLength({ min: 3, max: 30 })
        .withMessage('Username must be between 3 and 30 characters')
        .matches(/^[a-zA-Z0-9_]+$/)
        .withMessage('Username can only contain letters, numbers and underscores'),
    body('email')
        .optional({ checkFalsy: true })
        .trim()
        .isEmail()
        .normalizeEmail()
        .withMessage('Please enter a valid email'),
    body('password')
        .isLength({ min: 6 })
        .withMessage('Password must be at least 6 characters long')
        .matches(/\d/)
        .withMessage('Password must contain at least one number'),
    body('phoneNumber')
        .trim()
        .notEmpty()
        .withMessage('Phone number is required')
        .matches(/^\+?[1-9]\d{1,14}$/)
        .withMessage('Please enter a valid international phone number format'),
    body('age')
        .optional()
        .isInt({ min: 1, max: 150 })
        .withMessage('Age must be between 1 and 150'),
];

export const validateMeal = [
    body('name')
        .trim()
        .notEmpty()
        .withMessage('Meal name is required')
        .isLength({ max: 100 })
        .withMessage('Meal name must not exceed 100 characters'),
    body('price')
        .isFloat({ min: 0 })
        .withMessage('Price must be a positive number'),
    body('categoryId')
        .isInt()
        .withMessage('Valid category ID is required'),
    body('image')
        .optional()
        .isURL()
        .withMessage('Image must be a valid URL'),
];

export const validateCategory = [
    body('name')
        .trim()
        .notEmpty()
        .withMessage('Category name is required')
        .isLength({ max: 50 })
        .withMessage('Category name must not exceed 50 characters'),
];

export const validate = (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        console.log('Validation errors:', errors.array());
        return res.status(400).json({
            error: 'Validation failed',
            errors: errors.array()
        });
    }
    next();
};