<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exslt="http://exslt.org/common"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:file="http://expath.org/ns/file"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:isothes="http://purl.org/iso25964/skos-thes#"
    xmlns:cc="http://creativecommons.org/ns#"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    version="3.0"
    exclude-result-prefixes="#all">

    <xsl:output  method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

    <xsl:param name="inputFile" select="unparsed-text('input.json')"/>
    <xsl:param name="lang" select="'en'"/>
    <xsl:param name="vocabulary" select="'/home/thouvenin/devel/web-services/loterre-resolvers/v1/QX8.skos'"/>
    <xsl:variable name="DICO" select="document($vocabulary)/rdf:RDF"/>


<!--===============================================================
0- traitement du thésaurus : création d'un index avec les prefs,  les synos et les hiddens triés
========================================================================-->
           <xsl:variable name="FRE">
                <xsl:for-each select="$DICO//skos:Concept/skos:prefLabel[@xml:lang='fr']">
                       <!--liste d'exclusion-->
                    <xsl:if test="not(.=('SOI', 'SOC', 'climat', 'K', 'B','N,','S','Si','D','Cl','H'))">
                            <terme>
                               <xsl:attribute name="id">
                                   <xsl:value-of select="../@rdf:about"/>
                               </xsl:attribute>
                               <xsl:attribute name="lang">fr</xsl:attribute>
                               <xsl:attribute name="status">pref</xsl:attribute>
                               <xsl:value-of select="normalize-space(.)"/>
                           </terme>
                        </xsl:if>
               </xsl:for-each>
               <xsl:for-each select="$DICO//skos:Concept/skos:altLabel[@xml:lang='fr' and not(contains(.,'?')) and not(.='')] | $DICO//skos:Concept/skos:hiddenLabel[@xml:lang='fr'  and not(contains(.,'?')) and not(.='')]">  <!--liste d'exclusion-->
                   <!--liste d'exclusion-->
                   <xsl:if test="not(.=('SOI', 'SOC', 'climat', 'K', 'B','N,','S','Si','D','Cl','H'))">
                       <terme>
                       <xsl:attribute name="id">
                           <xsl:value-of select="../@rdf:about"/>
                       </xsl:attribute>
                       <xsl:attribute name="lang">fr</xsl:attribute>
                       <xsl:attribute name="status">syn</xsl:attribute>
                       <xsl:attribute name="renvoi"><xsl:value-of select="../skos:prefLabel[@xml:lang='fr']"/></xsl:attribute>
                       <xsl:value-of select="normalize-space(.)"/>
                   </terme>
                   </xsl:if>
               </xsl:for-each>
           </xsl:variable>
           <xsl:variable name="ENG">
           <xsl:for-each select="$DICO//skos:Concept/skos:prefLabel[@xml:lang='en']">
                       <!--liste d'exclusion-->
                   <xsl:if test="not(.=('SOI', 'SOC', 'climate', 'K', 'B','N,','S','Si','D','Cl','H'))">
                           <terme>
                              <xsl:attribute name="id">
                                  <xsl:value-of select="../@rdf:about"/>
                              </xsl:attribute>
                              <xsl:attribute name="lang">en</xsl:attribute>
                              <xsl:attribute name="status">pref</xsl:attribute>
                              <xsl:value-of select="normalize-space(.)"/>
                          </terme>
                       </xsl:if>
               </xsl:for-each>

                   <xsl:for-each select="$DICO//skos:Concept/skos:altLabel[@xml:lang='en' and not(.='')] | $DICO//skos:Concept/skos:hiddenLabel[@xml:lang='en' and not(.='')]">    <!-- liste d'exclusion -->
                   <!--liste d'exclusion-->
                   <xsl:if test="not(.=('SOI', 'SOC', 'climate', 'K', 'B','N,','S','Si','D','Cl','H'))">
                       <terme>
                       <xsl:attribute name="id">
                           <xsl:value-of select="../@rdf:about"/>
                       </xsl:attribute>
                       <xsl:attribute name="lang">en</xsl:attribute>
                       <xsl:attribute name="status">syn</xsl:attribute>
                       <xsl:attribute name="renvoi"><xsl:value-of select="../skos:prefLabel[@xml:lang='en']"/></xsl:attribute>
                       <xsl:value-of select="normalize-space(.)"/>
                   </terme>
                   </xsl:if>

               </xsl:for-each>


           </xsl:variable>
           <xsl:variable name="dicoName">
               <xsl:for-each select="$DICO//skos:ConceptScheme">
                   <dico>
                       <xsl:attribute name="uri" select="@rdf:about"/>
                      <xsl:choose>
                         <xsl:when test="dct:title[@xml:lang='fr']">
                            <xsl:value-of select="dct:title[@xml:lang='fr']"/>
                         </xsl:when>
                         <xsl:otherwise>
                            <xsl:value-of select="dct:title[@xml:lang='en']"/>
                         </xsl:otherwise>
                      </xsl:choose>
                    </dico>
               </xsl:for-each>
           </xsl:variable>

    <!-- =================================================================================================
    1- fichier d'entrée
    =====================================================================================================-->
    <xsl:template match="/" name="main">
        <xsl:variable name="PASS1">
            <pass1>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()" mode="input"/>
                </xsl:copy>
            </pass1>
        </xsl:variable>
        <xsl:apply-templates select="exslt:node-set($PASS1)/pass1"/>
    </xsl:template>
    <xsl:template match="@*|node()" mode="input">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="input"/>
        </xsl:copy>
    </xsl:template>

    <!-- =================================================================================================
    2- annotation de chaque article
    =====================================================================================================-->

       <xsl:template match="pass1">
        <xsl:variable name="PASS2">
            <pass2>
            <root>
                <xsl:for-each select="//fn:map[child::fn:string[@key='id']] | //fn:map[child::node()[local-name(.)='id']]">
                 <record>
                     <xsl:attribute name="id">
                         <xsl:value-of select="descendant::fn:string[@key='id']"/>
                     </xsl:attribute>
                        <!--<xsl:variable name="id">
                            <xsl:value-of select="descendant::fn:string[@key='id']"/>
                        </xsl:variable>
                        <xsl:variable name="docLanguage">
                            <xsl:value-of select="descendant::fn:array[@key='language']/fn:string"/>
                        </xsl:variable>
                        <xsl:variable name="title">
                            <xsl:value-of select="descendant::fn:string[@key='title']"/>
                        </xsl:variable>
                        <xsl:variable name="abstract">
                            <xsl:value-of select="descendant::fn:string[@key='abstract']"/>
                        </xsl:variable>
                     <xsl:variable name="nativeKeywords">
                         <xsl:for-each select="descendant::fn:array[@key='subject']/descendant::fn:string[@key='value']">
                             <xsl:text> </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
                         </xsl:for-each>
                     </xsl:variable>-->
                     <!--<xsl:variable name="fullText">
                        <xsl:value-of select="$CORPUS//tei:TEI[descendant::tei:idno=$id]/normalize-space(string-join(descendant-or-self::text(), ' '))"/>
                     </xsl:variable>-->
                    <!-- titre + résumé + MCA -->
                   <!-- <xsl:variable name="TitleAbstractKeywords">
                       <!-\-<xsl:value-of select="concat(fn:string[@key='title'], fn:string[@key='abstract'], fn:map[@key='keywords'])"/>-\-><!-\- keywords = teeft -\->
                        <xsl:value-of select="concat(' ',descendant::fn:string[@key='title'], ' ', descendant::fn:string[@key='abstract'], ' ', $nativeKeywords, ' ')"/>
                    </xsl:variable>-->

                    <!-- tous les contenus textuels (même les identifiants !) dans une variable-->
                   <!-- <xsl:variable name="docText" select="normalize-space(string-join(descendant-or-self::text(), ' '))"/>-->
