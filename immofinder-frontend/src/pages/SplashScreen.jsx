import { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';

const SplashScreen = () => {
  const navigate = useNavigate();

  useEffect(() => {
    const timer = setTimeout(() => {
      // On efface le token à chaque démarrage pour forcer la reconnexion
      // localStorage.removeItem('token'); 
      // localStorage.removeItem('user');

      // On redirige DIRECTEMENT vers la page de connexion
      navigate('/login');
      
    }, 3000);

    return () => clearTimeout(timer);
  }, [navigate]);

  return (
    <div className="relative w-full h-screen flex flex-col items-center justify-center overflow-hidden">
      
      {/* Image de fond */}
      <img 
        src="https://images.unsplash.com/photo-1613490493576-7fde63acd811?q=80&w=1000&auto=format&fit=crop" 
        alt="Villa de rêve" 
        className="absolute inset-0 w-full h-full object-cover z-0"
      />
      
      {/* Dégradé violet */}
      <div className="absolute inset-0 bg-gradient-to-b from-purple-900/60 via-transparent to-purple-900/90 z-10"></div>

      {/* Contenu (Logo et Texte) */}
      <div className="relative z-20 flex flex-col items-center mt-[-100px]">
        <div className="w-20 h-20 mb-4 drop-shadow-lg">
          <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" className="w-full h-full">
            <path d="M12 3L2 12H5V21H19V12H22L12 3Z" stroke="#5B21B6" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" fill="white"/>
            <rect x="9" y="12" width="3" height="4" fill="#5B21B6"/>
            <rect x="13" y="12" width="3" height="4" fill="#5B21B6"/>
            <rect x="9" y="17" width="3" height="4" fill="#5B21B6"/>
            <rect x="13" y="17" width="3" height="4" fill="#5B21B6"/>
          </svg>
        </div>
        
        <h1 className="text-4xl font-extrabold text-gray-900 tracking-tight drop-shadow-md">
          Immo<span className="text-primary">Finder</span>
        </h1>
        
        <p className="text-gray-800 font-semibold mt-2 text-center drop-shadow-md">
          Trouvez votre bien idéal<br/>en Tunisie
        </p>
      </div>

      <div className="absolute bottom-12 z-20">
        <div className="w-10 h-10 border-4 border-white/30 border-t-white rounded-full animate-spin"></div>
      </div>
    </div>
  );
};

export default SplashScreen;