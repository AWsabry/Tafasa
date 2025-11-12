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
  const [isUploadModalOpen, setIsUploadModalOpen] = useState(false);
  const [uploading, setUploading] = useState(false);
  const [uploadFile, setUploadFile] = useState(null);
  const [uploadError, setUploadError] = useState(null);
  const [uploadSummary, setUploadSummary] = useState(null);
  const [uploadDetails, setUploadDetails] = useState([]);
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

  const handleUploadSubmit = async (e) => {
    e.preventDefault();
    setUploadError(null);
    setUploadSummary(null);
    setUploadDetails([]);

    if (!uploadFile) {
      setUploadError('Please select an Excel file to upload.');
      return;
    }

    const formData = new FormData();
    formData.append('file', uploadFile);

    setUploading(true);
    try {
      const response = await api.upload('/meals/upload', formData);
      setUploadSummary(response.summary || null);
      setUploadDetails(response.errors || []);
      if (response.errors && response.errors.length > 0) {
        setUploadError('Some rows could not be imported. Review the details below.');
      }
      await fetchMeals();
    } catch (err) {
      setUploadError(err?.message || 'Failed to upload meals.');
    } finally {
      setUploading(false);
    }
  };

  const closeUploadModal = () => {
    setIsUploadModalOpen(false);
    setUploadFile(null);
    setUploadError(null);
    setUploadSummary(null);
    setUploadDetails([]);
  };
 
  if (loading) return (
    <div className="flex items-center justify-center py-12">
      <div className="animate-spin rounded-full h-10 w-10 border-4 border-[var(--color-primary)] border-t-transparent"></div>
    </div>
  );

  if (error && !isModalOpen && !isUploadModalOpen) return (
    <div className="card p-6">
      <p className="text-[var(--color-accent-red)]">Error: {error}</p>
    </div>
  );

  return (
    <>
      <div className="flex flex-wrap justify-end gap-3 mb-4">
        <button
          onClick={() => {
            setIsUploadModalOpen(true);
            setUploadError(null);
            setUploadSummary(null);
            setUploadDetails([]);
          }}
          className="btn btn-secondary group flex items-center gap-2"
        >
          <svg className="w-5 h-5 transition-transform group-hover:scale-110" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 4v4m0 0h4M4 8l4-4m8 12v4m0 0h4m-4 0l4-4" />
          </svg>
          Upload Meals (Excel)
        </button>
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

      <Modal isOpen={isUploadModalOpen} onClose={closeUploadModal}>
        <div className="mb-4">
          <h2 className="text-lg font-semibold">Upload Meals from Excel</h2>
          <p className="text-sm text-[var(--color-text-secondary)]">
            Upload an Excel file (.xlsx or .xls) using the provided template. Ingredients can be separated with <code>|</code> and rows separated with <code>;</code>.
          </p>
          <a
            href="/samples/meals_upload_template.xls"
            download
            className="text-sm text-[var(--color-primary)] hover:underline"
          >
            Download sample template
          </a>
        </div>

        <form onSubmit={handleUploadSubmit} className="space-y-4">
          <div>
            <input
              type="file"
              accept=".xlsx,.xls,.csv"
              onChange={(event) => {
                setUploadFile(event.target.files?.[0] || null);
                setUploadError(null);
              }}
              className="block w-full text-sm text-[var(--color-text-secondary)] file:mr-4 file:rounded file:border-0 file:px-4 file:py-2 file:bg-[var(--color-primary)] file:text-white hover:file:bg-[var(--color-primary-light)]"
            />
            <p className="mt-2 text-xs text-[var(--color-text-secondary)]">
              Required columns: <strong>Name</strong>, <strong>Price</strong>, and either <strong>CategoryId</strong> or <strong>CategoryName</strong>.
            </p>
            <p className="mt-1 text-xs text-[var(--color-text-secondary)]">
              Ingredients format example: <code>Tomato|2|pcs;Olive Oil|1|tbsp</code>. Steps example: <code>Preheat oven;Bake for 20 minutes</code>.
            </p>
          </div>

          {uploadError && (
            <div className="rounded-lg bg-red-500/10 text-red-400 p-3 text-sm">
              {uploadError}
            </div>
          )}

          {uploadSummary && (
            <div className="rounded-lg bg-green-500/10 p-3 text-sm space-y-1">
              <p className="text-green-400 font-semibold">Upload summary</p>
              <p>Processed rows: {uploadSummary.processed}</p>
              <p>Created meals: {uploadSummary.created}</p>
              <p>Failed rows: {uploadSummary.failed}</p>
            </div>
          )}

          {uploadDetails.length > 0 && (
            <div className="rounded-lg bg-yellow-500/10 p-3 text-sm space-y-2 max-h-40 overflow-y-auto">
              <p className="text-yellow-300 font-semibold">Issues found</p>
              <ul className="space-y-1 list-disc list-inside">
                {uploadDetails.map((detail, idx) => (
                  <li key={`${detail.row}-${idx}`}>
                    Row {detail.row}: {detail.error}
                  </li>
                ))}
              </ul>
            </div>
          )}

          <div className="flex justify-end gap-3 pt-4 border-t border-[var(--color-bg-tertiary)]">
            <button
              type="button"
              onClick={closeUploadModal}
              className="px-4 py-2 text-sm font-medium text-[var(--color-text-secondary)] hover:text-[var(--color-text-primary)]"
            >
              Close
            </button>
            <button
              type="submit"
              disabled={uploading}
              className="rounded-lg bg-[var(--color-primary)] px-4 py-2 text-sm font-medium text-white hover:bg-[var(--color-primary-light)] disabled:opacity-60"
            >
              {uploading ? 'Uploading...' : 'Upload' }
            </button>
          </div>
        </form>
      </Modal>
    </>
  );
};

export default MealsView;
