/*
 * Les fonctions pour la generation dynamique du formulaire * 
 * 
 */

/*
 * GenereForm() genere la premier etape de la selection 
 * c'est a dire le choix d'etage + elle genere les ecouteurs
 * d'evenement pour le choix fait
 * 
 */
function GenereForm(){
    //Recuperation du formulaire
    var formulaire = document.getElementById("formulaire");
    
    //Creation de la premiere selection
    var SelectEtage = document.createElement('select');
    SelectEtage.id = balatt[0];
    SelectEtage.name = balatt[0];
    formulaire.appendChild( SelectEtage );                         
    
    //L'ajoute de l'option All
    var optionAll = document.createElement('option');      
    optionAll.selected="selected";
    optionAll.value="All";
    optionAll.innerHTML = "All";
    SelectEtage.appendChild( optionAll );
    
    //l'ajoute d'autres choix a partir de la variable contenu
    for(var i=0; i < contenu.length; i++){
        var option = document.createElement('option');
        option.value=contenu[i][0];
        option.innerHTML = contenu[i][0];
        SelectEtage.appendChild(option);
    }
                    
    var hidden = document.createElement( "input" );
    hidden.id = "hidden";
    hidden.type = "hidden";
    hidden.name = balatt[1];
    hidden.value = "All";
    formulaire.appendChild( hidden );
                    
    SelectEtage.addEventListener('change', EtageChosed, false);
}

/*
 * EtageChosed() sert a faire la liaison avec la fonciton qui va nous generer les
 * magasins de l'etage choisi et en plus gere le choix du All
 * 
 */

function EtageChosed(e){
    var formulaire = document.getElementById("formulaire");
    var existe = document.getElementById(balatt[1]);
    var existe1 = document.getElementById(balatt[2]);
    var existe2 = document.getElementById( "hidden" );

    if(existe1){
        formulaire.removeChild( existe1 );
    }
    if(existe){
        formulaire.removeChild( existe );
    }
    if(existe2){
        formulaire.removeChild( existe2 );
    }
    //Si on a selectione All => ne fait pas la deuxieme etape
    if( e.target.value == "All" ){
        var hidden = document.createElement( "input" );
        hidden.type = "hidden";
        hidden.name = balatt[1];
        hidden.value = "All";
        formulaire.appendChild( hidden );
    }
    //Sinon fait la deuxieme etape
    else{
        var SelectType = document.createElement('select');
        SelectType.id = balatt[1];
        SelectType.name = balatt[1];
        CreateMagasinType(SelectType, e.target.value);    
        formulaire.appendChild( SelectType ); 
    }
}

/*
 * CreateMagasinType() la fonction qui fait la deuxieme etape de la generation dynamique
 * qui est la generation des types de magasin de l'etage choisit a partir de la variable 
 * contenu
 */
function CreateMagasinType(type, etage){
                        
    var optionAll = document.createElement('option');      
    optionAll.selected="selected";
    optionAll.value="All";
    optionAll.innerHTML = "All";
    type.appendChild( optionAll );

    for(var i=0;i < contenu.length; i++){
        if(contenu[i][0]==etage){
            for(var j=0;j < contenu[i][1].length; j++){
                var existe = false

                //Filtrage des type de magasins doublants 
                for(var x = 0 ; x < type.childNodes.length; x++){
                    if( type.childNodes[x].value == contenu[i][1][j][0]){
                        existe = true;
                    }
                }
                if(!existe){
                    var option = document.createElement('option');
                    option.value = contenu[i][1][j][0];
                    option.name = contenu[i][1][j][0];
                    option.innerHTML = contenu[i][1][j][0];
                    type.appendChild(option);
                }

            }
        }
    }
    type.addEventListener('change', function(e){TypeChosed( e , etage )}, false);
}

/*
 * La fonction qui gere le cas de All + fait la liaison de l'etape 2 avec etape 3
 */
                    
function TypeChosed(e, etage){
    var formulaire = document.getElementById("formulaire");
    var existe = document.getElementById(balatt[2]);
    if(existe){
        formulaire.removeChild( existe );
    }
    if( e.target.value!= "All" ){
        var SelectMagasin = document.createElement('select');
        SelectMagasin.id = balatt[2];
        SelectMagasin.name = balatt[2];
        CreateMagasinNom( SelectMagasin, e.target.value, etage);
        formulaire.appendChild( SelectMagasin ); 
    }
}

/*
 * Etape 3 => generation des magasins du type et de l'etage choisit
 */
function CreateMagasinNom( magasin, type, etage ){
                    
    var optionAll = document.createElement('option');      
    optionAll.selected="selected";
    optionAll.value="All";
    optionAll.innerHTML = "All";
    magasin.appendChild( optionAll );
                        
    for(var i=0;i < contenu.length; i++){
        if(contenu[i][0]==etage){
            for(var j=0;j < contenu[i][1].length; j++){
                if(contenu[i][1][j][0] == type){
                    var option = document.createElement('option');
                    option.value=contenu[i][1][j][1];
                    option.innerHTML = contenu[i][1][j][1];
                    magasin.appendChild(option);
                }
            }
        }
    }
}