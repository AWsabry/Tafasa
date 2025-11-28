import xlsx from 'xlsx';
import sequelize from './src/config/database.js';
import Meal from './src/models/Meal.js';
import Category from './src/models/Category.js';
import Favorite from './src/models/Favorite.js';

async function cleanDatabase() {
    try {
        // Read the Excel file to get the valid meal names
        console.log('Reading Excel file...');
        const workbook = xlsx.readFile('arabic_meals.xlsx');
        const sheetName = workbook.SheetNames[0];
        const worksheet = workbook.Sheets[sheetName];
        const data = xlsx.utils.sheet_to_json(worksheet);

        // Extract valid meal names from Excel
        const validMealNames = data.map(row =>
            row.name || row.Name || row.meal || row.Meal
        ).filter(name => name);

        console.log(`Valid meals from Excel: ${validMealNames.length}`);
        console.log('Valid meal names:', validMealNames);

        // Connect to database
        await sequelize.authenticate();
        console.log('\nDatabase connected');

        // Get all meals from database
        const allMeals = await Meal.findAll();
        console.log(`\nTotal meals in database: ${allMeals.length}`);

        // Find meals that are NOT in the Excel file
        const mealsToDelete = allMeals.filter(meal =>
            !validMealNames.includes(meal.name)
        );

        console.log(`\nMeals to delete: ${mealsToDelete.length}`);
        mealsToDelete.forEach(meal => {
            console.log(`  - ${meal.name} (ID: ${meal.id})`);
        });

        // Delete the extra meals
        if (mealsToDelete.length > 0) {
            for (const meal of mealsToDelete) {
                // First, delete any favorites associated with this meal
                const deletedFavorites = await Favorite.destroy({
                    where: { mealId: meal.id }
                });
                if (deletedFavorites > 0) {
                    console.log(`  Deleted ${deletedFavorites} favorite(s) for: ${meal.name}`);
                }

                // Now delete the meal
                await meal.destroy();
                console.log(`✓ Deleted: ${meal.name}`);
            }
        }

        // Verify final count
        const remainingMeals = await Meal.count();
        console.log(`\n=== Cleanup Summary ===`);
        console.log(`Meals deleted: ${mealsToDelete.length}`);
        console.log(`Meals remaining: ${remainingMeals}`);

        // Show remaining meals
        const finalMeals = await Meal.findAll({
            include: [{ model: Category }]
        });
        console.log('\n=== Remaining Meals ===');
        finalMeals.forEach((meal, index) => {
            console.log(`${index + 1}. ${meal.name} (${meal.Category.name})`);
        });

    } catch (error) {
        console.error('Cleanup failed:', error);
    } finally {
        await sequelize.close();
    }
}

cleanDatabase();
