import { useState } from 'react';
import { User, Mail, Phone, Lock, Eye, EyeOff } from 'lucide-react';
import { Link, useNavigate } from 'react-router-dom';
import axios from 'axios';

const RegisterScreen = () => {
  const [formData, setFormData] = useState({
    fullName: '',
    email: '',
    phone: '',
    password: '',
    confirmPassword: ''
  });
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  
  const navigate = useNavigate();

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleRegister = async (e) => {
    e.preventDefault();
    setError('');

    if (formData.password !== formData.confirmPassword) {
      return setError('Les mots de passe ne correspondent pas');
    }

    setLoading(true);

    try {
      // Appel à votre backend pour créer le compte
      const response = await axios.post('http://localhost:5000/api/auth/register', {
        fullName: formData.fullName,
        email: formData.email,
        phone: formData.phone,
        password: formData.password
      });

      // Sauvegarder le token et rediriger vers l'accueil
      localStorage.setItem('token', response.data.token);
      localStorage.setItem('user', JSON.stringify(response.data));
      navigate('/');
    } catch (err) {
      setError(err.response?.data?.message || "Erreur lors de l'inscription");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="max-w-md mx-auto bg-white min-h-screen flex flex-col p-6 pb-10">
      
      {/* Bouton retour */}
      <button onClick={() => navigate(-1)} className="self-start mb-4">
        <svg className="w-6 h-6 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15 19l-7-7 7-7" /></svg>
      </button>

      {/* Titre */}
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-gray-800">Créer un compte</h1>
        <p className="text-gray-500 text-sm mt-1">Rejoignez ImmoFinder</p>
      </div>

      {/* Formulaire */}
      <form onSubmit={handleRegister} className="flex flex-col gap-4">
        
        {error && <div className="bg-red-100 text-red-600 p-3 rounded-lg text-sm">{error}</div>}

        {/* Nom complet */}
        <div className="flex items-center border border-gray-300 rounded-lg px-3 py-3 bg-gray-50 focus-within:border-primary focus-within:bg-white transition-all">
          <User className="w-5 h-5 text-gray-400" />
          <input type="text" name="fullName" placeholder="Nom complet" className="w-full bg-transparent outline-none ml-3 text-sm text-gray-700" onChange={handleChange} required />
        </div>

        {/* Email */}
        <div className="flex items-center border border-gray-300 rounded-lg px-3 py-3 bg-gray-50 focus-within:border-primary focus-within:bg-white transition-all">
          <Mail className="w-5 h-5 text-gray-400" />
          <input type="email" name="email" placeholder="Email" className="w-full bg-transparent outline-none ml-3 text-sm text-gray-700" onChange={handleChange} required />
        </div>

        {/* Téléphone */}
        <div className="flex items-center border border-gray-300 rounded-lg px-3 py-3 bg-gray-50 focus-within:border-primary focus-within:bg-white transition-all">
          <Phone className="w-5 h-5 text-gray-400" />
          <input type="tel" name="phone" placeholder="Téléphone" className="w-full bg-transparent outline-none ml-3 text-sm text-gray-700" onChange={handleChange} required />
        </div>

        {/* Mot de passe */}
        <div className="flex items-center border border-gray-300 rounded-lg px-3 py-3 bg-gray-50 focus-within:border-primary focus-within:bg-white transition-all">
          <Lock className="w-5 h-5 text-gray-400" />
          <input type={showPassword ? "text" : "password"} name="password" placeholder="Mot de passe" className="w-full bg-transparent outline-none ml-3 text-sm text-gray-700" onChange={handleChange} required />
          <button type="button" onClick={() => setShowPassword(!showPassword)}>
            {showPassword ? <EyeOff className="w-5 h-5 text-gray-400" /> : <Eye className="w-5 h-5 text-gray-400" />}
          </button>
        </div>

        {/* Confirmer Mot de passe */}
        <div className="flex items-center border border-gray-300 rounded-lg px-3 py-3 bg-gray-50 focus-within:border-primary focus-within:bg-white transition-all">
          <Lock className="w-5 h-5 text-gray-400" />
          <input type="password" name="confirmPassword" placeholder="Confirmer le mot de passe" className="w-full bg-transparent outline-none ml-3 text-sm text-gray-700" onChange={handleChange} required />
        </div>

        {/* Bouton S'inscrire */}
        <button type="submit" disabled={loading} className="bg-primary text-white font-semibold py-3 rounded-lg mt-2 shadow-lg shadow-purple-200 hover:bg-primary-light transition-all disabled:opacity-50">
          {loading ? 'Inscription...' : "S'inscrire"}
        </button>
      </form>

      {/* Lien connexion */}
      <p className="text-center text-sm text-gray-500 mt-6">
        Déjà un compte ?{' '}
        <Link to="/login" className="text-primary font-semibold hover:underline">
          Se connecter
        </Link>
      </p>
    </div>
  );
};

export default RegisterScreen;