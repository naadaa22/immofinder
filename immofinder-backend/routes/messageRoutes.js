const express = require('express');
const router = express.Router();
const Message = require('../models/Message');
const User = require('../models/User'); // <-- Import ajouté
const { protect } = require('../middlewares/authMiddleware');

// ==========================================
// ⚠️ CETTE ROUTE DOIT ÊTRE EN PREMIER
// GET /api/messages/conversations
// ==========================================
router.get('/conversations', protect, async (req, res) => {
  try {
    // 1. Trouver tous les messages où je suis impliqué
    const messages = await Message.find({
      $or: [{ sender: req.user._id }, { receiver: req.user._id }]
    }).sort({ createdAt: -1 }); // Du plus récent au plus ancien

    // 2. Extraire les IDs des autres utilisateurs uniques
    const conversationUserIds = new Set();
    messages.forEach(msg => {
      const otherId = msg.sender.toString() === req.user._id.toString() 
        ? msg.receiver.toString() 
        : msg.sender.toString();
      conversationUserIds.add(otherId);
    });

    // 3. Récupérer les infos (nom, email) de ces utilisateurs
    const users = await User.find({ _id: { $in: Array.from(conversationUserIds) } }).select('fullName email');

    // 4. Construire la liste finale pour le frontend
    const conversations = users.map(user => {
      // Trouver le dernier message avec cet utilisateur
      const lastMessage = messages.find(msg => 
        (msg.sender.toString() === user._id.toString() || msg.receiver.toString() === user._id.toString())
      );
      
      return {
        user: user,
        lastMessage: lastMessage ? lastMessage.content : 'Nouvelle conversation',
        time: lastMessage ? lastMessage.createdAt : new Date(),
        unread: false 
      };
    });

    res.json(conversations);
  } catch (error) {
    res.status(500).json({ message: 'Erreur', error: error.message });
  }
});

// ==========================================
// GET /api/messages/:userId
// (Récupérer les messages d'une conversation)
// ==========================================
router.get('/:userId', protect, async (req, res) => {
  try {
    const messages = await Message.find({
      $or: [
        { sender: req.user._id, receiver: req.params.userId },
        { sender: req.params.userId, receiver: req.user._id },
      ],
    }).sort({ createdAt: 1 });
    res.json(messages);
  } catch (error) {
    res.status(500).json({ message: 'Erreur', error: error.message });
  }
});

// ==========================================
// POST /api/messages
// (Envoyer un message)
// ==========================================
router.post('/', protect, async (req, res) => {
  try {
    const { receiver, content } = req.body;
    const message = await Message.create({
      sender: req.user._id,
      receiver,
      content,
    });
    res.status(201).json(message);
  } catch (error) {
    res.status(400).json({ message: 'Erreur', error: error.message });
  }
});

module.exports = router;