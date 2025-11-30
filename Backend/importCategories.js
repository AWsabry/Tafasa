import sequelize from './src/config/database.js';
import Category from './src/models/Category.js';

const categories = [
    { id: 1, name: 'فطور' },
    { id: 2, name: 'غداء' },
    { id: 3, name: 'عشاء' },
    { id: 4, name: 'حلويات' },
    { id: 5, name: 'مشروبات' }
];

async function importCategories() {
    try {
        await sequelize.authenticate();
        console.log('Database connected');

        for (const categoryData of categories) {
            const [category, created] = await Category.findOrCreate({
                where: { id: categoryData.id },
                defaults: categoryData
            });

            if (created) {
                console.log(`✓ Created category: ${category.name} (ID: ${category.id})`);
            } else {
                console.log(`- Category already exists: ${category.name} (ID: ${category.id})`);
            }
        }

        console.log('\n✅ Categories import completed!');
        process.exit(0);
    } catch (error) {
        console.error('❌ Error:', error);
        process.exit(1);
    }
}

importCategories();
