const express = require('express');
const router = express.Router();

// On ajoute toggleFavorite dans l'import
const { protect } = require('../middlewares/authMiddleware');
const { registerUser, loginUser, getProfile, toggleFavorite, googleLogin } = require('../controllers/authController');

router.post('/register', registerUser);
router.post('/login', loginUser);
router.get('/profile', protect, getProfile);
router.post('/google', googleLogin);

// La nouvelle route pour ajouter/retirer un favori
router.post('/favorites/:propertyId', protect, toggleFavorite);

module.exports = router;