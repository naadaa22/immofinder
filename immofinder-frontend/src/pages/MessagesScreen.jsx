import { useState, useEffect, useContext } from 'react';
import { Search, Edit } from 'lucide-react';
import { Link, useNavigate } from 'react-router-dom';
import axios from 'axios';
import BottomNav from '../components/BottomNav';
import { AuthContext } from '../context/AuthContext';

const MessagesScreen = () => {
  const { token } = useContext(AuthContext);
  const navigate = useNavigate();
  const [conversations, setConversations] = useState([]);
  const [loading, setLoading] = useState(true);
  const [errorMsg, setErrorMsg] = useState(null); // <-- Pour afficher l'erreur

  useEffect(() => {
    const fetchConversations = async () => {
      // Si pas de token, on redirige vers login
      if (!token) {
        setLoading(false);
        navigate('/login');
        return;
      }

      try {
        const response = await axios.get('http://localhost:5000/api/messages/conversations', {
          headers: { Authorization: `Bearer ${token}` },
          timeout: 5000 // <-- On attend max 5 secondes
        });
        setConversations(response.data);
      } catch (error) {
        console.error("Erreur:", error);
        // Si le backend ne répond pas, on affiche un message d'erreur
        setErrorMsg("Impossible de charger les messages. Vérifiez que le serveur backend est bien lancé.");
      } finally {
        setLoading(false);
      }
    };

    fetchConversations();
  }, [token, navigate]);

  // Formater l'heure
  const formatTime = (dateString) => {
    const date = new Date(dateString);
    const now = new Date();
    if (date.toDateString() === now.toDateString()) {
      return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    }
    return date.toLocaleDateString([], { day: 'numeric', month: 'short' });
  };

  if (loading) return <div className="text-center py-20 text-gray-500">Chargement...</div>;

  return (
    <div className="max-w-md mx-auto bg-white min-h-screen pb-20 relative">
      <div className="flex justify-between items-center p-4 border-b border-gray-100">
        <h1 className="text-xl font-bold text-gray-800">Messages</h1>
        <button className="text-primary" onClick={() => navigate('/search')}>
          <Edit className="w-6 h-6" />
        </button>
      </div>

      <div className="px-4 py-3">
        <div className="flex items-center bg-gray-100 rounded-xl px-3 py-2">
          <Search className="w-5 h-5 text-gray-400" />
          <input type="text" placeholder="Rechercher..." className="bg-transparent outline-none ml-2 w-full text-sm" />
        </div>
      </div>

      <div className="flex flex-col">
        {/* AFFICHAGE DE L'ERREUR SI LE BACKEND NE RÉPOND PAS */}
        {errorMsg ? (
          <div className="text-center py-10 px-4 text-red-500 font-medium">
            {errorMsg}
          </div>
        ) : conversations.length === 0 ? (
          <div className="text-center py-10 px-4 text-gray-500">
            <p className="font-medium text-gray-700">Aucune conversation</p>
            <p className="text-sm mt-2">Contactez un vendeur depuis une annonce.</p>
          </div>
        ) : (
          conversations.map((conv) => (
            <Link 
              to={`/chat/${conv.user._id}`} 
              key={conv.user._id} 
              className="flex items-center gap-3 p-4 hover:bg-gray-50 transition-colors border-b border-gray-50"
            >
              <div className="w-14 h-14 bg-purple-100 rounded-full flex items-center justify-center flex-shrink-0">
                <span className="text-xl font-bold text-primary">
                  {conv.user.fullName ? conv.user.fullName.charAt(0).toUpperCase() : 'U'}
                </span>
              </div>
              <div className="flex-1 min-w-0">
                <div className="flex justify-between items-center mb-1">
                  <h3 className="font-semibold text-gray-800 truncate">{conv.user.fullName}</h3>
                  <span className="text-xs text-gray-400 flex-shrink-0">{formatTime(conv.time)}</span>
                </div>
                <p className="text-sm text-gray-500 truncate">{conv.lastMessage}</p>
              </div>
            </Link>
          ))
        )}
      </div>

      <BottomNav />
    </div>
  );
};

export default MessagesScreen;