<?xml version="1.0" encoding="ISO-8859-1" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:dyn="http://exslt.org/dynamic"
                version="1.0">      
    
    <xsl:output method="html" encoding="ISO-8859-1" />
    
    <xsl:param name='criteres'/>
    
    <xsl:template match="/">
        <div><h5>Visualisation SVG</h5>
                <script type="text/javascript" src="dijkstra.js"/>
                <script type="text/javascript">
                    //Les liaisons entrees les sommets avec les distances
                    
                    //Pour les etages -1 et 0
                    var graph1 = {
                                a: {b: 100, f: 125},
                                b: {a: 100, c: 100, e:  75},
                                c: {b: 100, d: 100, i: 125, f: 125},
                                d: {c: 100, j:  75},
                                e: {b:  75, g: 100},
                                f: {a: 125, c: 125},
                                g: {i: 100, e: 100},
                                h: {j: 100},
                                i: {g: 100, c: 125},
                                j: {h: 100, d:  75}
                                };
                    //Pour les etages 1 et 2
                    var graph2 = {
                                a: {b: 100},
                                b: {a: 100, e:  75, f:  75},
                                c: {d: 100},
                                d: {c: 100, i:  75, j:  75},
                                e: {b:  75, g: 100},
                                f: {b:  75, h: 100},
                                g: {e: 100, i: 100},
                                h: {f: 100, j: 100},
                                i: {d:  75, g: 100},
                                j: {d:  75, h: 100}
                                };
                    
                    //Les coordonnes de chaque sommet            
                    var pathCord = {
                                   a: {x:   0, y: 150},
                                   b: {x: 100, y: 150},
                                   c: {x: 200, y: 150},
                                   d: {x: 300, y: 150},
                                   e: {x: 100, y:  75},
                                   f: {x: 100, y: 225},
                                   g: {x: 200, y:  75},
                                   h: {x: 200, y: 225},
                                   i: {x: 300, y:  75},
                                   j: {x: 300, y: 225}
                                    };
                                         
                </script> 
                
                <!--Construction de la requete xpath a partir du choix fait--> 
                
                <xsl:variable name="xpath">
                        /<xsl:call-template name="construit_xpath">
                            <xsl:with-param name="critere" select="concat($criteres,'&amp;')"/>
                            <xsl:with-param name="memoire" select="''"/>
                        </xsl:call-template> 
                </xsl:variable>
                
                <xsl:variable name="etage">
                    <xsl:call-template name="GetFilter">
                        <xsl:with-param name="critere" select="$criteres"/>
                    </xsl:call-template>
                </xsl:variable>
                
                          
                <svg xmlns="http://www.w3.org/2000/svg" 
                    xmlns:xlink="http://www.w3.org/1999/xlink" 
                    xmlns:dyn="http://exslt.org/dynamic"
                    viewBox='0 0 300 300'
                    width='400'
                    height='400'>   
                    
                    <script type="text/ecmascript">
                    <![CDATA[
                        //La fonction qui est declanche lors un click sur un magasin
                        function StartAnimation1( evt ){
                            calculPlaceProche( evt.target, pathCord, graph1 ); 
                        }
                        function StartAnimation2( evt ){
                            calculPlaceProche( evt.target, pathCord, graph2 ); 
                        }
                    ]]>
                    </script>
   
                    <!--La structure de l'image composee des elements svg-->
                    <g id="structure">
                        
                        <!--Le cadre-->
                        
                        <rect id="content" x="0" y="0" height="300" width="300" fill="none" stroke="blue" />
                        
                        <xsl:choose>
                            <xsl:when test="$etage &lt; 1">
                                
                                <!--L'image pour l'etage -1 et 0-->
                        
                                <polygon    id="rayon1" 
                                            points="0,0 300,0 300,70 95,70 95,145 0,145 " 
                                            fill="yellow" />

                                <polygon    id="rayon2" 
                                            points="0,155 0,300 300,300 300,230 195,230 195,220 295,220 295,155 205,155 100,230" 
                                            fill="pink" />

                                <polygon    id="rayon3" 
                                            points="215,145 300,145 300,80" 
                                            fill="silver" />

                                <polygon    id="rayon4" 
                                            points="105,145 105,80 285,80 195,145" 
                                            fill="green" />

                                <polygon    id="rayon5" 
                                            points="15,155 185,155 100,220" 
                                            fill="green" />
                                    
                            </xsl:when>
                            
                            <xsl:otherwise>
                                
                                <!--L'image pour l'etage 1 et 2-->
                        
                                <polygon    id="rayon1" 
                                            points="0,0 300,0 300,70 95,70 95,145 0,145 " 
                                            fill="yellow" />

                                <polygon    id="rayon2" 
                                            points="0,155 0,300 300,300 300,230 95,230 95,155" 
                                            fill="pink" />

                                <polygon    id="rayon3" 
                                            points="105,80 105,220 295,220 295,155 195,155 195,145 295,145 295,80" 
                                            fill="green" /> 
                                            
                            </xsl:otherwise>
                        </xsl:choose>
                         
                                    
                                            
                        
                        <!--Pour visualiser les neuds du graphe -->
                        
                        <!--circle id="a" cx="0"   cy="150" r="5" fill="yellow"/>
                        <text x="0" y="150">a</text>

                        <circle id="b" cx="100" cy="150" r="5" fill="yellow"/>
                        <text x="100" y="150">b</text>

                        <circle id="c" cx="200" cy="150" r="5" fill="yellow"/>
                        <text x="200" y="150">c</text>

                        <circle id="d" cx="300" cy="150" r="5" fill="yellow"/>
                        <text x="300" y="150">d</text>

                        <circle id="e" cx="100" cy="75" r="5"  fill="yellow"/>
                        <text x="100" y="75">e</text>

                        <circle id="f" cx="100" cy="225" r="5" fill="yellow"/>
                        <text x="100" y="225">f</text>

                        <circle id="g" cx="200" cy="75" r="5"  fill="yellow"/>
                        <text x="200" y="75">g</text>                    

                        <circle id="h" cx="200" cy="225" r="5" fill="yellow"/>
                        <text x="200" y="225">h</text>

                        <circle id="i" cx="300" cy="75" r="5"  fill="yellow"/>
                        <text x="300" y="75">i</text>

                        <circle id="j" cx="300" cy="225" r="5" fill="yellow"/>  
                        <text x="300" y="225">j</text-->
                        
                        
                        <!--Le chemin pour les etages -1 et 0 -->

                        <!--line x1="0" y1="150" x2="100" y2="150" stroke="green"/>
                        <line x1="100" y1="150" x2="200" y2="150" stroke="green"/>
                        <line x1="200" y1="150" x2="300" y2="150" stroke="green"/>
                        <line x1="0" y1="150" x2="100" y2="225" stroke="green"/>
                        <line x1="100" y1="75" x2="200" y2="75" stroke="green"/>
                        <line x1="200" y1="75" x2="300" y2="75" stroke="green"/>
                        <line x1="200" y1="225" x2="300" y2="225" stroke="green"/>
                        <line x1="100" y1="150" x2="100" y2="75" stroke="green"/>
                        <line x1="300" y1="150" x2="300" y2="225" stroke="green"/>
                        <line x1="200" y1="150" x2="300" y2="75" stroke="green"/>
                        <line x1="200" y1="150" x2="100" y2="225" stroke="green"/-->
                        
                        <!--Le chemin pour les etages 1 et 2 -->
                        <!--line x1="0" y1="150" x2="100" y2="150" stroke="green"/>
                        <line x1="100" y1="150" x2="100" y2="75" stroke="green"/>
                        <line x1="100" y1="75" x2="200" y2="75" stroke="green"/>
                        <line x1="200" y1="75" x2="300" y2="75" stroke="green"/>
                        <line x1="300" y1="75" x2="300" y2="150" stroke="green"/>
                        <line x1="300" y1="150" x2="200" y2="150" stroke="green"/>
                        <line x1="300" y1="150" x2="300" y2="225" stroke="green"/>
                        <line x1="300" y1="225" x2="200" y2="225" stroke="green"/>
                        <line x1="200" y1="225" x2="100" y2="225" stroke="green"/>
                        <line x1="100" y1="225" x2="100" y2="150" stroke="green"/-->
                    </g>
                    
                    <g id="animation">
                        <xsl:choose>                            
                            <xsl:when test="$etage &lt; 1">
                                <xsl:for-each select="dyn:evaluate($xpath)">
                                    <rect onclick="StartAnimation1( evt )" id="magasin" x="{x}" y="{y}" rx="4" width="10" height="10" fill="red"/>
                                    <text   x="{x}" y="{y}" textLength ="" 
                                            font-family="Verdana" font-size="10" fill="blue"><xsl:value-of select="@nom"/></text>
                                </xsl:for-each>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:for-each select="dyn:evaluate($xpath)">
                                    <rect onclick="StartAnimation2( evt )" id="magasin" x="{x}" y="{y}" rx="4" width="10" height="10" fill="red"/>
                                    <text   x="{x}" y="{y}" textLength ="" 
                                            font-family="Verdana" font-size="10" fill="blue"><xsl:value-of select="@nom"/></text>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    
                    </g>
                </svg>
                </div>

    </xsl:template>
    
    <!--Fonction qui prend la valeur du 1er filtre qui est dans notre cas l'etage-->
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
