<?xml version="1.0" encoding="ISO-8859-1" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:dyn="http://exslt.org/dynamic"
                version="1.0">

    <xsl:output method="xml" encoding="ISO-8859-1" />

    <xsl:param name='criteres'/>

    <xsl:template match="/">
        <xsl:apply-templates select="/*"/>            
    </xsl:template>
    
    <xsl:template match="*">               
        <xsl:choose>
            <!--On teste si on manipule la balise polygon-->
            <xsl:when test="count(ancestor::node())=1">
                
                <!--Construction de la requete a partir de la selection faite-->
                <xsl:variable name="xpath">
                    /<xsl:call-template name="construit_xpath">
                        <xsl:with-param name="critere" select="concat($criteres,'&amp;')"/>
                        <xsl:with-param name="memoire" select="''"/>
                    </xsl:call-template> 
                </xsl:variable>
                
                <!--Recuperation de nombre des filtres valeurs possible 0,1,2,3-->
                <xsl:variable name="nbFilters">
                        <xsl:call-template name="GetFiltersNumber">
                            <xsl:with-param name="xpath" select="$xpath"/>
                            <xsl:with-param name="memoire" select="0"/>
                        </xsl:call-template>
                </xsl:variable>
                
                <!--On reculere la valeur du premier filtre qui est dans notre cas le numero d'etage-->
                <xsl:variable name="filtre">
                    <xsl:call-template name="GetFilter">
                            <xsl:with-param name="critere" select="$criteres"/>
                    </xsl:call-template>
                </xsl:variable>               
                
                <xsl:choose>
                    <!--Si on a pas de filtres, on recopie le tout-->
                    <xsl:when test="$nbFilters = 0">
                        <xsl:copy-of select="."/>
                    </xsl:when>
                    <!--Si on a 1 filtre, on recopie la balise polygin + les magasins d'etage passe par le filtre-->
                    <xsl:when test="$nbFilters = 1">
                        <xsl:copy select=".">
                            <xsl:for-each select="*">
                                <xsl:for-each select="attribute::*[.=$filtre]">                                       
                                    <xsl:copy-of select="parent::node()"/>
                                </xsl:for-each>
                            </xsl:for-each>
                        </xsl:copy>
                    </xsl:when>
                    <!--Si on a 2 ou 3 filtres, on recopie certain magasins du certain etage-->
                    <xsl:otherwise>
                        <xsl:element name="{name()}">
                            <xsl:for-each select="*">
                                <xsl:variable name="name" select="name()"/>
                                <xsl:for-each select="attribute::*[.=$filtre]">
                                    <xsl:attribute name="niveau"><xsl:value-of select="$filtre"/></xsl:attribute>
                                    <xsl:element name="{$name}">
                                        <xsl:attribute name="{name()}"><xsl:value-of select="$filtre"/></xsl:attribute>
                                        <xsl:for-each select="dyn:evaluate($xpath)">
                                            <xsl:copy-of select="."/>
                                        </xsl:for-each>  
                                    </xsl:element>
                                </xsl:for-each>  
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
        
    </xsl:template>

    <xsl:template name="GetFiltersNumber">
        <xsl:param name="xpath" />
        <xsl:param name="memoire" />
    
        <xsl:choose>
            <xsl:when test="contains($xpath,'[')">
                <xsl:call-template name="GetFiltersNumber">
                    <xsl:with-param name="xpath" select="substring-after($xpath ,']')"/>
                    <xsl:with-param name="memoire" select="$memoire + 1"/>
                </xsl:call-template> 
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$memoire"/>
            </xsl:otherwise>
        </xsl:choose>
    
    </xsl:template>

    <xsl:template name="GetFilter">
        <xsl:param name="critere" />
        
        <xsl:variable name="aux" select="substring-after($critere ,'=')"/>
        <xsl:variable name="resultat" select="substring-before($aux ,'&amp;')"/>
    
        <xsl:value-of select="$resultat"/>
    
    </xsl:template>

    <xsl:template name="construit_xpath">
        <xsl:param name="critere" />
        <xsl:param name="memoire" />
        
        <xsl:variable name="reste" select="substring-after($critere , '&amp;')"/>
        
        <xsl:variable name="BAV" select="substring-before($critere ,'&amp;')"/>
        <xsl:variable name="valeur" select="substring-after($BAV ,'=')"/>
        <xsl:variable name="BA" select="substring-before($BAV ,'=')"/>
        <xsl:variable name="balise" select="substring-before($BA ,'-')"/>
        <xsl:variable name="attribut" select="substring-after($BA ,'-')"/>       
        
        <xsl:variable name="resultat">
            <xsl:choose>
                <xsl:when test="$valeur = 'All'">
                    <xsl:choose>
                        <xsl:when test="contains($memoire,$balise)">
                                      
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select='concat("/", $balise )' />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="contains($memoire,$balise)">
                    <xsl:value-of select='concat("[@", $attribut, "=&#x27;", $valeur,"&#x27;]")' />                
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select='concat("/", $balise, "[@", $attribut, "=&#x27;", $valeur,"&#x27;]")' />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:value-of select="$resultat"/>
        
        <xsl:choose>
            <xsl:when test="string-length($reste) > 0">
                <xsl:call-template name="construit_xpath">
                    <xsl:with-param name="critere" select="$reste"/>
                    <xsl:with-param name="memoire" select="concat($memoire , $resultat)"/>
                </xsl:call-template> 
            </xsl:when>
        </xsl:choose>
    </xsl:template>
      

</xsl:stylesheet>
