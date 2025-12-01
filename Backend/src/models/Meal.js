import mongoose from 'mongoose';

const ingredientSchema = new mongoose.Schema({
    name: { type: String, required: true },
    amount: { type: Number },
    unit: { type: String }
}, { _id: false });

const stepSchema = new mongoose.Schema({
    step: { type: Number, required: true },
    description: { type: String, required: true }
}, { _id: false });

const mealSchema = new mongoose.Schema({
    name: { type: String, required: true, trim: true },
    description: { type: String },
    image: { type: String },
    ingredients: { type: [ingredientSchema], default: [] },
    preparationSteps: { type: [stepSchema], default: [] },
    categoryId: { type: mongoose.Schema.Types.ObjectId, ref: 'Category', required: true }
}, {
    timestamps: true,
    toJSON: {
        transform: (_, ret) => {
            ret.id = ret._id.toString();
            delete ret._id;
            delete ret.__v;
            return ret;
        }
    }
});

const Meal = mongoose.model('Meal', mealSchema);
export default Meal;
