<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="pad.xsl"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <xsl:call-template name="pad">
    <xsl:with-param name="length" select="10" />
    <xsl:with-param name="char" select="'*'" />
  </xsl:call-template>
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