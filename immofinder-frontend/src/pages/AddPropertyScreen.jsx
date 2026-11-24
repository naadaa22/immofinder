
import { useState } from 'react';
import { Camera, ChevronLeft } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';

const AddPropertyScreen = () => {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  
  // État pour les données du formulaire
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    price: '',
    type: 'Vente',
    category: 'Appartement',
    location: '',
    area: '',
    bedrooms: '',
    bathrooms: ''
  });

  // État pour l'image (nous allons utiliser une URL pour l'instant pour simplifier)
  const [imageUrl, setImageUrl] = useState('https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80');

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      const token = localStorage.getItem('token');
      if (!token) {
        return navigate('/login');
      }

      // Préparer les données (convertir les nombres)
      const propertyData = {
        ...formData,
        price: Number(formData.price),
        area: Number(formData.area),
        bedrooms: Number(formData.bedrooms) || 0,
        bathrooms: Number(formData.bathrooms) || 0,
        images: [imageUrl] // On ajoute l'image par défaut
      };

      // Envoi au backend
      await axios.post('http://localhost:5000/api/properties', propertyData, {
        headers: {
          Authorization: `Bearer ${token}`
        }
      });

      // Si succès, on retourne à l'accueil
      navigate('/');
    } catch (err) {
      setError(err.response?.data?.message || "Erreur lors de la publication");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="max-w-md mx-auto bg-white min-h-screen flex flex-col p-4 pb-10">
      
      {/* Header */}
      <div className="flex items-center mb-6">
        <button onClick={() => navigate(-1)} className="p-2 -ml-2">
          <ChevronLeft className="w-6 h-6 text-gray-700" />
        </button>
        <h1 className="text-lg font-bold text-gray-800 mx-auto pr-6">Publier une annonce</h1>
      </div>

      <form onSubmit={handleSubmit} className="flex flex-col gap-4">
        
        {error && <div className="bg-red-100 text-red-600 p-3 rounded-lg text-sm">{error}</div>}

        {/* Zone d'ajout de photo (Design maquette) */}
        <div className="border-2 border-dashed border-purple-200 bg-purple-50 rounded-xl p-8 flex flex-col items-center justify-center text-primary mb-2 cursor-pointer hover:bg-purple-100 transition-all">
          <Camera className="w-8 h-8 mb-2" />
          <span className="text-sm font-semibold">Ajouter des photos</span>
          <span className="text-xs text-purple-400 mt-1">(Appuyez pour choisir)</span>
        </div>
        
        {/* Image simulée (pour voir le rendu) */}
        {imageUrl && (
          <div className="relative h-32 w-full rounded-xl overflow-hidden mb-2">
             <img src={imageUrl} alt="Aperçu" className="w-full h-full object-cover" />
             <button type="button" onClick={() => setImageUrl('')} className="absolute top-2 right-2 bg-white text-red-500 rounded-full p-1 text-xs font-bold">X</button>
          </div>
        )}

        {/* Titre */}
        <input type="text" name="title" placeholder="Titre de l'annonce *" className="border border-gray-300 rounded-lg px-4 py-3 text-sm focus:outline-none focus:border-primary" onChange={handleChange} required />

        {/* Description */}
        <textarea name="description" placeholder="Description *" rows="4" className="border border-gray-300 rounded-lg px-4 py-3 text-sm focus:outline-none focus:border-primary resize-none" onChange={handleChange} required></textarea>

        {/* Type de bien (Select) */}
        <select name="type" className="border border-gray-300 rounded-lg px-4 py-3 text-sm text-gray-600 focus:outline-none focus:border-primary bg-white" onChange={handleChange} value={formData.type}>
          <option value="Vente">Vente</option>
          <option value="Location">Location</option>
          <option value="Neuf">Neuf</option>
          <option value="Terrain">Terrain</option>
        </select>

        {/* Catégorie (Select) */}
        <select name="category" className="border border-gray-300 rounded-lg px-4 py-3 text-sm text-gray-600 focus:outline-none focus:border-primary bg-white" onChange={handleChange} value={formData.category}>
          <option value="Appartement">Appartement</option>
          <option value="Villa">Villa</option>
          <option value="Maison">Maison</option>
          <option value="Terrain">Terrain</option>
        </select>

        {/* Prix et Localisation */}
        <div className="flex gap-4">
          <input type="number" name="price" placeholder="Prix (DT) *" className="w-1/2 border border-gray-300 rounded-lg px-4 py-3 text-sm focus:outline-none focus:border-primary" onChange={handleChange} required />
          <input type="text" name="location" placeholder="Localisation (ex: Tunis) *" className="w-1/2 border border-gray-300 rounded-lg px-4 py-3 text-sm focus:outline-none focus:border-primary" onChange={handleChange} required />
        </div>

        {/* Détails (Chambres, SDB, Surface) */}
        <div className="flex gap-2">
          <input type="number" name="bedrooms" placeholder="Chambres" className="w-1/3 border border-gray-300 rounded-lg px-3 py-3 text-sm focus:outline-none focus:border-primary" onChange={handleChange} />
          <input type="number" name="bathrooms" placeholder="Salles de bain" className="w-1/3 border border-gray-300 rounded-lg px-3 py-3 text-sm focus:outline-none focus:border-primary" onChange={handleChange} />
          <input type="number" name="area" placeholder="Surface (m²) *" className="w-1/3 border border-gray-300 rounded-lg px-3 py-3 text-sm focus:outline-none focus:border-primary" onChange={handleChange} required />
        </div>

        {/* Bouton Publier */}
        <button type="submit" disabled={loading} className="bg-primary text-white font-semibold py-3 rounded-lg mt-4 shadow-lg shadow-purple-200 hover:bg-primary-light transition-all disabled:opacity-50">
          {loading ? 'Publication...' : "Publier l'annonce"}
        </button>
      </form>
    </div>
  );
};

export default AddPropertyScreen;