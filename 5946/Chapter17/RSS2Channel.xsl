<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rss="http://purl.org/rss/1.0/"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:rev="http://www.example.com/reviews"
                exclude-result-prefixes="rdf rss dc rev">

<xsl:strip-space elements="*" />

<xsl:output indent="yes" />

<xsl:template match="rdf:RDF">
  <Channel>
    <xsl:apply-templates select="rss:channel" />
    <xsl:apply-templates select="rss:item">
      <xsl:sort select="position()" order="descending" data-type="number" />
    </xsl:apply-templates>
  </Channel>
</xsl:template>

<xsl:template match="rss:channel">
  <xsl:apply-templates select="rss:title" />
</xsl:template>

<xsl:template match="rss:channel/rss:title">
  <Name><xsl:value-of select="." /></Name>
</xsl:template>

<xsl:template match="rss:item">
  <xsl:variable name="videoPlus" select="dc:identifier" />
  <Program videoPlus="{$videoPlus}">
    <xsl:for-each select="$reviews">
      <xsl:apply-templates select="key('reviews', $videoPlus)/rev:rating" />
    </xsl:for-each>
    <xsl:apply-templates select="@rdf:about" />
    <xsl:apply-templates select="." mode="duration" />
    <xsl:apply-templates select="rss:title" />
    <Title />
    <xsl:apply-templates select="rss:description" />
  </Program>
</xsl:template>

<xsl:template match="rss:item/rss:title">
  <Series><xsl:value-of select="." /></Series>
</xsl:template>

<xsl:template match="rss:description">
  <Description><xsl:value-of select="." /></Description>
</xsl:template>

<xsl:template match="@rdf:about">
  <Start><xsl:value-of select="substring-after(., '#')" /></Start>
</xsl:template>

<xsl:template match="rss:item" mode="duration">
  <xsl:variable name="nextProgram" 
                select="preceding-sibling::rss:item[1]" />
  <xsl:if test="$nextProgram">
    <Duration>
      <xsl:variable name="start" 
        select="substring-after(@rdf:about, '#')" />
      <xsl:variable name="end" 
        select="substring-after($nextProgram/@rdf:about, '#')" />
      <xsl:variable name="startHour" select="substring($start, 12, 2)" />
      <xsl:variable name="startMin" select="substring($start, 15, 2)" />
      <xsl:variable name="endHour" select="substring($end, 12, 2)" />
      <xsl:variable name="endMin" select="substring($end, 15, 2)" />
      <xsl:variable name="durHours">
      <xsl:variable name="minAdjust" select="$startMin > $endMin" />
        <xsl:choose>
          <xsl:when test="$startHour > $endHour">
            <xsl:value-of select="($endHour + 24) - $startHour - 
                                  $minAdjust" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$endHour - $startHour - $minAdjust" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="durMins">
        <xsl:choose>
          <xsl:when test="$startMin > $endMin">
            <xsl:value-of select="($endMin + 60) - $startMin" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$endMin - $startMin" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:text>PT</xsl:text>
      <xsl:if test="number($durHours)">
        <xsl:value-of select="$durHours" />
        <xsl:text>H</xsl:text>
      </xsl:if>
      <xsl:if test="number($durMins)">
        <xsl:value-of select="$durMins" />
        <xsl:text>M</xsl:text>
      </xsl:if>
    </Duration>
  </xsl:if>
</xsl:template>

<xsl:variable name="reviews" select="document('reviews.rss')" />

<xsl:key name="reviews" match="rss:item"
   use="substring-before(
          substring-after(rss:link, 'http://www.example.com/reviews/'),
          '.html')" />

<xsl:template match="rev:rating">
  <xsl:attribute name="rating">
    <xsl:value-of select="." />
  </xsl:attribute>
</xsl:template>

</xsl:stylesheet>
