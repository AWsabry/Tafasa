import { DataTypes, Model } from 'sequelize';
import sequelize from '../config/database.js';
import User from './User.js';
import Meal from './Meal.js';

class Favorite extends Model {}

Favorite.init({
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    userId: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: User,
            key: 'id'
        }
    },
    mealId: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: Meal,
            key: 'id'
        }
    }
}, {
    sequelize,
    modelName: 'Favorite',
    indexes: [
        {
            unique: true,
            fields: ['userId', 'mealId'] // Prevent duplicate favorites
        }
    ]
});

// Set up relationships
Favorite.belongsTo(User, { foreignKey: 'userId' });
Favorite.belongsTo(Meal, { foreignKey: 'mealId' });
User.hasMany(Favorite, { foreignKey: 'userId' });
Meal.hasMany(Favorite, { foreignKey: 'mealId' });

export default Favorite;
