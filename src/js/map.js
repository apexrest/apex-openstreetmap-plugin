function updateMap(map, mapData, filePrefix = "") {
  var allMarkers = []
    for (var markerData of mapData.markers) {
      var icon = getMarkerIcon('blue')
      if (markerData.hasOwnProperty('color')) {
        icon = getMarkerIcon(markerData.color)
      }

      var marker = L.marker(markerData.point, {icon})
      if (markerData.hasOwnProperty('text')) {
        marker.bindPopup(markerData.text)
      }
      
      marker.addTo(map)
      allMarkers.push(markerData.point)
    }

    for (var polygonData of mapData.polygons) {
      console.log(polygonData)
      var color = 'blue'
      if (polygonData.hasOwnProperty('color')) {
        color = polygonData.color
      }

      var polygon = L.polygon(polygonData.points, {color})
      if (polygonData.hasOwnProperty('text')) {
        polygon.bindPopup(polygonData.text)
      }
      
      polygon.addTo(map)
      allMarkers = allMarkers.concat(polygonData.points)
    }

    map.fitBounds(allMarkers)

    function getMarkerIcon(color) {
      return L.icon({
        iconRetinaUrl: filePrefix + 'assets/markers/marker-icon-2x-' + color + '.png',
        iconUrl: filePrefix + 'assets/markers/marker-icon-' + color + '.png',
        shadowUrl: filePrefix + 'assets/markers/marker-shadow.png',
        iconSize: [25, 41],
        iconAnchor: [12, 41],
        popupAnchor: [1, -34],
        shadowSize: [41, 41]
      })
    }
}
