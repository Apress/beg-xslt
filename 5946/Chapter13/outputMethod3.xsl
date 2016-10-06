<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="outputMethod3.xsl"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                exclude-result-prefixes="saxon">
<xsl:output method="saxon:xhtml" indent="yes" />

<xsl:template match="/">
  <html>
    <head><title>Sample HTML Document</title></head>
    <body>
      <!-- an empty paragraph -->
      <p />
      <!-- a line break -->
      <br />
    </body>
  </html>
</xsl:template>
</xsl:stylesheet>