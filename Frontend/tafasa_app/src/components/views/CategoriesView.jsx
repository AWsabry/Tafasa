import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import CategoriesTable from '../tables/CategoriesTable';
import { api } from '../../utils/api';
import { useAuth } from '../../contexts/AuthContext';
import CategoryForm from '../forms/CategoryForm';

const Modal = ({ isOpen, onClose, children }) => {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 overflow-y-auto">
      <div className="flex min-h-screen items-center justify-center p-4">
        <div className="fixed inset-0 bg-black/50 transition-opacity" onClick={onClose}></div>
        <div className="relative rounded-lg bg-[var(--color-bg-secondary)] p-6 w-full max-w-md">
          {children}
        </div>
      </div>
    </div>
  );
};

const CategoriesView = () => {
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const navigate = useNavigate();
  const { token } = useAuth();

  const fetchCategories = async () => {
    setLoading(true);
    try {
      const data = await api.get('/categories');
      const list = Array.isArray(data) ? data : (data?.categories || []);
      setCategories(list);
      setError(null);
    } catch (err) {
      const msg = err?.message || 'Failed to load categories';
      if (msg === 'Please authenticate.' || msg.toLowerCase().includes('authenticate') || msg.includes('401')) {
        navigate('/login');
        return;
      }
      setError(msg);
    } finally {
      setLoading(false);
    }
  };

  const handleAddCategory = async (formData) => {
    try {
      const response = await api.post('/categories', formData);
      const newCategory = response.category || response;
      
      // Update categories list
      setCategories(prev => [...prev, newCategory]);
      setIsModalOpen(false);
    } catch (err) {
      const msg = err?.message || 'Failed to create category';
      if (msg === 'Please authenticate.' || msg.toLowerCase().includes('authenticate') || msg.includes('401')) {
        navigate('/login');
        return;
      }
      setError(msg);
    }
  };

  const handleDeleteCategory = async (categoryId) => {
    if (!window.confirm('Are you sure you want to delete this category?')) {
      return;
    }

    try {
      await api.delete(`/categories/${categoryId}`);
      // Refresh the categories list
      await fetchCategories();
    } catch (err) {
      const msg = err?.message || 'Failed to delete category';
      alert(msg);
    }
  };

  useEffect(() => {
    let mounted = true;
    if (mounted) {
      fetchCategories();
    }
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

  return (
    <>
      <div className="flex justify-end mb-4">
        <button
          onClick={() => setIsModalOpen(true)}
          className="btn btn-primary group flex items-center gap-2"
        >
          <svg className="w-5 h-5 transition-transform group-hover:scale-110" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
          </svg>
          Add New Category
        </button>
      </div>

      <CategoriesTable categories={categories} onDelete={handleDeleteCategory} />

      <Modal isOpen={isModalOpen} onClose={() => setIsModalOpen(false)}>
        <div className="mb-4">
          <h2 className="text-lg font-semibold">Add New Category</h2>
          <p className="text-sm text-[var(--color-text-secondary)]">Create a new category for meals</p>
        </div>
        <CategoryForm 
          onSubmit={handleAddCategory}
          onCancel={() => setIsModalOpen(false)}
        />
      </Modal>
    </>
  );
};

export default CategoriesView;
