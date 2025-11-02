import { DataTypes, Model } from 'sequelize';
import sequelize from '../config/database.js';
import Category from './Category.js';

class Meal extends Model {}

Meal.init({
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    name: {
        type: DataTypes.STRING,
        allowNull: false,
        validate: {
            notEmpty: true
        }
    },
    description: {
        type: DataTypes.TEXT,
        allowNull: true
    },
    price: {
        type: DataTypes.DECIMAL(10, 2),
        allowNull: false,
        validate: {
            min: 0
        }
    },
    image: {
        type: DataTypes.STRING,
        allowNull: true
    },
    ingredients: {
        type: DataTypes.JSON,
        allowNull: false,
        defaultValue: [],
        validate: {
            isValidIngredientsList(value) {
                if (!Array.isArray(value)) {
                    throw new Error('Ingredients must be an array');
                }
                value.forEach(ingredient => {
                    if (typeof ingredient !== 'object' || !ingredient.name) {
                        throw new Error('Each ingredient must have a name');
                    }
                    // amount and unit are optional
                });
            }
        }
    },
    preparationSteps: {
        type: DataTypes.JSON,
        allowNull: false,
        defaultValue: [],
        validate: {
            isValidStepsList(value) {
                if (!Array.isArray(value)) {
                    throw new Error('Preparation steps must be an array');
                }
                value.forEach((step, index) => {
                    if (typeof step !== 'object' || !step.step || !step.description) {
                        throw new Error('Each step must have step number and description');
                    }
                    if (step.step !== index + 1) {
                        throw new Error('Steps must be properly numbered in sequence');
                    }
                });
            }
        }
    },
    categoryId: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: Category,
            key: 'id'
        }
    }
}, {
    sequelize,
    modelName: 'Meal'
});

// Set up the relationship
Meal.belongsTo(Category, { foreignKey: 'categoryId' });
Category.hasMany(Meal, { foreignKey: 'categoryId' });

export default Meal;