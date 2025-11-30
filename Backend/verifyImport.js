import sequelize from './src/config/database.js';
import Category from './src/models/Category.js';
import Meal from './src/models/Meal.js';

async function verifyImport() {
    try {
        await sequelize.authenticate();
        console.log('Database connected\n');

        // Count categories
        const categoryCount = await Category.count();
        console.log(`Total Categories: ${categoryCount}`);

        // List all categories
        const categories = await Category.findAll();
        categories.forEach(cat => {
            console.log(`  - ${cat.name} (ID: ${cat.id})`);
        });

        // Count meals
        const mealCount = await Meal.count();
        console.log(`\nTotal Meals: ${mealCount}`);

        // Show sample meals with full details
        const sampleMeals = await Meal.findAll({
            limit: 3,
            include: [{ model: Category }]
        });

        console.log('\n=== Sample Meals ===');
        sampleMeals.forEach((meal, index) => {
            console.log(`\n${index + 1}. ${meal.name}`);
            console.log(`   Category: ${meal.Category.name}`);
            console.log(`   Description: ${meal.description}`);
            console.log(`   Price: ${meal.price}`);
            console.log(`   Ingredients: ${JSON.stringify(meal.ingredients, null, 2)}`);
            console.log(`   Preparation Steps: ${JSON.stringify(meal.preparationSteps, null, 2)}`);
        });

    } catch (error) {
        console.error('Verification failed:', error);
    } finally {
        await sequelize.close();
    }
}

verifyImport();
