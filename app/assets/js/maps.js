var platform = new H.service.Platform({
  'apikey': 'tsfTRvQK_fj7o7rS-8jw0jODSSm-g-5mUSnmEA80skw'
});
// Obtain the default map types from the platform object:
var defaultLayers = platform.createDefaultLayers();

// Get an instance of the geocoding service:
var service = platform.getSearchService();

// Call the geocode method with the geocoding parameters,
// the callback and an error callback function (called if a
// communication error occurs):
// service.geocode(
//   {
//     q: "via teofilo folengo 34, roma"
//   },
//   (result) => {
//     result.items.forEach(
//       (item) => {
//         map.addObject(new H.map.Marker(item.position));
//       });
//     map.setCenter(result.items[0].position)
//   },
//   alert);
// Instantiate (and display) a map object:
var map = new H.Map(
  document.getElementById('mapContainer'),
  defaultLayers.vector.normal.map,
  {
    zoom: 10,
    center: { lat: -79.4063075, lng: 0.3149312 }
  });

var eventcoords = { lat: $("#mapContainer").attr('data-lat') , lng: $("#mapContainer").attr('data-lng') }
if ( eventcoords.lat == undefined && eventcoords.lng == undefined ){
  navigator.geolocation.getCurrentPosition( (position) => { map.setCenter({ lat: position.coords.latitude, lng: position.coords.longitude }) } );
}
else {
  var Marker = new H.map.Marker(eventcoords);
  map.addObject(Marker);
  map.setCenter(eventcoords);
  map.setZoom(17);
}

var behavior = new H.mapevents.Behavior(new H.mapevents.MapEvents(map));

window.addEventListener('resize', () => map.getViewPort().resize());

// Create the default UI:
var ui = H.ui.UI.createDefault(map, defaultLayers);


function setMarker(coordinate,label){
  map.removeObjects(map.getObjects());  
  ui.getBubbles().forEach((b)=>{b.close();ui.removeBubble(b)});
  map.addObject(new H.map.Marker(coordinate));
  map.setCenter(coordinate);
  map.setZoom(16);
  document.getElementById("event_cords").value = `${coordinate.lat},${coordinate.lng}`;
  document.getElementById("event_where").value = `${label}`;
}


/**
 * Creates a new marker and adds it to a group
 * @param {H.map.Group} group       The group holding the new marker
 * @param {H.geo.Point} coordinate  The location of the marker
 * @param {String} html             Data associated with the marker
 */
function addMarkerToGroup(group, coordinate, label) {
  var marker = new H.map.Marker(coordinate);
  // add custom data to the marker
  const html = `<div> ${label} <button type="button" class="btn btn-primary" onclick="return setMarker({lat:${coordinate.lat},lng:${coordinate.lng}},'${label}');">Set Place</button> </div>`
  marker.setData(html);
  group.addObject(marker);
}

function SearchPlaces(e) {
  var query = document.getElementById("mapSearchInput").value;
  map.removeObjects(map.getObjects());
  var group = new H.map.Group();

  map.addObject(group);

  // add 'tap' event listener, that opens info bubble, to the group
  group.addEventListener('tap', function (evt) {
    // event target is the marker itself, group is a parent event target
    // for all objects that it contains
    var bubble =  new H.ui.InfoBubble(evt.target.getGeometry(), {
      // read custom data
      content: evt.target.getData()
    });
    // show info bubble
    ui.addBubble(bubble);
  }, false);
  service.geocode(
    {
      q: query
    },
    (result) => {
      result.items.forEach(
        (item) => {
          addMarkerToGroup(group,item.position,item.address.label);
        });
        var bound = group.getBoundingBox();
        map.getViewModel().setLookAtData({
          bounds: new H.geo.Rect( bound.getTop()*1.002, bound.getLeft()*1.002, bound.getBottom()/1.002, bound.getRight()/1.002 )
        })
    },
    ()=>{});
}

if (document.getElementById("mapsearch"))
  document.getElementById("mapsearch").addEventListener("click",SearchPlaces);

function setEventTitle(){
  var query = document.getElementById("mapEventInfo").innerHTML;
  service.geocode(
    {
      q: query
    },
    (result) => {
      const item = result.items[0];
      if(item.title != item.address.label)
        document.getElementById("mapEventInfo").innerHTML = `<h5>${item.title}</h5>${item.address.street},
          ${item.address.houseNumber}, ${item.address.postalCode} ${item.address.city}, ${item.address.countryName}`;
    },
    ()=>{});
}

if (document.getElementById("mapEventInfo"))
  setEventTitle();
