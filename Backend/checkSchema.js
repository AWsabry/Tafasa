import sequelize from './src/config/database.js';

async function checkSchema() {
    try {
        const [results] = await sequelize.query(
            "SELECT sql FROM sqlite_master WHERE type='table' AND name='Users';"
        );

        console.log('Current Users table schema:');
        console.log(results[0]?.sql || 'Table not found');

        // Also show all tables
        const [tables] = await sequelize.query(
            "SELECT name FROM sqlite_master WHERE type='table';"
        );
        console.log('\nAll tables in database:');
        console.log(tables.map(t => t.name).join(', '));

        process.exit(0);
    } catch (error) {
        console.error('Error:', error);
        process.exit(1);
    }
}

checkSchema();
