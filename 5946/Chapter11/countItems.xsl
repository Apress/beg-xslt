<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="countItems.xsl"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <xsl:call-template name="countItems">
    <xsl:with-param name="string" select="'This is a test string for testers'" />
    <xsl:with-param name="delimiter" select="' '" />
  </xsl:call-template>
</xsl:template>

<xsl:template name="countItems">
  <xsl:param name="string" />
  <xsl:param name="delimiter" select="' '" />
  <xsl:param name="count" select="0" />
  <xsl:choose>
    <xsl:when test="contains($string, $delimiter)">
      <xsl:call-template name="countItems">
        <xsl:with-param name="string"
                        select="substring-after($string, $delimiter)" />
        <xsl:with-param name="delimiter" select="$delimiter" />
        <xsl:with-param name="count" select="$count + 1" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$count + 1" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>