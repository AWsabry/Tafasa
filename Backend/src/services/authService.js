import jwt from 'jsonwebtoken';
import { Op } from 'sequelize';
import User from '../models/User.js';

class AuthService {
    static async register(username, email, password, phoneNumber, age) {
        try {
            console.log('AuthService.register called with:', { username, email, phoneNumber, age });

            const whereConditions = [
                { username },
                { phoneNumber }
            ];

            // Only check email if it's provided
            if (email) {
                whereConditions.push({ email });
            }

            console.log('Checking for existing user with conditions:', whereConditions);

            const existingUser = await User.findOne({
                where: {
                    [Op.or]: whereConditions
                }
            });

            if (existingUser) {
                console.log('Existing user found:', existingUser.username);
                if (email && existingUser.email === email) {
                    throw new Error('Email already in use');
                }
                if (existingUser.username === username) {
                    throw new Error('Username already taken');
                }
                if (existingUser.phoneNumber === phoneNumber) {
                    throw new Error('Phone number already registered');
                }
            }

            console.log('Creating new user...');
            const user = await User.create({
                username,
                email,
                password,
                phoneNumber,
                age
            });

            console.log('User created successfully:', user.id);
            const token = this.generateToken(user.id);
            return { user, token };
        } catch (error) {
            console.error('AuthService.register error:', error.message);
            console.error('Error name:', error.name);
            console.error('Full error:', JSON.stringify(error, null, 2));
            if (error.errors && error.errors.length > 0) {
                console.error('Validation errors:', error.errors.map(e => ({
                    field: e.path,
                    message: e.message,
                    value: e.value
                })));
            }
            throw error;
        }
    }

    static async login(email, phone, password) {
        try {
            // Build the where condition based on what was provided
            const whereCondition = {};

            if (email) {
                whereCondition.email = email;
            } else if (phone) {
                whereCondition.phoneNumber = phone;
            }

            const user = await User.findOne({ where: whereCondition });
            if (!user) {
                throw new Error('User not found');
            }

            const isMatch = await user.comparePassword(password);
            if (!isMatch) {
                throw new Error('Invalid credentials');
            }

            const token = this.generateToken(user.id);
            return { user, token };
        } catch (error) {
            throw error;
        }
    }

    static generateToken(userId) {
        return jwt.sign(
            { userId },
            process.env.JWT_SECRET,
            { expiresIn: '24h' }
        );
    }

    static async getAllUsers() {
        try {
            const users = await User.findAll({
                attributes: ['id', 'username', 'email', 'phoneNumber', 'age', 'createdAt'],
                order: [['createdAt', 'DESC']]
            });
            return users;
        } catch (error) {
            throw error;
        }
    }

    static async getUserById(id) {
        try {
            const user = await User.findByPk(id, {
                attributes: ['id', 'username', 'email', 'phoneNumber', 'age', 'createdAt']
            });
            
            if (!user) {
                throw new Error('User not found');
            }

            return user;
        } catch (error) {
            throw error;
        }
    }

    static async deleteUser(id) {
        try {
            const user = await User.findByPk(id);
            
            if (!user) {
                throw new Error('User not found');
            }

            await user.destroy();
            return { message: 'User deleted successfully' };
        } catch (error) {
            throw error;
        }
    }
}

export default AuthService;