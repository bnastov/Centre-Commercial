/******************************************************************************
 * Created 2008-08-19.
 *
 * Dijkstra path-finding functions. Adapted from the Dijkstar Python project.
 *
 * Copyright (C) 2008
 *   Wyatt Baldwin <self@wyattbaldwin.com>
 *   All rights reserved
 *
 * Licensed under the MIT license.
 *
 *   http://www.opensource.org/licenses/mit-license.php
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *****************************************************************************/
var dijkstra = {
  single_source_shortest_paths: function(graph, s, d) {
    // Predecessor map for each node that has been encountered.
    // node ID => predecessor node ID
    var predecessors = {};

    // Costs of shortest paths from s to all nodes encountered.
    // node ID => cost
    var costs = {};
    costs[s] = 0;

    // Costs of shortest paths from s to all nodes encountered; differs from
    // `costs` in that it provides easy access to the node that currently has
    // the known shortest path from s.
    // XXX: Do we actually need both `costs` and `open`?
    var open = dijkstra.PriorityQueue.make();
    open.push(s, 0);

    var closest,
        u,
        cost_of_s_to_u,
        adjacent_nodes,
        cost_of_e,
        cost_of_s_to_u_plus_cost_of_e,
        cost_of_s_to_v,
        first_visit;
    while (open) {
      // In the nodes remaining in graph that have a known cost from s,
      // find the node, u, that currently has the shortest path from s.
      closest = open.pop();
      u = closest.value;
      cost_of_s_to_u = closest.cost;

      // Get nodes adjacent to u...
      adjacent_nodes = graph[u] || {};

      // ...and explore the edges that connect u to those nodes, updating
      // the cost of the shortest paths to any or all of those nodes as
      // necessary. v is the node across the current edge from u.
      for (var v in adjacent_nodes) {
        // Get the cost of the edge running from u to v.
        cost_of_e = adjacent_nodes[v];

        // Cost of s to u plus the cost of u to v across e--this is *a*
        // cost from s to v that may or may not be less than the current
        // known cost to v.
        cost_of_s_to_u_plus_cost_of_e = cost_of_s_to_u + cost_of_e;

        // If we haven't visited v yet OR if the current known cost from s to
        // v is greater than the new cost we just found (cost of s to u plus
        // cost of u to v across e), update v's cost in the cost list and
        // update v's predecessor in the predecessor list (it's now u).
        cost_of_s_to_v = costs[v];
        first_visit = (typeof costs[v] === 'undefined');
        if (first_visit || cost_of_s_to_v > cost_of_s_to_u_plus_cost_of_e) {
          costs[v] = cost_of_s_to_u_plus_cost_of_e;
          open.push(v, cost_of_s_to_u_plus_cost_of_e);
          predecessors[v] = u;
        }

        // If a destination node was specified and we reached it, we're done.
        if (v === d) {
          open = null;
          break;
        }
      }
    }

    if (typeof costs[d] === 'undefined') {
      var msg = ['Could not find a path from ', s, ' to ', d, '.'].join('');
      throw new Error(msg);
    }

    return predecessors;
  },

  extract_shortest_path_from_predecessor_list: function(predecessors, d) {
    var nodes = [];
    var u = d;
    var predecessor;
    while (u) {
      nodes.push(u);
      predecessor = predecessors[u];
      u = predecessors[u];
    }
    nodes.reverse();
    return nodes;
  },

  find_path: function(graph, s, d) {
    var predecessors = dijkstra.single_source_shortest_paths(graph, s, d);
    return dijkstra.extract_shortest_path_from_predecessor_list(
      predecessors, d);
  },

  /**
   * A very naive priority queue implementation.
   */
  PriorityQueue: {
    make: function (opts) {
      var T = dijkstra.PriorityQueue,
          t = {},
          opts = opts || {},
          key;
      for (key in T) {
        t[key] = T[key];
      }
      t.queue = [];
      t.sorter = opts.sorter || T.default_sorter;
      return t;
    },

    default_sorter: function (a, b) {
      return a.cost - b.cost;
    },

    /**
     * Add a new item to the queue and ensure the highest priority element
     * is at the front of the queue.
     */
    push: function (value, cost) {
      var item = {value: value, cost: cost};
      this.queue.push(item);
      this.queue.sort(this.sorter);
    },

    /**
     * Return the highest priority element in the queue.
     */
    pop: function () {
      return this.queue.shift();
    }
  }
};

/*
*
*
*
********************MyFunctions***********************
*
*
*
 */
 
 /*
 * C'est la calculPlaceProche qui est appele lors qu'on click sur un magasin
 * Parametres : 
 * 1) le magasin sur lequel on a clicke 
 * 2) pathCord = les coordonnees de chaque sommet
 * 3) prahe = le graphe sur lequel on va appliquer l'algo de dijsktra
  */
