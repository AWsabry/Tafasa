import React from 'react';

const CategoriesTable = ({ categories, onDelete }) => {
  return (
    <div className="card overflow-hidden p-0 w-full">
      <div className="overflow-x-auto w-full">
        <table className="w-full divide-y divide-[var(--color-border)]">
          <thead className="bg-[var(--color-bg-tertiary)]">
            <tr>
              <th className="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-[var(--color-text-secondary)]">ID</th>
              <th className="py-3.5 px-3 text-left text-sm font-semibold text-[var(--color-text-secondary)]">Name</th>
              <th className="py-3.5 px-3 text-left text-sm font-semibold text-[var(--color-text-secondary)]">Description</th>
              <th className="py-3.5 px-3 text-left text-sm font-semibold text-[var(--color-text-secondary)]">Meals Count</th>
              <th className="py-3.5 pl-3 pr-4 text-right text-sm font-semibold text-[var(--color-text-secondary)]">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-[var(--color-border)]">
            {categories?.map((category) => (
              <tr key={category.id} className="hover:bg-[var(--color-bg-tertiary)] transition-colors">
                <td className="whitespace-nowrap py-4 pl-4 pr-3 text-sm">
                  <span className="px-2.5 py-0.5 rounded-full font-medium">
                    #{category.id}
                  </span>
                </td>
                <td className="whitespace-nowrap py-4 px-3 text-sm font-medium text-[var(--color-text-primary)]">{category.name}</td>
                <td className="py-4 px-3 text-sm text-[var(--color-text-secondary)]">
                  {category.description || '-'}
                </td>
                <td className="whitespace-nowrap py-4 px-3 text-sm text-[var(--color-text-secondary)]">
                  {category.meals?.length || 0}
                </td>
                <td className="whitespace-nowrap py-4 pl-3 pr-4 text-right text-sm">
                  <button className="btn btn-secondary btn-compact mr-2">Edit</button>
                  <button 
                    onClick={() => onDelete && onDelete(category.id)} 
                    className="btn btn-danger-ghost btn-compact"
                  >
                    Delete
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default CategoriesTable;