<!--                     <xsl:variable name="docText" select="normalize-space(string-join(descendant::fn:string[@key='value'], ' '))"/>-->
                     <xsl:variable name="docText" select="normalize-space(string-join(descendant::node()[local-name(.)='value' or @key='value'], ' '))"/>

 <!--                      <xsl:copy-of select="node()"/>-->
<!--=====================================Annotation proprement dite================================-->
                    <xsl:for-each select="$dicoName/dico">
                            <xsl:variable name="uriDico" select="@uri"/>
                          <!--  <array>
                                <xsl:attribute name="key">annotations</xsl:attribute>-->
<!--                                <xsl:if test="$docLanguage=('fr', 'fre', 'fra', 'FR', 'FRE', 'FRA') ">-->
                                    <xsl:if test="$lang=('fr', 'fre', 'fra', 'FR', 'FRE', 'FRA') ">
                                    <!-- annotation avec les termes français de la ressource terminologique dont l'uri correspond à $uriDico-->
                                    <xsl:for-each select="$FRE/terme[substring-before(@id, '-')=$uriDico]">
                                        <xsl:variable name="keyword" select="."/>
                                        <xsl:variable name="id" select="@id"/>
                                        <xsl:variable name="status" select="@status"/>
                                        <xsl:variable name="renvoi" select="@renvoi"/>
                                        <!-- word boundary "\W" ne tient pas compte des lettres accentuées ("début" et "d'eau" génèrent "Deutérium" dont l'altLabel est "D";
                                            la variable "nonWordChar" intègre les lettres accentuées (\u00C0 jusqu'à \u017F) et les 3 formes d'apostrophe(\u0027, \u02BC, \u2019)-->
                                        <xsl:variable name="nonWordChar" select="'[^0-9A-Za-z\u00C0-\u017F\u0027\u02BC\u2019]'"/>
<!--                                        <xsl:variable name="nonWordChar" select="'[^\\p{L}+$]'"/>-->
                                        <!-- variable keyword2 : intègre les word boundaries pour ne prendre que les termes entiers ; échappe les caractères RegExp réservés-->
                                        <xsl:variable name="keyword2" select="concat($nonWordChar, replace(replace(replace(replace(replace(replace(replace(replace(replace($keyword, ',','&#x2C;'), '+', '\\+' , '!iq'), '(','\\(', '!iq'), ')', '\\)','!iq'), '[', '\\[' , '!iq'), ']', '\\]' , '!iq'), '{', '\\{' , '!iq'), '}', '\\}' , '!iq'), '|', '\\|' , '!iq'),$nonWordChar)"/>
                                        <xsl:analyze-string select="concat('\W',$docText,'\W')" regex="{$keyword2}" flags="!i" >
<!--                                           <xsl:analyze-string select="concat('\W',$TitleAbstractKeywords,'\W')" regex="{$keyword2}" flags="!i" >-->
 <!--                                              <xsl:analyze-string select="concat('\W',$fullText,'\W')" regex="{$keyword2}" flags="!i" >-->
                                            <xsl:matching-substring>
                                                <annotation>
                                                    <lang>fre</lang>
                                                    <prefLabel>
                                                        <!--on ne sort que le préférentiel-->
                                                        <xsl:choose>
                                                            <xsl:when test="$status='pref'">
                                                                <xsl:value-of select="$keyword"/>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:value-of select="$renvoi"/>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </prefLabel>
                                                    <termeReconnu>
                                                        <xsl:value-of select="."/>
                                                    </termeReconnu>
                                                    <conceptUri>
                                                        <xsl:value-of select="$id"/>
                                                    </conceptUri>

                                                    <status>
                                                        <xsl:value-of select="$status"/>
                                                    </status>
                                                    <renvoi>
                                                        <xsl:value-of select="$renvoi"/>
                                                    </renvoi>
                                                </annotation>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <!-- on ne sort pas le reste du texte pour alléger le résultat-->
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:for-each>
                                </xsl:if>

                                <xsl:if test="$lang=('en', 'eng','EN','ENG','de','ger','dut','unknown')">
                                    <!-- annotation avec les termes anglais de la ressource terminologique -->
                                    <xsl:for-each select="$ENG/terme[substring-before(@id, '-')=$uriDico]">
                                        <xsl:variable name="keyword" select="."/>
                                        <xsl:variable name="id" select="@id"/>
                                        <xsl:variable name="status" select="@status"/>
                                        <xsl:variable name="renvoi" select="@renvoi"/>
                                        <!-- variable keyword2 : intègre les word boundaries pour ne prendre que les termes entiers ; échappe les caractères RegExp réservés-->
                                        <xsl:variable name="keyword2" select="concat('\W', replace(replace(replace(replace(replace(replace(replace(replace(replace(replace($keyword, ',','&#x2C;'), '+', '\\+' , '!iq'), '(','\\(', '!iq'), ')', '\\)','!iq'), '[', '\\[' , '!iq'), ']', '\\]' , '!iq'), '{', '\\{' , '!iq'), '}', '\\}' , '!iq'), '|', '\\|' , '!iq'), '-', '\\‐' , '!iq'),'\W')"/>
                                                                               <xsl:analyze-string select="concat('\W',$docText,'\W')" regex="{$keyword2}" flags="!i" >
<!--                                       <xsl:analyze-string select="concat('\W',$TitleAbstractKeywords,'\W')" regex="{$keyword2}" flags="!i" >-->
<!--                                          <xsl:analyze-string select="concat('\W',$fullText,'\W')" regex="{$keyword2}" flags="!i" >-->
                                            <xsl:matching-substring>
                                                <annotation>
                                                    <lang>eng</lang>
                                                    <prefLabel>
                                                        <!--on ne sort que le préférentiel-->
                                                        <xsl:choose>
                                                            <xsl:when test="$status='pref'">
                                                                <xsl:value-of select="$keyword"/>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:value-of select="$renvoi"/>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </prefLabel>
                                                    <termeReconnu>
                                                        <xsl:value-of select="."/>
                                                    </termeReconnu>
                                                    <conceptUri>
                                                        <xsl:value-of select="$id"/>
                                                    </conceptUri>
                                                      <status>
                                                        <xsl:value-of select="$status"/>
                                                    </status>
                                                    <renvoi>
                                                        <xsl:value-of select="$renvoi"/>
                                                    </renvoi>
                                                </annotation>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <!-- on ne sort pas le reste du texte pour alléger le résultat-->
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:for-each>
                                </xsl:if>


                        </xsl:for-each>
                 </record>
                </xsl:for-each>
            </root>
            </pass2>
        </xsl:variable>
        <xsl:apply-templates select="exslt:node-set($PASS2)/pass2"/>
    </xsl:template>
    <!-- ===================================================================
   3- regroupement des annotations par vocabulaire puis par terme
=======================================================================   -->

    <xsl:template match="pass2">
            <root>
                <xsl:for-each select="//record">
                <!-- début de chaque document -->
                 <record>
                    <xsl:copy-of select="@id" copy-namespaces="0"/>

                            <!-- on regroupe les annotations et on factorise sur l'identifiant ark (scheme) et sur le terme-->
<!--                              <xsl:for-each-group select="descendant::fn:map[parent::fn:array[@key='annotations']]" group-by="fn:string[@key='conceptUri'], fn:array[@key='lang']/fn:string" composite="1">-->
                               <!-- on regroupe les annotations et on factorise sur le terme + langue-->
                                  <xsl:for-each-group select="descendant::annotation" group-by="prefLabel, lang" composite="1">
                                         <xsl:variable name="freq" select="count(current-group()) "/>

                                    <annotation>

                                        <lang>
                                          <xsl:value-of select="current-grouping-key()[2]"/>
                                       </lang>

                                        <prefLabel><xsl:value-of select="current-grouping-key()[1]"/></prefLabel>

                                        <xsl:for-each-group select="current-group()/termeReconnu" group-by=".">
                                           <termeReconnu>
                                               <xsl:value-of select="current-grouping-key()"/>
                                           </termeReconnu>
                                           </xsl:for-each-group>

                                        <!--Termes génériques-->
                                         <xsl:for-each-group select="current-group()/conceptUri" group-by=".">
                                           <!-- tous les génériques de niveau 1 du concept  -->
                                            <xsl:for-each select="$DICO//skos:Concept[@rdf:about=current-grouping-key()]/skos:broader">
                                                <xsl:variable name="génériques">
                                                    <xsl:call-template name="classif">
                                                        <xsl:with-param name="tg" select="@rdf:resource"/>
                                                        <xsl:with-param name="position">1</xsl:with-param>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                 <!-- génériques dans une variable pour pouvroir les renuméroter dans le sens décroissant-->
                                                    <xsl:variable name="génériques_num">
                                                        <xsl:for-each select="$génériques//tg[starts-with(.,'1')]">
                                                            <xsl:variable name="position">1</xsl:variable>
                                                            <xsl:variable name="string1" select="."/>
                                                            <xsl:choose>
                                                                <xsl:when test="following::node()[starts-with(name(.), 'TG_')]">
                                                                    <xsl:for-each select="following::node()[starts-with(name(.), 'TG_') and not(child::node()[starts-with(name(.), 'TG_')])]">
                                                                        <xsl:variable name="niveau" select="number(substring-after(name(.), 'TG_'))"/>
                                                                        <xsl:variable name="num">1</xsl:variable>
                                                                        <arbreHierarchique>
                                                                            <tg>
                                                                                <xsl:value-of select="tg"/>
                                                                            </tg>
                                                                            <xsl:call-template name="previousTG">
                                                                                <xsl:with-param name="tg" select="parent::node()[starts-with(name(.), 'TG_')][last()]/tg"/>
                                                                                <xsl:with-param name="niveau" select="$niveau -1"/>
                                                                                <xsl:with-param name="num" select="$num +1"/>
                                                                            </xsl:call-template>
                                                                            <tg>
                                                                                <xsl:value-of select="$string1"/>
                                                                            </tg>
                                                                        </arbreHierarchique>
                                                                    </xsl:for-each>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                    <arbreHierarchique>
                                                                        <tg  xsl:exclude-result-prefixes="#all">
                                                                            <xsl:value-of select="$string1"/>
                                                                        </tg>
                                                                    </arbreHierarchique>
                                                                </xsl:otherwise>
                                                            </xsl:choose>
                                                        </xsl:for-each>
                                                    </xsl:variable>
                                                     <!-- renumérotation -->
                                                    <xsl:variable name="génériques_Renum">
                                                        <xsl:for-each select="$génériques_num/arbreHierarchique">
                                                            <arbreHierarchique>
                                                                <xsl:for-each select="tg">
                                                                    <tg>
                                                                        <xsl:value-of select="concat(position(), ' - ',substring(.,3))"/>
                                                                    </tg>
                                                                </xsl:for-each>
                                                            </arbreHierarchique>
                                                        </xsl:for-each>
                                                    </xsl:variable>
                                                    <!-- regroupement sur une ligne -->
                                                    <xsl:for-each select="$génériques_Renum/arbreHierarchique">
                                                        <arbreHierarchique>
                                                            <xsl:for-each select="tg">
                                                                <xsl:choose>
                                                                    <xsl:when test="position()=last()">
                                                                        <xsl:value-of select="."/>
                                                                    </xsl:when>
                                                                    <xsl:otherwise>
                                                                        <xsl:value-of select="."/>
                                                                        <xsl:text>, </xsl:text>
                                                                    </xsl:otherwise>
                                                                </xsl:choose>
                                                            </xsl:for-each>
                                                         </arbreHierarchique>
                                                    </xsl:for-each>
                                           </xsl:for-each>
                                             <conceptUri>
                                                 <xsl:value-of select="current-grouping-key()"/>
                                             </conceptUri>
                                </xsl:for-each-group>


                                       <outil>Loterre_Annot</outil>

                                        <frequence>
                                            <xsl:value-of select="$freq "/>
                                        </frequence>

                                    </annotation>
                            </xsl:for-each-group>
                </record>
            </xsl:for-each>
                </root>

    </xsl:template>

    <!-- ===================================================================
  TG
=======================================================================   -->
    <xsl:template name="classif">
        <xsl:param name="tg"/>
        <xsl:param name="position"/>

        <xsl:if test="$DICO//skos:Concept[@rdf:about=$tg]">
            <tg>
                <xsl:value-of select="concat($position, '-',$DICO//skos:Concept[@rdf:about=$tg]/skos:prefLabel[@xml:lang='en'])"/>

            </tg>

            <xsl:for-each select="$DICO//skos:Concept[@rdf:about=$tg]/skos:broader/@rdf:resource">
                <xsl:element name="{concat('TG_',$position +1)}">
                    <xsl:call-template name="classif99">
                        <xsl:with-param name="tg" select="."/>
                        <xsl:with-param name="position">
                            <xsl:value-of select="$position +1"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:element>
            </xsl:for-each>

            <!--</xsl:otherwise>
            </xsl:choose>-->

        </xsl:if>



    </xsl:template>
    <!-- ===================================================================
  TG99
=======================================================================   -->
    <xsl:template name="classif99">
        <xsl:param name="tg"/>
        <xsl:param name="position"/>

        <xsl:if test="$DICO//skos:Concept[@rdf:about=$tg]">
            <tg>
                <xsl:value-of select="concat($position, '-',$DICO//skos:Concept[@rdf:about=$tg]/skos:prefLabel[@xml:lang='en'])"/>

            </tg>


            <xsl:for-each select="$DICO//skos:Concept[@rdf:about=$tg]/skos:broader/@rdf:resource">
                <xsl:element name="{concat('TG_',$position+1)}">
                    <xsl:call-template name="classif99">
                        <xsl:with-param name="tg" select="."/>
                        <xsl:with-param name="position">
                            <xsl:value-of select="$position +1"/>
                        </xsl:with-param>
                    </xsl:call-template>

                </xsl:element>
            </xsl:for-each>

        </xsl:if>


    </xsl:template>
    <!-- ===================================================================
  TG précédant
=======================================================================   -->

    <xsl:template name="previousTG">
        <xsl:param name="tg"/>
        <xsl:param name="niveau"/>
        <xsl:param name="num"/>
        <xsl:for-each select="parent::node()[starts-with(name(.), 'TG_') and child::tg=$tg]">
            <tg>
                <xsl:value-of select="$tg"/>
            </tg>
            <xsl:call-template name="previousTG">
                <!--<xsl:with-param name="tg" select="parent::fn:array[child::fn:array/fn:string=$tg]"/>-->
                <xsl:with-param name="tg" select="parent::node()[starts-with(name(.), 'TG_')][last()]/tg"/>
                <xsl:with-param name="niveau" select="$niveau -1"/>
                <xsl:with-param name="num" select="$num -1"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>


</xsl:stylesheet>





