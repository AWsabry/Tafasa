import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import MealsTable from '../tables/MealsTable';
import { api } from '../../utils/api';
import { useAuth } from '../../contexts/AuthContext';
import MealForm from '../forms/MealForm';

const Modal = ({ isOpen, onClose, children }) => {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 overflow-y-auto">
      <div className="flex min-h-screen items-center justify-center p-4">
        <div className="fixed inset-0 bg-black/50 transition-opacity" onClick={onClose}></div>
        <div className="relative rounded-lg bg-[var(--color-bg-secondary)] p-6 w-full max-w-2xl max-h-[90vh] overflow-y-auto">
          {children}
        </div>
      </div>
    </div>
  );
};

const MealsView = () => {
  const [meals, setMeals] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const navigate = useNavigate();
  const { token } = useAuth();

  const fetchMeals = async () => {
    setLoading(true);
    try {
      const data = await api.get('/meals');
      const list = Array.isArray(data) ? data : (data?.meals || []);
      setMeals(list);
      setError(null);
    } catch (err) {
      const msg = err?.message || 'Failed to load meals';
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
      fetchMeals();
    }
    return () => { mounted = false; };
  }, []);

  const handleDeleteMeal = async (mealId) => {
    if (!window.confirm('Are you sure you want to delete this meal?')) {
      return;
    }

    try {
      await api.delete(`/meals/${mealId}`);
      // Refresh the meals list
      await fetchMeals();
    } catch (err) {
      const msg = err?.message || 'Failed to delete meal';
      alert(msg);
    }
  };

  const handleAddMeal = async (formData) => {
    try {
      const response = await api.post('/meals', formData);
      const newMeal = response.meal || response;
      
      // Refresh the meals list
      await fetchMeals();
      setIsModalOpen(false);
    } catch (err) {
      const msg = err?.message || 'Failed to create meal';
      setError(msg);
    }
  };

  if (loading) return (
    <div className="flex items-center justify-center py-12">
      <div className="animate-spin rounded-full h-10 w-10 border-4 border-[var(--color-primary)] border-t-transparent"></div>
    </div>
  );

  if (error && !isModalOpen) return (
    <div className="card p-6">
      <p className="text-[var(--color-accent-red)]">Error: {error}</p>
    </div>
  );

  return (
    <>
      <div className="flex justify-end mb-4">
        <button
          onClick={() => {
            setIsModalOpen(true);
            setError(null);
          }}
          className="btn btn-primary group flex items-center gap-2"
        >
          <svg className="w-5 h-5 transition-transform group-hover:scale-110" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
          </svg>
          Add New Meal
        </button>
      </div>

      <MealsTable meals={meals} onDelete={handleDeleteMeal} />

      <Modal isOpen={isModalOpen} onClose={() => {
        setIsModalOpen(false);
        setError(null);
      }}>
        <div className="mb-4">
          <h2 className="text-lg font-semibold">Add New Meal</h2>
          <p className="text-sm text-[var(--color-text-secondary)]">Create a new meal with ingredients and preparation steps</p>
        </div>
        <MealForm 
          onSubmit={handleAddMeal}
          onCancel={() => {
            setIsModalOpen(false);
            setError(null);
          }}
        />
      </Modal>
    </>
  );
};

export default MealsView;
