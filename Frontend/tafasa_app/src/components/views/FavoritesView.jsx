import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { favoritesApi } from '../../utils/api';
import { useAuth } from '../../contexts/AuthContext';

const FavoritesView = () => {
  const [favorites, setFavorites] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [selectedMeal, setSelectedMeal] = useState(null);
  const [showModal, setShowModal] = useState(false);
  const [removingId, setRemovingId] = useState(null);
  const navigate = useNavigate();
  const { token } = useAuth();

  const fetchFavorites = async () => {
    setLoading(true);
    try {
      const data = await favoritesApi.getAllFavorites();
      const list = Array.isArray(data) ? data : (data?.favorites || []);
      setFavorites(list);
      setError(null);
    } catch (err) {
      const msg = err?.message || 'Failed to load favorites';
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
      fetchFavorites();
    }
    return () => { mounted = false; };
  }, []);

  const handleRemoveFavorite = async (mealId) => {
    if (!window.confirm('Are you sure you want to remove this meal from favorites?')) {
      return;
    }

    setRemovingId(mealId);
    try {
      await favoritesApi.removeFavorite(mealId);
      // Refresh the favorites list
      await fetchFavorites();
    } catch (err) {
      const msg = err?.message || 'Failed to remove favorite';
      alert(msg);
    } finally {
      setRemovingId(null);
    }
  };

  const openMealDetails = (favorite) => {
    setSelectedMeal(favorite);
    setShowModal(true);
  };

  const closeModal = () => {
    setShowModal(false);
    setSelectedMeal(null);
  };

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
      {!favorites || favorites.length === 0 ? (
        <div className="card p-12 text-center">
          <div className="mx-auto w-16 h-16 rounded-full bg-[var(--color-primary)] bg-opacity-10 flex items-center justify-center mb-4">
            <svg className="w-8 h-8 text-[var(--color-primary)]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
            </svg>
          </div>
          <h3 className="text-lg font-semibold mb-2">No favorite meals yet</h3>
          <p className="text-[var(--color-text-secondary)]">Start adding meals to your favorites to see them here.</p>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {favorites.map((favorite) => (
            <div key={favorite.id} className="card overflow-hidden hover:shadow-lg transition-shadow">
              <div className="aspect-video relative bg-[var(--color-bg-tertiary)]">
                {favorite.image ? (
                  <img
                    src={favorite.image}
                    alt={favorite.name}
                    className="w-full h-full object-cover"
                  />
                ) : (
                  <div className="flex items-center justify-center h-full">
                    <svg className="w-12 h-12 text-[var(--color-text-secondary)]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                  </div>
                )}
                <button
                  onClick={() => handleRemoveFavorite(favorite.mealId)}
                  disabled={removingId === favorite.mealId}
                  className="absolute top-2 right-2 w-8 h-8 rounded-full bg-red-500 bg-opacity-90 hover:bg-opacity-100 flex items-center justify-center transition-all disabled:opacity-50"
                  title="Remove from favorites"
                >
                  {removingId === favorite.mealId ? (
                    <div className="animate-spin rounded-full h-4 w-4 border-2 border-white border-t-transparent"></div>
                  ) : (
                    <svg className="w-5 h-5 text-white" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
                    </svg>
                  )}
                </button>
              </div>
              <div className="p-4">
                <div className="flex items-start justify-between mb-2">
                  <h3 className="font-semibold text-lg">{favorite.name}</h3>
                  <span className="text-[var(--color-primary)] font-bold ml-2">
                    ${Number(favorite.price).toFixed(2)}
                  </span>
                </div>
                {favorite.category && (
                  <div className="inline-block px-2 py-1 rounded-md bg-[var(--color-secondary)] bg-opacity-10 text-[var(--color-secondary)] text-xs font-medium mb-2">
                    {favorite.category.name}
                  </div>
                )}
                <p className="text-sm text-[var(--color-text-secondary)] line-clamp-2 mb-4">
                  {favorite.description || 'No description available'}
                </p>
                <div className="flex gap-2">
                  <button
                    onClick={() => openMealDetails(favorite)}
                    className="flex-1 btn btn-primary text-sm py-2"
                  >
                    View Details
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}

      {showModal && selectedMeal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center overflow-y-auto p-4">
          <div className="fixed inset-0 bg-black/50" onClick={closeModal}></div>
          <div className="relative bg-[var(--color-bg-secondary)] rounded-lg w-full max-w-3xl p-6 max-h-[90vh] overflow-y-auto">
            <div className="flex justify-between items-center border-b border-[var(--color-bg-tertiary)] pb-4 mb-4">
              <div>
                <h3 className="text-2xl font-bold">{selectedMeal.name}</h3>
                {selectedMeal.category && (
                  <span className="inline-block mt-2 px-3 py-1 rounded-md bg-[var(--color-secondary)] bg-opacity-10 text-[var(--color-secondary)] text-sm font-medium">
                    {selectedMeal.category.name}
                  </span>
                )}
              </div>
              <button
                onClick={closeModal}
                className="rounded-lg p-2 hover:bg-[var(--color-bg-tertiary)]"
              >
                <svg className="w-6 h-6" viewBox="0 0 20 20" fill="currentColor">
                  <path fillRule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clipRule="evenodd" />
                </svg>
              </button>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <div className="aspect-video relative rounded-lg overflow-hidden bg-[var(--color-bg-tertiary)] mb-4">
                  {selectedMeal.image ? (
                    <img src={selectedMeal.image} alt={selectedMeal.name} className="w-full h-full object-cover" />
                  ) : (
                    <div className="flex items-center justify-center h-full text-[var(--color-text-secondary)]">No image</div>
                  )}
                </div>
                <div className="space-y-3">
                  <div>
                    <h4 className="font-semibold mb-1">Price</h4>
                    <p className="text-2xl font-bold text-[var(--color-primary)]">
                      ${Number(selectedMeal.price).toFixed(2)}
                    </p>
                  </div>
                  <div>
                    <h4 className="font-semibold mb-1">Description</h4>
                    <p className="text-sm text-[var(--color-text-secondary)]">
                      {selectedMeal.description || 'No description available'}
                    </p>
                  </div>
                </div>
              </div>

              <div className="space-y-4">
                <div>
                  <h4 className="font-semibold mb-3 flex items-center gap-2">
                    <svg className="w-5 h-5 text-[var(--color-primary)]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
                    </svg>
                    Ingredients
                  </h4>
                  <div className="rounded-lg bg-[var(--color-bg-tertiary)] p-4 max-h-[200px] overflow-y-auto">
                    {selectedMeal.ingredients && selectedMeal.ingredients.length > 0 ? (
                      <ul className="space-y-2">
                        {selectedMeal.ingredients.map((ing, i) => (
                          <li key={i} className="text-sm flex items-start gap-2">
                            <span className="w-6 h-6 flex-shrink-0 flex items-center justify-center rounded bg-[var(--color-primary)] bg-opacity-10 text-[var(--color-primary)] font-medium">
                              {i + 1}
                            </span>
                            <div className="flex-1">
                              <span className="font-medium">{ing.name}</span>
                              {ing.amount && (
                                <span className="text-[var(--color-text-secondary)] ml-2">
                                  - {ing.amount} {ing.unit || ''}
                                </span>
                              )}
                            </div>
                          </li>
                        ))}
                      </ul>
                    ) : (
                      <p className="text-sm text-[var(--color-text-secondary)]">No ingredients listed</p>
                    )}
                  </div>
                </div>

                <div>
                  <h4 className="font-semibold mb-3 flex items-center gap-2">
                    <svg className="w-5 h-5 text-[var(--color-primary)]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01" />
                    </svg>
                    Preparation Steps
                  </h4>
                  <div className="rounded-lg bg-[var(--color-bg-tertiary)] p-4 max-h-[200px] overflow-y-auto">
                    {selectedMeal.preparationSteps && selectedMeal.preparationSteps.length > 0 ? (
                      <div className="space-y-3">
                        {selectedMeal.preparationSteps.map((step) => (
                          <div key={step.step} className="flex gap-3">
                            <div className="w-8 h-8 flex-shrink-0 rounded-full bg-[var(--color-primary)] flex items-center justify-center text-white font-bold text-sm">
                              {step.step}
                            </div>
                            <p className="text-sm flex-1 pt-1">{step.description}</p>
                          </div>
                        ))}
                      </div>
                    ) : (
                      <p className="text-sm text-[var(--color-text-secondary)]">No preparation steps listed</p>
                    )}
                  </div>
                </div>
              </div>
            </div>

            <div className="mt-6 pt-4 border-t border-[var(--color-bg-tertiary)] flex gap-3">
              <button
                onClick={() => handleRemoveFavorite(selectedMeal.mealId)}
                disabled={removingId === selectedMeal.mealId}
                className="flex-1 btn bg-red-500 hover:bg-red-600 text-white disabled:opacity-50"
              >
                {removingId === selectedMeal.mealId ? 'Removing...' : 'Remove from Favorites'}
              </button>
              <button
                onClick={closeModal}
                className="flex-1 btn btn-secondary"
              >
                Close
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
};

export default FavoritesView;
