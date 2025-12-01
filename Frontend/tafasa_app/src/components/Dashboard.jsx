import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import UsersView from './views/UsersView';
import CategoriesView from './views/CategoriesView';
import MealsView from './views/MealsView';
import FavoritesView from './views/FavoritesView';
import LogsView from './views/LogsView';
import { api } from '../utils/api';
import TafasaLogo from '../assets/02.png';

const NAV_ITEMS = [
  {
    id: 'overview',
    label: 'Overview',
    hint: 'Pulse & KPIs',
    icon: (props) => (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={1.6} strokeLinecap="round" strokeLinejoin="round" {...props}>
        <path d="M4 16l4-5 4 3 6-7 2 2" />
        <path d="M4 20h16" />
      </svg>
    )
  },
  {
    id: 'logs',
    label: 'Logs',
    hint: 'Audit trail',
    icon: (props) => (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={1.6} strokeLinecap="round" strokeLinejoin="round" {...props}>
        <path d="M6 3h9l5 5v13a0 0 0 0 1 0 0H6a0 0 0 0 1 0 0V3z" />
        <path d="M15 3v5a2 2 0 0 0 2 2h5" />
        <path d="M9 14h6" />
        <path d="M9 18h3" />
      </svg>
    )
  },
  {
    id: 'users',
    label: 'Users',
    hint: 'Team & members',
    icon: (props) => (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={1.6} strokeLinecap="round" strokeLinejoin="round" {...props}>
        <path d="M17 20v-2.4a4.1 4.1 0 00-4.1-4.1h-1.8A4.1 4.1 0 007 17.6V20" />
        <circle cx="12" cy="9" r="3.5" />
      </svg>
    )
  },
  {
    id: 'categories',
    label: 'Categories',
    hint: 'Structure & tags',
    icon: (props) => (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={1.6} strokeLinecap="round" strokeLinejoin="round" {...props}>
        <rect x="4" y="4" width="6.5" height="6.5" rx="1.4" />
        <rect x="13.5" y="4" width="6.5" height="6.5" rx="1.4" />
        <rect x="4" y="13.5" width="6.5" height="6.5" rx="1.4" />
        <rect x="13.5" y="13.5" width="6.5" height="6.5" rx="1.4" />
      </svg>
    )
  },
  {
    id: 'meals',
    label: 'Meals',
    hint: 'Catalog & recipes',
    icon: (props) => (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={1.6} strokeLinecap="round" strokeLinejoin="round" {...props}>
        <path d="M4 17h16" />
        <path d="M12 4.8a6.2 6.2 0 00-6.2 6.2V12h12.4v-1a6.2 6.2 0 00-6.2-6.2z" />
        <path d="M12 3v2" />
      </svg>
    )
  },
  {
    id: 'favorites',
    label: 'Favorites',
    hint: 'Saved picks',
    icon: (props) => (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={1.6} strokeLinecap="round" strokeLinejoin="round" {...props}>
        <path d="M12 20s-6-3.3-6-8.5A4.5 4.5 0 0112 7a4.5 4.5 0 016 4.5c0 5.2-6 8.5-6 8.5z" />
      </svg>
    )
  }
];

const QUICK_ACTIONS = [
  {
    id: 'quick-meal',
    label: 'Create meal',
    description: 'Publish new recipes',
    target: 'meals',
    icon: (props) => (
      <svg viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth={1.8} strokeLinecap="round" strokeLinejoin="round" {...props}>
        <path d="M10 4v12" />
        <path d="M4 10h12" />
      </svg>
    )
  },
  {
    id: 'quick-category',
    label: 'Add category',
    description: 'Organise catalog',
    target: 'categories',
    icon: (props) => (
      <svg viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth={1.8} strokeLinecap="round" strokeLinejoin="round" {...props}>
        <rect x="4" y="4" width="5" height="5" rx="1" />
        <rect x="11" y="4" width="5" height="5" rx="1" />
        <rect x="4" y="11" width="5" height="5" rx="1" />
        <rect x="11" y="11" width="5" height="5" rx="1" />
      </svg>
    )
  }
];

