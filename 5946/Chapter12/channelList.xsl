<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml">

<xsl:variable name="ChannelList">
  <p><xsl:apply-templates mode="ChannelList" /></p>
</xsl:variable>

<xsl:template match="TVGuide" mode="ChannelList">
  <xsl:apply-templates select="Channel" mode="ChannelList">
    <xsl:sort select="Name" />
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="Channel" mode="ChannelList">
  <xsl:call-template name="link">
    <xsl:with-param name="href" select="concat('#', Name)" />
    <xsl:with-param name="content" select="string(Name)" />
  </xsl:call-template>
  <xsl:if test="position() != last()"> | </xsl:if>
</xsl:template>

</xsl:stylesheet>