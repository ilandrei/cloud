
const searchClicked = async () =>{
    var providedIp = document.getElementById('search-input').value
    var url = `http://localhost:42069/api?ip=${providedIp}`
    let response = await fetch(url);
    if (response.ok){
        response.json().then(data => {
            console.log(data)
            document.body.style.backgroundImage = `url(${data.url})`;
            document.getElementById('page-title').innerHTML = "ip.img: "+ data.country
        })
    }
    else{
        console.log(response.status)
    }
}