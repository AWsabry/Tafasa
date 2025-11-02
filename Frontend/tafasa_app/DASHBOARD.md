Dashboard integration notes and folder structure

Files added/updated:

- src/components/Dashboard.jsx  - React component converted from provided HTML
- src/App.jsx                  - Updated to render the `Dashboard` component
- index.html                   - Updated to include Google Fonts and Tailwind CDN (for prototyping)

Recommended folder structure (already present):

Frontend/tafasa_app
├── index.html
├── package.json
├── src
│   ├── main.jsx
│   ├── index.css
│   ├── App.jsx
│   └── components
│       └── Dashboard.jsx
└── README.md

Notes:
- The component uses Tailwind utility classes via the CDN included in `index.html`. For production use, install and configure Tailwind locally.
- If you want me to wire up dynamic data (meals, categories, users) into the dashboard cards, point me to the API endpoints (or provide sample responses) and I will add fetch calls and simple state management.
- If you prefer the original full HTML head contents (extra meta, icons), I can merge them into `index.html` as needed.
