import { useState, useContext } from 'react'; // <-- Ajout de useContext
import { Mail, Lock, Eye, EyeOff } from 'lucide-react';
import { Link, useNavigate } from 'react-router-dom';
import { GoogleLogin } from '@react-oauth/google'; // <-- Import Google
import axios from 'axios';
import { AuthContext } from '../context/AuthContext'; // <-- Import du contexte

const LoginScreen = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  
  const navigate = useNavigate();
  const { login } = useContext(AuthContext); // <-- Récupération de la fonction login

  // Connexion classique (Email / Mot de passe)
  const handleLogin = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      const response = await axios.post('http://localhost:5000/api/auth/login', {
        email,
        password
      });

      // On utilise la fonction login du contexte pour tout sauvegarder
      login(response.data, response.data.token);
      navigate('/home');
      
    } catch (err) {
      setError(err.response?.data?.message || 'Erreur de connexion');
    } finally {
      setLoading(false);
    }
  };

  // Connexion avec Google
  const handleGoogleSuccess = async (credentialResponse) => {
    setError('');
    setLoading(true);
    try {
      // On envoie le jeton Google à notre backend
      const response = await axios.post('http://localhost:5000/api/auth/google', {
        idToken: credentialResponse.credential
      });
      
      // On connecte l'utilisateur
      login(response.data, response.data.token);
      navigate('/home');
    } catch (err) {
      console.error("Erreur Google", err);
      setError("Erreur lors de la connexion avec Google.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="max-w-md mx-auto bg-white min-h-screen flex flex-col p-6">
      
      {/* Logo */}
      <div className="flex flex-col items-center mt-10 mb-8">
        <div className="w-16 h-16 bg-primary rounded-xl flex items-center justify-center mb-4">
          <svg className="w-10 h-10 text-white" fill="currentColor" viewBox="0 0 24 24"><path d="M12 3l10 9h-3v9h-5v-6H10v6H5v-9H2l10-9z"/></svg>
        </div>
        <h1 className="text-2xl font-bold text-primary">ImmoFinder</h1>
        <p className="text-gray-500 text-sm mt-2">Connectez-vous pour continuer</p>
      </div>

      {/* Formulaire */}
      <form onSubmit={handleLogin} className="flex flex-col gap-4">
        
        {error && <div className="bg-red-100 text-red-600 p-3 rounded-lg text-sm">{error}</div>}

        {/* Email */}
        <div className="flex items-center border border-gray-300 rounded-lg px-3 py-3 bg-gray-50 focus-within:border-primary focus-within:bg-white transition-all">
          <Mail className="w-5 h-5 text-gray-400" />
          <input 
            type="email" 
            placeholder="Email" 
            className="w-full bg-transparent outline-none ml-3 text-sm text-gray-700"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
          />
        </div>

        {/* Mot de passe */}
        <div className="flex items-center border border-gray-300 rounded-lg px-3 py-3 bg-gray-50 focus-within:border-primary focus-within:bg-white transition-all">
          <Lock className="w-5 h-5 text-gray-400" />
          <input 
            type={showPassword ? "text" : "password"} 
            placeholder="Mot de passe" 
            className="w-full bg-transparent outline-none ml-3 text-sm text-gray-700"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
          <button type="button" onClick={() => setShowPassword(!showPassword)}>
            {showPassword ? <EyeOff className="w-5 h-5 text-gray-400" /> : <Eye className="w-5 h-5 text-gray-400" />}
          </button>
        </div>

        {/* Bouton Se connecter */}
        <button 
          type="submit" 
          disabled={loading}
          className="bg-primary text-white font-semibold py-3 rounded-lg mt-2 shadow-lg shadow-purple-200 hover:bg-primary-light transition-all disabled:opacity-50"
        >
          {loading ? 'Connexion...' : 'Se connecter'}
        </button>
      </form>

      {/* Séparateur */}
      <div className="flex items-center my-6">
        <div className="flex-1 h-px bg-gray-200"></div>
        <span className="px-4 text-gray-400 text-sm">— ou —</span>
        <div className="flex-1 h-px bg-gray-200"></div>
      </div>

      {/* Boutons sociaux */}
      <div className="flex flex-col gap-3">
        
        {/* 🌟 BOUTON GOOGLE OFFICIEL */}
        <div className="flex justify-center w-full">
          <GoogleLogin
            onSuccess={handleGoogleSuccess}
            onError={() => setError("La connexion Google a échoué")}
            theme="outline"
            shape="rectangular"
            text="signin_with"
            width="350" // Ajustez selon la largeur de votre conteneur
          />
        </div>

        {/* Bouton Apple (statique) */}
        <button className="w-full flex items-center justify-center gap-2 border border-gray-300 rounded-lg py-3 hover:bg-gray-50 transition-all">
          <img src="https://www.svgrepo.com/show/512317/apple-173.svg" alt="Apple" className="w-5 h-5" />
          <span className="text-sm font-medium text-gray-700">Apple</span>
        </button>
      </div>

      {/* Lien inscription */}
      <p className="text-center text-sm text-gray-500 mt-8">
        Vous n'avez pas de compte ?{' '}
        <Link to="/register" className="text-primary font-semibold hover:underline">
          S'inscrire
        </Link>
      </p>
    </div>
  );
};

export default LoginScreen;