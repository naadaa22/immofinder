import { Home, Heart, Plus, MessageCircle, User } from 'lucide-react';
import { Link, useLocation } from 'react-router-dom';

const BottomNav = () => {
  const location = useLocation();
  const isActive = (path) => location.pathname === path;

  return (
    <div className="fixed bottom-0 w-full max-w-md mx-auto bg-white border-t border-gray-200 flex justify-around items-center py-3 z-50">
      <Link to="/" className={`flex flex-col items-center ${isActive('/') ? 'text-primary' : 'text-gray-400'}`}>
        <Home className="w-6 h-6" />
        <span className="text-[10px] mt-1 font-medium">Accueil</span>
      </Link>
      
      <Link to="/favoris" className={`flex flex-col items-center ${isActive('/favoris') ? 'text-primary' : 'text-gray-400'}`}>
        <Heart className="w-6 h-6" />
        <span className="text-[10px] mt-1 font-medium">Favoris</span>
      </Link>
      
      {/* Bouton central violet */}
      <Link to="/publier" className="bg-primary text-white p-3 rounded-full shadow-lg -mt-8 border-4 border-white">
        <Plus className="w-6 h-6" />
      </Link>
      
      <Link to="/messages" className={`flex flex-col items-center ${isActive('/messages') ? 'text-primary' : 'text-gray-400'}`}>
        <MessageCircle className="w-6 h-6" />
        <span className="text-[10px] mt-1 font-medium">Messages</span>
      </Link>
      
      <Link to="/profil" className={`flex flex-col items-center ${isActive('/profil') ? 'text-primary' : 'text-gray-400'}`}>
        <User className="w-6 h-6" />
        <span className="text-[10px] mt-1 font-medium">Profil</span>
      </Link>
    </div>
  );
};

export default BottomNav;