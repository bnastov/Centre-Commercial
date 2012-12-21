var map= null;
var imageMap =null;
var imageMap1='map/plan1.png';
var imageMap2='map/plan2.png';
var markersArray = [];

var location2 = new google.maps.LatLng(43.6360, 3.8579);

 $().ready(function() {
        manipXML();
		initialiser();
		//afficherMarker();
 });
 
(function($) {

function CoordMapType() {}

        CoordMapType.prototype.tileSize = new google.maps.Size(1000,1000);
        CoordMapType.prototype.maxZoom = 16;
		CoordMapType.prototype.minZoom = 12;
        CoordMapType.prototype.getTile = function(coord, zoom, ownerDocument) {
                var conteneur = ownerDocument.createElement('div');
                conteneur.style.width = this.tileSize.width + 'px';
                conteneur.style.height = this.tileSize.height + 'px';
                return conteneur;
        };

        CoordMapType.prototype.name = "map personnaliser";
        var testMapType = new CoordMapType();

initialiser = function() {

                
                var Centre = new google.maps.LatLng(43.632598, 3.865029);
                var Options = {
                        zoom: 15,
                        center: Centre,
                        mapTypeControl: false,
                        streetViewControl: false,
                };
                map = new google.maps.Map(document.getElementById("map"),Options);

                map.mapTypes.set('perso',testMapType);
                map.setMapTypeId('perso');
               

                var Limites = new google.maps.LatLngBounds(new google.maps.LatLng(43.6304178, 3.8578111), new google.maps.LatLng(43.6362320, 3.8704443));
				
                overlayprincipal = new MainOverlay(Limites, imageMap1, map);
                map.setZoom(15);
                map.setCenter(Centre);
				// Definition des limites de notre overlay - a perfectionner !
              google.maps.event.addListener(map,'drag',function() {
			  checkBounds(); 
			  });
			  google.maps.event.addListener(map,'zoom_changed',function() {
			
					if (map.getZoom() > 15){
						overlayprincipal = new MainOverlay(Limites, imageMap2, map);
						} 
					if (map.getZoom() < 16) {
						overlayprincipal = new MainOverlay(Limites, imageMap1, map);
						} 
		});
			  
			 
}

		
        /* Fonctions pour l'overlay principal */
        
        function MainOverlay(limites, image, map) {
                this.bounds_ = limites;
                this.image_ = image;
                this.setMap(map);
        }

        MainOverlay.prototype = new google.maps.OverlayView();
                
        MainOverlay.prototype.draw = function() {

                var Projection = this.getProjection();
                var SOpx = Projection.fromLatLngToDivPixel(this.bounds_.getSouthWest());
                var NEpx = Projection.fromLatLngToDivPixel(this.bounds_.getNorthEast());

                var conteneur = this.div_;
                conteneur.style.left = SOpx.x + 'px';
                conteneur.style.top = NEpx.y + 'px';
                conteneur.style.width = (NEpx.x - SOpx.x) + 'px';
                conteneur.style.height = (SOpx.y - NEpx.y) + 'px';
        }

        MainOverlay.prototype.onRemove = function() {
                this.div_.parentNode.removeChild(this.div_);
                this.div_ = null;
        }       

        MainOverlay.prototype.onAdd = function() {
                var conteneur = document.createElement('div');
                conteneur.id= "mainoverlay"
                conteneur.style.border = "none";
                conteneur.style.borderWidth = "0px";
                conteneur.style.position = "absolute";
                
                var image = document.createElement("img");
                image.src = this.image_;
                image.style.width = "100%";
                image.style.height = "100%";

                conteneur.appendChild(image);
                this.div_ = conteneur;
                var paneaux = this.getPanes();
                paneaux.overlayLayer.appendChild(conteneur);
        }
		
	
   
function checkBounds() {    
		if(! allowedBounds.contains(map.getCenter())) {
		  var C = map.getCenter();
		  var X = C.lng();
		  var Y = C.lat();

		  var AmaxX = allowedBounds.getNorthEast().lng();
		  var AmaxY = allowedBounds.getNorthEast().lat();
		  var AminX = allowedBounds.getSouthWest().lng();
		  var AminY = allowedBounds.getSouthWest().lat();

		  if (X < AminX) {X = AminX;}
		  if (X > AmaxX) {X = AmaxX;}
		  if (Y < AminY) {Y = AminY;}
		  if (Y > AmaxY) {Y = AmaxY;}

		  map.setCenter(new google.maps.LatLng(Y,X)); 
		}
	}
        
 manipXML =function (){
	$.ajax( {
            type: "GET",
            url: "result.xml",
            dataType: "xml",
            success: function(xml) 
			{ 
			 {
						var i =0;
						$(xml).find('etage').each(
						function(){
							
							var niveau = $(this).attr('niveau');
							
								location2 = new google.maps.LatLng(43.6360, 3.8579);
								$('<div class="items" ></div>').html('<a href="">'+niveau+'</a>').appendTo('#Div_XML');
								$(this).find('magasin').each(   
								function()
								{	 
									var type = $(this).attr('type');
									var nom = $(this).attr('nom');
									var titre = "type :"+type+" Nom :"+nom;
									var x = new Array();
									x[i]=$(this).find('x').text();
									var y = new Array();
									y[i]= $(this).find('y').text();
									//$('<div class="items" ></div>').html('<a href="">'+y[i]+'x:'+x[i]+'</a>').appendTo('#Div_XML');
									location2 = new google.maps.LatLng(43.6360-(0.00002*y[i]), 3.8599+(0.00003*x[i]));
									addMarker(location2 , titre);
									i++;
								
								});
							
						});
						
                      }
			}
        }
      );            


	  }
		


function addMarker(location ,titre) {

  marker = new google.maps.Marker({
	
    position: location,
    map: map,
	title:titre
	
  });
   markersArray.push(marker);
 
}
afficherMarker =function() {
if (markersArray) {
    for (i in markersArray) {
      markersArray[i].getPosition();
	  
	  }
	}
}


})(jQuery);
