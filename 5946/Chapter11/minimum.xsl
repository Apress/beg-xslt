<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <xsl:call-template name="minimum">
    <xsl:with-param name="nodes" select="values/value" />
  </xsl:call-template>
</xsl:template>

<xsl:template name="minimum">
  <xsl:param name="nodes" select="/.." />
  <xsl:param name="minimum" select="number($nodes[1])" />
  <xsl:choose>
    <xsl:when test="$nodes">
      <xsl:variable name="value" select="number($nodes[1])" />
      <xsl:call-template name="minimum">
        <xsl:with-param name="nodes" select="$nodes[position() > 1]" />
        <xsl:with-param name="minimum">
          <xsl:choose>
            <xsl:when test="$minimum &lt;= $value">
              <xsl:value-of select="$minimum" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$value" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$minimum" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>