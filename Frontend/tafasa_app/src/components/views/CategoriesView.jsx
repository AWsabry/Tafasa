import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import CategoriesTable from '../tables/CategoriesTable';
import { api } from '../../utils/api';
import { useAuth } from '../../contexts/AuthContext';

const CategoriesView = () => {
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const navigate = useNavigate();
  const { token } = useAuth();

  useEffect(() => {
    let mounted = true;
    const fetchCategories = async () => {
      setLoading(true);
        try {
          const data = await api.get('/categories');
          const list = Array.isArray(data) ? data : (data?.categories || []);
          if (mounted) setCategories(list);
        } catch (err) {
          const msg = err?.message || 'Failed to load categories';
          if (msg === 'Please authenticate.' || msg.toLowerCase().includes('authenticate') || msg.includes('401')) {
            navigate('/login');
            return;
          }
          if (mounted) setError(msg);
        } finally {
          if (mounted) setLoading(false);
        }
    };

    fetchCategories();
    return () => { mounted = false; };
  }, []);

  if (loading) return (
    <div className="flex items-center justify-center py-12">
      <div className="animate-spin rounded-full h-10 w-10 border-4 border-[var(--color-primary)] border-t-transparent"></div>
    </div>
  );

  if (error) return (
    <div className="card p-6">
      <p className="text-[var(--color-accent-red)]">Error: {error}</p>
    </div>
  );

  return <CategoriesTable categories={categories} />;
};

export default CategoriesView;
