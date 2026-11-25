const User = require('../models/User');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { OAuth2Client } = require('google-auth-library'); // <-- NOUVEL IMPORT

const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, { expiresIn: '30d' });
};

// Initialisation du client Google
const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

// POST /api/auth/register
exports.registerUser = async (req, res) => {
  const { fullName, email, phone, password } = req.body;

  try {
    if (!fullName || !email || !phone || !password) {
      return res.status(400).json({ message: 'Tous les champs sont obligatoires' });
    }

    const userExists = await User.findOne({ email });
    if (userExists) {
      return res.status(400).json({ message: 'Cet email est déjà utilisé' });
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const user = await User.create({
      fullName,
      email,
      phone,
      password: hashedPassword,
    });

    res.status(201).json({
      _id: user._id,
      fullName: user.fullName,
      email: user.email,
      phone: user.phone,
      token: generateToken(user._id),
    });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// POST /api/auth/login
exports.loginUser = async (req, res) => {
  const { email, password } = req.body;

  try {
    if (!email || !password) {
      return res.status(400).json({ message: 'Email et mot de passe requis' });
    }

    const user = await User.findOne({ email });
    if (user && (await bcrypt.compare(password, user.password))) {
      res.json({
        _id: user._id,
        fullName: user.fullName,
        email: user.email,
        phone: user.phone,
        token: generateToken(user._id),
      });
    } else {
      res.status(401).json({ message: 'Email ou mot de passe incorrect' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// GET /api/auth/profile (protégé)
exports.getProfile = async (req, res) => {
  res.json(req.user);
};

// POST /api/auth/favorites/:propertyId (protégé)
exports.toggleFavorite = async (req, res) => {
  try {
    const user = await User.findById(req.user._id);
    const propertyId = req.params.propertyId;

    if (user.favorites.includes(propertyId)) {
      user.favorites = user.favorites.filter(id => id.toString() !== propertyId);
    } else {
      user.favorites.push(propertyId);
    }

    await user.save();
    res.json(user.favorites);
  } catch (error) {
    res.status(500).json({ message: 'Erreur', error: error.message });
  }
};

// ==========================================
// NOUVELLE FONCTION : POST /api/auth/google
// ==========================================
exports.googleLogin = async (req, res) => {
  const { idToken } = req.body;

  try {
    // 1. Vérifier le jeton Google
    const ticket = await client.verifyIdToken({
      idToken,
      audience: process.env.GOOGLE_CLIENT_ID,
    });
    
    const { name, email } = ticket.getPayload();

    // 2. Chercher ou créer l'utilisateur dans MongoDB
    let user = await User.findOne({ email });

    if (!user) {
      // Création automatique d'un compte (sans mot de passe)
      user = await User.create({
        fullName: name,
        email: email,
        phone: 'Non renseigné', // Champ requis par votre modèle
        password: 'google-auth-' + Math.random().toString(36).slice(-8), // Mot de passe aléatoire
      });
    }

    // 3. Générer notre propre token JWT
    const token = generateToken(user._id);

    res.json({
      _id: user._id,
      fullName: user.fullName,
      email: user.email,
      phone: user.phone,
      token: token,
    });

  } catch (error) {
    console.error("Erreur Google Auth:", error);
    res.status(401).json({ message: 'Jeton Google invalide' });
  }
};