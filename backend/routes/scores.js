import express from 'express';
import jwt from 'jsonwebtoken';
import db from '../database.js';

const router = express.Router();
const JWT_SECRET = process.env.JWT_SECRET || 'adventure_run_secret_key';

function authenticate(req, res, next) {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'No token provided' });
  }

  const token = authHeader.split(' ')[1];
  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.user = decoded;
    next();
  } catch (err) {
    return res.status(401).json({ error: 'Invalid token' });
  }
}

router.post('/', authenticate, (req, res) => {
  const { score } = req.body;

  if (typeof score !== 'number' || score < 0) {
    return res.status(400).json({ error: 'Valid score required' });
  }

  db.get(
    'SELECT MAX(score) as best FROM scores WHERE user_id = ?',
    [req.user.id],
    (err, row) => {
      if (err) {
        console.error('Score check error:', err);
        return res.status(500).json({ error: 'Failed to check score' });
      }

      const bestScore = row?.best || 0;
      if (score > bestScore) {
        db.run(
          'INSERT INTO scores (user_id, score) VALUES (?, ?)',
          [req.user.id, score],
          function (err) {
            if (err) {
              console.error('Score save error:', err);
              return res.status(500).json({ error: 'Failed to save score' });
            }
            res.json({ message: 'New high score!', score });
          }
        );
      } else {
        res.json({ message: 'Score not higher than best', bestScore, score });
      }
    }
  );
});

router.get('/leaderboard', (req, res) => {
  db.all(
    `SELECT users.username, MAX(scores.score) as score
     FROM scores 
     INNER JOIN users ON scores.user_id = users.id 
     GROUP BY users.id
     ORDER BY scores.score DESC 
     LIMIT 10`,
    [],
    (err, rows) => {
      if (err) {
        console.error('Leaderboard error:', err);
        return res.status(500).json({ error: 'Failed to get leaderboard' });
      }
      res.json(rows);
    }
  );
});

// Get max score for logged in user
router.get('/max', authenticate, (req, res) => {
  db.get(
    `SELECT MAX(score) as score FROM scores WHERE user_id = ?`,
    [req.user.id],
    (err, row) => {
      if (err) {
        console.error('Max score error:', err);
        return res.status(500).json({ error: 'Failed to get max score' });
      }
      res.json({ score: row?.score || 0 });
    }
  );
});

export default router;