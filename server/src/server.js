require('dotenv').config();
const express = require('express');
const pool = require('./config/db');
//const bcrypt = require('bcryptjs');

const app = express();
const port = process.env.PORT || 8080;
app.use(express.json());

const resources = ['inquiries', 'answers', 'users'];

get_resources();
add_resources();

// Start the server
app.get('/', (req, res) => { res.send('Backend server is running!'); });
app.listen(port, "0.0.0.0", () => { console.log(`Server is running on http://0.0.0.0:${port}`); });

// == Server Functions ==

// -- Register and Login --

// Register

app.post('/api/register', async (req, res) => {
	try {
		const { username, password } = req.body;

		if (!username || !password) {
			return res.status(400).json({ message: 'Username and password are required' });
		}

		//const salt = bcrypt.genSaltSync(10);
		//const hashedPassword = await bcrypt.hashSync(password, salt);

		const query = `INSERT INTO users (username, password) VALUES ($1, $2) RETURNING user_id, username`;
		const result = await pool.query(query, [username, password]); //

		res.status(201).json({ success: true, user: result.rows[0] });

	} catch (error) {
		console.error('Registration error:', error);
		if (error.code === '23505') {
			return res.status(400).json({ message: 'Username already exists' });
		}
		res.status(500).json({ message: 'Registration failed', error: error.message });
	}
});

// Login

app.post('/api/login', async (req, res) => {
	try {
		const { username, password } = req.body;

		if (!username || !password) {
			return res.status(400).json({ message: 'Username and password are required' });
		}

		const result = await pool.query(`SELECT * FROM users WHERE username = $1`, [username]); //

		if (result.rows.length === 0) {
			return res.status(401).json({ message: 'Invalid username or password' });
		}

		const user = result.rows[0];

		const isMatch = (password === user.password)

		if (!isMatch) {
			return res.status(401).json({ message: 'Invalid username or password' });
		}

		res.status(200).json({ 
			success: true, 
			message: 'Login successful', 
			user: { id: user.id, username: user.username } 
		});

	} catch (error) {
		console.error('Login error:', error);
		res.status(500).json({ message: 'Login failed', error: error.message });
	}
});

// -- Q and A --

// Get QnA (Question and all the answers relating to it)
function get_qna() {
	app.get(`/api/qna`, async (req, res) => {
		try {
			const { inquiry_id } = req.body;
			const { inquiry_res } = await pool.query(`SELECT * FROM inquiries WHERE inquiry_id = $1`, [inquiry_id]);
			const { answers_res } = await pool.query(`SELECT * FROM answers WHERE inquiry_id = $1`, [inquiry_id]);
			
			res.json({
				inquiry: inquiry_res.rows[0] || null,
				answers: answers_res.rows);
			});
				
		} catch(error) {
			console.error(`Error fetching ${resource}:`, error);
			res.status(500).json({ message: 'Database query error' });
		}
	});
}

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

