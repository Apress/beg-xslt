<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:variable name="foo" select="'foo'" />

<xsl:template match="/">              
  <xsl:variable name="foo">
    <xsl:message><xsl:value-of select="$foo" /></xsl:message>
    <xsl:variable name="foo">
      <xsl:message><xsl:value-of select="$foo" /></xsl:message>
      <xsl:value-of select="concat($foo, 'foo')" />
    </xsl:variable>
    <xsl:value-of select="concat($foo, 'foo')" />
  </xsl:variable>
  <xsl:message terminate="yes"><xsl:value-of select="$foo" /></xsl:message>
  <html>
    <head>
      <title>TV Guide</title>
      <link rel="stylesheet" href="TVGuide.css" />
      <script type="text/javascript">
        // <![CDATA[
        function toggle(element) {
          if (element.style.display == 'none') {
            element.style.display = 'block';
          } else {
            element.style.display = 'none';
          }
        }
        // ]]>
      </script>
    </head>

    <body>
      <h1>TV Guide</h1>
      <xsl:apply-templates mode="ChannelList" />
      <xsl:apply-templates />
    </body>
  </html>
</xsl:template>

<xsl:template match="TVGuide">
  <xsl:variable name="StarTrekChannels" 
                select="Channel[Program[starts-with(Series, 'Star Trek')]]" />
  <xsl:choose>
    <xsl:when test="$StarTrekChannels">
      <xsl:apply-templates select="$StarTrekChannels" />
    </xsl:when>
    <xsl:otherwise>
      <p>No Star Trek showing this week!</p>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="Channel" mode="ChannelList">
  [<a href="#{Name}"><xsl:value-of select="Name" /></a>]
</xsl:template>

<xsl:template match="Channel">
  <xsl:variable name="StarTrekPrograms"
                select="Program[starts-with(Series, 'Star Trek')]" />
  <xsl:if test="$StarTrekPrograms">
    <xsl:apply-templates select="Name" />
    <xsl:apply-templates select="$StarTrekPrograms" />
  </xsl:if>
</xsl:template>

<xsl:template match="Channel/Name">
  <h2 class="channel"><a name="{.}" id="{.}"><xsl:value-of select="." /></a></h2>
</xsl:template>

<xsl:template match="Channel/Program">
  <div>
    <p>
      <xsl:apply-templates select="Series" /><br />
      <xsl:apply-templates select="Description" />
      <xsl:if test="CastList">
        <span onclick="toggle({Series}Cast);">[Cast]</span>
      </xsl:if>
    </p>
    <xsl:if test="CastList">
      <div id="{Series}Cast" style="display: none;">
        <xsl:apply-templates select="CastList" />
      </div>
    </xsl:if>
  </div>
</xsl:template>

<xsl:template match="Program/Series">
  <span class="title"><xsl:value-of select="." /></span>
</xsl:template>

<xsl:template match="Description//Channel">
  <span class="channel">
    <xsl:value-of select="." />
  </span>
</xsl:template>

<xsl:template match="Description//Series">
  <span class="series">
    <xsl:value-of select="." />
  </span>
</xsl:template>

<xsl:template match="Description//Program">
  <span class="program">
    <xsl:value-of select="." />
  </span>
</xsl:template>

<xsl:template match="Description//Character">
  <span class="character">
    <xsl:value-of select="." />
  </span>
</xsl:template>

<xsl:template match="Description//Actor">
  <span class="actor">
    <xsl:value-of select="." />
  </span>
</xsl:template>

<xsl:template match="CastList">
  <ul class="castlist">
    <xsl:apply-templates />
  </ul>
</xsl:template>

<xsl:template match="CastMember">
  <li>
    <xsl:apply-templates select="Character" />
    <xsl:apply-templates select="Actor" />
  </li>
</xsl:template>

<xsl:template match="CastMember/Character">
  <span class="character">
    <xsl:apply-templates select="Name" />
  </span>
</xsl:template>

<xsl:template match="CastMember/Actor">
  <span class="actor">
    <xsl:apply-templates select="Name" />
  </span>
</xsl:template>

</xsl:stylesheet>