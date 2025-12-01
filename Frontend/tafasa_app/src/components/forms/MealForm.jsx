import React, { useState, useEffect } from 'react';
import { api } from '../../utils/api';

const MealForm = ({ onSubmit, onCancel, initialData = {} }) => {
  const [formData, setFormData] = useState({
    name: initialData.name || '',
    description: initialData.description || '',
    image: initialData.image || '',
    categoryId: initialData.categoryId?.id || initialData.categoryId || '',
    ingredients: initialData.ingredients || [],
    preparationSteps: initialData.preparationSteps || []
  });
  const [categories, setCategories] = useState([]);
  const [loadingCategories, setLoadingCategories] = useState(false);
  const [error, setError] = useState('');
  const [newIngredient, setNewIngredient] = useState({ name: '', amount: '', unit: '' });
  const [newStep, setNewStep] = useState({ description: '' });

  useEffect(() => {
    const fetchCategories = async () => {
      setLoadingCategories(true);
      try {
        const data = await api.get('/categories');
        const list = Array.isArray(data) ? data : (data?.categories || []);
        setCategories(list);
      } catch (err) {
        setError('Failed to load categories');
      } finally {
        setLoadingCategories(false);
      }
    };
    fetchCategories();
  }, []);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  const handleAddIngredient = () => {
    if (!newIngredient.name.trim()) {
      setError('Ingredient name is required');
      return;
    }
    const ingredient = {
      name: newIngredient.name.trim(),
      ...(newIngredient.amount && { amount: Number(newIngredient.amount) }),
      ...(newIngredient.unit && { unit: newIngredient.unit.trim() })
    };
    setFormData(prev => ({
      ...prev,
      ingredients: [...prev.ingredients, ingredient]
    }));
    setNewIngredient({ name: '', amount: '', unit: '' });
    setError('');
  };

  const handleRemoveIngredient = (index) => {
    setFormData(prev => ({
      ...prev,
      ingredients: prev.ingredients.filter((_, i) => i !== index)
    }));
  };

  const handleAddStep = () => {
    if (!newStep.description.trim()) {
      setError('Step description is required');
      return;
    }
    const stepNumber = formData.preparationSteps.length + 1;
    const step = {
      step: stepNumber,
      description: newStep.description.trim()
    };
    setFormData(prev => ({
      ...prev,
      preparationSteps: [...prev.preparationSteps, step]
    }));
    setNewStep({ description: '' });
    setError('');
  };

  const handleRemoveStep = (index) => {
    const updatedSteps = formData.preparationSteps
      .filter((_, i) => i !== index)
      .map((step, idx) => ({ ...step, step: idx + 1 }));
    setFormData(prev => ({
      ...prev,
      preparationSteps: updatedSteps
    }));
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    setError('');

    // Validation
    if (!formData.name.trim()) {
      setError('Meal name is required');
      return;
    }
    if (!formData.categoryId) {
      setError('Category is required');
      return;
    }
    if (formData.image && !isValidUrl(formData.image)) {
      setError('Image must be a valid URL');
      return;
    }

    onSubmit({
      ...formData,
      categoryId: formData.categoryId
    });
  };

  const isValidUrl = (string) => {
    try {
      new URL(string);
      return true;
    } catch (_) {
      return false;
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4 max-h-[80vh] overflow-y-auto">
      {error && (
        <div className="bg-red-500/10 text-red-400 p-3 rounded-lg text-sm">
          {error}
        </div>
      )}

      <div>
        <label htmlFor="name" className="block text-sm font-medium text-[var(--color-text-secondary)] mb-1">
          Name <span className="text-red-400">*</span>
        </label>
        <input
          type="text"
          id="name"
          name="name"
          value={formData.name}
          onChange={handleChange}
          className="block w-full rounded-lg bg-[var(--color-bg-tertiary)] border-transparent px-4 py-2.5 text-[var(--color-text-primary)]"
          placeholder="Enter meal name"
          required
        />
      </div>

      <div>
        <label htmlFor="categoryId" className="block text-sm font-medium text-[var(--color-text-secondary)] mb-1">
          Category <span className="text-red-400">*</span>
        </label>
        <select
          id="categoryId"
          name="categoryId"
          value={formData.categoryId}
          onChange={handleChange}
          className="block w-full rounded-lg bg-[var(--color-bg-tertiary)] border-transparent px-4 py-2.5 text-[var(--color-text-primary)]"
          required
          disabled={loadingCategories}
        >
          <option value="">Select a category</option>
          {categories.map(category => (
            <option key={category.id} value={category.id}>
              {category.name}
            </option>
          ))}
        </select>
      </div>

      <div>
        <label htmlFor="description" className="block text-sm font-medium text-[var(--color-text-secondary)] mb-1">
          Description (optional)
        </label>
        <textarea
          id="description"
          name="description"
          value={formData.description}
          onChange={handleChange}
          className="block w-full rounded-lg bg-[var(--color-bg-tertiary)] border-transparent px-4 py-2.5 text-[var(--color-text-primary)]"
          rows="3"
          placeholder="Enter meal description"
        />
      </div>

      <div>
        <label htmlFor="image" className="block text-sm font-medium text-[var(--color-text-secondary)] mb-1">
          Image URL (optional)
        </label>
        <input
          type="url"
          id="image"
          name="image"
          value={formData.image}
          onChange={handleChange}
          className="block w-full rounded-lg bg-[var(--color-bg-tertiary)] border-transparent px-4 py-2.5 text-[var(--color-text-primary)]"
          placeholder="https://example.com/image.jpg"
        />
      </div>

      {/* Ingredients Section */}
      <div>
        <label className="block text-sm font-medium text-[var(--color-text-secondary)] mb-2">
          Ingredients
        </label>
        <div className="space-y-2 max-h-40 overflow-y-auto bg-[var(--color-bg-tertiary)] p-3 rounded-lg">
          {formData.ingredients.length === 0 ? (
            <p className="text-sm text-[var(--color-text-secondary)]">No ingredients added yet</p>
          ) : (
            formData.ingredients.map((ingredient, index) => (
              <div key={index} className="flex items-center justify-between bg-[var(--color-bg-secondary)] p-2 rounded">
                <span className="text-sm">
                  {ingredient.name}
                  {ingredient.amount && ` - ${ingredient.amount} ${ingredient.unit || ''}`}
                </span>
                <button
                  type="button"
                  onClick={() => handleRemoveIngredient(index)}
                  className="text-red-400 hover:text-red-300 text-sm"
                >
                  Remove
                </button>
              </div>
            ))
          )}
        </div>
        <div className="mt-2 grid grid-cols-3 gap-2">
          <input
            type="text"
            placeholder="Ingredient name"
            value={newIngredient.name}
            onChange={(e) => setNewIngredient(prev => ({ ...prev, name: e.target.value }))}
            className="block w-full rounded-lg bg-[var(--color-bg-tertiary)] border-transparent px-3 py-2 text-sm text-[var(--color-text-primary)]"
          />
          <input
            type="number"
            placeholder="Amount"
            value={newIngredient.amount}
            onChange={(e) => setNewIngredient(prev => ({ ...prev, amount: e.target.value }))}
            className="block w-full rounded-lg bg-[var(--color-bg-tertiary)] border-transparent px-3 py-2 text-sm text-[var(--color-text-primary)]"
          />
          <div className="flex gap-2">
            <input
              type="text"
              placeholder="Unit"
              value={newIngredient.unit}
              onChange={(e) => setNewIngredient(prev => ({ ...prev, unit: e.target.value }))}
              className="block w-full rounded-lg bg-[var(--color-bg-tertiary)] border-transparent px-3 py-2 text-sm text-[var(--color-text-primary)]"
            />
            <button
              type="button"
              onClick={handleAddIngredient}
              className="rounded-lg bg-[var(--color-primary)] px-3 py-2 text-sm font-medium text-white hover:bg-[var(--color-primary-light)]"
            >
              Add
            </button>
          </div>
        </div>
      </div>

      {/* Preparation Steps Section */}
      <div>
        <label className="block text-sm font-medium text-[var(--color-text-secondary)] mb-2">
          Preparation Steps
        </label>
        <div className="space-y-2 max-h-40 overflow-y-auto bg-[var(--color-bg-tertiary)] p-3 rounded-lg">
          {formData.preparationSteps.length === 0 ? (
            <p className="text-sm text-[var(--color-text-secondary)]">No steps added yet</p>
          ) : (
            formData.preparationSteps.map((step, index) => (
              <div key={index} className="flex items-start gap-2 bg-[var(--color-bg-secondary)] p-2 rounded">
                <span className="flex-shrink-0 w-6 h-6 rounded-full bg-[var(--color-primary)] text-white text-xs flex items-center justify-center">
                  {step.step}
                </span>
                <span className="flex-1 text-sm">{step.description}</span>
                <button
                  type="button"
                  onClick={() => handleRemoveStep(index)}
                  className="text-red-400 hover:text-red-300 text-sm"
                >
                  Remove
                </button>
              </div>
            ))
          )}
        </div>
        <div className="mt-2 flex gap-2">
          <input
            type="text"
            placeholder="Enter step description"
            value={newStep.description}
            onChange={(e) => setNewStep(prev => ({ ...prev, description: e.target.value }))}
            className="block w-full rounded-lg bg-[var(--color-bg-tertiary)] border-transparent px-3 py-2 text-sm text-[var(--color-text-primary)]"
          />
          <button
            type="button"
            onClick={handleAddStep}
            className="rounded-lg bg-[var(--color-primary)] px-4 py-2 text-sm font-medium text-white hover:bg-[var(--color-primary-light)]"
          >
            Add Step
          </button>
        </div>
      </div>

      <div className="flex justify-end gap-3 pt-4 border-t border-[var(--color-bg-tertiary)]">
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
          Save Meal
        </button>
      </div>
    </form>
  );
};

export default MealForm;