const Dashboard = () => {
  const [activeTab, setActiveTab] = useState('overview');
  const [showUserMenu, setShowUserMenu] = useState(false);
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);
  const [users, setUsers] = useState([]);
  const [categories, setCategories] = useState([]);
  const [meals, setMeals] = useState([]);
  const [favorites, setFavorites] = useState([]);
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
      console.error('Logout error:', error);
      logout();
      navigate('/login');
    }
  };

  const handleTabChange = (tab) => {
    setActiveTab(tab);
    setIsSidebarOpen(false);
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

      const me = meRes?.user || meRes;
      setCurrentUser(me || null);
      if (me && me.role !== 'admin') {
        logout();
        navigate('/login');
        return;
      }
    } catch (err) {
      const msg = err?.message || '';
      if (
        msg === 'Please authenticate.' ||
        msg.toLowerCase().includes('authenticate') ||
        msg.includes('401') ||
        msg.toLowerCase().includes('admin access') ||
        msg.includes('403')
      ) {
        navigate('/login');
      }
    } finally {
      if (mounted) setLoading(false);
    }
    };

    fetchOverview();
    return () => {
      mounted = false;
    };
  }, [navigate]);

  const formatNumber = (value) => {
    if (!Number.isFinite(value)) return '0';
    return new Intl.NumberFormat().format(value);
  };

  const renderOverview = () => {
    const topCategories = categories.slice(0, 4);
    const overviewStats = [
      {
        id: 'stat-users',
        label: 'Verified users',
        value: formatNumber(users.length),
        accent: 'bg-[#f6edf9]'
      },
      {
        id: 'stat-categories',
        label: 'Live categories',
        value: formatNumber(categories.length),
        accent: 'bg-[#fff3e4]'
      },
      {
        id: 'stat-meals',
        label: 'Meals in catalog',
        value: formatNumber(meals.length),
        accent: 'bg-[#e9f4ff]'
      },
      {
        id: 'stat-favorites',
        label: 'Top favorites',
        value: formatNumber(0),
        accent: 'bg-[#fdf1f5]'
      }
    ];

    const activityTimeline = [
      {
        id: 'activity-sync',
        title: 'Catalog synchronized',
        detail: `${formatNumber(meals.length)} meals accessible`,
        time: 'just now',
        accent: 'bg-white/20 text-white',
        icon: (props) => (
          <svg viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth={1.8} strokeLinecap="round" strokeLinejoin="round" {...props}>
            <path d="M4 10a6 6 0 0111.8-1.5" />
            <path d="M16 10a6 6 0 01-11.8 1.5" />
            <path d="M10 4v2" />
            <path d="M10 14v2" />
          </svg>
        )
      },
      {
        id: 'activity-meal',
        title: meals[0]?.name ? `${meals[0].name} published` : 'Menu ready for updates',
        detail: meals[0]?.description ? meals[0].description : 'Add a new meal to keep the menu fresh.',
        time: '8 minutes ago',
        accent: 'bg-[var(--color-primary)]/10 text-[var(--color-primary)]',
        icon: (props) => (
          <svg viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth={1.8} strokeLinecap="round" strokeLinejoin="round" {...props}>
            <path d="M3 12h14" />
            <path d="M10 4a5 5 0 00-5 5v3h10V9a5 5 0 00-5-5z" />
            <path d="M10 2v2" />
          </svg>
        )
      },
      {
        id: 'activity-user',
        title: users[0]?.username ? `${users[0].username} joined Tafasa` : 'Invite your team',
        detail: users[0]?.email || 'Share access so your team can collaborate securely.',
        time: '1 hour ago',
        accent: 'bg-[#fff1e6] text-[#fe8131]',
        icon: (props) => (
          <svg viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth={1.8} strokeLinecap="round" strokeLinejoin="round" {...props}>
            <circle cx="9" cy="7" r="3" />
            <path d="M14 15v-1.2A3.8 3.8 0 0010.2 10H7.8A3.8 3.8 0 004 13.8V15" />
            <path d="M15 7h4" />
          </svg>
        )
      }
    ];

    const healthMetrics = [
      { id: 'health-data', label: 'Data freshness', value: '99%', context: 'Updated 3 mins ago' },
      { id: 'health-quality', label: 'Category coverage', value: `${topCategories.length ? 92 : 65}%`, context: topCategories.length ? 'Balanced menus' : 'Add more categories' },
      { id: 'health-engagement', label: 'Team responsiveness', value: '1.2h', context: 'Avg. resolution time' }
    ];

    return (
      <div className="space-y-8">
        <section className="grid gap-6 xl:grid-cols-[1.7fr,1fr]">
          <div className="card relative overflow-hidden bg-gradient-to-r from-[var(--color-primary)] via-[#8c5593] to-[#8c5593] text-white">
            <div className="absolute inset-0 opacity-[0.08] bg-[radial-gradient(circle_at_top,#fff,transparent_55%)]" />
            <div className="relative flex flex-col gap-6">
              <div>
                <p className="text-xs uppercase tracking-[0.4em] text-white/70">Executive Dashboard</p>
                <h2 className="mt-2 text-3xl sm:text-4xl text-white/85 font-semibold">Hi {currentUser?.name || currentUser?.username || 'Admin'},</h2>
                <p className="mt-2 text-base text-white/85">Keep an eye on Tafasa&apos;s catalog health, user engagement, and curation velocity in one glance.</p>
              </div>
              <div className="flex flex-wrap gap-3">
                <button
                  type="button"
                  onClick={() => handleTabChange('meals')}
                  className="btn btn-tonal"
                >
                  Add meal
                </button>
                <button
                  type="button"
                  onClick={() => handleTabChange('categories')}
                  className="inline-flex items-center justify-center rounded-full border border-white/40 px-5 py-2.5 text-sm font-semibold text-white transition hover:border-white hover:bg-white/10"
                >
                  Plan categories
                </button>
              </div>
              <div className="grid gap-4 sm:grid-cols-2">
                <div className="rounded-2xl bg-white/15 p-4">
                  <p className="text-xs uppercase tracking-wide text-white/70">Active meals</p>
                  <p className="text-2xl font-semibold">{formatNumber(meals.length)}</p>
                  <p className="text-sm text-white/80">ready for distribution</p>
                </div>
                <div className="rounded-2xl bg-white/15 p-4">
                  <p className="text-xs uppercase tracking-wide text-white/70">Categories curated</p>
                  <p className="text-2xl font-semibold">{formatNumber(categories.length)}</p>
                  <p className="text-sm text-white/80">ensuring balanced menus</p>
                </div>
              </div>
            </div>
          </div>
          <div className="card flex flex-col gap-5">
            <div>
              <p className="text-xs font-semibold uppercase tracking-wide text-[var(--color-text-tertiary)]">Quick actions</p>
              <h3 className="mt-1 text-xl font-semibold text-[var(--color-text-primary)]">Stay on top of the workflow</h3>
            </div>
            <div className="flex flex-wrap gap-3">
              {QUICK_ACTIONS.map((action) => {
                const Icon = action.icon;
                return (
                  <button
                    type="button"
                    key={action.id}
                    onClick={() => handleTabChange(action.target)}
                    className="flex min-w-[150px] flex-1 items-start justify-between rounded-2xl border border-[var(--color-border)] bg-white/80 px-4 py-3 text-left transition hover:-translate-y-0.5 hover:border-[var(--color-primary)] hover:shadow-lg"
                  >
                    <div>
                      <p className="text-sm font-semibold">{action.label}</p>
                      <p className="text-xs text-[var(--color-text-secondary)]">{action.description}</p>
                    </div>
                    <span className="inline-flex h-9 w-9 items-center justify-center rounded-full bg-[var(--color-primary)]/12 text-[var(--color-primary)]">
                      <Icon className="h-4 w-4" />
                    </span>
                  </button>
                );
              })}
            </div>
            <div className="rounded-2xl border border-dashed border-[var(--color-border)] p-4">
              <p className="text-sm font-semibold text-[var(--color-text-primary)]">Need a hand?</p>
              <p className="text-xs text-[var(--color-text-secondary)]">We can help you generate custom reports or bulk imports.</p>
              <button type="button" className="mt-3 text-sm font-semibold text-[var(--color-primary)]">Contact support →</button>
            </div>
          </div>
        </section>

        <section className="grid gap-6 md:grid-cols-2 xl:grid-cols-4">
          {overviewStats.map((stat) => (
            <div key={stat.id} className="card border border-[var(--color-border)] bg-white/90 shadow-[0px_18px_45px_rgba(111,55,116,0.07)] transition hover:-translate-y-1">
              <div className={`inline-flex items-center rounded-full px-3 py-1 text-xs font-semibold text-[var(--color-text-secondary)] ${stat.accent}`}>
                {stat.label}
              </div>
              <p className="mt-4 text-3xl font-semibold">{stat.value}</p>
       
            </div>
          ))}
        </section>

        <section className="grid gap-6 lg:grid-cols-3">
          <div className="card lg:col-span-2">
            <div className="mb-5 flex items-center justify-between">
              <div>
                <p className="text-xs uppercase tracking-[0.3em] text-[var(--color-text-tertiary)]">Activity</p>
                <h3 className="mt-1 text-xl font-semibold text-[var(--color-text-primary)]">Recent progress</h3>
              </div>
              <button type="button" onClick={() => handleTabChange('logs')} className="text-sm font-semibold text-[var(--color-primary)]">View logs</button>
            </div>
            <div className="space-y-4">
              {activityTimeline.map((item) => {
                const Icon = item.icon;
                return (
                  <div key={item.id} className="flex items-start gap-4 rounded-2xl border border-[var(--color-border)] bg-white p-4">
                    <div className={`flex h-12 w-12 items-center justify-center rounded-2xl ${item.accent}`}>
                      <Icon className="h-5 w-5" />
                    </div>
                    <div className="flex-1">
                      <p className="font-semibold text-[var(--color-text-primary)]">{item.title}</p>
                      <p className="text-sm text-[var(--color-text-secondary)]">{item.detail}</p>
                    </div>
                    <span className="text-xs font-semibold uppercase tracking-wide text-[var(--color-text-tertiary)]">{item.time}</span>
                  </div>
                );
              })}
            </div>
          </div>

            <div className="space-y-6">
              <div className="card">
                <div className="mb-4">
                  <p className="text-xs uppercase tracking-[0.3em] text-[var(--color-text-tertiary)]">Categories</p>
                  <h3 className="text-xl font-semibold text-[var(--color-text-primary)]">Coverage status</h3>
                </div>
                {topCategories.length ? (
                  <div className="space-y-4">
                    {topCategories.map((category, index) => {
                      const value = Math.min(96, 70 + index * 6);
                      return (
                        <div key={category.id || category.name} className="space-y-2">
                          <div className="flex items-center justify-between text-sm font-semibold">
                            <span>{category.name}</span>
                            <span>{value}%</span>
                          </div>
                          <div className="h-2 w-full rounded-full bg-[var(--color-bg-tertiary)]">
                            <div className="h-2 rounded-full bg-[var(--color-primary)]" style={{ width: `${value}%` }} />
                          </div>
                        </div>
                      );
                    })}
                  </div>
                ) : (
                  <p className="text-sm text-[var(--color-text-secondary)]">No categories yet. Add your first taxonomy to unlock tailored insights.</p>
                )}
              </div>
          </div>
        </section>
      </div>
    );
  };

  const renderContent = () => {
    switch (activeTab) {
      case 'overview':
        return renderOverview();
      case 'users':
        return <UsersView />;
      case 'categories':
        return <CategoriesView />;
      case 'meals':
        return <MealsView />;
      case 'favorites':
        return <FavoritesView />;
      case 'logs':
        return <LogsView />;
      default:
        return null;
    }
  };

  const activeNav = NAV_ITEMS.find((item) => item.id === activeTab) || NAV_ITEMS[0];

  return (
    <div
      className="relative flex min-h-screen w-full overflow-hidden bg-[var(--color-bg-primary)] text-[var(--color-text-primary)]"
      style={{ fontFamily: '"Work Sans", "Noto Sans", sans-serif' }}
    >
      <div
        className={`fixed inset-0 z-20 bg-black/30 backdrop-blur-sm transition-opacity lg:hidden ${isSidebarOpen ? 'opacity-100' : 'pointer-events-none opacity-0'}`}
        onClick={() => setIsSidebarOpen(false)}
      />

      <aside
        className={`fixed inset-y-0 left-0 z-30 w-72 transform bg-white px-6 py-6 shadow-2xl transition-transform duration-300 lg:static lg:translate-x-0 lg:border-r lg:border-[var(--color-border)] lg:shadow-none ${
          isSidebarOpen ? 'translate-x-0' : '-translate-x-full'
        }`}
      >
        <div className="flex h-full flex-col gap-6">
          <div className="flex items-center gap-3">
            <img
              src={TafasaLogo}
              alt="Tafasa"
              className="h-16 w-16 rounded-2xl border border-[var(--color-border)] object-cover shadow-sm"
            />
            <div>
              <p className="text-xs uppercase tracking-[0.3em] text-[var(--color-text-tertiary)]">Tafasa</p>
              <p className="text-lg font-semibold text-[var(--color-text-primary)]">Operations</p>
            </div>
          </div>

          <nav className="flex flex-col gap-2 overflow-y-auto pb-10">
            {NAV_ITEMS.map((item) => {
              const Icon = item.icon;
              const isActive = activeTab === item.id;
              return (
                <button
                  type="button"
                  key={item.id}
                  onClick={() => handleTabChange(item.id)}
                  className={`flex w-full items-center gap-3 rounded-2xl border px-3 py-3 text-left transition ${
                    isActive
                      ? 'border-transparent bg-[var(--color-primary)] text-white shadow-[0px_25px_55px_rgba(111,55,116,0.2)]'
                      : 'border-[var(--color-border)] bg-white text-[var(--color-text-secondary)] hover:border-[var(--color-primary)] hover:text-[var(--color-primary)]'
                  }`}
                >
                  <span className="inline-flex h-9 w-9 items-center justify-center rounded-2xl bg-white/10">
                    <Icon className={`h-5 w-5 ${isActive ? 'text-white' : 'text-[var(--color-text-secondary)]'}`} />
                  </span>
                  <div>
                    <p className="text-sm font-semibold">{item.label}</p>
                    <p className={`text-xs ${isActive ? 'text-white/80' : 'text-[var(--color-text-tertiary)]'}`}>{item.hint}</p>
                  </div>
                </button>
              );
            })}
          </nav>

          <div className="mt-auto rounded-2xl border border-dashed border-[var(--color-border)] bg-[var(--color-bg-tertiary)]/60 p-4">
            <p className="text-sm font-semibold text-[var(--color-text-primary)]">System status</p>
            <p className="text-xs text-[var(--color-text-secondary)]">Everything looks good. Monitor real-time metrics here.</p>
            <button type="button" onClick={handleLogout} className="mt-3 inline-flex items-center rounded-full bg-white px-4 py-2 text-xs font-semibold text-[var(--color-primary)]">
              Logout
            </button>
          </div>
        </div>
      </aside>

      <div className="flex min-h-screen flex-1 flex-col lg:ml-0">
        <header className="sticky top-0 z-10 flex flex-wrap items-center justify-between gap-4 border-b border-[var(--color-border)] bg-[var(--color-bg-primary)]/90 px-4 py-4 backdrop-blur-md sm:px-6 lg:px-10">
          <div className="flex items-center gap-3">
            <button
              type="button"
              className="inline-flex h-11 w-11 items-center justify-center rounded-2xl border border-[var(--color-border)] bg-white text-[var(--color-text-primary)] lg:hidden"
              onClick={() => setIsSidebarOpen((prev) => !prev)}
            >
              <svg className="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2}>
                <path d="M4 7h16M4 12h16M4 17h16" strokeLinecap="round" strokeLinejoin="round" />
              </svg>
            </button>
            <img
              src={TafasaLogo}
              alt="Tafasa logo"
              className="h-14 w-14 rounded-2xl border border-[var(--color-border)] bg-white object-cover shadow-sm"
            />
            <div>
              <p className="text-xs uppercase tracking-[0.4em] text-[var(--color-text-tertiary)]">Current view</p>
              <h2 className="text-xl font-semibold">{activeNav.label}</h2>
            </div>
          </div>
          <div className="flex flex-1 items-center justify-end gap-3">
            <div className="relative hidden w-full max-w-sm sm:block">
              <input
                type="text"
                placeholder="Search users, meals, categories..."
                className="w-full rounded-full border border-[var(--color-border)] bg-white/80 px-4 py-2.5 pr-10 text-sm text-[var(--color-text-primary)] placeholder:text-[var(--color-text-tertiary)] focus:border-[var(--color-primary)] focus:outline-none"
              />
              <svg
                className="absolute right-4 top-1/2 h-4 w-4 -translate-y-1/2 text-[var(--color-text-tertiary)]"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth={2}
              >
                <circle cx="11" cy="11" r="7" />
                <path d="M20 20l-3-3" strokeLinecap="round" strokeLinejoin="round" />
              </svg>
            </div>
            <button
              type="button"
              onClick={() => handleTabChange('users')}
              className="hidden rounded-full border border-[var(--color-border)] px-4 py-2 text-sm font-semibold text-[var(--color-text-secondary)] transition hover:border-[var(--color-primary)] hover:text-[var(--color-primary)] sm:inline-flex"
            >
              Users
            </button>
            <div className="hidden sm:inline-flex">
              <button
                type="button"
                onClick={() => handleTabChange('meals')}
                className="btn btn-primary"
              >
                New entry
              </button>
            </div>
            <div className="relative">
              <button
                type="button"
                onClick={() => setShowUserMenu((prev) => !prev)}
                className="flex items-center gap-3 rounded-full border border-[var(--color-border)] bg-white px-2 py-1 pl-1 pr-3"
              >
                <span
                  className="h-10 w-10 rounded-full bg-cover bg-center ring-2 ring-[var(--color-primary)]/40"
                  style={{ backgroundImage: `url("https://ui-avatars.com/api/?name=${encodeURIComponent(currentUser?.username || currentUser?.name || 'U')}&background=6f3774&color=fff")` }}
                />
                <span className="hidden text-sm font-semibold text-[var(--color-text-primary)] sm:block">
                  {currentUser?.name || currentUser?.username || 'User'}
                </span>
                <svg className="h-4 w-4 text-[var(--color-text-tertiary)]" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={1.6}>
                  <path d="M6 9l6 6 6-6" strokeLinecap="round" strokeLinejoin="round" />
                </svg>
              </button>
              {showUserMenu && (
                <div className="absolute right-0 mt-3 w-60 rounded-2xl border border-[var(--color-border)] bg-white p-4 shadow-2xl">
                  {currentUser && (
                    <div className="mb-3 border-b border-[var(--color-border)] pb-3">
                      <p className="text-sm font-semibold text-[var(--color-text-primary)]">{currentUser.name || currentUser.username}</p>
                      <p className="text-xs text-[var(--color-text-secondary)]">{currentUser.email}</p>
                    </div>
                  )}
                  <button
                    type="button"
                    onClick={handleLogout}
                    className="flex w-full items-center justify-between rounded-xl bg-[var(--color-primary)]/10 px-4 py-2 text-sm font-semibold text-[var(--color-primary)]"
                  >
                    Logout
                    <svg className="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={1.6}>
                      <path d="M14 8l4 4-4 4" strokeLinecap="round" strokeLinejoin="round" />
                      <path d="M4 12h14" strokeLinecap="round" strokeLinejoin="round" />
                    </svg>
                  </button>
                </div>
              )}
            </div>
          </div>
        </header>

        <main className="flex flex-1 flex-col gap-8 px-4 py-6 sm:px-6 lg:px-10">
          <section className="flex flex-wrap items-center justify-between gap-4">
            <div>
              <p className="text-xs uppercase tracking-[0.4em] text-[var(--color-text-tertiary)]">Control center</p>
              <h1 className="mt-2 text-3xl font-semibold text-[var(--color-text-primary)]">{activeNav.label}</h1>
              <p className="text-sm text-[var(--color-text-secondary)]">{activeNav.hint}</p>
            </div>
            <div className="flex flex-wrap gap-3">
              <button type="button" onClick={() => handleTabChange('overview')} className="btn btn-primary">
                Refresh insights
              </button>
            </div>
          </section>

          {loading ? (
            <div className="flex items-center justify-center py-16">
              <div className="h-14 w-14 animate-spin rounded-full border-4 border-[var(--color-primary)] border-t-transparent" />
            </div>
          ) : (
            <div className="fade-in">{renderContent()}</div>
          )}
        </main>
      </div>
    </div>
  );
};

export default Dashboard;
