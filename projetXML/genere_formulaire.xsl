<?xml version="1.0" encoding="ISO-8859-1" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:output method="html" encoding="ISO-8859-1" />
    
    
    <xsl:template match="/">
        <div>
                <script type="text/javascript" src="form_generique.js"/>
                <h3> Formulaire Dynamique </h3>
                <script type="text/javascript">
                    //la variable contnu contient tt les choix possible
                    var contenu = new Array();
                    //la variable balatt contient le nom des balises
                    var balatt = new Array();
                </script>
                
                <xsl:apply-templates select="/*"/>
                <form id="formulaire" action="index.php">
                    <input type="submit" value="Valider"/>
                </form>
                <script type="text/javascript">                   
                    GenereForm();
                </script>
         </div>
         
          
    </xsl:template>
    
    <!--Le template qui parcure les balises xml et nous genere contenu + balatt-->
    <xsl:template match="*">            
        <xsl:variable name="nomBalise" select="name()"/>
        
        <xsl:choose>
            <!--Quand on est au niveau de la balise Polygon-->
            <xsl:when test="count(ancestor::node()) = 2">
                <xsl:for-each select="@*">
                    <script type="text/javascript">
                        if(balatt.indexOf("<xsl:value-of select='concat($nomBalise,"-", name())' />") == -1){
                            balatt.push("<xsl:value-of select='concat($nomBalise,"-", name())' />");
                        }
                        contenu.push(new Array("<xsl:value-of select="." />",new Array()));                          
                    </script>
                </xsl:for-each>
                <xsl:apply-templates select="*"/>
            </xsl:when>
            
            <!--Quand on est au niveau de la balise Etage-->
            <xsl:when test="count(ancestor::node()) = 3">
                <script type="text/javascript">
                    contenu[contenu.length - 1][1].push(new Array());
                </script>
                <xsl:for-each select="@*">
                    <script type="text/javascript">
                        if(balatt.indexOf("<xsl:value-of select='concat($nomBalise,"-", name())' />") == -1){
                            balatt.push("<xsl:value-of select='concat($nomBalise,"-", name())' />");
                        }
                        contenu[contenu.length - 1][1][contenu[contenu.length - 1][1].length - 1].push("<xsl:value-of select="." />");
                    </script>
                </xsl:for-each>
                <xsl:apply-templates select="*"/>
            </xsl:when>                
            <xsl:otherwise>
                <xsl:apply-templates select="*"/>
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>

    



</xsl:stylesheet>
 

