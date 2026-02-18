const https = require('https');

module.exports = async (req, res) => {
  // CORS Headers
  res.setHeader('Access-Control-Allow-Credentials', true);
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET,OPTIONS,PATCH,DELETE,POST,PUT');
  res.setHeader(
    'Access-Control-Allow-Headers',
    'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version'
  );

  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  const { skey, st, page } = req.query;
  const url = `https://dorar.net/dorar_api.json?skey=${encodeURIComponent(skey || '')}&st=${st || 'a'}&page=${page || '1'}`;

  const options = {
    headers: {
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      'Accept': 'application/json',
      'Referer': 'https://dorar.net/',
    }
  };

  https.get(url, options, (apiRes) => {
    let data = '';
    apiRes.on('data', (chunk) => {
      data += chunk;
    });
    apiRes.on('end', () => {
      try {
        // نرسل البيانات كما هي (Raw Text أو JSON)
        res.status(200).send(data);
      } catch (e) {
        res.status(500).json({ error: 'Error parsing response' });
      }
    });
  }).on('error', (err) => {
    res.status(500).json({ error: err.message });
  });
};
