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
      SELECT *
      FROM AirportView
      ORDER BY AirportDisplay
    `);

    const airports = result.rows.map(([id, label]) => ({
      id,
      label
    }));

    res.json(airports);
  } catch (err) {
    console.error('Query error:', err);
    res.status(500).json({ error: 'Failed to fetch airports' });
  } finally {
    if (conn) await conn.close();
  }
});

// Search flights
app.get('/api/search-flights', async (req, res) => {
  const { departureId, arrivalId, date } = req.query;
  let conn;

  try {
    conn = await pool.getConnection();

    const binds = {};
    let plsql = '';
    
    if (departureId && arrivalId && date) {
      plsql = `BEGIN AirlinePackage.SearchFlights(:departureId, :arrivalId, TO_TIMESTAMP(:date, 'YYYY-MM-DD'), :cursor); END;`;
      binds.departureId = parseInt(departureId);
      binds.arrivalId = parseInt(arrivalId);
      binds.date = date;
    } else if (departureId && arrivalId) {
      plsql = `BEGIN AirlinePackage.SearchFlights(:departureId, :arrivalId, :cursor); END;`;
      binds.departureId = parseInt(departureId);
      binds.arrivalId = parseInt(arrivalId);
    } else if (departureId && date) {
      plsql = `BEGIN AirlinePackage.SearchFlights(:departureId, TO_TIMESTAMP(:date, 'YYYY-MM-DD'), :cursor); END;`;
      binds.departureId = parseInt(departureId);
      binds.date = date;
    } else if (departureId) {
      plsql = `BEGIN AirlinePackage.SearchFlights(:departureId, :cursor); END;`;
      binds.departureId = parseInt(departureId);
    } else {
      plsql = `BEGIN AirlinePackage.SearchFlights(:cursor); END;`;
    }

    binds.cursor = { type: oracledb.CURSOR, dir: oracledb.BIND_OUT };

    const result = await conn.execute(plsql, binds);
    const rs = result.outBinds.cursor;

    const meta = result.outBinds.cursor.metaData;
    const flights = [];
    let row;
    while ((row = await rs.getRow())) {
      const flight = {};
      row.forEach((val, idx) => {
        flight[meta[idx].name] = val;
      });
      flights.push(flight);
    }

    res.json(flights);
  } catch (err) {
    console.error('Flight search error:', err);
    res.status(500).json({ error: 'Failed to search flights' });
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