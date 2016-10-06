<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="ul">
  <CastList><xsl:apply-templates /></CastList>
</xsl:template>

<xsl:template match="li">
  <CastMember><xsl:apply-templates /></CastMember>
</xsl:template>

<xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
<xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'" />

<xsl:template match="span">
  <xsl:variable name="name"
                select="concat(translate(substring(@class, 1, 1),
                                         $lower, $upper),
                               substring(@class, 2))" />
  <xsl:element name="{$name}">
    <Name><xsl:value-of select="." /></Name>
  </xsl:element>
</xsl:template>

</xsl:stylesheet>