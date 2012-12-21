package composants
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.*;
	import flash.net.*;
	import flash.xml.XMLNode;
	
	import mx.collections.ArrayList;
	import mx.containers.Canvas;
	import mx.containers.Panel;
	import mx.containers.TitleWindow;
	import mx.containers.VBox;
	import mx.containers.ViewStack;
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.controls.LinkBar;
	import mx.controls.Text;
	import mx.controls.TextInput;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	
	import spark.components.Button;
	
	public class Grille extends VBox{
		
		private var LB:LinkBar;
		private var VS:ViewStack;
		private var chargeurXML:URLLoader;//sert a charger l'xml
		private var titleWindow:TitleWindow;//sert a faire un formulaire popup a ramplir
		private var nomMagasin:TextInput;//set a ramplir le nom du magasin
		private var typeMagasin:TextInput;//sert a ramplir le type du magasin
		private var corx:int;//y cor du magasin a ajouter
		private var cory:int;//x cor du magasin a ajouter
		private var currentEtage:String;//on reculere l'etage avec cet attribure
		private var currentCanvas:Canvas;//c'est la ou on ajoute le nouveau magasin

		
		public function Grille():void{
			
			VS = new ViewStack();
			VS.id="viewStack";
			LB = new LinkBar();
			LB.dataProvider=VS;
			
			chargeurXML = new URLLoader( new URLRequest("D:/Program Files/EasyPHP-5.3.8.1/www/projetXML/polygon.xml"));
			chargeurXML.addEventListener(Event.COMPLETE , ChargingComplete );
			
			addChild(LB);
			addChild(VS);
			
		}
		
		private function ChargingComplete(event:Event ):void{
			var xml = new XML(event.currentTarget.data );			
			var donnees:XMLList = xml..etage;
			//Pour chaque etage on cree un paneau ou on va afficher les magasins
			for each(var donnee:XML in donnees){
				creePanel(donnee.@niveau, xml);
			}
		}
		
		protected function creePanel(x:String , xml:XML):void{
			//La fonction qui cree le paneau
			var panel:Panel = new Panel();
			panel.label = "Etage : "+ x;
			panel.title = "Etage : "+x;
			
			//On va dessiner le plan + les magasins dans le canvas
			var dessin:Canvas = new Canvas();			
			dessin.name = x;
			dessin.addEventListener(MouseEvent.CLICK,CreatePopUp);			
			
			var image:Image = new Image();
			if(x == "-1" || x == "0"){
				image.source="plan1.png";
			}
			else{
				image.source="plan2.png";
			}
			image.height = 300;
			image.width = 300;
			dessin.addChild(image);				
			
			var donnees:XMLList = xml.etage.(@niveau == x).magasin;
			for each(var donnee:XML in donnees){
				//texte sert a nommer les magasins
				var texte:Text = new Text();
				texte.text = donnee.@nom;
				texte.x = donnee.x;
				texte.y = donnee.y;
				//On deplace le text de 10px pour eviter la colisions avec le button 
				texte.y+=7;
				
				//on represante les magasins avec des buttons, on associe une action lors du click qui affiche le nom + type de magasin
				var magasin:Button = new Button();
				magasin.label = donnee.@nom;
				magasin.name = donnee.@type;					
				magasin.x = donnee.x.toString();
				magasin.y = donnee.y.toString();
				magasin.width = 10;
				magasin.height = 10;
				magasin.addEventListener(MouseEvent.RIGHT_CLICK, DeleteMagasin);
				
				//Ajout dans le canvas
				dessin.addChild(magasin);
				dessin.addChild(texte);
			}			
			panel.addChild(dessin);				
			VS.addChild(panel);
			
		}
		
		private function CreatePopUp(evt : MouseEvent):void{
			//On recupere l'etage ou on doit ajouter le magasin
			currentEtage = evt.currentTarget.name;
			currentCanvas = evt.currentTarget as Canvas;
			//On recuperer x et y cor pour ajouter le magasin
			corx = Math.round( ( evt.localX * 300 ) / 700 ) - 2;
			cory = Math.round( ( evt.localY * 300 ) / 700 ) - 2;
			initAddMagasin();
		}		
		
		//Le formualire a ramplir pour l'ajouter un magasin
		private function initAddMagasin():void{
			titleWindow = new TitleWindow();
			titleWindow.title = "Ajout d'un magasin";
			nomMagasin = new TextInput();
			typeMagasin = new TextInput();
			var nom:Label = new Label();
			nom.text = "Nom du magasin : ";
			var type:Label = new Label();
			type.text = "Type du magasin : ";
			var valider:Button = new Button();
			valider.label = "Valider";
			valider.addEventListener(MouseEvent.CLICK, FinaliseAjoutMagasin);
			
			titleWindow.showCloseButton = true;			
			titleWindow.addEventListener(CloseEvent.CLOSE, titleWindow_close);
			
			titleWindow.addChild(type);
			titleWindow.addChild(typeMagasin);
			titleWindow.addChild(nom);
			titleWindow.addChild(nomMagasin);
			titleWindow.addChild(valider);			
			
			PopUpManager.addPopUp(titleWindow, this, true);
			PopUpManager.centerPopUp(titleWindow);
		}
		
		private function titleWindow_close(evt:CloseEvent):void {
			PopUpManager.removePopUp(titleWindow);
		}
		
		private function FinaliseAjoutMagasin(evt : MouseEvent ):void{
			CreateMagasin();
			PopUpManager.removePopUp(titleWindow);
		}
		
		private function CreateMagasin():void{			
			
			//L'ajout dans le fichier XML		
			
			var xml:XML = new XML(chargeurXML.data);
			//On cree la baslise magasin avec les attributes nom et type
			//On cree les sous balises x et y
			//On ajoute x et y dans magasin
			//On ajoute magasin dans le bon etage			
			var Bmagasin:String = "magasin";  
			var nom:String = "nom";  
			var nomValue:String = nomMagasin.text;//On recupere le nom qu'on viens d'ajouter dans le formulaire
			var type:String = "type";
			var typeValue:String = typeMagasin.text;//On recupere le type qu'on viens d'ajouter dans le formulaire	
			var BaliseMagasin:XML = <{Bmagasin} {type}={typeValue} {nom}={nomValue}></{Bmagasin}>;  
			
			var BX:String ="x";
			var xContenu:String =corx.toString();
			var BaliseX:XML = <{BX}>{xContenu}</{BX}>; 			
			
			var BY:String ="y";
			var yContenu:String = cory.toString();
			var BaliseY:XML = <{BY}>{yContenu}</{BY}>; 
			
			BaliseMagasin.appendChild(BaliseX);
			BaliseMagasin.appendChild(BaliseY);
			
			var donnees:XMLList = xml..etage;
			//Pour chaque etage on cree un paneau ou on va afficher les magasins
			for each(var donnee:XML in donnees){
				if(donnee.@niveau == currentEtage){//On ajoute dans le bon etage
					donnee.appendChild(BaliseMagasin);
				}
			}
			saveXML(xml);
			
			//L'ajoute dans le Canvas
			
			var magasin:Button = new Button();
			magasin.label = nomValue;
			magasin.name = typeValue;
			magasin.width = 10;
			magasin.height = 10;
			magasin.x = corx;
			magasin.y = cory;
			magasin.addEventListener(MouseEvent.RIGHT_CLICK, DeleteMagasin);
			
			var texte:Text = new Text();
			texte.text = nomValue;
			texte.x = corx;
			texte.y = cory;
			//On deplace le text de 10px pour eviter la colisions avec le button 
			texte.y+=7;
			
			currentCanvas.addChild(magasin);
			currentCanvas.addChild(texte);
		}	
		
		private function saveXML(xml:XML):void{
			
			var newXMLStr:String = '<?xml version="1.0" encoding="utf-8"?>';
			newXMLStr += xml;
						
			var dir:File = new File("D:/Program Files/EasyPHP-5.3.8.1/www/projetXML");
			var myfile:File = dir.resolvePath("polygon.xml");
			var fs:FileStream = new FileStream();
			fs.open(myfile, FileMode.WRITE);
			fs.writeUTFBytes(newXMLStr);
			fs.close();
			
		}
		
		private function DeleteMagasin(evt : MouseEvent):void{
			
			var name:String = evt.currentTarget.label;
			var type:String = evt.currentTarget.name;
			
			var xml:XML = new XML(chargeurXML.data);
			var donnees:XMLList = xml..magasin;
			//Pour chaque etage on cree un paneau ou on va afficher les magasins
/*
			for each(var donnee:XML in donnees){
				if(donnee.@nom == name){//On ajoute dans le bon etage
					delete donnee[0];
				}
			}
			
			for(var i:int = donnees.length() -1; i >= 0; i--)
			{
				if(donnees[i].@nom == name){//On ajoute dans le bon etage
					delete donnee[i];
				}
			}
*/		
			//delete xml.etage.(@niveau == "1");
			//saveXML(xml);	
				
			Alert.show(xml);
		}
	}
}