function calculPlaceProche( magasin, pathCord, graph ){
    //xcor et ycor du magasin
    var xcor = magasin.x.baseVal.valueAsString;
    var ycor = magasin.y.baseVal.valueAsString;


    
    //On calcule le point le plus proche du magasin selectione en utilisant la theoreme de pythagore 
    var nomPlace;
    var plusProche = { x: 0, y: 150};
    for(var place in pathCord){
        if( Math.sqrt(  Math.pow( Math.abs( pathCord[place].x - xcor ) , 2 ) + 
            Math.pow( Math.abs( pathCord[place].y - ycor ) , 2 ) ) 
            <
        Math.sqrt(  Math.pow( Math.abs( plusProche.x - xcor ) , 2 ) + 
            Math.pow( Math.abs( plusProche.y - ycor ) , 2 ) ) ){
            nomPlace = place;
            plusProche.x = pathCord[nomPlace].x;
            plusProche.y = pathCord[nomPlace].y;
        }
    }
    //On calcule le chemin le plus court de l'entree du polygon (cords 0,150 ) 
    //vers le point le plus proche du magasin clicker                     
    var chemin = findPath( nomPlace, graph );

    //La fonction qui va relier le chemin plus court de l'entree vers le point plus proche avec le magasin clicke
    startAnimation( chemin , xcor , ycor, pathCord );
}
/*
 * Ici on applique l'algo de dijsktra de l'entree du polygon le neud a(0,150) vers le ponts le plus proche
 * de notre magasin 
 */                    
function findPath( nomPlace, graph ){
    
    var path = dijkstra.find_path(graph, 'a', nomPlace );
    return path;
}
/*
 * La fonction qui 
 * 1) initialise le pointeur ( l'objet qui va nous montrer le chemin le plus court )
 * 2) initialise le chemin du pointeur  
 */
function startAnimation( chemin , destX , destY, pathCord ){
    initPointeur( 0 , 150 );
    move( chemin , destX , destY, pathCord );
}
/*
 * Initialisation du pointeur
 */                  
function initPointeur( xcor , ycor ){
    //svg = la groupe contenant tout les magasins
    var svg = document.getElementById("animation");
    var svgNS = "http://www.w3.org/2000/svg";
                        
    var pExistant = document.getElementById("pointeur");                        

    var pointeur = document.createElementNS(svgNS,"circle");
    pointeur.id="pointeur";
    pointeur.setAttributeNS(null , "cx" ,   xcor );	
    pointeur.setAttributeNS(null , "cy" , ycor );	
    pointeur.setAttributeNS(null , "r"  ,   "5" );	
    pointeur.setAttributeNS(null,"fill", "orange");
    
    //Si un autre pointeur existe deja, on le ramplace
    if( pExistant ){
        svg.replaceChild( pointeur , pExistant );
    }
    else{
        svg.appendChild( pointeur );
    }
}
/*
 * Initialisation du chemin du pointeur
 */                   
function move( chemin , destX , destY, pathCord  ){
    //Recuperation de la groupe animation + le pointeur
    var svgNS = "http://www.w3.org/2000/svg";
    var pointeur = document.getElementById("pointeur");
                        
    //Le point de depart a(0,150) = l'entree du polygon      
    var debutXaux = 0;
    var debutYaux = 150;
    var debutX = 0;
    var debutY = 0;
    
    //Creation du chemin du pointeur a partir du chemin plus cour et pathCord = ensembre les chemins
    for( var x = 1 ; x < chemin.length ; x++ ){
                        
        var finXaux = pathCord[chemin[x]].x;
        var finYaux = pathCord[chemin[x]].y;
                            
        var finX =  finXaux - debutXaux ;
        var finY =  finYaux - debutYaux ;
                            
        var courve = "M "+debutX+","+debutY+" c 0,0 0,0 "+finX+","+finY;
        
        var anim = document.createElementNS( svgNS , "animateMotion" );        
                            
        anim.setAttributeNS(null , "id" , x );
        anim.setAttributeNS(null , "path" , courve );                                 
        anim.setAttributeNS(null , "dur" ,  "2s" );
        anim.setAttributeNS(null , "fill" ,  "freeze" );
                            
        if( x == 1){        
            anim.setAttributeNS(null , "begin" , "pointeur.click"  );
        }
        else{
            var begVal = (x - 1)+'.end';
            anim.setAttributeNS(null , "begin" , begVal );
        }
                            
        pointeur.appendChild( anim );
                            
        debutX += finX ;
        debutY += finY ;
                            
        debutXaux = finXaux ;
        debutYaux = finYaux ;
                            
                            
    }
    //Ici on relie juste le dernier point du chemin plus cour avec le magasin                    
    var finX =  destX - debutXaux ;
    var finY =  destY - debutYaux ;
                        
    var begVal = ( chemin.length - 1 )+'.end';
    var courveFinal = "M "+debutX+","+debutY+" c 0,0 0,0 "+finX+","+finY;
                        
    var anim = document.createElementNS( svgNS , "animateMotion" );
    anim.setAttributeNS(null , "path" , courveFinal );                     
    anim.setAttributeNS(null , "begin" , begVal  );                       
    anim.setAttributeNS(null , "dur" ,  "2s" );
    anim.setAttributeNS(null , "fill" ,  "freeze" );
    pointeur.appendChild( anim );                        
} 


