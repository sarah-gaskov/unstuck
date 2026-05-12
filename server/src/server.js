require('dotenv').config();
const express = require('express');
const pool = require('./config/db');
const bcrypt = require('bcryptjs');

const app = express();
const port = process.env.PORT || 8080;
app.use(express.json());

const resources = ['inquiries', 'answers', 'users'];

get_resources();
add_resources();
get_board();

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

		const salt = await bcrypt.genSaltSync(10);
		const hashedPassword = await bcrypt.hashSync(password, salt);

		const query = `INSERT INTO users (username, password) VALUES ($1, $2) RETURNING user_id, username`;
		const result = await pool.query(query, [username, hashedPassword]); //

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

		const isMatch = await bcrypt.compare(password, user.password)

		if (!isMatch) {
			return res.status(401).json({ message: 'Invalid username or password' });
		}

		res.status(200).json({ 
			success: true, 
			message: 'Login successful', 
			user: { id: user.user_id, username: user.username, is_mechanic: user.is_mechanic }
		});

	} catch (error) {
		console.error('Login error:', error);
		res.status(500).json({ message: 'Login failed', error: error.message });
	}
});

// Add Guest

app.post('/api/login-guest', async (req, res) => {
	try {
		const guestId = Math.floor(100000 + Math.random() * 900000); //TODO: Have the DB do this instead
		const username = `Guest_${guestId}`;
		
		const salt = await bcrypt.genSalt(10);
		const hashedPassword = await bcrypt.hash(guestId.toString(), salt);
		
		const query = `INSERT INTO users (username, password, is_anonymous) VALUES ($1, $2, true) RETURNING user_id, username`;
		const result = await pool.query(query, [username, hashedPassword]);
		
		res.status(200).json({ success: true, username: result.rows[0].username, user_id: result.rows[0].user_id });
	} catch (error) {
		console.error('Guest login error:', error);
		res.status(500).json({ message: 'Guest login failed' });
	}
});

// Remove Guest

app.delete('/api/delete-guest', async (req, res) => {
	try {
		const { username } = req.body;
		await pool.query(`DELETE FROM users WHERE username = $1 AND is_anonymous = true`, [username]);
		res.status(200).json({ success: true, message: 'Guest deleted' });
	} catch (error) {
		console.error('Error deleting guest:', error);
		res.status(500).json({ message: 'Failed to delete guest' });
	}
});

// -- Q and A --

// Get notifications
app.get('/api/notifications/:userId', async (req, res) => {
	try {
		const { userId } = req.params;
		const { rows } = await pool.query(
			`SELECT * FROM notifications WHERE user_id = $1 ORDER BY created_at DESC`,
			[userId]
		);
		res.json(rows);
	} catch (error) {
		console.error('Error fetching notifications:', error);
		res.status(500).json({ message: 'Database query error' });
	}
});

// Mark a notification as read
app.patch('/api/notifications/:id/read', async (req, res) => {
	try {
		const { id } = req.params;
		await pool.query(`UPDATE notifications SET is_read = true WHERE notification_id = $1`, [id]);
		res.status(200).json({ success: true });
	} catch (error) {
		console.error('Error marking notification as read:', error);
		res.status(500).json({ message: 'Database error' });
	}
});

// Add an answer and notify the asker
app.post('/api/add-answer', async (req, res) => {
	try {
		const { inquiry_id, body, user_id } = req.body;

		const answerResult = await pool.query(
			`INSERT INTO answers (inquiry_id, body, user_id) VALUES ($1, $2, $3) RETURNING *`,
			[inquiry_id, body, user_id]
		);

		const inquiryResult = await pool.query(
			`SELECT asker_id, title FROM inquiries WHERE inquiry_id = $1`,
			[inquiry_id]
		);

		if (inquiryResult.rows.length > 0) {
			const { asker_id, title } = inquiryResult.rows[0];
			await pool.query(
				`INSERT INTO notifications (user_id, message) VALUES ($1, $2)`,
				[asker_id, `Your question "${title}" received an answer.`]
			);
		}

		res.status(200).json({ success: true, data: answerResult.rows[0] });
	} catch (error) {
		console.error('Error adding answer:', error);
		res.status(500).json({ message: 'Database error', error: error.message });
	}
});

// Get questions posted by a specific user
app.get('/api/my-questions/:userId', async (req, res) => {
	try {
		const { userId } = req.params;
		const { rows } = await pool.query(
			`SELECT * FROM inquiries WHERE asker_id = $1 ORDER BY created_at DESC`,
			[userId]
		);
		res.json(rows);
	} catch (error) {
		console.error('Error fetching my questions:', error);
		res.status(500).json({ message: 'Database query error' });
	}
});

// Get answers submitted by a specific mechanic with the asker's username
app.get('/api/my-answers/:userId', async (req, res) => {
	try {
		const { userId } = req.params;
		const { rows } = await pool.query(
			`SELECT a.*, u.username
			 FROM answers a
			 JOIN inquiries i ON a.inquiry_id = i.inquiry_id
			 JOIN users u ON i.asker_id = u.user_id
			 WHERE a.user_id = $1
			 ORDER BY a.created_at DESC`,
			[userId]
		);
		res.json(rows);
	} catch (error) {
		console.error('Error fetching my answers:', error);
		res.status(500).json({ message: 'Database query error' });
	}
});

// Get board (all questions and all relevant answers)
function get_board() {
	app.get('/api/board', async (req, res) => {
		try {
			const query = `
				SELECT i.*, 
					   COALESCE(
						   json_agg(
                               to_jsonb(a.*) || jsonb_build_object('username', u.username)
                           ) FILTER (WHERE a.inquiry_id IS NOT NULL), 
						   '[]'
					   ) as answers 
				FROM inquiries i 
				LEFT JOIN answers a ON i.inquiry_id = a.inquiry_id 
				LEFT JOIN users u ON a.user_id = u.user_id
				GROUP BY i.inquiry_id
				ORDER BY i.inquiry_id DESC;
			`;
			const { rows } = await pool.query(query);
			res.json(rows);
		} catch (error) {
			console.error('Error fetching QnA:', error);
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

