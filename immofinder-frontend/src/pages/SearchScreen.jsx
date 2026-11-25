import { useState, useEffect } from 'react';
import { MapContainer, TileLayer, Marker, Popup } from 'react-leaflet';
import { Search, SlidersHorizontal, MapPin, Star } from 'lucide-react';
import { Link, useNavigate } from 'react-router-dom';
import axios from 'axios';
import 'leaflet/dist/leaflet.css';
import L from 'leaflet';
import BottomNav from '../components/BottomNav';

// Correction bug Leaflet
delete L.Icon.Default.prototype._getIconUrl;
L.Icon.Default.mergeOptions({
  iconRetinaUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-icon-2x.png',
  iconUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-icon.png',
  shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-shadow.png',
});

const SearchScreen = () => {
  const navigate = useNavigate();
  const [properties, setProperties] = useState([]);
  const [filteredProperties, setFilteredProperties] = useState([]);
  const [showFilters, setShowFilters] = useState(true);
  
  const [transactionType, setTransactionType] = useState('Tous');
  const [maxPrice, setMaxPrice] = useState(1000000);
  const [propertyType, setPropertyType] = useState('Tous');

  const defaultPosition = [36.8065, 10.1815]; // Tunis

  useEffect(() => {
    const fetchProperties = async () => {
      try {
        const response = await axios.get('http://localhost:5000/api/properties');
        setProperties(response.data);
        setFilteredProperties(response.data);
      } catch (error) {
        console.error("Erreur chargement annonces", error);
      }
    };
    fetchProperties();
  }, []);

  const applyFilters = () => {
    let result = properties;
    if (transactionType !== 'Tous') result = result.filter(p => p.type === transactionType);
    if (propertyType !== 'Tous') result = result.filter(p => p.category === propertyType);
    result = result.filter(p => p.price <= maxPrice);
    setFilteredProperties(result);
    setShowFilters(false);
  };

  return (
    <div className="max-w-md mx-auto bg-white min-h-screen pb-20 relative flex flex-col">
      
      {/* Header de recherche */}
      <div className="p-4 bg-white z-10 shrink-0">
        <div className="flex items-center justify-between mb-3">
          <button onClick={() => navigate(-1)}><span className="text-xl">←</span></button>
          <h1 className="font-bold text-lg">Recherche</h1>
          <SlidersHorizontal className="w-5 h-5 text-gray-600" onClick={() => setShowFilters(!showFilters)} />
        </div>
        <div className="flex items-center bg-gray-100 rounded-xl px-3 py-2">
          <Search className="w-5 h-5 text-gray-400" />
          <input type="text" placeholder="Ville, quartier..." className="bg-transparent outline-none ml-2 w-full text-sm" />
        </div>
      </div>

      {/* Panneau de Filtres */}
      {showFilters && (
        <div className="p-4 bg-white border-b border-gray-100 z-10 shrink-0">
          <div className="flex gap-2 mb-4">
            {['Vente', 'Location', 'Tous'].map((type) => (
              <button
                key={type}
                onClick={() => setTransactionType(type)}
                className={`flex-1 py-2 rounded-full text-xs font-medium transition-all ${
                  transactionType === type ? 'bg-primary text-white' : 'bg-gray-100 text-gray-600'
                }`}
              >
                {type}
              </button>
            ))}
          </div>

          <div className="mb-4">
            <div className="flex justify-between text-xs font-medium text-gray-600 mb-2">
              <span>Prix (DT)</span>
              <span className="text-primary font-bold">{maxPrice.toLocaleString()} DT</span>
            </div>
            <input 
              type="range" min="50000" max="1000000" step="10000"
              value={maxPrice} onChange={(e) => setMaxPrice(Number(e.target.value))}
              className="w-full accent-primary"
            />
          </div>

          <div className="mb-4">
            <p className="text-xs font-medium text-gray-600 mb-2">Type de bien</p>
            <div className="flex justify-between text-center">
              {['Maison', 'Appartement', 'Villa', 'Terrain'].map((type) => (
                <button
                  key={type}
                  onClick={() => setPropertyType(type)}
                  className={`flex flex-col items-center gap-1 ${propertyType === type ? 'text-primary' : 'text-gray-500'}`}
                >
                  <div className={`p-2 rounded-xl ${propertyType === type ? 'bg-purple-100' : 'bg-gray-100'}`}>
                    <MapPin className="w-5 h-5" />
                  </div>
                  <span className="text-[10px]">{type}</span>
                </button>
              ))}
            </div>
          </div>

          <button 
            onClick={applyFilters}
            className="w-full bg-primary text-white font-semibold py-3 rounded-xl shadow-lg shadow-purple-200"
          >
            Appliquer les filtres
          </button>
        </div>
      )}

      {/* 🗺️ CARTE (Zone corrigée) */}
      <div className="flex-1 relative bg-gray-100" style={{ minHeight: '400px' }}>
        {/* Le texte des résultats */}
        <div className="absolute top-4 left-4 z-[400] bg-white/90 px-3 py-1 rounded-full text-xs font-semibold shadow-sm">
          Résultats ({filteredProperties.length})
        </div>

        {/* Leaflet Map */}
        <div className="absolute inset-0 z-0">
          <MapContainer 
            center={defaultPosition} 
            zoom={12} 
            style={{ height: '100%', width: '100%' }} // Hauteur à 100% du parent
          >
            <TileLayer 
              url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png" 
              attribution='&copy; OpenStreetMap'
            />
            
            {filteredProperties.map((property) => (
              <Marker 
                key={property._id} 
                /* Position aléatoire autour de Tunis pour la démo (à remplacer par les vraies coords) */
                position={[defaultPosition[0] + (Math.random() - 0.5) * 0.05, defaultPosition[1] + (Math.random() - 0.5) * 0.05]}
              >
                <Popup>
                  <div className="text-center">
                    <p className="font-bold text-primary">{property.price} DT</p>
                    <Link to={`/property/${property._id}`} className="text-xs text-blue-500 underline">Voir détails</Link>
                  </div>
                </Popup>
              </Marker>
            ))}
          </MapContainer>
        </div>

        {/* Carte flottante en bas (résultat rapide) */}
        {filteredProperties.length > 0 && (
          <div className="absolute bottom-4 left-4 right-4 z-[400]">
             <Link to={`/property/${filteredProperties[0]._id}`} className="bg-white rounded-xl shadow-lg p-2 flex items-center gap-3 border border-gray-100">
                <img 
                  src={filteredProperties[0].images?.[0] ? `http://localhost:5000${filteredProperties[0].images[0]}` : "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80"} 
                  alt="Maison" 
                  className="w-16 h-16 rounded-lg object-cover" 
                />
                <div>
                  <p className="font-bold text-primary text-sm">{filteredProperties[0].price} DT</p>
                  <p className="text-sm font-semibold text-gray-800">{filteredProperties[0].title}</p>
                  <p className="text-xs text-gray-500 flex items-center gap-1"><MapPin className="w-3 h-3"/> {filteredProperties[0].location}</p>
                </div>
             </Link>
          </div>
        )}
      </div>

      <BottomNav />
    </div>
  );
};

export default SearchScreen;