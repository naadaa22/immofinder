const mongoose = require('mongoose');

const userSchema = new mongoose.Schema(
  {
    fullName: { type: String, required: true, trim: true },
    email: { type: String, required: true, unique: true, lowercase: true },
    phone: { type: String, required: true },
    password: { type: String, required: true, minlength: 6 },
    role: { type: String, enum: ['user', 'admin'], default: 'user' },
    // La ligne importante pour les favoris :
    favorites: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Property' }],
  },
  { timestamps: true }
);

module.exports = mongoose.model('User', userSchema);