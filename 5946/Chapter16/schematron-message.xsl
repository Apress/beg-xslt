<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias">

<xsl:import href="skeleton1-5.xsl" />

<xsl:namespace-alias stylesheet-prefix="axsl" result-prefix="xsl" />

<xsl:template name="process-message">
  <axsl:message>
    <xsl:apply-templates mode="text" />
  </axsl:message>
</xsl:template>

</xsl:stylesheet>
