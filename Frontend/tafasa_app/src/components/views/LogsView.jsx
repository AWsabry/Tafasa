import React from 'react';

const LOG_ENTRIES = [
  {
    id: 'log-1',
    actor: 'System',
    action: 'Database sync completed',
    target: 'Meals service',
    status: 'success',
    timestamp: '2 minutes ago',
    meta: 'Schema auto-alter applied'
  },
  {
    id: 'log-2',
    actor: 'Admin',
    action: 'User role updated',
    target: 'user_42 → admin',
    status: 'success',
    timestamp: '12 minutes ago',
    meta: 'Performed via dashboard'
  },
  {
    id: 'log-3',
    actor: 'System',
    action: 'Login attempt blocked',
    target: 'unknown device',
    status: 'denied',
    timestamp: '25 minutes ago',
    meta: 'Non-admin credentials'
  },
  {
    id: 'log-4',
    actor: 'Admin',
    action: 'Category deleted',
    target: 'Seasonal Specials',
    status: 'warning',
    timestamp: '1 hour ago',
    meta: 'Cleanup task'
  }
];

const statusStyles = {
  success: 'bg-green-100 text-green-700 border-green-200',
  warning: 'bg-yellow-100 text-yellow-800 border-yellow-200',
  denied: 'bg-red-100 text-red-700 border-red-200'
};

const LogsView = () => {
  return (
    <div className="space-y-6">
      <div className="flex flex-wrap items-baseline justify-between gap-3">
        <div>
          <p className="text-xs uppercase tracking-[0.3em] text-[var(--color-text-tertiary)]">Audit trail</p>
          <h2 className="text-2xl font-semibold text-[var(--color-text-primary)]">System logs</h2>
          <p className="text-sm text-[var(--color-text-secondary)]">Latest platform events and admin actions.</p>
        </div>
      </div>

      <div className="rounded-2xl border border-[var(--color-border)] bg-white shadow-[0px_18px_45px_rgba(111,55,116,0.07)]">
        <div className="flex items-center justify-between border-b border-[var(--color-border)] px-5 py-4">
          <div className="flex items-center gap-3">
            <div className="h-10 w-10 rounded-full bg-[var(--color-primary)]/10 text-[var(--color-primary)] flex items-center justify-center font-semibold">ℹ</div>
            <div>
              <p className="font-semibold text-[var(--color-text-primary)]">Recent activity</p>
              <p className="text-xs text-[var(--color-text-secondary)]">Auto-refresh every few minutes.</p>
            </div>
          </div>
        </div>
        <div className="divide-y divide-[var(--color-border)]">
          {LOG_ENTRIES.map((log) => {
            const badge = statusStyles[log.status] || statusStyles.success;
            return (
              <div key={log.id} className="flex flex-wrap items-start justify-between gap-4 px-5 py-4">
                <div className="space-y-1">
                  <p className="text-sm font-semibold text-[var(--color-text-primary)]">{log.action}</p>
                  <p className="text-sm text-[var(--color-text-secondary)]">{log.meta}</p>
                  <div className="flex flex-wrap items-center gap-2 text-xs text-[var(--color-text-secondary)]">
                    <span className="inline-flex items-center rounded-full bg-[var(--color-bg-tertiary)] px-3 py-1 font-semibold text-[var(--color-text-primary)]">
                      {log.actor}
                    </span>
                    <span className="inline-flex items-center rounded-full border border-[var(--color-border)] px-3 py-1">
                      Target: {log.target}
                    </span>
                  </div>
                </div>
                <div className="flex flex-col items-end gap-2">
                  <span className={`inline-flex items-center gap-2 rounded-full border px-3 py-1 text-xs font-semibold ${badge}`}>
                    {log.status === 'success' && '✓'}{log.status === 'warning' && '!'}{log.status === 'denied' && '✕'} {log.status}
                  </span>
                  <p className="text-xs uppercase tracking-wide text-[var(--color-text-tertiary)]">{log.timestamp}</p>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
};

export default LogsView;
