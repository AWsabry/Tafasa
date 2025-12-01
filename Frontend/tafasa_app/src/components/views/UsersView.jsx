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

  const fetchUsers = async () => {
    setLoading(true);
    try {
      const data = await api.get('/users');
      const list = Array.isArray(data) ? data : (data?.users || []);
      setUsers(list);
      setError(null);
    } catch (err) {
      const msg = err?.message || 'Failed to load users';
      if (msg === 'Please authenticate.' || msg.toLowerCase().includes('authenticate') || msg.includes('401')) {
        navigate('/login');
        return;
      }
      setError(msg);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    let mounted = true;
    if (mounted) {
      fetchUsers();
    }
    return () => {
      mounted = false;
    };
  }, []);

  const handleDeleteUser = async (userId) => {
    if (!window.confirm('Are you sure you want to delete this user?')) {
      return;
    }

    try {
      await api.delete(`/users/${userId}`);
      // Refresh the users list
      await fetchUsers();
    } catch (err) {
      const msg = err?.message || 'Failed to delete user';
      alert(msg);
    }
  };

  const handleRoleChange = async (userId, role) => {
    try {
      await api.patch(`/users/${userId}/role`, { role });
      await fetchUsers();
    } catch (err) {
      const msg = err?.message || 'Failed to update role';
      alert(msg);
    }
  };

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

  return <UsersTable users={users} onDelete={handleDeleteUser} onRoleChange={handleRoleChange} />;
};

export default UsersView;
