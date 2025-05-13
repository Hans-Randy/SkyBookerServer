# SkyBooker Server

A Node.js server application for managing airline bookings and related operations. This server provides a RESTful API interface for airline booking management.

## Features

- RESTful API endpoints for airline operations
- Oracle Database integration
- Environment-based configuration
- Express.js server framework

## Prerequisites

- Node.js (v14 or higher)
- Oracle Database
- Oracle Instant Client

## Installation

1. Clone the repository:

```bash
git clone [repository-url]
cd SkyBookerServer
```

2. Install dependencies:

```bash
npm install
```

3. Set up environment variables:
   Create a `.env` file in the root directory with the following variables:

```
DB_USER=your_db_username
DB_PASSWORD=your_db_password
DB_CONNECT_STRING=your_db_connection_string
```

4. Set up the database:

- `airline_database_setup.sql`

## Running the Server

Start the server:

```bash
node server.js
```

The server will start on the default port (typically 3000).

## API Endpoints

The server provides various endpoints for airline booking operations. Refer to the server.js file for detailed endpoint documentation.

## Dependencies

- express: ^4.21.2
- dotenv: ^16.4.7
- oracledb: ^6.8.0

## Project Structure

- `server.js` - Main server application file
- `airline_database_setup.sql` - Database schema and initial setup
- `airline_package_tests.sql` - Database package tests
- `.env` - Environment configuration (create this file)
