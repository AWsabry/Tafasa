import React, { useState } from 'react';
import { api } from '../../utils/api';

const MealsTable = ({ meals, onDelete }) => {
  const [showModal, setShowModal] = useState(false);
  const [selectedMeal, setSelectedMeal] = useState(null);
  const [detailLoading, setDetailLoading] = useState(false);
  const [ingredientForm, setIngredientForm] = useState({ name: '', amount: '', unit: '' });
  const [actionError, setActionError] = useState(null);

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
  return (
    <div className="overflow-x-auto rounded-xl bg-white/5 p-6">
      <table className="min-w-full">
        <thead>
          <tr className="border-b border-white/10">
            <th className="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-white/60">ID</th>
            <th className="py-3.5 px-3 text-left text-sm font-semibold text-white/60">Image</th>
            <th className="py-3.5 px-3 text-left text-sm font-semibold text-white/60">Name</th>
            <th className="py-3.5 px-3 text-left text-sm font-semibold text-white/60">Category</th>
            <th className="py-3.5 px-3 text-left text-sm font-semibold text-white/60">Price</th>
            <th className="py-3.5 px-3 text-left text-sm font-semibold text-white/60">Description</th>
            <th className="py-3.5 pl-3 pr-4 text-right text-sm font-semibold text-white/60">Actions</th>
          </tr>
        </thead>
        <tbody>
          {meals?.map((meal) => (
            <tr key={meal.id} className="border-b border-white/5">
              <td className="whitespace-nowrap py-4 pl-4 pr-3 text-sm text-white">{meal.id}</td>
              <td className="whitespace-nowrap py-4 px-3 text-sm">
                {meal.image ? (
                  <img 
                    src={meal.image} 
                    alt={meal.name} 
                    className="h-10 w-10 rounded-full object-cover"
                  />
                ) : (
                  <div className="h-10 w-10 rounded-full bg-white/10"></div>
                )}
              </td>
              <td className="whitespace-nowrap py-4 px-3 text-sm text-white">{meal.name}</td>
              <td className="whitespace-nowrap py-4 px-3 text-sm text-white">
                {meal.categoryId?.name || meal.category?.name || '-'}
              </td>
              <td className="whitespace-nowrap py-4 px-3 text-sm text-white">
                ${meal.price.toFixed(2)}
              </td>
              <td className="py-4 px-3 text-sm text-white line-clamp-2">
                {meal.description || '-'}
              </td>
              <td className="whitespace-nowrap py-4 pl-3 pr-4 text-right text-sm">
                <button onClick={() => openMealDetails(meal.id)} className="rounded bg-white/5 px-2 py-1 text-white hover:bg-white/10 mr-2">View</button>
                <button className="rounded bg-white/5 px-2 py-1 text-white hover:bg-white/10 mr-2">Edit</button>
                <button 
                  onClick={() => onDelete && onDelete(meal.id)} 
                  className="rounded bg-red-500/10 px-2 py-1 text-red-400 hover:bg-red-500/20"
                >
                  Delete
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
      {showModal && selectedMeal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center overflow-y-auto p-4">
          <div className="fixed inset-0 bg-black/50" onClick={closeModal}></div>
          <div className="relative bg-[var(--color-bg-secondary)] rounded-lg w-full max-w-2xl p-6">
            <div className="flex justify-between items-center border-b border-[var(--color-bg-tertiary)] pb-4">
              <h3 className="text-xl font-semibold">{selectedMeal.name}</h3>
              <button 
                onClick={closeModal} 
                className="rounded-lg p-2 hover:bg-[var(--color-bg-tertiary)]"
              >
                <svg className="w-5 h-5" viewBox="0 0 20 20" fill="currentColor">
                  <path fillRule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clipRule="evenodd" />
                </svg>
              </button>
            </div>
            {detailLoading ? (
              <div className="py-6 text-center">Loading...</div>
            ) : (
              <div className="space-y-6 mt-4">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div>
                    <div className="aspect-video relative rounded-lg overflow-hidden bg-[var(--color-bg-tertiary)]">
                      {selectedMeal.image ? (
                        <img src={selectedMeal.image} alt={selectedMeal.name} className="w-full h-full object-cover" />
                      ) : (
                        <div className="flex items-center justify-center h-full text-[var(--color-text-secondary)]">No image</div>
                      )}
                    </div>
                    <div className="mt-4 space-y-2">
                      <p className="text-sm text-[var(--color-text-secondary)]">{selectedMeal.description}</p>
                      <p className="font-medium">Price: ${Number(selectedMeal.price).toFixed(2)}</p>
                      {selectedMeal.categoryId && (
                        <div className="mt-3 p-3 rounded-lg bg-[var(--color-bg-tertiary)] space-y-2">
                          <h4 className="font-semibold text-sm mb-2">Category Information</h4>
                          <p className="text-sm">
                            <span className="text-[var(--color-text-secondary)]">ID:</span>{' '}
                            <span className="font-medium">{selectedMeal.categoryId.id}</span>
                          </p>
                          <p className="text-sm">
                            <span className="text-[var(--color-text-secondary)]">Name:</span>{' '}
                            <span className="font-medium">{selectedMeal.categoryId.name}</span>
                          </p>
                          {selectedMeal.categoryId.description && (
                            <p className="text-sm">
                              <span className="text-[var(--color-text-secondary)]">Description:</span>{' '}
                              <span>{selectedMeal.categoryId.description}</span>
                            </p>
                          )}
                        </div>
                      )}
                      {!selectedMeal.categoryId && (
                        <p className="text-sm">Category: {selectedMeal.category?.name || '-'}</p>
                      )}
                    </div>
                  </div>

                  <div className="space-y-6">
                    <div>
                      <h4 className="font-semibold mb-2">Ingredients</h4>
                      <ul className="space-y-1 max-h-[120px] overflow-y-auto rounded-lg bg-[var(--color-bg-tertiary)] p-3">
                        {(selectedMeal.ingredients || []).map((ing, i) => (
                          <li key={i} className="text-sm flex items-center gap-2">
                            <span className="w-6 h-6 flex items-center justify-center rounded bg-[var(--color-bg-secondary)]">{i + 1}</span>
                            <span>{ing.name}</span>
                            {ing.amount && (
                              <span className="text-[var(--color-text-secondary)]">
                                {ing.amount} {ing.unit || ''}
                              </span>
                            )}
                          </li>
                        ))}
                      </ul>
                      <form onSubmit={handleAddIngredient} className="mt-3 space-y-2">
                        <div className="grid grid-cols-3 gap-2">
                          <input 
                            name="name" 
                            value={ingredientForm.name} 
                            onChange={handleIngredientChange} 
                            placeholder="Name" 
                            className="block w-full rounded bg-[var(--color-bg-tertiary)] px-3 py-1.5 text-sm"
                          />
                          <input 
                            name="amount" 
                            value={ingredientForm.amount} 
                            onChange={handleIngredientChange} 
                            placeholder="Amount" 
                            className="block w-full rounded bg-[var(--color-bg-tertiary)] px-3 py-1.5 text-sm"
                          />
                          <input 
                            name="unit" 
                            value={ingredientForm.unit} 
                            onChange={handleIngredientChange} 
                            placeholder="Unit" 
                            className="block w-full rounded bg-[var(--color-bg-tertiary)] px-3 py-1.5 text-sm"
                          />
                        </div>
                        <div className="flex justify-end">
                          <button 
                            type="submit" 
                            className="rounded bg-[var(--color-primary)] px-3 py-1.5 text-sm font-medium text-white hover:bg-[var(--color-primary-light)]"
                          >
                            Add Ingredient
                          </button>
                        </div>
                      </form>
                    </div>

                    <div>
                      <h4 className="font-semibold mb-2">Preparation Steps</h4>
                      <div className="space-y-2 max-h-[200px] overflow-y-auto rounded-lg bg-[var(--color-bg-tertiary)] p-3">
                        {(selectedMeal.preparationSteps || []).map((step) => (
                          <div key={step.step} className="flex gap-3">
                            <div className="w-6 h-6 flex-shrink-0 rounded-full bg-[var(--color-bg-secondary)] flex items-center justify-center text-sm">
                              {step.step}
                            </div>
                            <p className="text-sm">{step.description}</p>
                          </div>
                        ))}
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