<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="replaceWhitespace.xsl"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <xsl:call-template name="replaceWhitespace">
    <xsl:with-param name="string" select="'&#x9;This is a test string&#xA;&#xD;for testers'" />
  </xsl:call-template>
</xsl:template>

<xsl:template name="replaceWhitespace">
  <xsl:param name="string" />
  <xsl:choose>
    <!-- replacing tabs -->
    <xsl:when test="contains($string, '&#x9;')">
      <xsl:call-template name="replaceWhitespace">
        <xsl:with-param name="string" 
                        select="substring-before($string, '&#x9;')" />
      </xsl:call-template>
      <xsl:text>   </xsl:text>
      <xsl:call-template name="replaceWhitespace">
        <xsl:with-param name="string" 
                        select="substring-after($string, '&#x9;')" />
      </xsl:call-template>
    </xsl:when>
    <!-- replacing carriage returns -->
    <xsl:when test="contains($string, '&#xD;')">
      <xsl:call-template name="replaceWhitespace">
        <xsl:with-param name="string" 
                        select="substring-before($string, '&#xD;')" />
      </xsl:call-template>
      <xsl:call-template name="replaceWhitespace">
        <xsl:with-param name="string" 
                        select="substring-after($string, '&#xD;')" />
      </xsl:call-template>
    </xsl:when>
    <!-- replacing new lines -->
    <xsl:when test="contains($string, '&#xA;')">
      <xsl:call-template name="replaceWhitespace">
        <xsl:with-param name="string" 
                        select="substring-before($string, '&#xA;')" />
      </xsl:call-template>
      <br />
      <xsl:call-template name="replaceWhitespace">
        <xsl:with-param name="string" 
                        select="substring-after($string, '&#xA;')" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$string" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>