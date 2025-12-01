import jwt from 'jsonwebtoken';
import User from '../models/User.js';

class AuthService {
    static async register(username, email, password, phoneNumber, age, role) {
        try {
            console.log('AuthService.register called with:', { username, email, phoneNumber, age });

            const conditions = [{ username }, { phoneNumber }];
            if (email) conditions.push({ email });

            console.log('Checking for existing user with conditions:', conditions);

            const existingUser = await User.findOne({ $or: conditions });

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

            // Default all registrations to regular user; admin must be set manually
            const normalizedRole = 'user';

            console.log('Creating new user...');
            const user = await User.create({
                username,
                email,
                password,
                phoneNumber,
                age,
                role: normalizedRole
            });

            console.log('User created successfully:', user.id);
            const token = this.generateToken(user.id, user.role);
            return { user, token };
        } catch (error) {
            console.error('AuthService.register error:', error.message);
            console.error('Error name:', error.name);
            console.error('Full error:', JSON.stringify(error, null, 2));
            throw error;
        }
    }

    static async login(email, phone, password) {
        try {
            const whereCondition = email ? { email } : { phoneNumber: phone };
            const user = await User.findOne(whereCondition);
            if (!user) {
                throw new Error('User not found');
            }

            if (user.role !== 'admin') { 
                console.log(user.role);
                throw new Error('Only admin users can sign in');
            }

            const isMatch = await user.comparePassword(password);
            if (!isMatch) {
                throw new Error('Invalid credentials');
            }

            const token = this.generateToken(user.id, user.role);
            return { user, token };
        } catch (error) {
            throw error;
        }
    }

    static generateToken(userId, role) {
        return jwt.sign(
            { userId, role },
            process.env.JWT_SECRET,
            { expiresIn: '24h' }
        );
    }

    static async getAllUsers() {
        try {
            const users = await User.find()
                .select('username email phoneNumber age role createdAt')
                .sort({ createdAt: -1 });
            return users;
        } catch (error) {
            throw error;
        }
    }

    static async getUserById(id) {
        try {
            const user = await User.findById(id).select('username email phoneNumber age role createdAt');
            
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
            const user = await User.findById(id);
            
            if (!user) {
                throw new Error('User not found');
            }

            await user.deleteOne();
            return { message: 'User deleted successfully' };
        } catch (error) {
            throw error;
        }
    }

    static async updateUserRole(id, role) {
        if (!['admin', 'user'].includes(role)) {
            throw new Error('Invalid role');
        }
        const user = await User.findById(id);
        if (!user) {
            throw new Error('User not found');
        }
        user.role = role;
        await user.save();
        return {
            id: user.id,
            username: user.username,
            email: user.email,
            phoneNumber: user.phoneNumber,
            age: user.age,
            role: user.role,
            createdAt: user.createdAt
        };
    }
}

export default AuthService;
