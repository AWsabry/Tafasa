import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import UsersView from './views/UsersView';
import CategoriesView from './views/CategoriesView';
import MealsView from './views/MealsView';
import FavoritesView from './views/FavoritesView';
import { api } from '../utils/api';

const Dashboard = () => {
  const [activeTab, setActiveTab] = useState('overview');
  const [showUserMenu, setShowUserMenu] = useState(false);
  const [users, setUsers] = useState([]);
  const [categories, setCategories] = useState([]);
  const [meals, setMeals] = useState([]);
  const [currentUser, setCurrentUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const { logout } = useAuth();
  const navigate = useNavigate();

  const handleLogout = async () => {
    try {
      await api.post('/auth/logout');
      logout();
      navigate('/login');
    } catch (error) {
      // Even if the server logout fails, we'll still clear local state
      console.error('Logout error:', error);
      logout();
      navigate('/login');
    }
  };

  useEffect(() => {
    let mounted = true;
    const fetchOverview = async () => {
      setLoading(true);
      try {
        const [uRes, cRes, mRes, meRes] = await Promise.all([
          api.get('/users'),
          api.get('/categories'),
          api.get('/meals'),
          api.get('/users/me')
        ]);

        if (!mounted) return;

        const uList = Array.isArray(uRes) ? uRes : (uRes?.users || []);
        const cList = Array.isArray(cRes) ? cRes : (cRes?.categories || []);
        const mList = Array.isArray(mRes) ? mRes : (mRes?.meals || []);

        setUsers(uList);
        setCategories(cList);
        setMeals(mList);

        // meRes may be { message, user } or just a user object
        const me = meRes?.user || meRes;
        setCurrentUser(me || null);
      } catch (err) {
        const msg = err?.message || '';
        if (msg === 'Please authenticate.' || msg.toLowerCase().includes('authenticate') || msg.includes('401')) {
          navigate('/login');
        }
        // otherwise ignore; child views will show errors if needed
      } finally {
        if (mounted) setLoading(false);
      }
    };

    fetchOverview();
    return () => { mounted = false; };
  }, []);

  const renderContent = () => {
    switch (activeTab) {
      case 'overview':
        return (
          <div className="space-y-6 w-full">
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 w-full">
              <div className="card flex items-start p-6 hover:bg-[var(--color-bg-tertiary)] w-full">
                <div className="flex-1">
                  <h3 className="text-[var(--color-text-secondary)] text-sm font-medium mb-2">Total Users</h3>
                  <div className="flex items-baseline gap-2">
                    <p className="text-2xl sm:text-3xl font-bold tracking-tight">
                      {users.length}
                    </p>
                  </div>
                </div>
                <div className="w-10 h-10 rounded-lg bg-[var(--color-primary)] bg-opacity-10 flex items-center justify-center">
                  <svg className="w-5 h-5 text-[var(--color-primary)]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
                  </svg>
                </div>
              </div>
              <div className="card flex items-start p-6 hover:bg-[var(--color-bg-tertiary)]">
                <div className="flex-1">
                  <h3 className="text-[var(--color-text-secondary)] text-sm font-medium mb-2">Total Categories</h3>
                  <div className="flex items-baseline gap-2">
                    <p className="text-2xl sm:text-3xl font-bold tracking-tight">
                      {categories.length}
                    </p>
                  </div>
                </div>
                <div className="w-10 h-10 rounded-lg bg-[var(--color-secondary)] bg-opacity-10 flex items-center justify-center">
                  <svg className="w-5 h-5 text-[var(--color-secondary)]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
                  </svg>
                </div>
              </div>
              <div className="card flex items-start p-6 hover:bg-[var(--color-bg-tertiary)]">
                <div className="flex-1">
                  <h3 className="text-[var(--color-text-secondary)] text-sm font-medium mb-2">Total Meals</h3>
                  <div className="flex items-baseline gap-2">
                    <p className="text-2xl sm:text-3xl font-bold tracking-tight">
                      {meals.length}
                    </p>
                  </div>
                </div>
                <div className="w-10 h-10 rounded-lg bg-[var(--color-accent-yellow)] bg-opacity-10 flex items-center justify-center">
                  <svg className="w-5 h-5 text-[var(--color-accent-yellow)]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                  </svg>
                </div>
              </div>
            </div>
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 w-full">
              <div className="card p-6 w-full">
                <h3 className="text-lg font-semibold mb-4">Recent Activity</h3>
                <div className="space-y-4">
                  {[1,2,3].map((_, i) => (
                    <div key={i} className="flex items-center gap-4 p-3 rounded-lg bg-[var(--color-bg-tertiary)] bg-opacity-50">
                      <div className="w-8 h-8 rounded-full bg-[var(--color-primary)] bg-opacity-10 flex items-center justify-center">
                        <svg className="w-4 h-4 text-[var(--color-primary)]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v16m8-8H4" />
                        </svg>
                      </div>
                      <div className="flex-1">
                        <p className="text-sm font-medium">New meal added</p>
                        <p className="text-xs text-[var(--color-text-secondary)]">2 minutes ago</p>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
              <div className="card p-6">
                <h3 className="text-lg font-semibold mb-4">Popular Categories</h3>
                <div className="space-y-4">
                  {categories.slice(0, 3).map((category, i) => (
                    <div key={category.id} className="flex items-center gap-4">
                      <div className="relative flex-1">
                        <div className="flex justify-between mb-1">
                          <span className="text-sm font-medium">{category.name}</span>
                          <span className="text-sm text-[var(--color-text-secondary)]">{Math.floor(Math.random() * 50 + 50)}%</span>
                        </div>
                        <div className="w-full h-2 bg-[var(--color-bg-tertiary)] rounded-full overflow-hidden">
                          <div 
                            className="h-full bg-[var(--color-primary)]" 
                            style={{ width: `${Math.floor(Math.random() * 50 + 50)}%` }}
                          ></div>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          </div>
        );
      case 'users':
        return <UsersView />;
      case 'categories':
        return <CategoriesView />;
      case 'meals':
        return <MealsView />;
      case 'favorites':
        return <FavoritesView />;
      default:
        return null;
    }
  };

  return (
    <div className="relative flex min-h-screen w-full flex-col overflow-x-hidden" style={{ fontFamily: '"Work Sans", "Noto Sans", sans-serif' }}>
      <div className="layout-container flex h-full w-full flex-col">
        <header className="flex items-center justify-between whitespace-nowrap border-b border-solid border-[var(--color-bg-tertiary)] px-4 sm:px-6 py-4 bg-[var(--color-bg-secondary)]">
          <div className="flex items-center gap-4">
            <div className="w-8 h-8 p-1.5 bg-[var(--color-primary)] rounded-lg">
              <svg viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M24 4C25.7818 14.2173 33.7827 22.2182 44 24C33.7827 25.7818 25.7818 33.7827 24 44C22.2182 33.7827 14.2173 25.7818 4 24C14.2173 22.2182 22.2182 14.2173 24 4Z" fill="currentColor"></path>
              </svg>
            </div>
            <h2 className="text-lg font-bold leading-tight tracking-tight">Tafasa Admin</h2>
          </div>
          <div className="flex items-center gap-4 sm:gap-8">
            <nav className="hidden sm:flex items-center gap-6 md:gap-8">
              <button
                onClick={() => setActiveTab('overview')}
                className={`text-sm font-medium leading-normal transition-colors hover:text-[var(--color-primary-light)] ${
                  activeTab === 'overview' ? 'text-[var(--color-primary)]' : 'text-[var(--color-text-secondary)]'
                }`}
              >
                Overview
              </button>
              <button
                onClick={() => setActiveTab('users')}
                className={`text-sm font-medium leading-normal transition-colors hover:text-[var(--color-primary-light)] ${
                  activeTab === 'users' ? 'text-[var(--color-primary)]' : 'text-[var(--color-text-secondary)]'
                }`}
              >
                Users
              </button>
              <button
                onClick={() => setActiveTab('categories')}
                className={`text-sm font-medium leading-normal transition-colors hover:text-[var(--color-primary-light)] ${
                  activeTab === 'categories' ? 'text-[var(--color-primary)]' : 'text-[var(--color-text-secondary)]'
                }`}
              >
                Categories
              </button>
              <button
                onClick={() => setActiveTab('meals')}
                className={`text-sm font-medium leading-normal transition-colors hover:text-[var(--color-primary-light)] ${
                  activeTab === 'meals' ? 'text-[var(--color-primary)]' : 'text-[var(--color-text-secondary)]'
                }`}
              >
                Meals
              </button>
              <button
                onClick={() => setActiveTab('favorites')}
                className={`text-sm font-medium leading-normal transition-colors hover:text-[var(--color-primary-light)] ${
                  activeTab === 'favorites' ? 'text-[var(--color-primary)]' : 'text-[var(--color-text-secondary)]'
                }`}
              >
                Favorites
              </button>
            </nav>
            {/* Mobile menu button */}
            <button className="sm:hidden p-2 rounded-lg hover:bg-[var(--color-bg-tertiary)]">
              <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
              </svg>
            </button>
            <div className="relative">
              <button
                onClick={() => setShowUserMenu(!showUserMenu)}
                className="bg-center bg-no-repeat aspect-square bg-cover rounded-full w-10 h-10 ring-2 ring-[var(--color-primary)] ring-offset-2 ring-offset-[var(--color-bg-secondary)]"
                style={{ backgroundImage: `url("https://ui-avatars.com/api/?name=${encodeURIComponent(currentUser?.username || currentUser?.name || 'U')}&background=random")` }}
              />
              {showUserMenu && (
                <div className="absolute right-0 mt-2 w-48 rounded-md shadow-lg bg-[var(--color-bg-secondary)] ring-1 ring-black ring-opacity-5">
                  <div className="py-1">
                    {currentUser && (
                      <div className="px-4 py-2 text-sm text-[var(--color-text-secondary)] border-b border-[var(--color-bg-tertiary)]">
                        <div className="font-medium text-[var(--color-text-primary)]">{currentUser.name || currentUser.username}</div>
                        <div className="text-xs">{currentUser.email}</div>
                      </div>
                    )}
                    <button
                      onClick={handleLogout}
                      className="w-full text-left px-4 py-2 text-sm hover:bg-[var(--color-bg-tertiary)] flex items-center gap-2"
                    >
                      <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                      </svg>
                      Logout
                    </button>
                  </div>
                </div>
              )}
            </div>
          </div>
        </header>
        <main className="flex grow flex-col gap-8 p-4 w-full">
          <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 w-full">
            <div>
              <h1 className="text-2xl sm:text-3xl font-bold leading-tight tracking-tight mb-1">
                {activeTab.charAt(0).toUpperCase() + activeTab.slice(1)}
              </h1>
              <p className="text-[var(--color-text-secondary)] text-sm sm:text-base">
                Manage your {activeTab === 'overview' ? 'dashboard' : activeTab} and view statistics
              </p>
            </div>
    
          </div>
          
          {loading ? (
            <div className="flex items-center justify-center py-12">
              <div className="relative">
                <div className="animate-spin rounded-full h-12 w-12 border-4 border-[var(--color-primary)] border-t-transparent"></div>
                <div className="absolute inset-0 flex items-center justify-center">
                  <div className="h-6 w-6 bg-[var(--color-bg-primary)] rounded-full"></div>
                </div>
              </div>
            </div>
          ) : (
            <div className="fade-in">
              {renderContent()}
            </div>
          )}
        </main>
      </div>
    </div>
  );
};

export default Dashboard;
