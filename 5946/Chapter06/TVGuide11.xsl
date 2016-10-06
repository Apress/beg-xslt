<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:variable name="ChannelList">
  <p><xsl:apply-templates mode="ChannelList" /></p>
</xsl:variable>

<xsl:template match="/">
  <html>
    <head>
      <title>TV Guide</title>
      <link rel="stylesheet" href="TVGuide.css" />
      <script type="text/javascript">
        function toggle(element) {
          if (element.style.display == 'none') {
            element.style.display = 'block';
          } else {
            element.style.display = 'none';
          }
        }
      </script>
    </head>

    <body>
      <h1>TV Guide</h1>
      <xsl:copy-of select="$ChannelList" />
      <xsl:apply-templates />
      <xsl:copy-of select="$ChannelList" />
    </body>
  </html>
</xsl:template>

<xsl:template match="Channel" mode="ChannelList">
  <a href="#{Name}"><xsl:value-of select="Name" /></a>
  <xsl:if test="position() != last()"> | </xsl:if>
</xsl:template>

<xsl:template match="Channel">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="Channel/Name">
  <h2 class="channel">
    <a name="{.}" id="{.}"><xsl:apply-templates /></a>
  </h2>
</xsl:template>

<xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
<xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'" />

<xsl:variable name="keyword" select="'news'" />

<xsl:template match="Program">
  <xsl:choose>
    <xsl:when test="@flag = 'favorite' or @flag = 'interesting' or
                    @rating > 6 or 
                    contains(translate(Series, $upper, $lower), $keyword) or
                    contains(translate(Title, $upper, $lower), $keyword) or 
                    contains(translate(Description, $upper, $lower), $keyword)">
      <div class="interesting">
        <xsl:apply-templates select="." mode="Details" />
      </div>
    </xsl:when>
    <xsl:otherwise>
      <div>
        <xsl:apply-templates select="." mode="Details" />
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:variable name="StarTrekLogo">
  <img src="StarTrek.gif" alt="[Star Trek]" width="20" height="20" />
</xsl:variable>

<xsl:template match="Program" mode="Details">
  <p>
    <xsl:apply-templates select="Start" /><br />
    <xsl:variable name="image">
      <xsl:choose>
        <xsl:when test="@flag = 'favorite'">favorite</xsl:when>
        <xsl:when test="@flag = 'interesting'">interest</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="alt">
      <xsl:choose>
        <xsl:when test="@flag = 'favorite'">Favorite</xsl:when>
        <xsl:when test="@flag = 'interesting'">Interest</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="@flag">
      <img src="{$image}.gif" alt="[{$alt}]" width="20" height="20" />
    </xsl:if>
    <xsl:if test="starts-with(Series, 'StarTrek')">
      <xsl:copy-of select="$StarTrekLogo" />
    </xsl:if>
    <xsl:apply-templates select="." mode="Title" />
    <br />
    <xsl:apply-templates select="Description" />
    <xsl:apply-templates select="CastList" mode="DisplayToggle" />
  </p>
  <xsl:apply-templates select="CastList" />
</xsl:template>

<xsl:template match="Start">
  <xsl:variable name="dateTime" select="normalize-space()" />
  <xsl:variable name="year" select="substring($dateTime, 1, 4)" />
  <xsl:variable name="month" select="number(substring($dateTime, 6, 2))" />
  <xsl:variable name="day" select="number(substring($dateTime, 9, 2))" />
  <xsl:variable name="time" select="substring($dateTime, 12, 5)" />
  <span class="date">
    <xsl:value-of select="concat($month, '/', $day, '/', $year, ' ', $time)" />
  </span>
</xsl:template>

<xsl:template match="Program" mode="Title">
  <span class="title">
    <xsl:choose>
      <xsl:when test="string(Series)">
       <xsl:value-of select="Series" />
        <xsl:if test="string(Title)">
        - <span class="subtitle"><xsl:value-of select="Title" /></span>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="Title" />
      </xsl:otherwise>
    </xsl:choose>
  </span>
</xsl:template>

<xsl:template match="CastList" mode="DisplayToggle">
  <span onclick="toggle({Series}Cast);">[Cast]</span>
</xsl:template>

<xsl:template match="CastList">
  <div id="{Series}Cast" style="display: none;">
    <ul class="castlist"><xsl:apply-templates /></ul>
  </div>
</xsl:template>

<xsl:template match="CastMember">
  <li>
    <xsl:apply-templates select="Character" />
    <xsl:apply-templates select="Actor" />
  </li>
</xsl:template>

<xsl:template match="Character">
  <span class="character">
    <xsl:choose>
      <xsl:when test="Name">
        <xsl:apply-templates select="Name" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates />
      </xsl:otherwise>
    </xsl:choose>
  </span>
</xsl:template>

<xsl:template match="Actor">
  <span class="actor"><xsl:apply-templates select="Name" /></span>
</xsl:template>

<xsl:template match="Description//Actor">
  <span class="actor"><xsl:apply-templates /></span>
</xsl:template>

<xsl:template match="Description//Link">
  <a href="{@href}"><xsl:apply-templates /></a>
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

</xsl:stylesheet>