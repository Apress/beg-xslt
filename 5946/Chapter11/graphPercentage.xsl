<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <html>
    <head><title>Test Graph</title></head>
    <body>
      <xsl:apply-templates />
    </body>
  </html>
</xsl:template>

<xsl:template match="value">
  <xsl:value-of select="." />
  <xsl:text>: </xsl:text>
  <xsl:call-template name="graphPercentage">
    <xsl:with-param name="percentage" select="." />
  </xsl:call-template>
  <br />
</xsl:template>

<xsl:template name="graphPercentage">
  <xsl:param name="percentage" select="0" />
  <xsl:choose>
    <xsl:when test="$percentage >= 10">
      <img src="ten.gif" alt="**********" width="10" height="10" />
      <xsl:call-template name="graphPercentage">
        <xsl:with-param name="percentage" select="$percentage - 10" />
      </xsl:call-template>      
    </xsl:when>
    <xsl:when test="$percentage >= 1">
      <img src="one.gif" alt="*" width="1" height="10" />
      <xsl:call-template name="graphPercentage">
        <xsl:with-param name="percentage" select="$percentage - 1" />
      </xsl:call-template>      
    </xsl:when>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>