<!DOCTYPE html>
<html>
    <head>
        <title>Polygon</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		
    </head>
    <body>
        <center><h1>Projet Galaxie XML</h1></center>
        <?php
        $doc_xml_form = new DOMDocument();
        $doc_xml_form->load('polygon.xml');

        $doc_xsl_form = new DOMDocument();
        $doc_xsl_form->load('genere_formulaire.xsl');

        $proc = new XSLTProcessor();
        $proc->importStylesheet($doc_xsl_form);

        echo $proc->transformToXML($doc_xml_form);
        

        if($_SERVER['QUERY_STRING']){
            //Liaison du fichier polygon.xml avec genere_svg => Pour generer le svg
            $parametres = $_SERVER['QUERY_STRING'];
            
            $doc_xml_svg = new DOMDocument();
            $doc_xml_svg->load('polygon.xml');

            $doc_xsl_svg = new DOMDocument();
            $doc_xsl_svg->load('genere_svg.xsl');

            $proc = new XSLTProcessor();
            $proc->importStylesheet($doc_xsl_svg);

            $proc->setParameter(null, 'criteres', $parametres);
            echo $proc->transformToXML($doc_xml_svg);
            
            //Liaison du fichier poligon.xml avec genere_xml_flex => Pour generer le xml filtere pour l'utiliser
            $doc_xml_flex = new DOMDocument();
            $doc_xml_flex->load('polygon.xml');

            $doc_xsl_flex = new DOMDocument();
            $doc_xsl_flex->load('genere_xml_flex.xsl');

            $proc = new XSLTProcessor();        
            $proc->importStylesheet($doc_xsl_flex);

            $proc->setParameter(null,'criteres',$parametres);	
            $result = $proc->transformToXML($doc_xml_flex);
			$file = fopen("result.xml", "w+");
            fwrite($file, $result);
			
            fclose($file);
			
			
			?>
        <div>
            <h3>Visualisation Flex</h3>
            <EMBED src="Polygon.swf" 
                    WIDTH="400" 
                    HEIGHT="400" 
                    NAME="polygon" 
                    TYPE="application/x-shockwave-flash">
            </EMBED>    
        </div>
		<div>
		<h3> Visualisation GoogleMaps </h3>
		<a href="gmap1.html" target="_blank">lancez Google Maps</a>
		</div>
		
                <?php
        }
        ?>
		
    </body>
</html>