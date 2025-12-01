import { Navigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';

const ProtectedRoute = ({ children }) => {
  const { token, user, loadingUser } = useAuth();

  if (!token) {
    return <Navigate to="/login" replace />;
  }

  if (loadingUser) {
    return <div className="flex h-screen w-full items-center justify-center text-[var(--color-text-primary)]">Checking access...</div>;
  }

  if (!user || user.role !== 'admin') {
    return <Navigate to="/login" replace />;
  }

  return children;
};

export default ProtectedRoute;
