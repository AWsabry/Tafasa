import xlsx from 'xlsx';
import sequelize from './src/config/database.js';
import Category from './src/models/Category.js';
import Meal from './src/models/Meal.js';

async function importMeals() {
    try {
        // Read the Excel file
        console.log('Reading Excel file...');
        const workbook = xlsx.readFile('arabic_meals.xlsx');
        const sheetName = workbook.SheetNames[0];
        const worksheet = workbook.Sheets[sheetName];

        // Convert to JSON
        const data = xlsx.utils.sheet_to_json(worksheet);

        console.log('Excel file loaded successfully');
        console.log('Total rows:', data.length);
        console.log('Sample row:', JSON.stringify(data[0], null, 2));

        // Connect to database
        await sequelize.authenticate();
        console.log('Database connected');

        // Sync models
        await sequelize.sync();
        console.log('Models synchronized');

        // Import meals
        let imported = 0;
        let skipped = 0;

        for (const row of data) {
            try {
                // Get category ID directly from Excel file
                const categoryId = row.CategoryId || row.categoryId;

                if (!categoryId) {
                    console.log('Skipping row - no category ID found:', row);
                    skipped++;
                    continue;
                }

                // Verify category exists
                const category = await Category.findByPk(categoryId);
                if (!category) {
                    console.log(`Skipping row - category ${categoryId} not found:`, row);
                    skipped++;
                    continue;
                }

                // Parse ingredients (format: "name|amount|unit;name|amount|unit")
                let ingredients = [];
                const ingredientsData = row.Ingredients || row.ingredients;
                if (ingredientsData) {
                    try {
                        // If it's already JSON
                        if (typeof ingredientsData === 'object') {
                            ingredients = Array.isArray(ingredientsData) ? ingredientsData : [ingredientsData];
                        } else {
                            // Try to parse as JSON first
                            ingredients = JSON.parse(ingredientsData);
                        }
                    } catch (e) {
                        // Parse pipe-separated format: "name|amount|unit;name|amount|unit"
                        const parts = ingredientsData.split(';');
                        ingredients = parts.map(part => {
                            const [name, amount, unit] = part.split('|').map(s => s.trim());
                            return {
                                name: name || 'Unknown',
                                amount: amount ? parseFloat(amount) : undefined,
                                unit: unit || undefined
                            };
                        }).filter(ing => ing.name !== 'Unknown');

                        // Fallback to comma-separated if no pipes found
                        if (ingredients.length === 0) {
                            ingredients = ingredientsData.split(',').map(ing => ({
                                name: ing.trim()
                            }));
                        }
                    }
                }

                // Parse preparation steps
                let preparationSteps = [];
                if (row.preparationSteps || row.PreparationSteps || row.steps) {
                    const stepsData = row.preparationSteps || row.PreparationSteps || row.steps;
                    try {
                        if (typeof stepsData === 'object') {
                            preparationSteps = Array.isArray(stepsData) ? stepsData : [stepsData];
                        } else {
                            preparationSteps = JSON.parse(stepsData);
                        }
                    } catch (e) {
                        // If it's a newline or numbered list
                        const stepLines = stepsData.split(/\n|;/).filter(s => s.trim());
                        preparationSteps = stepLines.map((step, index) => ({
                            step: index + 1,
                            description: step.trim().replace(/^\d+[\.\)]\s*/, '')
                        }));
                    }
                }

                // Ensure steps have proper structure
                if (preparationSteps.length > 0) {
                    preparationSteps = preparationSteps.map((step, index) => ({
                        step: index + 1,
                        description: typeof step === 'string' ? step : (step.description || step.step || String(step))
                    }));
                }

                // Get meal name
                const mealName = row.name || row.Name || row.meal || row.Meal;

                if (!mealName) {
                    console.log('Skipping row - no name found:', row);
                    skipped++;
                    continue;
                }

                // Create meal
                await Meal.create({
                    name: mealName,
                    description: row.description || row.Description || '',
                    price: parseFloat(row.price || row.Price || 0),
                    image: row.image || row.Image || '',
                    ingredients: ingredients.length > 0 ? ingredients : [{ name: 'Not specified' }],
                    preparationSteps: preparationSteps.length > 0 ? preparationSteps : [{ step: 1, description: 'Not specified' }],
                    categoryId: categoryId
                });

                imported++;
                console.log(`✓ Imported: ${mealName}`);

            } catch (error) {
                console.error(`Error importing row:`, error.message);
                console.error('Row data:', row);
                skipped++;
            }
        }

        console.log('\n=== Import Summary ===');
        console.log(`Total rows: ${data.length}`);
        console.log(`Successfully imported: ${imported}`);
        console.log(`Skipped: ${skipped}`);

    } catch (error) {
        console.error('Import failed:', error);
    } finally {
        await sequelize.close();
    }
}

importMeals();
