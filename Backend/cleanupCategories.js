import sequelize from './src/config/database.js';
import Category from './src/models/Category.js';
import Meal from './src/models/Meal.js';

async function cleanupCategories() {
    try {
        await sequelize.authenticate();
        console.log('Database connected\n');

        // Find categories with no meals
        const allCategories = await Category.findAll({
            include: [{
                model: Meal,
                required: false
            }]
        });

        console.log('=== Categories Status ===');
        for (const category of allCategories) {
            const mealCount = await Meal.count({ where: { categoryId: category.id } });
            console.log(`${category.name} (ID: ${category.id}): ${mealCount} meals`);

            if (mealCount === 0 && category.name === 'Arabic Meals') {
                await category.destroy();
                console.log(`  ✓ Deleted unused category: ${category.name}`);
            }
        }

        // Show final categories
        const finalCategories = await Category.findAll();
        console.log('\n=== Final Categories ===');
        for (const category of finalCategories) {
            const mealCount = await Meal.count({ where: { categoryId: category.id } });
            console.log(`${category.name} (ID: ${category.id}): ${mealCount} meals`);
        }

    } catch (error) {
        console.error('Cleanup failed:', error);
    } finally {
        await sequelize.close();
    }
}

cleanupCategories();
