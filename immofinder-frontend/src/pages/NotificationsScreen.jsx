import { useContext } from 'react';
import { ArrowLeft, Settings } from 'lucide-react';
import { Link, useNavigate } from 'react-router-dom';
import { AuthContext } from '../context/AuthContext';

const NotificationsScreen = () => {
  const navigate = useNavigate();
  const { user } = useContext(AuthContext); // <-- On récupère le vrai utilisateur

  if (!user) {
    return <div className="text-center py-20">Chargement du profil...</div>;
  }

  return (
    <div className="max-w-md mx-auto bg-white min-h-screen relative">
      
      {/* Header */}
      <div className="flex items-center justify-between p-4 border-b border-gray-100">
        <button onClick={() => navigate(-1)}><ArrowLeft className="w-6 h-6 text-gray-700" /></button>
        <h1 className="font-bold text-lg">Notifications</h1>
        <button><Settings className="w-5 h-5 text-gray-500" /></button>
      </div>

      {/* Profil en haut (Vrai utilisateur) */}
      <div className="flex flex-col items-center mt-8 mb-8">
        {/* On affiche l'initiale du vrai nom dans un cercle violet */}
        <div className="w-20 h-20 bg-purple-100 rounded-full flex items-center justify-center mb-3 border-2 border-white shadow-md">
          <span className="text-3xl font-bold text-primary">
            {user.fullName ? user.fullName.charAt(0).toUpperCase() : 'U'}
          </span>
        </div>
        <h2 className="font-bold text-gray-800">{user.fullName}</h2>
        <p className="text-xs text-gray-500">{user.email}</p>
      </div>

      {/* Menu */}
      <div className="px-4 flex flex-col gap-2">
        {/* Mes annonces */}
        <Link to="/home" className="flex items-center justify-between p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors">
          <div className="flex items-center gap-3">
            <div className="w-8 h-8 bg-purple-100 rounded-lg flex items-center justify-center">
              <span className="text-primary font-bold text-sm">A</span>
            </div>
            <span className="font-medium text-gray-700">Mes annonces</span>
          </div>
          <span className="text-gray-400">›</span>
        </Link>

        {/* Mes favoris */}
        <Link to="/favoris" className="flex items-center justify-between p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors">
          <div className="flex items-center gap-3">
            <div className="w-8 h-8 bg-red-100 rounded-lg flex items-center justify-center">
              <span className="text-red-500 font-bold text-sm">♥</span>
            </div>
            <span className="font-medium text-gray-700">Mes favoris</span>
          </div>
          <span className="text-gray-400">›</span>
        </Link>

        {/* Mes messages */}
        <Link to="/messages" className="flex items-center justify-between p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors">
          <div className="flex items-center gap-3">
            <div className="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center">
              <span className="text-blue-500 font-bold text-sm">M</span>
            </div>
            <span className="font-medium text-gray-700">Mes messages</span>
          </div>
          <span className="text-gray-400">›</span>
        </Link>
      </div>
    </div>
  );
};

export default NotificationsScreen;