<?xml version="1.0" encoding="UTF-8"?>


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    extension-element-prefixes="tei" exclude-result-prefixes="xs tei" version="1.0">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <xsl:template match="/tei:TEI">
        <TEI xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.tei-c.org/ns/1.0 https://www.persee.fr/schemas/tei_all.xsd">
            <xsl:apply-templates select="tei:teiHeader"/>
            <xsl:apply-templates select="//tei:body"/>
        </TEI>
    </xsl:template>
    
    <xsl:template match="//tei:teiHeader">
        <teiHeader>
            <title>
                <xsl:value-of
                    select="//tei:fileDesc/tei:titleStmt/tei:title"/>
            </title>
            <idno type="local">
                <xsl:value-of select="//tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'local']"/>
            </idno>
        </teiHeader>
    </xsl:template>

    
    <xsl:template match="//tei:front"/>
    <xsl:template match="//tei:figure"/>
    <xsl:template match="//tei:note"/>
    
    <xsl:template match="//tei:body">
        <text>
            <body><xsl:apply-templates/></body>
        </text>
    </xsl:template>
    <xsl:template match="//tei:p[not(parent::tei:note)]">
        <p>
            <xsl:value-of select="."/>
        </p>
    </xsl:template>
    
    <xsl:template match="//tei:pb[parent::tei:body]">
        <pb>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <xsl:attribute name="n">
                <xsl:value-of select="@n"/>
            </xsl:attribute>
        </pb>
    </xsl:template>
</xsl:stylesheet>
