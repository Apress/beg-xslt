<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="replace.xsl"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <xsl:call-template name="replace">
    <xsl:with-param name="string" select="'This is a test string for testers'" />
    <xsl:with-param name="search" select="'test'" />
    <xsl:with-param name="replace"><b>test</b></xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="replace">
  <xsl:param name="string" />
  <xsl:param name="search" select="'&#xA;'" />
  <xsl:param name="replace"><br /></xsl:param>
  <xsl:choose>
    <xsl:when test="$search and contains($string, $search)">
      <xsl:value-of select="substring-before($string, $search)" />
      <xsl:copy-of select="$replace" />
      <xsl:call-template name="replace">
        <xsl:with-param name="string" 
                        select="substring-after($string, $search)" />
        <xsl:with-param name="search" select="$search" />
        <xsl:with-param name="replace" select="$replace" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$string" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>