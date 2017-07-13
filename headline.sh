#!/bin/bash

pushd "$(dirname "$0")"

macaddress=`cat config/macaddress`
if ! [[ `curl bbox/api/v1/hosts | jq ".[].hosts.list[] | select(.macaddress==\"$macaddress\") | {lastseen}"` == *0* ]]
then
    # nobody home
    echo "Nope"
    popd
    exit 0
fi

speak=./speak.sh

mpg123 res/start.mp3

$speak "Bonjour"
$speak `LC_ALL=fr_FR.UTF-8 date "+%A %e %B"`

$speak "Météo du jour:"
API_KEY=`cat auth/wundergroundApiKey`
data=`curl "http://api.wunderground.com/api/$API_KEY/forecast/lang:FR/q/France/Strasbourg.json"`
text_metric=`echo $data | jq '.forecast.txt_forecast.forecastday[0].fcttext_metric'`
$speak "$text_metric"

API_KEY=`cat auth/googleMapsApiKey`
depart=`date --date="07:35" "+%s"`
domicile=`cat config/domicile`
boulot=`cat config/boulot`
data=`curl "https://maps.googleapis.com/maps/api/directions/json?origin=$domicile&destination=$boulot&departure_time=$depart&traffic_model=best_guess&key=$API_KEY"`
temps=`echo $data | jq '.routes[0].legs[0].duration_in_traffic.text'`
$speak "Temps de trajet: $temps"

$speak `find . -name "*Plugin.py" -exec {} \;`

popd
