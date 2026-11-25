import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import SplashScreen from './pages/SplashScreen';
import LoginScreen from './pages/LoginScreen';
import RegisterScreen from './pages/RegisterScreen';
import HomeScreen from './pages/HomeScreen';
import PublishScreen from './pages/PublishScreen';
import PropertyDetailsScreen from './pages/PropertyDetailsScreen';
import SearchScreen from './pages/SearchScreen';
import MessagesScreen from './pages/MessagesScreen';
import ChatScreen from './pages/ChatScreen';
import FavoritesScreen from './pages/FavoritesScreen';
import ProfileScreen from './pages/ProfileScreen';
import NotificationsScreen from './pages/NotificationsScreen';
function App() {
  return (
    <Router>
      <div className="flex justify-center bg-gray-200 min-h-screen">
        <div className="w-full max-w-md bg-white min-h-screen shadow-2xl relative overflow-hidden">
          <Routes>
            {/* 1. Écran de démarrage */}
            <Route path="/" element={<SplashScreen />} />
            
            {/* 2. Authentification */}
            <Route path="/login" element={<LoginScreen />} />
            <Route path="/register" element={<RegisterScreen />} />
            
            {/* 3. Application principale */}
            <Route path="/home" element={<HomeScreen />} />
            <Route path="/search" element={<SearchScreen />} />
            <Route path="/publier" element={<PublishScreen />} />
            
            {/* 4. Détails d'une annonce */}
            <Route path="/property/:id" element={<PropertyDetailsScreen />} />
            
            {/* 5. Messagerie */}
            <Route path="/messages" element={<MessagesScreen />} />
            <Route path="/chat/:id" element={<ChatScreen />} />
            
            {/* 6. Favoris */}
            <Route path="/favoris" element={<FavoritesScreen />} />
            
            {/* 7. Profil */}
            <Route path="/profil" element={<ProfileScreen />} />

           <Route path="/notifications" element={<NotificationsScreen />} />
          </Routes>
        </div>
      </div>
    </Router>
  );
}

export default App;