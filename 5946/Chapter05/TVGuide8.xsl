<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

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
      <p>
        <xsl:apply-templates mode="ChannelList" />
      </p>
      <xsl:apply-templates />
      <p>
        <xsl:apply-templates mode="ChannelList" />
      </p>
    </body>
  </html>
</xsl:template>

<xsl:template match="Channel" mode="ChannelList">
  <xsl:if test="Program/@flag">
    [<a href="#{Name}"><xsl:value-of select="Name" /></a>]
  </xsl:if>
</xsl:template>

<xsl:template match="Channel">
  <xsl:if test="Program/@flag">
    <xsl:apply-templates />
  </xsl:if>
</xsl:template>

<xsl:template match="Channel/Name">
  <h2 class="channel">
    <a name="{.}" id="{.}"><xsl:apply-templates /></a>
  </h2>
</xsl:template>

<xsl:template match="Program">
  <div>
    <p>
      <xsl:apply-templates select="Start" /><br />
      <xsl:choose>
        <xsl:when test="@flag = 'favorite'">
          <img src="favorite.gif" alt="[Favorite]" width="20" height="20" />
        </xsl:when>
        <xsl:when test="@flag = 'interesting'">
          <img src="interest.gif" alt="[Interest]" width="20" height="20" />
        </xsl:when>
      </xsl:choose>
      <xsl:if test="starts-with(Series, 'StarTrek')">
        <img src="StarTrek.gif" alt="[Star Trek]" width="20" height="20" />
      </xsl:if>
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
      <br />
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

<xsl:template match="Start">
  <span class="date"><xsl:apply-templates /></span>
</xsl:template>

<xsl:template match="CastList">
  <ul class="castlist"><xsl:apply-templates /></ul>
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