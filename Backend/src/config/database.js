import mongoose from 'mongoose';

export const connectDatabase = async () => {
    const uri = process.env.MONGODB_URI;
    try {
        await mongoose.connect(uri, {
            serverSelectionTimeoutMS: 5000
        });
        console.log('MongoDB connected');
    } catch (error) {
        console.error('MongoDB connection error:', error.message);
        process.exit(1);
    }
};

export default connectDatabase;
