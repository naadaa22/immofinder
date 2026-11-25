import { useState, useEffect, useContext } from 'react';
import { Link } from 'react-router-dom';
import { Heart, MapPin, Star, ArrowLeft } from 'lucide-react';
import axios from 'axios';
import { AuthContext } from '../context/AuthContext';
import BottomNav from '../components/BottomNav';

const FavoritesScreen = () => {
  const { token } = useContext(AuthContext);
  const [favorites, setFavorites] = useState([]);
  const [loading, setLoading] = useState(true);

  // Récupérer les infos du profil (qui contient les IDs des favoris)
  useEffect(() => {
    const fetchFavorites = async () => {
      try {
        const response = await axios.get('http://localhost:5000/api/auth/profile', {
          headers: { Authorization: `Bearer ${token}` }
        });
        
        // Le backend renvoie l'utilisateur avec son tableau d'IDs favoris
        const favoriteIds = response.data.favorites || [];

        // Pour chaque ID, on va chercher les détails de l'annonce
        const favoritesData = await Promise.all(
          favoriteIds.map(id => axios.get(`http://localhost:5000/api/properties/${id}`))
        );

        setFavorites(favoritesData.map(res => res.data));
      } catch (error) {
        console.error("Erreur chargement favoris", error);
      } finally {
        setLoading(false);
      }
    };

    if (token) fetchFavorites();
  }, [token]);

  // Retirer un favori
  const removeFavorite = async (id) => {
    try {
      await axios.post(`http://localhost:5000/api/auth/favorites/${id}`, {}, {
        headers: { Authorization: `Bearer ${token}` }
      });
      // Mettre à jour la liste locale
      setFavorites(favorites.filter(fav => fav._id !== id));
    } catch (error) {
      console.error("Erreur suppression favori", error);
    }
  };

  return (
    <div className="max-w-md mx-auto bg-gray-50 min-h-screen pb-20 relative">
      
      {/* Header */}
      <div className="bg-white p-4 flex items-center gap-3 border-b border-gray-100 shadow-sm">
        <Link to="/home"><ArrowLeft className="w-6 h-6 text-gray-700" /></Link>
        <h1 className="text-xl font-bold text-gray-800">Mes favoris</h1>
      </div>

      <div className="p-4">
        {loading ? (
          <div className="text-center text-gray-500 py-10">Chargement...</div>
        ) : favorites.length === 0 ? (
          <div className="text-center text-gray-500 py-10">
            <Heart className="w-16 h-16 text-gray-300 mx-auto mb-4" />
            <p>Vous n'avez pas encore d'annonces favorites.</p>
            <Link to="/home" className="text-primary font-semibold mt-2 block">Explorer les annonces</Link>
          </div>
        ) : (
          <div className="flex flex-col gap-4">
            {favorites.map((annonce) => (
              <div key={annonce._id} className="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden flex">
                <div className="w-1/3 relative">
                  <img 
                    src={annonce.images?.[0] ? `http://localhost:5000${annonce.images[0]}` : "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80"} 
                    alt={annonce.title} 
                    className="w-full h-full object-cover" 
                  />
                </div>
                <div className="p-3 flex-1 flex flex-col justify-between">
                  <div>
                    <div className="flex justify-between items-start">
                      <h4 className="font-bold text-primary">{annonce.price} DT</h4>
                      <button onClick={() => removeFavorite(annonce._id)} className="text-red-500">
                        <Heart className="w-5 h-5" fill="currentColor" />
                      </button>
                    </div>
                    <p className="text-sm font-medium text-gray-800 truncate">{annonce.title}</p>
                    <p className="text-xs text-gray-500 flex items-center gap-1 mt-1"><MapPin className="w-3 h-3"/> {annonce.location}</p>
                  </div>
                  <Link to={`/property/${annonce._id}`} className="text-xs text-primary font-semibold mt-2">Voir détails →</Link>
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

export default FavoritesScreen;