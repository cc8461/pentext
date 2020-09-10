<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">


    <xsl:template name="getNumber">
        <xsl:param name="execsummary" select="false()" tunnel="yes"/>
        <xsl:param name="elementToNumber" select="." as="node()"/>
        <xsl:choose>
            <xsl:when test="$elementToNumber[self::finding]">
                <!-- Output finding display number -->
                <xsl:variable name="findingNumber" select="$elementToNumber/@number"/>
                <xsl:variable name="numFormat" select="'000'"/>
                <xsl:value-of
                    select="concat(ancestor::*[@findingCode][1]/@findingCode, '-', string(format-number($findingNumber, $numFormat)))"
                />
            </xsl:when>
            <xsl:when test="$elementToNumber[self::non-finding]">
                <xsl:variable name="nonFindingNumber" select="$elementToNumber/@number" as="xs:integer"/>
                <xsl:variable name="numFormat" select="'000'"/>
                <xsl:value-of
                    select="concat('NF-', string(format-number($nonFindingNumber, $numFormat)))"
                />
            </xsl:when>
            <xsl:when test="$elementToNumber[self::section[not(@visibility = 'hidden')]] or $elementToNumber[self::appendix[not(@visibility = 'hidden')]]">
                <xsl:choose>
                    <xsl:when test="$execsummary = true()">
                        <xsl:choose>
                            <xsl:when test="$elementToNumber[self::appendix]">
                                <fo:inline> Appendix&#160;<xsl:number
                                    count="appendix[not(@visibility = 'hidden')][@inexecsummary = 'yes']"
                                    level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/>
                                </fo:inline>
                            </xsl:when>
                            <xsl:when test="$elementToNumber[ancestor::appendix]">
                                <fo:inline> App&#160;<xsl:number count="appendix" level="multiple"
                                    format="{$AUTO_NUMBERING_FORMAT}"/>.<xsl:number
                                        count="section[ancestor::appendix][not(@visibility = 'hidden')][@inexecsummary = 'yes']"
                                        level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/>
                                </fo:inline>
                            </xsl:when>
                            <xsl:otherwise>
                                <fo:inline>
                                    <xsl:number
                                        count="section[not(@visibility = 'hidden')][ancestor-or-self::*/@inexecsummary = 'yes'] | finding | non-finding"
                                        level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/>
                                </fo:inline>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$elementToNumber[self::appendix]">
                                <fo:inline> Appendix&#160;<xsl:number
                                    count="appendix[not(@visibility = 'hidden')]" level="multiple"
                                    format="{$AUTO_NUMBERING_FORMAT}"/>
                                </fo:inline>
                            </xsl:when>
                            <xsl:when test="$elementToNumber[ancestor::appendix]">
                                <fo:inline> App&#160;<xsl:number count="appendix" level="multiple"
                                    format="{$AUTO_NUMBERING_FORMAT}"/>.<xsl:number
                                        count="section[ancestor::appendix][not(@visibility = 'hidden')]"
                                        level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/>
                                </fo:inline>
                            </xsl:when>
                            <xsl:otherwise>
                                <fo:inline>
                                    <xsl:number
                                        count="section[not(@visibility = 'hidden')] | finding | non-finding"
                                        level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/>
                                </fo:inline>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$elementToNumber[self::biblioentry]">
                <fo:inline>
                    <xsl:number count="biblioentry" format="{$AUTO_NUMBERING_FORMAT}"/>
                </fo:inline>
            </xsl:when>
        </xsl:choose>        
    </xsl:template>
    
    <xsl:template name="prependId">
        <xsl:choose>
                <xsl:when test="parent::finding or parent::non-finding">
                    <!-- prepend finding id (XXX-NNN) -->
                    <xsl:call-template name="getNumber">
                        <xsl:with-param name="elementToNumber" select=".."/>
                    </xsl:call-template>
                    <xsl:text> &#8212; </xsl:text>
                </xsl:when>
                <xsl:when test="parent::non-finding">
                    <!-- prepend non-finding id (NF-NNN) -->
                    <xsl:apply-templates select=".." mode="number"/>
                    <xsl:text> &#8212; </xsl:text>
                </xsl:when>
            </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
