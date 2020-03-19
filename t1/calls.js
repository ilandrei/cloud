const axios = require('axios')
const config = require('./config.json')


const getCountryOfIP = async (IP) => {
  console.log(IP)
  var response = await axios.get(`https://api.ipgeolocation.io/ipgeo?apiKey=${config.ip_api_key}&ip=${IP}`)
  console.log(response.country_name)
  return response.data.country_name
}

const getImagesForKeyWord = async (keyWord) => {
  var response = await axios.get(`https://api.unsplash.com/search/photos?query=${keyWord}&client_id=${config.unsplash_api_key}`)
  var results = response.data.results
  var urls = results.map(x => x.urls.full)
  return urls

}

const getRandomNr = async (max) => {
  var response = await axios.get(`https://www.random.org/integers/?num=1&min=1&max=${max}&col=1&base=10&format=plain`)
  return response.data
}

const getImageFromIP = async (IP)=>{
  const country = await getCountryOfIP(IP)
  const urls = await getImagesForKeyWord(country)
  const number = await getRandomNr(urls.length) - 1
  return {'country':country,'url':urls[number]}
}

exports.getImageFromIp = getImageFromIP