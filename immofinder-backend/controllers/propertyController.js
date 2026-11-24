const Property = require('../models/Property');

// POST /api/properties (protégé)
exports.createProperty = async (req, res) => {
  try {
    const { title, description, price, type, category, location, area } = req.body;

    if (!title || !description || !price || !type || !category || !location || !area) {
      return res.status(400).json({ message: 'Champs obligatoires manquants' });
    }

    const property = await Property.create({
      ...req.body,
      owner: req.user._id,
    });

    res.status(201).json(property);
  } catch (error) {
    res.status(400).json({ message: 'Erreur création annonce', error: error.message });
  }
};

// GET /api/properties
exports.getProperties = async (req, res) => {
  try {
    const { type, category, location, minPrice, maxPrice } = req.query;
    const query = {};

    if (type) query.type = type;
    if (category) query.category = category;
    if (location) query.location = { $regex: location, $options: 'i' };
    if (minPrice || maxPrice) {
      query.price = {};
      if (minPrice) query.price.$gte = Number(minPrice);
      if (maxPrice) query.price.$lte = Number(maxPrice);
    }

    const properties = await Property.find(query)
      .populate('owner', 'fullName email phone')
      .sort({ createdAt: -1 });

    res.json(properties);
  } catch (error) {
    res.status(500).json({ message: 'Erreur récupération annonces', error: error.message });
  }
};

// GET /api/properties/:id
exports.getPropertyById = async (req, res) => {
  try {
    const property = await Property.findById(req.params.id).populate(
      'owner',
      'fullName email phone'
    );
    if (!property) {
      return res.status(404).json({ message: 'Annonce non trouvée' });
    }
    res.json(property);
  } catch (error) {
    res.status(500).json({ message: 'Erreur', error: error.message });
  }
};

// DELETE /api/properties/:id (protégé)
exports.deleteProperty = async (req, res) => {
  try {
    const property = await Property.findById(req.params.id);
    if (!property) {
      return res.status(404).json({ message: 'Annonce non trouvée' });
    }
    if (property.owner.toString() !== req.user._id.toString()) {
      return res.status(403).json({ message: 'Non autorisé à supprimer cette annonce' });
    }
    await property.deleteOne();
    res.json({ message: 'Annonce supprimée' });
  } catch (error) {
    res.status(500).json({ message: 'Erreur', error: error.message });
  }
};