import { useState, useEffect, useContext } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { ArrowLeft, Share2, Heart, BedDouble, Bath, Square, Star, MessageCircle } from 'lucide-react';
import axios from 'axios';
import { AuthContext } from '../context/AuthContext';

const PropertyDetailsScreen = () => {
  const { id } = useParams(); 
  const navigate = useNavigate();
  const { user } = useContext(AuthContext); 
  const [property, setProperty] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    const fetchProperty = async () => {
      try {
        const response = await axios.get(`http://localhost:5000/api/properties/${id}`);
        setProperty(response.data);
      } catch (err) {
        setError("Impossible de charger l'annonce.");
      } finally {
        setLoading(false);
      }
    };
    fetchProperty();
  }, [id]);

  // ✅ FONCTION CORRIGÉE
  const handleContactSeller = () => {
    // On cherche le token directement dans le localStorage
    const localToken = localStorage.getItem('token');
    
    if (!localToken) {
      // Si pas connecté, on redirige vers le login
      navigate('/login');
      return;
    }
    
    // Si connecté, on vérifie qu'on a bien l'ID du propriétaire
    if (property && property.owner && property.owner._id) {
      navigate(`/chat/${property.owner._id}`);
    } else {
      alert("Erreur : Impossible de contacter le vendeur (données manquantes).");
    }
  };

  if (loading) return <div className="text-center py-20 text-gray-500">Chargement...</div>;
  if (error) return <div className="text-center py-20 text-red-500">{error}</div>;
  if (!property) return <div className="text-center py-20">Annonce introuvable.</div>;

  // Vérifier si l'utilisateur connecté est le propriétaire
  const isOwner = user && property.owner && property.owner._id === user._id;

  const mainImage = property.images && property.images.length > 0 
    ? `http://localhost:5000${property.images[0]}` 
    : "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80";

  return (
    <div className="max-w-md mx-auto bg-white min-h-screen pb-24 relative">
      
      {/* Image principale avec boutons flottants */}
      <div className="relative h-72 w-full">
        <img src={mainImage} alt={property.title} className="w-full h-full object-cover" />
        
        {/* Bouton Retour */}
        <button onClick={() => navigate(-1)} className="absolute top-4 left-4 bg-white p-2 rounded-full shadow-md">
          <ArrowLeft className="w-5 h-5 text-gray-800" />
        </button>
        
        {/* Boutons Partager & Favoris */}
        <div className="absolute top-4 right-4 flex gap-2">
          <button className="bg-white p-2 rounded-full shadow-md">
            <Share2 className="w-5 h-5 text-gray-800" />
          </button>
          <button className="bg-white p-2 rounded-full shadow-md">
            <Heart className="w-5 h-5 text-red-500" />
          </button>
        </div>

        {/* Indicateur d'images */}
        <div className="absolute bottom-4 right-4 bg-black/60 text-white text-xs px-3 py-1 rounded-full">
          1 / {property.images?.length || 1}
        </div>
      </div>

      {/* Contenu de l'annonce */}
      <div className="p-5">
        <h1 className="text-2xl font-bold text-primary">{property.price} DT</h1>
        <h2 className="text-lg font-semibold text-gray-800 mt-1">{property.title}</h2>
        
        <div className="flex items-center gap-1 mt-2">
          <Star className="w-4 h-4 text-yellow-400" fill="currentColor" />
          <span className="text-sm font-medium text-gray-600">{property.rating || "Nouveau"} ({property.reviewsCount || 0} avis)</span>
        </div>

        {/* Caractéristiques */}
        <div className="flex justify-between mt-6 bg-gray-50 p-4 rounded-xl">
          <div className="flex flex-col items-center">
            <BedDouble className="w-6 h-6 text-gray-600 mb-1" />
            <span className="text-xs text-gray-600">{property.bedrooms} Chambres</span>
          </div>
          <div className="w-px bg-gray-200"></div>
          <div className="flex flex-col items-center">
            <Bath className="w-6 h-6 text-gray-600 mb-1" />
            <span className="text-xs text-gray-600">{property.bathrooms} Salles de bain</span>
          </div>
          <div className="w-px bg-gray-200"></div>
          <div className="flex flex-col items-center">
            <Square className="w-6 h-6 text-gray-600 mb-1" />
            <span className="text-xs text-gray-600">{property.area} m²</span>
          </div>
        </div>

        {/* Description */}
        <div className="mt-6">
          <h3 className="font-bold text-gray-800 mb-2">Description</h3>
          <p className="text-sm text-gray-600 leading-relaxed">
            {property.description}
          </p>
        </div>

        {/* Infos propriétaire */}
        {property.owner && (
          <div className="mt-6 border-t border-gray-100 pt-4">
            <p className="text-xs text-gray-500 mb-1">Proposé par :</p>
            <p className="font-semibold text-gray-800">{property.owner.fullName}</p>
          </div>
        )}
      </div>

      {/* Bouton Contacter flottant en bas */}
      <div className="fixed bottom-0 w-full max-w-md bg-white border-t border-gray-100 p-4">
        {isOwner ? (
          <button disabled className="w-full bg-gray-300 text-gray-500 font-semibold py-3 rounded-xl cursor-not-allowed">
            C'est votre annonce
          </button>
        ) : (
          <button 
            onClick={handleContactSeller}
            className="w-full bg-primary text-white font-semibold py-3 rounded-xl flex items-center justify-center gap-2 shadow-lg hover:bg-primary-light transition-all"
          >
            <MessageCircle className="w-5 h-5" />
            Contacter le vendeur
          </button>
        )}
      </div>
    </div>
  );
};

export default PropertyDetailsScreen;