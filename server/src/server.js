require('dotenv').config();
const express = require('express');
const pool = require('./config/db');

const app = express();
const port = process.env.PORT || 8080;
app.use(express.json());

const resources = ['inquiries', 'answers'];

get_resources();
add_resources();

// Start the server
app.get('/', (req, res) => { res.send('Backend server is running!'); });
app.listen(port, "0.0.0.0", () => { console.log(`Server is running on http://0.0.0.0:${port}`); });

// == Server Functions ==

// Database -> frontend
function get_resources() {
	resources.forEach((resource) => {
		app.get(`/api/${resource}`, async (req, res) => {
			try {
				const { rows } = await pool.query(`SELECT * FROM ${resource}`);
				res.json(rows);
			} catch(error) {
				console.error(`Error fetching ${resource}:`, error);
				res.status(500).json({ message: 'Database query error' });
			}
		});
	});
}

// Frontend -> Database
function add_resources() {
	app.post('/api/create-entry', async (req, res) => {
	try {
		// Data must contain json
		const { resource, data } = req.body;

		// Validate resource
		if (!resources.includes(resource)) {
			return res.status(400).json({ message: 'Invalid resource specified' });
		}

		if (!data || Object.keys(data).length === 0) {
			return res.status(400).json({ message: 'No data provided' });
		}
			
		// Build the query
		const keys = Object.keys(data);
		const values = Object.values(data);
            
		// Creates placeholders
		const placeholders = keys.map((_, index) => `$${index + 1}`).join(', '); 
		const columns = keys.join(', ');

		const query = `INSERT INTO ${resource} (${columns}) VALUES (${placeholders}) RETURNING *`;
            
		const result = await pool.query(query, values);

		res.status(200).json({ success: true, data: result.rows[0] });

		} catch(error) {
			console.error('Error adding resource:', error);
			res.status(500).json({ message: 'Database insert error', error: error.message });
		}
	});
}

