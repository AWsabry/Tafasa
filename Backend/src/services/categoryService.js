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
            const categories = await Category.find();
            return categories;
        } catch (error) {
            throw error;
        }
    }

    static async getCategoryById(id) {
        try {
            const category = await Category.findById(id);
            if (!category) {
                throw new Error('Category not found');
            }
            const meals = await Meal.find({ categoryId: id }).select('id name description image');
            const categoryObj = category.toJSON();
            categoryObj.Meals = meals;
            return categoryObj;
        } catch (error) {
            throw error;
        }
    }

    static async deleteCategory(id) {
        try {
            const meals = await Meal.find({ categoryId: id }).limit(1);
            if (meals.length > 0) {
                throw new Error('Cannot delete category with associated meals. Please delete or reassign meals first.');
            }

            const category = await Category.findById(id);
            if (!category) {
                throw new Error('Category not found');
            }

            await category.deleteOne();
            return { message: 'Category deleted successfully' };
        } catch (error) {
            throw error;
        }
    }
}

export default CategoryService;
