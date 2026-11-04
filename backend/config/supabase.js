const path = require('path');
const dotenv = require('dotenv');
const { createClient } = require('@supabase/supabase-js');

dotenv.config({ path: path.join(__dirname, '..', '.env') });

const supabaseUrl = process.env.SUPABASE_URL;
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const isConfigured = Boolean(supabaseUrl && serviceRoleKey);

const supabase = isConfigured
  ? createClient(supabaseUrl, serviceRoleKey)
  : null;

module.exports = { isConfigured, supabase };
