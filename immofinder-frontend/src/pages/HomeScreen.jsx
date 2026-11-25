import { useState, useEffect, useContext } from 'react';
import { Search, Bell, MapPin, Star, Heart } from 'lucide-react';
import { Link, useNavigate } from 'react-router-dom';
import axios from 'axios';
import BottomNav from '../components/BottomNav';
import { AuthContext } from '../context/AuthContext';

const HomeScreen = () => {
  const [annonces, setAnnonces] = useState([]);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();
  const { token, user, login } = useContext(AuthContext); 

  // Récupérer les annonces au chargement de la page
  useEffect(() => {
    const fetchProperties = async () => {
      try {
        const response = await axios.get('http://localhost:5000/api/properties');
        setAnnonces(response.data.slice(0, 5)); 
      } catch (error) {
        console.error("Erreur lors de la récupération des annonces:", error);
      } finally {
        setLoading(false);
      }
    };

    fetchProperties();
  }, []);

  // Fonction pour ajouter ou retirer un favori
  const handleToggleFavorite = async (e, id) => {
    e.stopPropagation(); // Empêche l'ouverture de la page détails
    if (!token) {
      navigate('/login');
      return;
    }

    try {
      const response = await axios.post(`http://localhost:5000/api/auth/favorites/${id}`, {}, {
        headers: { Authorization: `Bearer ${token}` }
      });
      
      // Mettre à jour le contexte utilisateur pour rafraichir les cœurs sans recharger la page
      const updatedUser = { ...user, favorites: response.data };
      login(updatedUser, token); // Met à jour le localStorage et le contexte
      
    } catch (error) {
      console.error("Erreur favoris", error);
    }
  };

  // Vérifier si une annonce est dans les favoris de l'utilisateur
  const isFavorite = (id) => {
    return user?.favorites?.includes(id);
  };

  return (
    <div className="max-w-md mx-auto bg-white min-h-screen pb-20 relative">
      {/* Header */}
      <div className="flex justify-between items-center p-4">
        <div className="flex items-center gap-1 font-semibold text-gray-800">
          <MapPin className="w-4 h-4 text-primary" />
          <span>Tunis</span>
        </div>
        {/* 🛎️ CLOCHE MISE À JOUR ICI */}
        <Bell 
          className="w-6 h-6 text-gray-600 cursor-pointer hover:text-primary transition-colors" 
          onClick={() => navigate('/notifications')} 
        />
      </div>

      {/* Barre de recherche */}
      <div className="px-4" onClick={() => navigate('/search')}>
        <div className="flex items-center bg-gray-100 rounded-xl px-3 py-2 cursor-pointer">
          <Search className="w-5 h-5 text-gray-400" />
          <input 
            type="text" 
            placeholder="Rechercher un bien..." 
            className="bg-transparent outline-none ml-2 w-full text-sm cursor-pointer" 
            readOnly
          />
        </div>
      </div>

      {/* Catégories */}
      <div className="flex justify-between px-4 mt-6 text-center text-xs font-medium text-gray-600">
        <Link to="/search?type=Vente" className="flex flex-col items-center gap-1 text-primary">
          <div className="bg-purple-100 p-3 rounded-xl"><MapPin className="w-5 h-5" /></div>
          <span>Vente</span>
        </Link>
        <Link to="/search?type=Location" className="flex flex-col items-center gap-1">
          <div className="bg-orange-50 p-3 rounded-xl"><MapPin className="w-5 h-5 text-orange-400" /></div>
          <span>Location</span>
        </Link>
        <Link to="/search?type=Neuf" className="flex flex-col items-center gap-1">
          <div className="bg-blue-50 p-3 rounded-xl"><MapPin className="w-5 h-5 text-blue-400" /></div>
          <span>Neuf</span>
        </Link>
        <Link to="/search?type=Terrain" className="flex flex-col items-center gap-1">
          <div className="bg-green-50 p-3 rounded-xl"><MapPin className="w-5 h-5 text-green-400" /></div>
          <span>Terrain</span>
        </Link>
      </div>

      {/* Bannière */}
      <div className="mx-4 mt-6 bg-primary rounded-2xl p-4 text-white relative overflow-hidden flex justify-between items-center">
        <div className="z-10">
          <h2 className="font-bold text-lg leading-tight">Trouvez la maison<br/>de vos rêves</h2>
          <button 
            onClick={() => navigate('/search')}
            className="mt-3 bg-white text-primary text-xs font-bold px-4 py-2 rounded-lg hover:bg-gray-100 transition"
          >
            Découvrir →
          </button>
        </div>
        <img src="https://images.unsplash.com/photo-1600585154340-be6161a56a0c?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80" alt="Maison" className="w-24 h-24 object-cover rounded-lg z-10" />
      </div>

      {/* Annonces Populaires */}
      <div className="mt-6 px-4">
        <div className="flex justify-between items-center mb-4">
          <h3 className="font-bold text-gray-800">Annonces populaires</h3>
          <Link to="/search" className="text-primary text-xs font-semibold hover:underline">Voir tout</Link>
        </div>

        {loading ? (
          <div className="text-center text-gray-500 text-sm py-4">Chargement des annonces...</div>
        ) : annonces.length === 0 ? (
          <div className="text-center text-gray-500 text-sm py-4">Aucune annonce pour le moment.</div>
        ) : (
          <div className="flex gap-4 overflow-x-auto pb-4 scrollbar-hide">
            {annonces.map((annonce) => (
              <div 
                key={annonce._id} 
                onClick={() => navigate(`/property/${annonce._id}`)}
                className="min-w-[240px] bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden cursor-pointer hover:shadow-md transition-shadow"
              >
                <div className="relative h-32">
                  <img 
                    src={annonce.images?.[0] ? `http://localhost:5000${annonce.images[0]}` : "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80"} 
                    alt={annonce.title} 
                    className="w-full h-full object-cover" 
                  />
                  {/* Bouton Cœur Dynamique */}
                  <button 
                    onClick={(e) => handleToggleFavorite(e, annonce._id)}
                    className="absolute top-2 right-2 bg-white p-1.5 rounded-full shadow z-10 hover:scale-110 transition-transform"
                  >
                    <Heart 
                      className="w-4 h-4 text-red-500" 
                      fill={isFavorite(annonce._id) ? "currentColor" : "none"} 
                    />
                  </button>
                </div>
                <div className="p-3">
                  <h4 className="font-bold text-primary">{annonce.price.toLocaleString()} DT</h4>
                  <p className="text-sm font-medium text-gray-800 truncate">{annonce.title}</p>
                  <p className="text-xs text-gray-500">{annonce.location}</p>
                  <div className="flex items-center gap-1 mt-2">
                    <Star className="w-3 h-3 text-yellow-400" fill="currentColor" />
                    <span className="text-xs font-medium text-gray-600">4.8 (120 avis)</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      <BottomNav />
    </div>
  );
};

export default HomeScreen;