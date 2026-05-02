sholat(){
    TODAY=$(date +%Y-%m-%d)
    curl -s "https://raw.githubusercontent.com/lakuapik/jadwalsholatorg/master/adzan/malang/2024/05.json" | jq --arg TODAY "$TODAY" '.[] | select(.tanggal==$TODAY)'
}

suhu(){
    local city="${1:-Malang,id}" # Default to Malang, Indonesia if no argument is given
    local api_key="437faf056b3415d3db0335962fbc7eb0" # Use your actual API key here
    local units="metric"
    local url="http://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${api_key}&units=${units}"

    curl -s "${url}" | jq '.main.temp'
}
