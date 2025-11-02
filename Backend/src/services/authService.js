import jwt from 'jsonwebtoken';
import { Op } from 'sequelize';
import User from '../models/User.js';

class AuthService {
    static async register(username, email, password, phoneNumber) {
        try {
            const existingUser = await User.findOne({ 
                where: {
                    [Op.or]: [
                        { email }, 
                        { username },
                        ...(phoneNumber ? [{ phoneNumber }] : [])
                    ]
                }
            });

            if (existingUser) {
                if (existingUser.email === email) {
                    throw new Error('Email already in use');
                }
                if (existingUser.username === username) {
                    throw new Error('Username already taken');
                }
                if (existingUser.phoneNumber === phoneNumber) {
                    throw new Error('Phone number already registered');
                }
            }

            const user = await User.create({
                username,
                email,
                password,
                phoneNumber
            });
            
            const token = this.generateToken(user.id);
            return { user, token };
        } catch (error) {
            throw error;
        }
    }

    static async login(email, password) {
        try {
            const user = await User.findOne({ where: { email } });
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
                attributes: ['id', 'username', 'email', 'phoneNumber', 'createdAt'],
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
                attributes: ['id', 'username', 'email', 'phoneNumber', 'createdAt']
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