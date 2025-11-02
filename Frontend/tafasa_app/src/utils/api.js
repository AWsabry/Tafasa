const API_BASE_URL = 'http://localhost:5000';

// List of endpoints that don't require authentication
const PUBLIC_ENDPOINTS = ['/auth/login', '/auth/register'];

export const api = {
  get: async (endpoint) => {
    const token = localStorage.getItem('token');
    const headers = !PUBLIC_ENDPOINTS.includes(endpoint) && token
      ? { 'Authorization': `Bearer ${token}` }
      : {};

    const response = await fetch(`${API_BASE_URL}${endpoint}`, { headers });
    
    if (!response.ok) {
      if (response.status === 401 && !PUBLIC_ENDPOINTS.includes(endpoint)) {
        localStorage.removeItem('token');
      }
      const errorData = await response.json();
      throw new Error(errorData.error || `HTTP ${response.status}`);
    }
    
    return response.json();
  },

  post: async (endpoint, data) => {
    const token = localStorage.getItem('token');
    const headers = {
      'Content-Type': 'application/json',
      ...((!PUBLIC_ENDPOINTS.includes(endpoint) && token) && {
        'Authorization': `Bearer ${token}`
      })
    };
    const response = await fetch(`${API_BASE_URL}${endpoint}`, {
      method: 'POST',
      headers,
      body: JSON.stringify(data),
    });

    if (!response.ok) {
      if (response.status === 401 && !PUBLIC_ENDPOINTS.includes(endpoint)) {
        localStorage.removeItem('token');
      }

      // Try to parse JSON error body, fallback to plain text
      let errorMessage = `HTTP ${response.status}`;
      try {
        const errorData = await response.json();
        if (errorData) {
          // prefer `error` field, then `message`, then stringify whole body
          errorMessage = errorData.error || errorData.message || JSON.stringify(errorData);
        }
      } catch (parseErr) {
        try {
          const text = await response.text();
          if (text) errorMessage = text;
        } catch (_) {
          // ignore
        }
      }

      throw new Error(errorMessage || `HTTP ${response.status}`);
    }

    return response.json();
  },

  patch: async (endpoint, data) => {
    const token = localStorage.getItem('token');
    const headers = {
      'Content-Type': 'application/json',
      ...((!PUBLIC_ENDPOINTS.includes(endpoint) && token) && {
        'Authorization': `Bearer ${token}`
      })
    };

    const response = await fetch(`${API_BASE_URL}${endpoint}`, {
      method: 'PATCH',
      headers,
      body: JSON.stringify(data),
    });

    if (!response.ok) {
      if (response.status === 401 && !PUBLIC_ENDPOINTS.includes(endpoint)) {
        localStorage.removeItem('token');
      }

      let errorMessage = `HTTP ${response.status}`;
      try {
        const errorData = await response.json();
        if (errorData) {
          errorMessage = errorData.error || errorData.message || JSON.stringify(errorData);
        }
      } catch (parseErr) {
        try {
          const text = await response.text();
          if (text) errorMessage = text;
        } catch (_) {}
      }

      throw new Error(errorMessage || `HTTP ${response.status}`);
    }

    return response.json();
  },

  // Add other methods (PUT, DELETE) as needed
};