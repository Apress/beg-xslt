<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="power.xsl"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <xsl:call-template name="power">
    <xsl:with-param name="number" select="2" />
    <xsl:with-param name="power" select="8" />
  </xsl:call-template>
</xsl:template>

<xsl:template name="power">
  <xsl:param name="number" select="1" />
  <xsl:param name="power" select="1" />
  <xsl:param name="result" select="1" />
  <xsl:choose>
    <xsl:when test="$power = 0">
      <xsl:value-of select="$result"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="power">
        <xsl:with-param name="number" select="$number" />
        <xsl:with-param name="power" select="$power - 1" />
        <xsl:with-param name="result" select="$result * $number" />
      </xsl:call-template>  
    </xsl:otherwise>  
  </xsl:choose>  
</xsl:template>

</xsl:stylesheet>