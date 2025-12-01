import React, { useEffect, useState } from 'react';
import { api, favoritesApi } from '../../utils/api';

const MealsTable = ({ meals = [], onDelete, onBulkDelete, onEdit }) => {
  const [showModal, setShowModal] = useState(false);
  const [selectedMeal, setSelectedMeal] = useState(null);
  const [detailLoading, setDetailLoading] = useState(false);
  const [ingredientForm, setIngredientForm] = useState({ name: '', amount: '', unit: '' });
  const [actionError, setActionError] = useState(null);
  const [addingToFavorites, setAddingToFavorites] = useState(null);
   // Track selected rows for bulk actions
  const [selectedIds, setSelectedIds] = useState([]);

  useEffect(() => {
    if (!Array.isArray(meals)) return;
    // Remove selections for meals no longer in the list
    setSelectedIds((prev) => prev.filter((id) => meals.some((m) => m.id === id)));
  }, [meals]);

  const openMealDetails = async (mealId) => {
    setActionError(null);
    setDetailLoading(true);
    try {
      const data = await api.get(`/meals/${mealId}`);
      const normalized = normalizeMeal(data);
      setSelectedMeal(normalized);
      setShowModal(true);
    } catch (err) {
      setActionError(err.message || 'Failed to load meal details');
    } finally {
      setDetailLoading(false);
    }
  };

  const closeModal = () => {
    setShowModal(false);
    setSelectedMeal(null);
    setIngredientForm({ name: '', amount: '', unit: '' });
    setActionError(null);
  };

  const handleIngredientChange = (e) => {
    const { name, value } = e.target;
    setIngredientForm(prev => ({ ...prev, [name]: value }));
  };

  const handleAddIngredient = async (e) => {
    e.preventDefault();
    setActionError(null);
    if (!ingredientForm.name.trim()) {
      setActionError('Ingredient name is required');
      return;
    }

    try {
      // Get current ingredients array
      const currentIngredients = Array.isArray(selectedMeal.ingredients)
        ? [...selectedMeal.ingredients]
        : [];

      // Create new ingredient object
      const newIngredient = {
        name: ingredientForm.name.trim(),
        ...(ingredientForm.amount && { amount: Number(ingredientForm.amount) }),
        ...(ingredientForm.unit && { unit: ingredientForm.unit.trim() })
      };

      // Add new ingredient to the array
      const updatedIngredients = [...currentIngredients, newIngredient];

      // Send PUT request with entire ingredients array
      const res = await api.put(`/meals/${selectedMeal.id}/ingredients`, {
        ingredients: updatedIngredients
      });

      // Update selected meal locally
      const updated = res.meal || res;
      setSelectedMeal(normalizeMeal(updated));
      setIngredientForm({ name: '', amount: '', unit: '' });
    } catch (err) {
      setActionError(err.message || 'Failed to add ingredient');
    }
  };

  const handleAddToFavorites = async (mealId) => {
    setAddingToFavorites(mealId);
    try {
      await favoritesApi.addFavorite(mealId);
      alert('Meal added to favorites!');
    } catch (err) {
      const msg = err?.message || 'Failed to add to favorites';
      alert(msg);
    } finally {
      setAddingToFavorites(null);
    }
  };

  const toggleSelect = (mealId) => {
    setSelectedIds((prev) =>
      prev.includes(mealId) ? prev.filter((id) => id !== mealId) : [...prev, mealId]
    );
  };

  const toggleSelectAll = () => {
    const list = Array.isArray(meals) ? meals : [];
    if (selectedIds.length === list.length) {
      setSelectedIds([]);
    } else {
      setSelectedIds(list.map((m) => m.id));
    }
  };

  const handleBulkDelete = () => {
    if (!selectedIds.length) return;
    if (onBulkDelete) {
      onBulkDelete(selectedIds);
      setSelectedIds([]);
    }
  };

  // Ensure ingredients and preparationSteps are arrays (Sequelize may return stringified JSON on some DBs)
  function normalizeMeal(meal) {
    if (!meal) return meal;
    const copy = { ...meal };
    try {
      if (copy.ingredients && typeof copy.ingredients === 'string') {
        copy.ingredients = JSON.parse(copy.ingredients);
      }
    } catch (e) {
      copy.ingredients = [];
    }
    try {
      if (copy.preparationSteps && typeof copy.preparationSteps === 'string') {
        copy.preparationSteps = JSON.parse(copy.preparationSteps);
      }
    } catch (e) {
      copy.preparationSteps = [];
    }
    // ensure arrays
    if (!Array.isArray(copy.ingredients)) copy.ingredients = [];
    if (!Array.isArray(copy.preparationSteps)) copy.preparationSteps = [];
    return copy;
  }
  const list = Array.isArray(meals) ? meals : [];

  return (
    <div className="card overflow-hidden p-0 w-full">
      {list.length > 0 && (
        <div className="flex items-center justify-between border-b border-[var(--color-border)] bg-white/70 px-4 py-3">
          <p className="text-sm text-[var(--color-text-secondary)]">
            Selected: <span className="font-semibold text-[var(--color-text-primary)]">{selectedIds.length}</span>
          </p>
          <button
            type="button"
            onClick={handleBulkDelete}
            disabled={!selectedIds.length}
            className="btn btn-danger-ghost btn-compact disabled:opacity-60"
          >
            Delete selected
          </button>
        </div>
      )}
      <div className="overflow-x-auto w-full">
        {!list.length ? (
          <div className="text-center py-12">
            <svg className="mx-auto h-12 w-12 text-[var(--color-text-tertiary)]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
            </svg>
            <h3 className="mt-2 text-sm font-medium text-[var(--color-text-primary)]">No meals found</h3>
            <p className="mt-1 text-sm text-[var(--color-text-secondary)]">Get started by creating a new meal.</p>
          </div>
        ) : (
          <table className="w-full divide-y divide-[var(--color-border)]">
            <thead className="bg-[var(--color-bg-tertiary)]">
              <tr>
                <th className="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-[var(--color-text-secondary)]">
                  <input
                    type="checkbox"
                    checked={selectedIds.length === meals.length && meals.length > 0}
                    onChange={toggleSelectAll}
                  />
                </th>
                <th className="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-[var(--color-text-secondary)]">ID</th>
                <th className="py-3.5 px-3 text-left text-sm font-semibold text-[var(--color-text-secondary)]">Image</th>
                <th className="py-3.5 px-3 text-left text-sm font-semibold text-[var(--color-text-secondary)]">Name</th>
                <th className="py-3.5 px-3 text-left text-sm font-semibold text-[var(--color-text-secondary)]">Category</th>
                <th className="py-3.5 px-3 text-left text-sm font-semibold text-[var(--color-text-secondary)]">Description</th>
                <th className="py-3.5 pl-3 pr-4 text-right text-sm font-semibold text-[var(--color-text-secondary)]">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-[var(--color-border)]">
              {list.map((meal) => (
                <tr key={meal.id} className="hover:bg-[var(--color-bg-tertiary)] transition-colors">
                  <td className="whitespace-nowrap py-4 pl-4 pr-3 text-sm">
                    <input
                      type="checkbox"
                      checked={selectedIds.includes(meal.id)}
                      onChange={() => toggleSelect(meal.id)}
                    />
                  </td>
                  <td className="whitespace-nowrap py-4 pl-4 pr-3 text-sm">
                    <span className="px-2.5 py-0.5 rounded-full font-medium">
                      #{meal.id}
                    </span>
                  </td>
                  <td className="whitespace-nowrap py-4 px-3 text-sm">
                    {meal.image ? (
                      <img
                        src={meal.image}
                        alt={meal.name}
                        className="h-10 w-10 rounded-full object-cover"
                      />
                    ) : (
                      <div className="h-10 w-10 rounded-full bg-[var(--color-bg-tertiary)]"></div>
                    )}
                  </td>
                  <td className="whitespace-nowrap py-4 px-3 text-sm font-medium text-[var(--color-text-primary)]">{meal.name}</td>
                  <td className="whitespace-nowrap py-4 px-3 text-sm text-[var(--color-text-secondary)]">
                    {meal.categoryId?.name || meal.category?.name || '-'}
                  </td>
                  <td className="py-4 px-3 text-sm text-[var(--color-text-secondary)] line-clamp-2">
                    {meal.description || '-'}
                  </td>
                  <td className="whitespace-nowrap py-4 pl-3 pr-4 text-right text-sm">
                    <button
                      onClick={() => handleAddToFavorites(meal.id)}
                      disabled={addingToFavorites === meal.id}
                      className="btn btn-ghost btn-compact mr-2 disabled:opacity-50"
                      title="Add to favorites"
                    >
                      {addingToFavorites === meal.id ? '...' : '♥'}
                    </button>
                    <button onClick={() => onEdit && onEdit(meal)} className="btn btn-secondary btn-compact mr-2">Edit</button>
                    <button
                      onClick={() => onDelete && onDelete(meal.id)}
                      className="btn btn-danger-ghost btn-compact"
                    >
                      Delete
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
      {showModal && selectedMeal && (
        <div className="fixed inset-0 z-50 flex items-start justify-center overflow-y-auto bg-black/40 px-4 py-8">
          <div className="relative w-full max-w-5xl rounded-2xl bg-[var(--color-bg-secondary)] shadow-2xl ring-1 ring-[var(--color-border)]">
            <div className="flex items-center justify-between border-b border-[var(--color-border)] px-6 py-4">
              <div>
                <p className="text-xs uppercase tracking-[0.3em] text-[var(--color-text-tertiary)]">Meal detail</p>
                <h3 className="text-2xl font-semibold text-[var(--color-text-primary)]">{selectedMeal.name}</h3>
              </div>
              <button
                onClick={closeModal}
                className="rounded-full border border-[var(--color-border)] px-4 py-2 text-sm font-semibold text-[var(--color-text-primary)] hover:border-[var(--color-primary)]"
              >
                Close
              </button>
            </div>
            {detailLoading ? (
              <div className="py-6 text-center text-[var(--color-text-primary)]">Loading...</div>
            ) : (
              <div className="space-y-6 px-6 py-5">
                <div className="grid grid-cols-1 gap-6 lg:grid-cols-[1.4fr,1fr]">
                  <div className="space-y-4">
                    <div className="aspect-video overflow-hidden rounded-2xl bg-[var(--color-bg-tertiary)]">
                      {selectedMeal.image ? (
                        <img src={selectedMeal.image} alt={selectedMeal.name} className="h-full w-full object-cover" />
                      ) : (
                        <div className="flex h-full items-center justify-center text-[var(--color-text-secondary)]">No image</div>
                      )}
                    </div>
                    <div className="space-y-2">
                      <p className="text-base text-[var(--color-text-secondary)]">{selectedMeal.description}</p>
                      {selectedMeal.categoryId && (
                        <div className="rounded-2xl border border-[var(--color-border)] bg-[var(--color-bg-primary)] p-4 space-y-2">
                          <h4 className="text-sm font-semibold text-[var(--color-text-primary)]">Category Information</h4>
                          <p className="text-sm text-[var(--color-text-primary)]">
                            <span className="text-[var(--color-text-secondary)]">ID:</span>{' '}
                            <span className="font-medium">{selectedMeal.categoryId.id}</span>
                          </p>
                          <p className="text-sm text-[var(--color-text-primary)]">
                            <span className="text-[var(--color-text-secondary)]">Name:</span>{' '}
                            <span className="font-medium">{selectedMeal.categoryId.name}</span>
                          </p>
                          {selectedMeal.categoryId.description && (
                            <p className="text-sm text-[var(--color-text-primary)]">
                              <span className="text-[var(--color-text-secondary)]">Description:</span>{' '}
                              <span>{selectedMeal.categoryId.description}</span>
                            </p>
                          )}
                        </div>
                      )}
                      {!selectedMeal.categoryId && (
                        <p className="text-sm text-[var(--color-text-primary)]">Category: {selectedMeal.category?.name || '-'}</p>
                      )}
                    </div>
                  </div>

                  <div className="space-y-6">
                    <div>
                      <h4 className="mb-2 text-lg font-semibold text-[var(--color-text-primary)]">Ingredients</h4>
                      <ul className="space-y-2 rounded-2xl border border-[var(--color-border)] bg-[var(--color-bg-primary)] p-4 max-h-48 overflow-y-auto">
                        {(selectedMeal.ingredients || []).map((ing, i) => (
                          <li key={i} className="flex items-center gap-3 text-sm text-[var(--color-text-primary)]">
                            <span className="flex h-7 w-7 items-center justify-center rounded-full bg-[var(--color-bg-secondary)] text-[var(--color-text-primary)]">{i + 1}</span>
                            <span>{ing.name}</span>
                            {ing.amount && (
                              <span className="text-[var(--color-text-secondary)]">
                                {ing.amount} {ing.unit || ''}
                              </span>
                            )}
                          </li>
                        ))}
                        {(selectedMeal.ingredients || []).length === 0 && (
                          <li className="text-sm text-[var(--color-text-secondary)]">No ingredients added yet.</li>
                        )}
                      </ul>
                      <form onSubmit={handleAddIngredient} className="mt-3 space-y-2">
                        <div className="grid grid-cols-3 gap-2">
                          <input
                            name="name"
                            value={ingredientForm.name}
                            onChange={handleIngredientChange}
                            placeholder="Name"
                            className="input block w-full"
                          />
                          <input
                            name="amount"
                            value={ingredientForm.amount}
                            onChange={handleIngredientChange}
                            placeholder="Amount"
                            className="input block w-full"
                          />
                          <input
                            name="unit"
                            value={ingredientForm.unit}
                            onChange={handleIngredientChange}
                            placeholder="Unit"
                            className="input block w-full"
                          />
                        </div>
                        <div className="flex justify-end">
                          <button
                            type="submit"
                            className="btn btn-primary"
                          >
                            Add Ingredient
                          </button>
                        </div>
                      </form>
                    </div>

                    <div>
                      <h4 className="mb-2 text-lg font-semibold text-[var(--color-text-primary)]">Preparation Steps</h4>
                      <div className="space-y-2 rounded-2xl border border-[var(--color-border)] bg-[var(--color-bg-primary)] p-4 max-h-56 overflow-y-auto">
                        {(selectedMeal.preparationSteps || []).map((step) => (
                          <div key={step.step} className="flex gap-3">
                            <div className="flex h-7 w-7 flex-shrink-0 items-center justify-center rounded-full bg-[var(--color-primary)] text-sm font-bold text-white">
                              {step.step}
                            </div>
                            <p className="text-sm text-[var(--color-text-primary)]">{step.description}</p>
                          </div>
                        ))}
                        {(selectedMeal.preparationSteps || []).length === 0 && (
                          <p className="text-sm text-[var(--color-text-secondary)]">No preparation steps added yet.</p>
                        )}
                      </div>
                    </div>
                  </div>
                </div>

                {actionError && (
                  <div className="rounded-lg bg-red-500/10 text-red-400 p-3 text-sm">
                    {actionError}
                  </div>
                )}
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
};

export default MealsTable;
