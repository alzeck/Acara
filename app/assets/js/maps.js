var platform = new H.service.Platform({
  'apikey': 'tsfTRvQK_fj7o7rS-8jw0jODSSm-g-5mUSnmEA80skw'
});
// Obtain the default map types from the platform object:
var defaultLayers = platform.createDefaultLayers();

// Instantiate (and display) a map object:
var map = new H.Map(
  document.getElementById('mapContainer'),
  defaultLayers.vector.normal.map,
  {
    zoom: 10,
    center: { lat: 41.9435446, lng: 12.5485884 }
  });

// Create the default UI:
var ui = H.ui.UI.createDefault(map, defaultLayers);