const debug = require('debug')('weathermap');
const Dotenv = require('dotenv').config();

const Koa = require('koa');
const router = require('koa-router')();
const fetch = require('node-fetch');
const cors = require('kcors');

const appId = process.env.APPID || console.log("APPID_ERROR");
const mapURI = process.env.MAP_ENDPOINT || console.log("MAP_ENDPOINT_ERROR");
const targetCity = process.env.TARGET_CITY || console.log("TARGET_CITY_ERROR");

const port = process.env.PORT || console.log("PORT_ERROR");

const app = new Koa();

app.use(cors());

const fetchWeather = async () => {
  const endpoint = `${mapURI}/weather?q=${targetCity}&appid=${appId}&`;
  const response = await fetch(endpoint);

  return response ? response.json() : {}
};

router.get('/api/weather', async ctx => {
  const weatherData = await fetchWeather();

  ctx.type = 'application/json; charset=utf-8';
  ctx.body = weatherData.weather ? weatherData.weather[0] : {};
});

app.use(router.routes());
app.use(router.allowedMethods());

app.listen(port);

console.log(`App listening on port ${port}`);
