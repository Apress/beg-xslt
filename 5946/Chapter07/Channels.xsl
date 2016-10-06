<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tv="http://www.example.com/TVGuide">

<xsl:template match="tv:Channel">
  Channel: <xsl:value-of select="tv:Name" />
</xsl:template>

</xsl:stylesheet>