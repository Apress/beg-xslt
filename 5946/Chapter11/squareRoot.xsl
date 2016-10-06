<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="squareRoot.xsl"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <xsl:call-template name="squareRoot">
    <xsl:with-param name="number" select="10" />
  </xsl:call-template>
</xsl:template>

<xsl:template name="squareRoot">
  <xsl:param name="number" select="0" />  
  <xsl:param name="precision" select="4" />
  <xsl:param name="estimate" select="1" />
  <xsl:param name="format">
    <xsl:text>0.</xsl:text>
    <xsl:call-template name="pad">
      <xsl:with-param name="length" select="$precision" />
      <xsl:with-param name="char" select="'0'" />
    </xsl:call-template>
  </xsl:param>
  <xsl:variable name="nextEstimate" 
    select="format-number($estimate + (($number - $estimate * $estimate) div 
                                       (2 * $estimate)), $format)" />
  <xsl:choose>
    <xsl:when test="number($estimate) = number($nextEstimate)">
      <xsl:value-of select="number($estimate)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="squareRoot">
        <xsl:with-param name="number" select="$number"/>
        <xsl:with-param name="estimate" select="$nextEstimate" />
        <xsl:with-param name="format" select="$format" />
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="pad">
  <xsl:param name="length" select="1" />
  <xsl:param name="char" select="' '" />
  <xsl:if test="$length > 0">
    <xsl:value-of select="$char" />
    <xsl:call-template name="pad">
      <xsl:with-param name="length" select="$length - 1" />
      <xsl:with-param name="char" select="$char" />
    </xsl:call-template>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>