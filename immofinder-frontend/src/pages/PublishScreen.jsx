import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Camera, ArrowLeft, X } from 'lucide-react'; // Ajout de l'icône X pour supprimer
import axios from 'axios';

const PublishScreen = () => {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    type: 'Vente',
    category: 'Appartement',
    price: '',
    location: '',
    area: '',
    bedrooms: '',
    bathrooms: ''
  });
  
  // On utilise un tableau pour stocker plusieurs images
  const [images, setImages] = useState([]);
  const [previews, setPreviews] = useState([]);

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  // Gérer la sélection de plusieurs images
  const handleImageChange = (e) => {
    const files = Array.from(e.target.files);
    
    // Limiter à 5 images maximum
    if (images.length + files.length > 5) {
      setError("Vous ne pouvez pas ajouter plus de 5 images.");
      return;
    }

    setImages([...images, ...files]);
    
    // Créer les URLs de prévisualisation
    const newPreviews = files.map(file => URL.createObjectURL(file));
    setPreviews([...previews, ...newPreviews]);
    setError('');
  };

  // Supprimer une image de la sélection
  const removeImage = (index) => {
    const newImages = [...images];
    newImages.splice(index, 1);
    setImages(newImages);

    const newPreviews = [...previews];
    newPreviews.splice(index, 1);
    setPreviews(newPreviews);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      const token = localStorage.getItem('token');
      if (!token) {
        throw new Error("Vous devez être connecté pour publier une annonce.");
      }

      let uploadedImageUrls = [];

      // 1. Upload de TOUTES les images
      if (images.length > 0) {
        const formDataImg = new FormData();
        // On ajoute chaque image au FormData
        images.forEach(image => {
          formDataImg.append('images', image); 
        });

        const uploadRes = await axios.post('http://localhost:5000/api/upload', formDataImg, {
          headers: { 
            'Content-Type': 'multipart/form-data',
            'Authorization': `Bearer ${token}`
          }
        });
        
        // Récupérer le tableau des chemins d'images renvoyé par le backend
        uploadedImageUrls = uploadRes.data.images; 
      }

      // 2. Création de l'annonce avec le tableau d'images
      const propertyData = {
        ...formData,
        price: Number(formData.price),
        area: Number(formData.area),
        bedrooms: Number(formData.bedrooms) || 0,
        bathrooms: Number(formData.bathrooms) || 0,
        images: uploadedImageUrls // On envoie le tableau
      };

      await axios.post('http://localhost:5000/api/properties', propertyData, {
        headers: { Authorization: `Bearer ${token}` }
      });

      navigate('/home');
      
    } catch (err) {
      setError(err.response?.data?.message || err.message || 'Erreur lors de la publication');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="max-w-md mx-auto bg-white min-h-screen flex flex-col pb-24">
      
      {/* Header */}
      <div className="flex items-center p-4 border-b border-gray-100">
        <button onClick={() => navigate(-1)} className="p-2 -ml-2">
          <ArrowLeft className="w-6 h-6 text-gray-700" />
        </button>
        <h1 className="flex-1 text-center font-bold text-gray-800 pr-6">Publier une annonce</h1>
      </div>

      <form onSubmit={handleSubmit} className="p-4 flex flex-col gap-5">
        
        {error && <div className="bg-red-100 text-red-600 p-3 rounded-lg text-sm">{error}</div>}

        {/* Zone d'upload d'images multiples */}
        <div>
          <div className="flex gap-2 overflow-x-auto pb-2 scrollbar-hide">
            {/* Aperçu des images sélectionnées */}
            {previews.map((preview, index) => (
              <div key={index} className="relative w-24 h-24 flex-shrink-0">
                <img src={preview} alt={`Aperçu ${index}`} className="w-full h-full object-cover rounded-xl" />
                <button 
                  type="button"
                  onClick={() => removeImage(index)}
                  className="absolute -top-2 -right-2 bg-red-500 text-white rounded-full p-1 shadow-md"
                >
                  <X className="w-3 h-3" />
                </button>
              </div>
            ))}

            {/* Bouton pour ajouter une image (masqué si on a déjà 5 images) */}
            {images.length < 5 && (
              <div className="relative w-24 h-24 flex-shrink-0 border-2 border-dashed border-gray-300 rounded-xl flex flex-col items-center justify-center bg-gray-50 hover:bg-gray-100 transition cursor-pointer">
                <input 
                  type="file" 
                  accept="image/*" 
                  multiple // <-- Permet de sélectionner plusieurs fichiers
                  onChange={handleImageChange} 
                  className="absolute inset-0 w-full h-full opacity-0 cursor-pointer z-10"
                />
                <Camera className="w-6 h-6 text-gray-400 mb-1" />
                <span className="text-[10px] text-gray-500 text-center px-1">Ajouter photo</span>
              </div>
            )}
          </div>
          <p className="text-xs text-gray-400 mt-1">Maximum 5 photos.</p>
        </div>

        {/* Titre */}
        <div>
          <label className="text-sm font-medium text-gray-700 mb-1 block">Titre de l'annonce *</label>
          <input type="text" name="title" onChange={handleChange} required className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:border-primary" placeholder="Ex: Villa moderne à Hammamet" />
        </div>

        {/* Description */}
        <div>
          <label className="text-sm font-medium text-gray-700 mb-1 block">Description *</label>
          <textarea name="description" onChange={handleChange} required rows="4" className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:border-primary" placeholder="Décrivez votre bien..."></textarea>
        </div>

        {/* Type et Catégorie */}
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="text-sm font-medium text-gray-700 mb-1 block">Type de bien</label>
            <select name="category" onChange={handleChange} className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:border-primary bg-white">
              <option value="Appartement">Appartement</option>
              <option value="Villa">Villa</option>
              <option value="Maison">Maison</option>
              <option value="Terrain">Terrain</option>
            </select>
          </div>
          <div>
            <label className="text-sm font-medium text-gray-700 mb-1 block">Transaction</label>
            <select name="type" onChange={handleChange} className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:border-primary bg-white">
              <option value="Vente">Vente</option>
              <option value="Location">Location</option>
              <option value="Neuf">Neuf</option>
            </select>
          </div>
        </div>

        {/* Prix et Localisation */}
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="text-sm font-medium text-gray-700 mb-1 block">Prix (DT) *</label>
            <input type="number" name="price" onChange={handleChange} required className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:border-primary" placeholder="250000" />
          </div>
          <div>
            <label className="text-sm font-medium text-gray-700 mb-1 block">Localisation *</label>
            <input type="text" name="location" onChange={handleChange} required className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:border-primary" placeholder="La Marsa, Tunis" />
          </div>
        </div>

        {/* Surface, Chambres, SDB */}
        <div className="grid grid-cols-3 gap-3">
          <div>
            <label className="text-sm font-medium text-gray-700 mb-1 block">Surface (m²) *</label>
            <input type="number" name="area" onChange={handleChange} required className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:border-primary" placeholder="120" />
          </div>
          <div>
            <label className="text-sm font-medium text-gray-700 mb-1 block">Chambres</label>
            <input type="number" name="bedrooms" onChange={handleChange} className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:border-primary" placeholder="3" />
          </div>
          <div>
            <label className="text-sm font-medium text-gray-700 mb-1 block">Salles de bain</label>
            <input type="number" name="bathrooms" onChange={handleChange} className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:border-primary" placeholder="2" />
          </div>
        </div>

        {/* Bouton Publier */}
        <button 
          type="submit" 
          disabled={loading}
          className="bg-primary text-white font-semibold py-3 rounded-xl mt-4 shadow-lg shadow-purple-200 hover:bg-primary-light transition-all disabled:opacity-50"
        >
          {loading ? 'Publication en cours...' : "Publier l'annonce"}
        </button>
      </form>
    </div>
  );
};

export default PublishScreen;