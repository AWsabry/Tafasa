import cors from 'cors';
import dotenv from 'dotenv';
import express from 'express';
import helmet from 'helmet';
import morgan from 'morgan';
import connectDatabase from './config/database.js';
import './models/Category.js';
import './models/Meal.js';
import './models/User.js';
import './models/Favorite.js';
import routes from './routes/index.js';

dotenv.config();

// Verify JWT_SECRET is loaded
if (!process.env.JWT_SECRET) {
    console.error('JWT_SECRET is not defined in environment variables');
    process.exit(1);
}

const app = express();

// Security middleware
app.use(helmet()); // Adds various HTTP headers for security
app.use(express.json({ limit: '10kb' })); // Limit payload size
app.use(cors({
    origin: process.env.CORS_ORIGIN || '*', // Restrict to specific origin in production
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization']
}));
app.use(morgan('dev'));

// Connect database
connectDatabase();

app.use('/', routes);

const PORT = process.env.PORT || 5000;

app.listen(PORT, '192.168.137.1', () => {
    console.log(`Server running on port ${PORT}`);
});
