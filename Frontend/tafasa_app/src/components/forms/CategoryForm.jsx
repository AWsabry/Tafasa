import React, { useState } from 'react';

const CategoryForm = ({ onSubmit, onCancel, initialData = {} }) => {
  const [formData, setFormData] = useState({
    name: initialData.name || '',
    description: initialData.description || ''
  });
  const [error, setError] = useState('');

  const handleSubmit = (e) => {
    e.preventDefault();
    setError('');

    // Validation
    if (!formData.name.trim()) {
      setError('Category name is required');
      return;
    }
    if (formData.name.length > 50) {
      setError('Category name must not exceed 50 characters');
      return;
    }

    onSubmit(formData);
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      {error && (
        <div className="bg-red-500/10 text-red-400 p-3 rounded-lg text-sm">
          {error}
        </div>
      )}
      
      <div>
        <label htmlFor="name" className="block text-sm font-medium text-[var(--color-text-secondary)] mb-1">
          Name
        </label>
        <input
          type="text"
          id="name"
          value={formData.name}
          onChange={(e) => setFormData(prev => ({ ...prev, name: e.target.value }))}
          className="block w-full rounded-lg bg-[var(--color-bg-tertiary)] border-transparent px-4 py-2.5 text-[var(--color-text-primary)]"
          placeholder="Enter category name"
        />
      </div>

      <div>
        <label htmlFor="description" className="block text-sm font-medium text-[var(--color-text-secondary)] mb-1">
          Description (optional)
        </label>
        <textarea
          id="description"
          value={formData.description}
          onChange={(e) => setFormData(prev => ({ ...prev, description: e.target.value }))}
          className="block w-full rounded-lg bg-[var(--color-bg-tertiary)] border-transparent px-4 py-2.5 text-[var(--color-text-primary)]"
          rows="3"
          placeholder="Enter category description"
        />
      </div>

      <div className="flex justify-end gap-3 pt-4">
        <button
          type="button"
          onClick={onCancel}
          className="px-4 py-2 text-sm font-medium text-[var(--color-text-secondary)] hover:text-[var(--color-text-primary)]"
        >
          Cancel
        </button>
        <button
          type="submit"
          className="rounded-lg bg-[var(--color-primary)] px-4 py-2 text-sm font-medium text-white hover:bg-[var(--color-primary-light)]"
        >
          Save Category
        </button>
      </div>
    </form>
  );
};

export default CategoryForm;