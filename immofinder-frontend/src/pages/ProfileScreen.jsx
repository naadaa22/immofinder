import { useState, useEffect, useContext } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { 
  LogOut, Heart, Settings, ChevronRight, Home, Mail, Phone, 
  Edit, Star, Bell, HelpCircle, Shield 
} from 'lucide-react';
import BottomNav from '../components/BottomNav';
import { AuthContext } from '../context/AuthContext';

const ProfileScreen = () => {
  const navigate = useNavigate();
  const { user, token, logout } = useContext(AuthContext);
  const [stats, setStats] = useState({ annonces: 0, favoris: 0, note: 4.8 });

  // Si l'utilisateur n'est pas connecté, on le redirige
  useEffect(() => {
    if (!token) {
      navigate('/login');
    }
  }, [token, navigate]);

  // Ici, on pourrait faire un appel API pour récupérer les vraies statistiques
  // Pour l'instant, on utilise les données du contexte
  useEffect(() => {
    if (user) {
      setStats({
        annonces: 0, // À remplacer par le vrai nombre d'annonces
        favoris: user.favorites?.length || 0,
        note: 4.8
      });
    }
  }, [user]);

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  if (!user) return null;

  return (
    <div className="max-w-md mx-auto bg-gray-50 min-h-screen pb-20 relative">
      
      {/* Header */}
      <div className="flex items-center justify-between p-4 bg-gray-50">
        <h1 className="text-xl font-bold text-gray-800">Mon profil</h1>
        <button className="text-primary"><Edit className="w-5 h-5" /></button>
      </div>

      {/* Carte Utilisateur (Violette) */}
      <div className="px-4 mt-2">
        <div className="bg-gradient-to-r from-purple-600 to-purple-400 rounded-3xl p-5 text-white shadow-lg relative">
          <div className="flex items-center gap-4">
            <div className="w-16 h-16 bg-white/20 backdrop-blur-sm rounded-full flex items-center justify-center border-2 border-white/50">
              <span className="text-2xl font-bold">{user.fullName?.charAt(0).toUpperCase()}</span>
            </div>
            <div>
              <h2 className="text-lg font-bold">{user.fullName}</h2>
              <p className="text-purple-100 text-sm">{user.email}</p>
              <p className="text-purple-200 text-xs mt-1">{user.phone || "Téléphone non renseigné"}</p>
            </div>
          </div>
          <button className="absolute top-4 right-4 p-2 bg-white/20 rounded-full hover:bg-white/30 transition">
            <Edit className="w-4 h-4 text-white" />
          </button>
        </div>
      </div>

      {/* Statistiques (3 cartes) */}
      <div className="flex justify-between px-4 mt-4 gap-2">
        <div className="bg-white rounded-2xl p-3 shadow-sm flex-1 flex flex-col items-center justify-center border border-gray-100">
          <Home className="w-5 h-5 text-primary mb-1" />
          <span className="font-bold text-lg">{stats.annonces}</span>
          <span className="text-xs text-gray-500">Annonces</span>
        </div>
        <div className="bg-white rounded-2xl p-3 shadow-sm flex-1 flex flex-col items-center justify-center border border-gray-100">
          <Heart className="w-5 h-5 text-primary mb-1" />
          <span className="font-bold text-lg">{stats.favoris}</span>
          <span className="text-xs text-gray-500">Favoris</span>
        </div>
        <div className="bg-white rounded-2xl p-3 shadow-sm flex-1 flex flex-col items-center justify-center border border-gray-100">
          <Star className="w-5 h-5 text-primary mb-1" />
          <span className="font-bold text-lg">{stats.note}</span>
          <span className="text-xs text-gray-500">Note</span>
        </div>
      </div>

      {/* Section Mon espace */}
      <div className="px-4 mt-6">
        <h3 className="font-bold text-gray-800 mb-3">Mon espace</h3>
        <div className="flex flex-col gap-2">
          
          <Link to="/home" className="bg-white rounded-2xl p-4 flex items-center justify-between shadow-sm border border-gray-100 hover:bg-gray-50 transition">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-purple-50 rounded-xl flex items-center justify-center">
                <Home className="w-5 h-5 text-primary" />
              </div>
              <div>
                <p className="font-semibold text-gray-800 text-sm">Mes annonces</p>
                <p className="text-xs text-gray-500">Gérer et publier vos biens</p>
              </div>
            </div>
            <ChevronRight className="w-5 h-5 text-gray-400" />
          </Link>

          <Link to="/favoris" className="bg-white rounded-2xl p-4 flex items-center justify-between shadow-sm border border-gray-100 hover:bg-gray-50 transition">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-red-50 rounded-xl flex items-center justify-center">
                <Heart className="w-5 h-5 text-red-500" />
              </div>
              <div>
                <p className="font-semibold text-gray-800 text-sm">Mes favoris</p>
                <p className="text-xs text-gray-500">Les biens que vous avez enregistrés</p>
              </div>
            </div>
            <ChevronRight className="w-5 h-5 text-gray-400" />
          </Link>

          <button className="bg-white rounded-2xl p-4 flex items-center justify-between shadow-sm border border-gray-100 hover:bg-gray-50 transition">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-blue-50 rounded-xl flex items-center justify-center">
                <Mail className="w-5 h-5 text-blue-500" />
              </div>
              <div>
                <p className="font-semibold text-gray-800 text-sm">Informations personnelles</p>
                <p className="text-xs text-gray-500">Nom, email et téléphone</p>
              </div>
            </div>
            <ChevronRight className="w-5 h-5 text-gray-400" />
          </button>
        </div>
      </div>

      {/* Section Préférences */}
      <div className="px-4 mt-6">
        <h3 className="font-bold text-gray-800 mb-3">Préférences</h3>
        <div className="flex flex-col gap-2">
          
          <div className="bg-white rounded-2xl p-4 flex items-center justify-between shadow-sm border border-gray-100">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-yellow-50 rounded-xl flex items-center justify-center">
                <Bell className="w-5 h-5 text-yellow-500" />
              </div>
              <div>
                <p className="font-semibold text-gray-800 text-sm">Notifications</p>
                <p className="text-xs text-gray-500">Nouveaux messages et annonces</p>
              </div>
            </div>
            {/* Toggle switch personnalisé */}
            <label className="relative inline-flex items-center cursor-pointer">
              <input type="checkbox" className="sr-only peer" defaultChecked />
              <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary"></div>
            </label>
          </div>

          <button className="bg-white rounded-2xl p-4 flex items-center justify-between shadow-sm border border-gray-100 hover:bg-gray-50 transition">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-teal-50 rounded-xl flex items-center justify-center">
                <HelpCircle className="w-5 h-5 text-teal-500" />
              </div>
              <div>
                <p className="font-semibold text-gray-800 text-sm">Centre d'aide</p>
                <p className="text-xs text-gray-500">Questions fréquentes et assistance</p>
              </div>
            </div>
            <ChevronRight className="w-5 h-5 text-gray-400" />
          </button>

          <button className="bg-white rounded-2xl p-4 flex items-center justify-between shadow-sm border border-gray-100 hover:bg-gray-50 transition">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-gray-100 rounded-xl flex items-center justify-center">
                <Shield className="w-5 h-5 text-gray-600" />
              </div>
              <div>
                <p className="font-semibold text-gray-800 text-sm">Confidentialité</p>
                <p className="text-xs text-gray-500">Consulter la politique de confidentialité</p>
              </div>
            </div>
            <ChevronRight className="w-5 h-5 text-gray-400" />
          </button>
        </div>
      </div>

      {/* Bouton Déconnexion */}
      <div className="px-4 mt-8 mb-4">
        <button 
          onClick={handleLogout} 
          className="w-full flex items-center justify-center gap-2 text-red-500 font-semibold py-3 rounded-xl hover:bg-red-50 transition"
        >
          <LogOut className="w-5 h-5" />
          Se déconnecter
        </button>
      </div>

      <BottomNav />
    </div>
  );
};

export default ProfileScreen;