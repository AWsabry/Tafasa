import React, { createContext, useContext, useEffect, useState } from 'react';
import { api } from '../utils/api';

const AuthContext = createContext();

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

export const AuthProvider = ({ children }) => {
  const [token, setToken] = useState(localStorage.getItem('token'));
  const [user, setUser] = useState(() => {
    try {
      const stored = localStorage.getItem('user');
      return stored ? JSON.parse(stored) : null;
    } catch (e) {
      return null;
    }
  });
  const [loadingUser, setLoadingUser] = useState(Boolean(token));

  const login = (newToken, userData) => {
    localStorage.setItem('token', newToken);
    if (userData) {
      localStorage.setItem('user', JSON.stringify(userData));
      setUser(userData);
    }
    setToken(newToken);
    setLoadingUser(false);
  };

  const logout = () => {
    // Clear all stored session data
    localStorage.clear();
    setToken(null);
    setUser(null);
    setLoadingUser(false);
  };

  const refreshUser = async () => {
    if (!token) {
      setUser(null);
      setLoadingUser(false);
      return null;
    }

    setLoadingUser(true);
    try {
      const res = await api.get('/users/me');
      if (res?.user) {
        localStorage.setItem('user', JSON.stringify(res.user));
        setUser(res.user);
        return res.user;
      }
      return null;
    } catch (err) {
      logout();
      return null;
    } finally {
      setLoadingUser(false);
    }
  };

  useEffect(() => {
    if (token) {
      refreshUser();
    } else {
      setLoadingUser(false);
    }
  }, [token]);

  return (
    <AuthContext.Provider value={{ token, user, login, logout, loadingUser, refreshUser }}>
      {children}
    </AuthContext.Provider>
  );
};
