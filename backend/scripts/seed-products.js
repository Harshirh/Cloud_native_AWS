const products = require('../products.json');
const { isConfigured, supabase } = require('../config/supabase');

async function seedProducts() {
  if (!isConfigured) {
    console.error('Set SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY in backend/.env first.');
    process.exitCode = 1;
    return;
  }

  const { error } = await supabase
    .from('products')
    .upsert(products, { onConflict: 'id' });

  if (error) {
    console.error('Product seed failed:', error.message);
    process.exitCode = 1;
    return;
  }

  console.log(`Seeded ${products.length} products.`);
}

seedProducts().catch((error) => {
  console.error('Product seed failed:', error.message);
  process.exitCode = 1;
});
