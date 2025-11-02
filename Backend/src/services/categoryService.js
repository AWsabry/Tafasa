import Category from '../models/Category.js';
import Meal from '../models/Meal.js';

class CategoryService {
    static async createCategory(data) {
        try {
            const category = await Category.create(data);
            return category;
        } catch (error) {
            throw error;
        }
    }

    static async getAllCategories() {
        try {
            const categories = await Category.findAll({
                include: [{
                    model: Meal,
                    attributes: ['id', 'name', 'price']
                }]
            });
            return categories;
        } catch (error) {
            throw error;
        }
    }

    static async getCategoryById(id) {
        try {
            const category = await Category.findByPk(id, {
                include: [{
                    model: Meal,
                    attributes: ['id', 'name', 'description', 'price', 'image']
                }]
            });
            if (!category) {
                throw new Error('Category not found');
            }
            return category;
        } catch (error) {
            throw error;
        }
    }

    static async deleteCategory(id) {
        try {
            const category = await Category.findByPk(id, {
                include: [{
                    model: Meal
                }]
            });
            
            if (!category) {
                throw new Error('Category not found');
            }

            // Check if category has associated meals
            if (category.Meals && category.Meals.length > 0) {
                throw new Error('Cannot delete category with associated meals. Please delete or reassign meals first.');
            }

            await category.destroy();
            return { message: 'Category deleted successfully' };
        } catch (error) {
            throw error;
        }
    }
}

export default CategoryService;