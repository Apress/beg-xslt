<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml">

<xsl:template match="Description//Actor">
  <span class="actor"><xsl:apply-templates /></span>
</xsl:template>

<xsl:template match="Description//Link">
  <xsl:call-template name="link">
    <xsl:with-param name="href" select="@href" />
    <xsl:with-param name="content">
      <xsl:apply-templates />
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="Description//Program">
  <span class="program"><xsl:apply-templates /></span>
</xsl:template>

<xsl:template match="Description//Series">
  <span class="series"><xsl:apply-templates /></span>
</xsl:template>

<xsl:template match="Description//Channel">
  <span class="channel"><xsl:apply-templates /></span>
</xsl:template>

<xsl:template match="Description//text()">
  <xsl:call-template name="highlightKeywords">
    <xsl:with-param name="string" select="." />
    <xsl:with-param name="keywords" select="$prefs/Keywords/Keyword" />
  </xsl:call-template>
</xsl:template>

<xsl:template name="highlightKeywords">
  <xsl:param name="string" />
  <xsl:param name="keywords" select="/TVGuide/Keywords/Keyword" />
  <xsl:variable name="keyword" 
                select="$keywords[contains($string, .)][1]" />
  <xsl:choose>
    <xsl:when test="$keyword">
      <xsl:call-template name="highlightKeywords">
        <xsl:with-param name="string"
                        select="substring-before($string, $keyword)" />
        <xsl:with-param name="keywords" select="$keywords" />
      </xsl:call-template>
      <span class="keyword">
        <xsl:value-of select="$keyword" />
      </span>
      <xsl:call-template name="highlightKeywords">
        <xsl:with-param name="string"
                        select="substring-after($string, $keyword)" />
        <xsl:with-param name="keywords" select="$keywords" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$string" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>