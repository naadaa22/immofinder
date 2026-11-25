const express = require('express');
const router = express.Router();
const {
  createProperty,
  getProperties,
  getPropertyById,
  deleteProperty,
} = require('../controllers/propertyController');
const { protect } = require('../middlewares/authMiddleware');

router.route('/')
  .get(getProperties)
  .post(protect, createProperty);

router.route('/:id')
  .get(getPropertyById)
  .delete(protect, deleteProperty);

module.exports = router;