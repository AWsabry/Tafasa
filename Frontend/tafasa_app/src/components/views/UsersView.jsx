import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import UsersTable from '../tables/UsersTable';
import { api } from '../../utils/api';
import { useAuth } from '../../contexts/AuthContext';

const UsersView = () => {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const { token } = useAuth();
  const navigate = useNavigate();

  useEffect(() => {
    let mounted = true;
    const fetchUsers = async () => {
      setLoading(true);
      try {
        const data = await api.get('/users');
        const list = Array.isArray(data) ? data : (data?.users || []);
        if (mounted) setUsers(list);
      } catch (err) {
        const msg = err?.message || 'Failed to load users';
        if (msg === 'Please authenticate.' || msg.toLowerCase().includes('authenticate') || msg.includes('401')) {
          navigate('/login');
          return;
        }
        if (mounted) setError(msg);
      } finally {
        if (mounted) setLoading(false);
      }
    };

    fetchUsers();
    return () => {
      mounted = false;
    };
  }, []);

  if (loading) return (
    <div className="flex items-center justify-center py-12">
      <div className="animate-spin rounded-full h-10 w-10 border-4 border-[var(--color-primary)] border-t-transparent"></div>
    </div>
  );

  if (error) return (
    <div className="card p-6">
      <p className="text-[var(--color-accent-red)]">Error: {error.message}</p>
    </div>
  );

  return <UsersTable users={users} />;
};

export default UsersView;
