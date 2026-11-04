const path = require('path');
const express = require('express');
const cors = require('cors');
require('dotenv').config();

const { isConfigured, supabase } = require('./config/supabase');
const app = express();
const port = process.env.PORT || 3000;
const frontendDirectory = path.join(__dirname, '..');
const asyncRoute = (handler) => (request, response, next) => {
  Promise.resolve(handler(request, response, next)).catch(next);
};

app.use(cors());
app.use(express.json());

app.get('/api/health', asyncRoute(async (request, response) => {
  if (!isConfigured) {
    return response.status(503).json({ status: 'error', database: 'not_configured' });
  }

  const { error } = await supabase.from('products').select('id').limit(1);
  if (error) {
    return response.status(503).json({ status: 'error', database: 'unavailable' });
  }

  return response.json({ status: 'ok', database: 'connected' });
}));

const listProducts = asyncRoute(async (request, response) => {
  if (!isConfigured) {
    return response.status(503).json({ error: 'Supabase is not configured.' });
  }

  const { data, error } = await supabase.from('products').select('*').order('id');
  if (error) {
    console.error('Supabase product query failed.');
    return response.status(500).json({ error: 'Unable to retrieve products.' });
  }

  return response.json(data);
});

app.get(['/api/products', '/api/product'], listProducts);

app.get('/api/product/:id', asyncRoute(async (request, response) => {
  if (!isConfigured) {
    return response.status(503).json({ error: 'Supabase is not configured.' });
  }

  const productId = Number(request.params.id);
  if (!Number.isInteger(productId) || productId < 1) {
    return response.status(400).json({ error: 'Product ID must be a positive integer.' });
  }

  const { data, error } = await supabase
    .from('products')
    .select('*')
    .eq('id', productId)
    .maybeSingle();

  if (error) {
    console.error('Supabase product query failed.');
    return response.status(500).json({ error: 'Unable to retrieve the product.' });
  }
  if (!data) {
    return response.status(404).json({ error: 'Product not found.' });
  }

  return response.json(data);
}));

app.use((error, request, response, next) => {
  console.error('Unexpected server error.');
  response.status(500).json({ error: 'An unexpected server error occurred.' });
});

app.use(express.static(frontendDirectory));

app.listen(port, () => {
  console.log(`E-Commerce website is available at http://localhost:${port}`);
});
