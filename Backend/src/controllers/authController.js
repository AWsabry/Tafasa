import AuthService from '../services/authService.js';

class AuthController {
    static async register(req, res) {
        try {
            const { username, email, password, phoneNumber, age, role } = req.body;

            console.log('Registration request body:', {
                username,
                email,
                password: password ? '***' : undefined,
                phoneNumber,
                age
            });

            if (!username || !password || !phoneNumber) {
                return res.status(400).json({ error: 'Username, phone number, and password are required' });
            }

            const { user, token } = await AuthService.register(username, email, password, phoneNumber, age, role);

            res.status(201).json({
                message: 'User registered successfully',
                user: {
                    id: user.id,
                    username: user.username,
                    email: user.email,
                    phoneNumber: user.phoneNumber,
                    age: user.age,
                    role: user.role
                },
                token
            });
        } catch (error) {
            res.status(400).json({ error: error.message });
        }
    }

    static async login(req, res) {
        try {
            const { email, phone, password } = req.body;

            if ((!email && !phone) || !password) {
                return res.status(400).json({ error: 'Email or phone number and password are required' });
            }

            const { user, token } = await AuthService.login(email, phone, password);

            res.json({
                message: 'Login successful',
                user: {
                    id: user.id,
                    username: user.username,
                    email: user.email,
                    phoneNumber: user.phoneNumber,
                    age: user.age,
                    role: user.role
                },
                token
            });
        } catch (error) {
            res.status(401).json({ error: error.message });
        }
    }

    static async logout(req, res) {
        try {
            // Since we're using JWT, we don't need to do anything server-side
            // The client should remove the token from their storage
            res.json({ message: 'Logged out successfully' });
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    }

    static async getAllUsers(req, res) {
        try {
            const users = await AuthService.getAllUsers();
            res.json({
                message: 'Users retrieved successfully',
                users
            });
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    }

    static async getUserById(req, res) {
        try {
            const { id } = req.params;
            const user = await AuthService.getUserById(id);
            res.json({
                message: 'User retrieved successfully',
                user
            });
        } catch (error) {
            if (error.message === 'User not found') {
                return res.status(404).json({ error: error.message });
            }
            res.status(500).json({ error: error.message });
        }
    }

    static async getCurrentUser(req, res) {
        try {
            // `auth` middleware attaches the full user instance to req.user
            const user = req.user;
            if (!user) return res.status(404).json({ error: 'User not found' });

            // Return only safe fields
            const safeUser = {
                id: user.id,
                username: user.username,
                email: user.email,
                phoneNumber: user.phoneNumber,
                age: user.age,
                role: user.role,
                createdAt: user.createdAt
            };

            res.json({
                message: 'Current user retrieved successfully',
                user: safeUser
            });
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    }

    static async deleteUser(req, res) {
        try {
            const { id } = req.params;
            const result = await AuthService.deleteUser(id);
            res.json(result);
        } catch (error) {
            if (error.message === 'User not found') {
                return res.status(404).json({ error: error.message });
            }
            res.status(500).json({ error: error.message });
        }
    }

    static async updateUserRole(req, res) {
        try {
            const { id } = req.params;
            const { role } = req.body;
            const updated = await AuthService.updateUserRole(id, role);
            res.json({ message: 'User role updated', user: updated });
        } catch (error) {
            if (error.message === 'User not found') {
                return res.status(404).json({ error: error.message });
            }
            if (error.message === 'Invalid role') {
                return res.status(400).json({ error: error.message });
            }
            res.status(500).json({ error: error.message });
        }
    }
}

export default AuthController;
