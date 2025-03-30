import express from 'express';
import oracledb from 'oracledb';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());

// Oracle DB setup
let pool;
async function initDB() {
  try {
    pool = await oracledb.createPool({
      user: process.env.ORACLE_USER,
      password: process.env.ORACLE_PASSWORD,
      connectString: process.env.ORACLE_CONNECTION_STRING,
    });
    console.log('✅ Connected to Oracle DB');
  } catch (err) {
    console.error('❌ Error initializing DB:', err);
    process.exit(1);
  }
}

// Select all airports
app.get('/api/airports', async (req, res) => {
  let conn;
  try {
    conn = await pool.getConnection();

    const result = await conn.execute(`
      SELECT AirportID, AirportCode, City
      FROM Airport
      ORDER BY City
    `);

    const airports = result.rows.map(([id, code, city]) => ({
      id,
      code,
      city,
      label: `${city}(${code})`
    }));

    res.json(airports);
  } catch (err) {
    console.error('Query error:', err);
    res.status(500).json({ error: 'Failed to fetch airports' });
  } finally {
    if (conn) await conn.close();
  }
});

// Example route
app.get('/api/flights', async (req, res) => {
  let conn;
  try {
    conn = await pool.getConnection();
    const result = await conn.execute(`SELECT * FROM flight`);
    res.json(result.rows);
  } catch (err) {
    console.error('Query error:', err);
    res.status(500).json({ error: 'Failed to fetch flights' });
  } finally {
    if (conn) await conn.close();
  }
});

app.get('/', (req, res) => {
  res.send('✈️ Airline API up and running');
});

// Start server
initDB().then(() => {
  app.listen(PORT, () => {
    console.log(`🚀 Server listening on http://localhost:${PORT}`);
  });
});