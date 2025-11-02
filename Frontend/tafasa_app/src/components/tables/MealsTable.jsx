import React, { useState } from 'react';
import { api } from '../../utils/api';

const MealsTable = ({ meals }) => {
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
      const payload = {
        name: ingredientForm.name.trim(),
        amount: ingredientForm.amount ? Number(ingredientForm.amount) : undefined,
        unit: ingredientForm.unit ? ingredientForm.unit.trim() : undefined
      };

      const res = await api.patch(`/meals/${selectedMeal.id}/ingredients`, payload);
      // update selected meal locally
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
                {meal.category?.name || '-'}
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
                <button className="rounded bg-red-500/10 px-2 py-1 text-red-400 hover:bg-red-500/20">Delete</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
      {showModal && selectedMeal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50">
          <div className="bg-[var(--color-bg-secondary)] rounded-lg w-full max-w-2xl p-6">
            <div className="flex justify-between items-start">
              <h3 className="text-lg font-semibold">{selectedMeal.name}</h3>
              <button onClick={closeModal} className="text-sm text-[var(--color-text-secondary)]">Close</button>
            </div>
            {detailLoading ? (
              <div className="py-6 text-center">Loading...</div>
            ) : (
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mt-4">
                <div>
                  <img src={selectedMeal.image} alt={selectedMeal.name} className="w-full h-48 object-cover rounded" />
                  <p className="mt-3 text-sm text-[var(--color-text-secondary)]">{selectedMeal.description}</p>
                  <p className="mt-2 font-medium">Price: ${Number(selectedMeal.price).toFixed(2)}</p>
                  <p className="mt-1 text-sm">Category: {selectedMeal.category?.name || '-'}</p>
                </div>
                <div>
                  <h4 className="font-semibold">Ingredients</h4>
                  <ul className="mt-2 space-y-1 max-h-40 overflow-auto">
                    {(selectedMeal.ingredients || []).map((ing, i) => (
                      <li key={i} className="text-sm">{ing.name}{ing.amount ? ` — ${ing.amount}` : ''}{ing.unit ? ` ${ing.unit}` : ''}</li>
                    ))}
                  </ul>

                  <form onSubmit={handleAddIngredient} className="mt-4 space-y-2">
                    <h5 className="font-medium">Add Ingredient</h5>
                    {actionError && <div className="text-sm text-[var(--color-accent-red)]">{actionError}</div>}
                    <div className="grid grid-cols-3 gap-2">
                      <input name="name" value={ingredientForm.name} onChange={handleIngredientChange} placeholder="Name" className="input" />
                      <input name="amount" value={ingredientForm.amount} onChange={handleIngredientChange} placeholder="Amount" className="input" />
                      <input name="unit" value={ingredientForm.unit} onChange={handleIngredientChange} placeholder="Unit" className="input" />
                    </div>
                    <div className="flex justify-end">
                      <button type="submit" className="btn btn-primary">Add</button>
                    </div>
                  </form>
                </div>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
};

export default MealsTable;