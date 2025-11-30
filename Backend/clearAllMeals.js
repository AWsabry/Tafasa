import sequelize from './src/config/database.js';
import Meal from './src/models/Meal.js';
import Favorite from './src/models/Favorite.js';

async function clearAllMeals() {
    try {
        await sequelize.authenticate();
        console.log('Database connected\n');

        // Delete all favorites first
        const deletedFavorites = await Favorite.destroy({ where: {} });
        console.log(`Deleted ${deletedFavorites} favorites`);

        // Delete all meals
        const deletedMeals = await Meal.destroy({ where: {} });
        console.log(`Deleted ${deletedMeals} meals`);

        console.log('\n✓ Database cleared successfully');

    } catch (error) {
        console.error('Clear failed:', error);
    } finally {
        await sequelize.close();
    }
}

clearAllMeals();
