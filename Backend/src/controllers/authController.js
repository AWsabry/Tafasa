import AuthService from '../services/authService.js';

class AuthController {
    static async register(req, res) {
        try {
            const { username, email, password, phoneNumber } = req.body;
            
            if (!username || !email || !password) {
                return res.status(400).json({ error: 'Username, email, and password are required' });
            }

            const { user, token } = await AuthService.register(username, email, password, phoneNumber);
            
            res.status(201).json({
                message: 'User registered successfully',
                user: {
                    id: user.id,
                    username: user.username,
                    email: user.email,
                    phoneNumber: user.phoneNumber
                },
                token
            });
        } catch (error) {
            res.status(400).json({ error: error.message });
        }
    }

    static async login(req, res) {
        try {
            const { email, password } = req.body;
            
            if (!email || !password) {
                return res.status(400).json({ error: 'Email and password are required' });
            }

            const { user, token } = await AuthService.login(email, password);
            
            res.json({
                message: 'Login successful',
                user: {
                    id: user.id,
                    username: user.username,
                    email: user.email,
                    phoneNumber: user.phoneNumber
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
}

export default AuthController;