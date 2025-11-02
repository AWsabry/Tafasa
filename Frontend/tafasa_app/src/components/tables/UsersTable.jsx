import React from 'react';

const UsersTable = ({ users }) => {
  return (
    <div className="card overflow-hidden p-0 w-full">
      <div className="overflow-x-auto w-full">
        <table className="w-full divide-y divide-[var(--color-bg-tertiary)]">
          <thead className="bg-[var(--color-bg-tertiary)]">
            <tr>
              <th className="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-[var(--color-text-secondary)]">ID</th>
              <th className="py-3.5 px-3 text-left text-sm font-semibold text-[var(--color-text-secondary)]">Username</th>
              <th className="py-3.5 px-3 text-left text-sm font-semibold text-[var(--color-text-secondary)]">Email</th>
              <th className="py-3.5 px-3 text-left text-sm font-semibold text-[var(--color-text-secondary)]">Phone</th>
              <th className="py-3.5 px-3 text-left text-sm font-semibold text-[var(--color-text-secondary)]">Created At</th>
              <th className="py-3.5 pl-3 pr-4 text-right text-sm font-semibold text-[var(--color-text-secondary)]">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-[var(--color-bg-tertiary)]">
            {users?.map((user) => (
              <tr key={user.id} className="hover:bg-[var(--color-bg-tertiary)] transition-colors">
                <td className="whitespace-nowrap py-4 pl-4 pr-3 text-sm">
                  <span className="bg-[var(--color-primary)] bg-opacity-10 text-[var(--color-primary)] px-2.5 py-0.5 rounded-full font-medium">
                    #{user.id}
                  </span>
                </td>
                <td className="whitespace-nowrap py-4 px-3 text-sm font-medium">{user.username}</td>
                <td className="whitespace-nowrap py-4 px-3 text-sm text-[var(--color-text-secondary)]">{user.email}</td>
                <td className="whitespace-nowrap py-4 px-3 text-sm text-[var(--color-text-secondary)]">{user.phoneNumber || '-'}</td>
                <td className="whitespace-nowrap py-4 px-3 text-sm text-[var(--color-text-secondary)]">
                  {new Date(user.createdAt).toLocaleDateString()}
                </td>
                <td className="whitespace-nowrap py-4 pl-3 pr-4 text-right text-sm">
                  <button className="btn btn-secondary py-1 px-3">Edit</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <div className="border-t border-[var(--color-bg-tertiary)] px-4 py-3 sm:px-6 flex items-center justify-between">
        <div className="flex items-center gap-2">
          <span className="text-sm text-[var(--color-text-secondary)]">Showing</span>
          <select className="input py-1 px-2 text-sm">
            <option>10</option>
            <option>25</option>
            <option>50</option>
          </select>
          <span className="text-sm text-[var(--color-text-secondary)]">entries</span>
        </div>
        <div className="flex items-center gap-2">
          <button disabled className="btn py-1 px-3 bg-[var(--color-bg-tertiary)] text-[var(--color-text-secondary)]">Previous</button>
          <button className="btn btn-primary py-1 px-3">Next</button>
        </div>
      </div>
    </div>
  );
};

export default UsersTable;