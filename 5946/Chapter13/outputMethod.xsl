<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="outputMethod.xsl"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes" />

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