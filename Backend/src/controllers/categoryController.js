import CategoryService from '../services/categoryService.js';

class CategoryController {
    static async createCategory(req, res) {
        try {
            const { name, description } = req.body;
            
            if (!name) {
                return res.status(400).json({ error: 'Category name is required' });
            }

            const category = await CategoryService.createCategory({ name, description });
            
            res.status(201).json({
                message: 'Category created successfully',
                category
            });
        } catch (error) {
            res.status(400).json({ error: error.message });
        }
    }

    static async getAllCategories(req, res) {
        try {
            const categories = await CategoryService.getAllCategories();
            res.json(categories);
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    }

    static async getCategoryById(req, res) {
        try {
            const { id } = req.params;
            const category = await CategoryService.getCategoryById(id);
            res.json(category);
        } catch (error) {
            res.status(404).json({ error: error.message });
        }
    }
}

export default CategoryController;