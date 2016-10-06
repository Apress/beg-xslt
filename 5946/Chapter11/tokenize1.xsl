<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="tokenize1.xsl"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <xsl:call-template name="tokenize">
    <xsl:with-param name="string" select="'2 23 67 124 13 9'" />
  </xsl:call-template>
</xsl:template>

<xsl:template name="tokenize">
  <xsl:param name="string" />
  <xsl:param name="delimiter" select="' '" />
  <xsl:choose>
    <xsl:when test="$delimiter and contains($string, $delimiter)">
      <token>
        <xsl:value-of select="substring-before($string, $delimiter)" />
      </token>
      <xsl:call-template name="tokenize">
        <xsl:with-param name="string" 
                        select="substring-after($string, $delimiter)" />
        <xsl:with-param name="delimiter" select="$delimiter" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <token><xsl:value-of select="$string" /></token>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>