import sequelize from './src/config/database.js';

async function migrateUserTable() {
    try {
        console.log('Disabling foreign key constraints...');
        await sequelize.query('PRAGMA foreign_keys = OFF');

        console.log('Dropping and recreating all tables...');
        await sequelize.sync({ force: true });

        console.log('Re-enabling foreign key constraints...');
        await sequelize.query('PRAGMA foreign_keys = ON');

        console.log('Migration completed! All tables recreated with new schema.');
        process.exit(0);
    } catch (error) {
        console.error('Migration failed:', error);
        process.exit(1);
    }
}

migrateUserTable();
