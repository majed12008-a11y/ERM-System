import express from 'express';
const app = express();
app.use(express.json());
app.post('/test', (req, res) => {
  console.log('Got request');
  res.json({ ok: true });
  console.log('Sent response');
});
app.listen(3001, () => console.log('UP'));
