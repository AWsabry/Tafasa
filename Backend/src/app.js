import express from 'express';
import dotenv from 'dotenv';
import cors from 'cors';
import morgan from 'morgan';
import helmet from 'helmet';
import routes from './routes/index.js';
import sequelize from './config/database.js';
import './models/User.js';
import './models/Category.js';
import './models/Meal.js';

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

// Sync database
sequelize.sync()
    .then(() => console.log('Database synced'))
    .catch(err => console.error('Error syncing database:', err));

app.use('/', routes);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
