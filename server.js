import express from "express";
import oracledb from "oracledb";
import dotenv from "dotenv";
import cors from "cors";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// CORS configuration
const corsOptions = {
  origin: process.env.FRONTEND_URL || "http://localhost:5173", // Your frontend URL
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
  allowedHeaders: ["Content-Type"],
};

// Middleware
app.use(cors(corsOptions));
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
    console.log("✅ Connected to Oracle DB");
  } catch (err) {
    console.error("❌ Error initializing DB:", err);
    process.exit(1);
  }
}

// Select all airports
app.get("/api/airports", async (req, res) => {
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
      label,
    }));

    res.json(airports);
  } catch (err) {
    console.error("Query error:", err);
    res.status(500).json({ error: "Failed to fetch airports" });
  } finally {
    if (conn) await conn.close();
  }
});

// Search flights
app.get("/api/search-flights", async (req, res) => {
  const { departureId, arrivalId, date } = req.query;
  let conn;

  try {
    conn = await pool.getConnection();

    const binds = {};
    let plsql = "";

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
    console.error("Flight search error:", err);
    res.status(500).json({ error: "Failed to search flights" });
  } finally {
    if (conn) await conn.close();
  }
});

// Search booked flights
app.get("/api/booked-flights", async (req, res) => {
  const { passengerId } = req.query;
  let conn;

  try {
    conn = await pool.getConnection();

    const binds = {};
    let plsql = "";

    if (passengerId) {
      plsql = `BEGIN AirlinePackage.SearchFlightsByPassenger(:passengerId, :cursor); END;`;
      binds.passengerId = parseInt(passengerId);
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
    console.error("Booked flight search error:", err);
    res.status(500).json({ error: "Failed to search booked flights" });
  } finally {
    if (conn) await conn.close();
  }
});

//Get all passengers
app.get("/api/passengers", async (req, res) => {
  let conn;
  try {
    conn = await pool.getConnection();

    const result = await conn.execute(`
      SELECT PassengerID, FullName, Email, PhoneNumer, PassPortNumber FROM Passenger ORDER BY FullName
    `);

    const passengers = result.rows.map(
      ([id, name, email, phone, passport]) => ({
        id,
        name,
        email,
        phone,
        passport,
      })
    );

    res.json(passengers);
  } catch (err) {
    console.error("Error fetching passengers:", err);
    res.status(500).json({ error: "Failed to fetch passengers" });
  } finally {
    if (conn) await conn.close();
  }
});

// Create new passenger
app.post("/api/passengers", async (req, res) => {
  const { name, email, phone, passport } = req.body;
  let conn;
  try {
    conn = await pool.getConnection();
    await conn.execute(
      `
      BEGIN AirlinePackage.AddPassenger(:name, :email, :phone, :passport); END;
    `,
      { name, email, phone, passport }
    );
    await conn.commit();
    res.status(201).json({ message: "Passenger added successfully" });
  } catch (err) {
    console.error("Error adding passenger:", err);
    res.status(500).json({ error: "Failed to add passenger" });
  } finally {
    if (conn) await conn.close();
  }
});

// Book a flight
app.post("/api/bookings", async (req, res) => {
  const { passengerId, flightId } = req.body;
  let conn;
  try {
    conn = await pool.getConnection();

    const seatResult = await conn.execute(
      `BEGIN :seatId := AirlinePackage.GetNextAvailableSeat(:flightId); END;`,
      {
        seatId: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER },
        flightId,
      }
    );
    const seatId = seatResult.outBinds.seatId;

    await conn.execute(
      `BEGIN AirlinePackage.AddBooking(:passengerId, :flightId, :seatId); END;`,
      { passengerId, flightId, seatId }
    );
    await conn.commit();

    res.status(200).json({ message: "Booking successful", seatId });
  } catch (err) {
    console.error("Error booking flight:", err);
    res.status(500).json({ error: "Booking failed", details: err.message });
  } finally {
    if (conn) await conn.close();
  }
});

// Get available seat count for a flight
app.get("/api/flights/:flightId/available-seats", async (req, res) => {
  const flightId = parseInt(req.params.flightId);
  let conn;

  try {
    conn = await pool.getConnection();

    const result = await conn.execute(
      `SELECT COUNT(*) AS AvailableSeats
       FROM Aircraft_Seat s
       JOIN Flight f ON s.AircraftID = f.AircraftID
       WHERE f.FlightID = :flightId AND s.IsAvailable = 'Y'`,
      { flightId }
    );

    const availableSeats = result.rows[0][0];

    res.status(200).json({ flightId, availableSeats });
  } catch (err) {
    console.error("Error fetching available seat count:", err);
    res.status(500).json({ error: "Failed to fetch available seats" });
  } finally {
    if (conn) await conn.close();
  }
});

// Example route
app.get("/api/flights", async (req, res) => {
  let conn;
  try {
    conn = await pool.getConnection();
    const result = await conn.execute(`SELECT * FROM flight`);
    res.json(result.rows);
  } catch (err) {
    console.error("Query error:", err);
    res.status(500).json({ error: "Failed to fetch flights" });
  } finally {
    if (conn) await conn.close();
  }
});

app.get("/", (req, res) => {
  res.send("✈️ Airline API up and running");
});

// Start server
initDB().then(() => {
  app.listen(PORT, () => {
    console.log(`🚀 Server listening on http://localhost:${PORT}`);
  });
});
