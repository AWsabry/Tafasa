import FavoriteService from '../services/favoriteService.js';

class FavoriteController {
    static async addFavorite(req, res) {
        try {
            const userId = req.user.id; // From auth middleware
            const { mealId } = req.body;

            if (!mealId) {
                return res.status(400).json({ error: 'Meal ID is required' });
            }

            const favorite = await FavoriteService.addFavorite(userId, mealId);
            res.status(201).json({
                message: 'Meal added to favorites',
                favorite
            });
        } catch (error) {
            if (error.message === 'Meal not found') {
                return res.status(404).json({ error: error.message });
            }
            if (error.message === 'Meal is already in favorites') {
                return res.status(409).json({ error: error.message });
            }
            res.status(500).json({ error: error.message });
        }
    }

    static async removeFavorite(req, res) {
        try {
            const userId = req.user.id; // From auth middleware
            const { mealId } = req.params;

            const result = await FavoriteService.removeFavorite(userId, parseInt(mealId));
            res.json(result);
        } catch (error) {
            if (error.message === 'Favorite not found') {
                return res.status(404).json({ error: error.message });
            }
            res.status(500).json({ error: error.message });
        }
    }

    static async getAllFavorites(req, res) {
        try {
            const userId = req.user.id; // From auth middleware
            const favorites = await FavoriteService.getAllFavorites(userId);
            res.json(favorites);
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    }
}

export default FavoriteController;
