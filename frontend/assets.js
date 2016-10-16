// require all assets
const req = require.context('./images/', true, /\.(jpg|jpeg|png|gif|svg|ico)$/);
req.keys().forEach(req);
