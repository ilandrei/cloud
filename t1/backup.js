const axios = require('axios')
const config = require('./config.json')

const getCountryOfIP = async (IP) => {
    axios.get(`https://api.ipgeolocation.io/ipgeo?apiKey=${config.ip_api_key}&ip=${IP}`)
  .then(function (response) {
    return response.data.country_name
  })
  .catch(function (error) {
    console.log(error);
    return undefined
  })
}

const getImagesForKeyWord = async (keyWord) => {
    axios.get(`https://api.unsplash.com/search/photos?query=${keyWord}&client_id=${config.unsplash_api_key}`)
    .then(function (response) {
      var results = response.data.results
      var urls = results.map(x => x.urls.full)
      return urls
    })
    .catch(function (error) {
      console.log(error);
      return undefined
    })
}

const getRandomNr = async (max) => {
  axios.get(`https://www.random.org/integers/?num=1&min=1&max=${max}&col=1&base=10&format=plain`)
  .then(function (response) {
    console.log(response.data)
    return response.data
  })
  .catch(function (error) {
    console.log(error);
    return undefined
  })
}

const getImageFromIP = async (IP)=>{
  const country = await getCountryOfIP(IP)
  console.log(country)
  const urls = await getImagesForKeyWord(country)
  console.log(urls)
  const number = await getRandomNr(urls.length) - 1
  console.log(urls[number])
  return urls[number] 
}

getImageFromIP("92.86.185.101")
// export {getCountryOfIP,getImagesForKeyWord,getRandomNr,getImageFromIP}