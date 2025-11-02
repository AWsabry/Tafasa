import React from 'react';

const CategoriesTable = ({ categories }) => {
  return (
    <div className="overflow-x-auto rounded-xl bg-white/5 p-6">
      <table className="min-w-full">
        <thead>
          <tr className="border-b border-white/10">
            <th className="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-white/60">ID</th>
            <th className="py-3.5 px-3 text-left text-sm font-semibold text-white/60">Name</th>
            <th className="py-3.5 px-3 text-left text-sm font-semibold text-white/60">Description</th>
            <th className="py-3.5 px-3 text-left text-sm font-semibold text-white/60">Meals Count</th>
            <th className="py-3.5 pl-3 pr-4 text-right text-sm font-semibold text-white/60">Actions</th>
          </tr>
        </thead>
        <tbody>
          {categories?.map((category) => (
            <tr key={category.id} className="border-b border-white/5">
              <td className="whitespace-nowrap py-4 pl-4 pr-3 text-sm text-white">{category.id}</td>
              <td className="whitespace-nowrap py-4 px-3 text-sm text-white">{category.name}</td>
              <td className="py-4 px-3 text-sm text-white">
                {category.description || '-'}
              </td>
              <td className="whitespace-nowrap py-4 px-3 text-sm text-white">
                {category.meals?.length || 0}
              </td>
              <td className="whitespace-nowrap py-4 pl-3 pr-4 text-right text-sm">
                <button className="rounded bg-white/5 px-2 py-1 text-white hover:bg-white/10 mr-2">Edit</button>
                <button className="rounded bg-red-500/10 px-2 py-1 text-red-400 hover:bg-red-500/20">Delete</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default CategoriesTable;