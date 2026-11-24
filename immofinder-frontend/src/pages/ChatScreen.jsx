import { useState, useEffect, useContext } from 'react';
import { ArrowLeft, Send, Smile, Settings } from 'lucide-react';
import { useParams, useNavigate } from 'react-router-dom';
import axios from 'axios';
import { AuthContext } from '../context/AuthContext';

const ChatScreen = () => {
  const { id } = useParams(); // ID du destinataire
  const navigate = useNavigate();
  const { user, token } = useContext(AuthContext);
  
  const [messages, setMessages] = useState([]);
  const [newMessage, setNewMessage] = useState('');
  const [loading, setLoading] = useState(true);

  // 1. Charger l'historique des messages
  useEffect(() => {
    const fetchMessages = async () => {
      try {
        const response = await axios.get(`http://localhost:5000/api/messages/${id}`, {
          headers: { Authorization: `Bearer ${token}` }
        });
        setMessages(response.data);
      } catch (error) {
        console.error("Erreur chargement messages", error);
      } finally {
        setLoading(false);
      }
    };

    if (token) fetchMessages();
  }, [id, token]);

  // 2. Envoyer un message
  const handleSend = async (e) => {
    e.preventDefault();
    if (!newMessage.trim() || !token) return;

    const messageData = {
      receiver: id,
      content: newMessage
    };

    // Optimistic UI (on affiche le message immédiatement)
    const tempMessage = {
      _id: Date.now(),
      sender: user._id,
      receiver: id,
      content: newMessage,
      createdAt: new Date().toISOString()
    };
    setMessages([...messages, tempMessage]);
    setNewMessage('');

    try {
      const response = await axios.post('http://localhost:5000/api/messages', messageData, {
        headers: { Authorization: `Bearer ${token}` }
      });
      // Remplacer le message temporaire par le vrai message de la BDD
      setMessages(prev => prev.map(msg => msg._id === tempMessage._id ? response.data : msg));
    } catch (error) {
      console.error("Erreur envoi message", error);
    }
  };

  // Formater l'heure
  const formatTime = (dateString) => {
    const date = new Date(dateString);
    return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  };

  if (loading) return <div className="text-center py-20">Chargement...</div>;

  return (
    <div className="max-w-md mx-auto bg-gray-50 min-h-screen flex flex-col relative">
      
      {/* Header du chat */}
      <div className="bg-white p-4 flex items-center justify-between shadow-sm z-10">
        <div className="flex items-center gap-3">
          <button onClick={() => navigate(-1)}><ArrowLeft className="w-6 h-6 text-gray-700" /></button>
          <img src={`https://i.pravatar.cc/150?u=${id}`} alt="User" className="w-10 h-10 rounded-full" />
          <div>
            <h2 className="font-bold text-gray-800 text-sm">Discussion</h2>
            <p className="text-xs text-green-500 font-medium">En ligne</p>
          </div>
        </div>
        <button><Settings className="w-5 h-5 text-gray-500" /></button>
      </div>

      {/* Zone des messages */}
      <div className="flex-1 p-4 overflow-y-auto flex flex-col gap-4 pb-24">
        {messages.length === 0 && (
          <p className="text-center text-gray-400 text-sm mt-10">Envoyez un message pour commencer la discussion.</p>
        )}
        
        {messages.map((msg) => {
          const isMe = msg.sender === user._id;
          return (
            <div key={msg._id} className={`flex ${isMe ? 'justify-end' : 'justify-start'}`}>
              <div className={`max-w-[75%] rounded-2xl px-4 py-2 text-sm ${
                isMe 
                  ? 'bg-primary text-white rounded-tr-sm' 
                  : 'bg-white text-gray-800 shadow-sm border border-gray-100 rounded-tl-sm'
              }`}>
                <p>{msg.content}</p>
                <span className={`text-[10px] block text-right mt-1 ${isMe ? 'text-purple-200' : 'text-gray-400'}`}>
                  {formatTime(msg.createdAt)}
                </span>
              </div>
            </div>
          );
        })}
      </div>

      {/* Barre d'envoi */}
      <form onSubmit={handleSend} className="absolute bottom-0 w-full bg-white border-t border-gray-100 p-3 flex items-center gap-2">
        <button type="button" className="p-2 text-gray-400"><Smile className="w-6 h-6" /></button>
        <input 
          type="text" 
          placeholder="Écrire un message..." 
          className="flex-1 bg-gray-100 rounded-full px-4 py-2 text-sm outline-none"
          value={newMessage}
          onChange={(e) => setNewMessage(e.target.value)}
        />
        <button type="submit" className="bg-primary text-white p-2.5 rounded-full shadow-md">
          <Send className="w-5 h-5" />
        </button>
      </form>
    </div>
  );
};

export default ChatScreen;