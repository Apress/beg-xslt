<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tv="http://www.example.com/TVGuide">

<xsl:variable name="ChannelList">
  <p><xsl:apply-templates mode="ChannelList" /></p>
</xsl:variable>

<xsl:template match="/">
  <html>
    <head>
      <title>TV Guide</title>
      <link rel="stylesheet" href="TVGuide2.css" />
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

<xsl:template match="tv:TVGuide" mode="ChannelList">
  <xsl:apply-templates select="tv:Channel" mode="ChannelList" />
</xsl:template>

<xsl:template match="tv:Channel" mode="ChannelList">
  <a href="#{tv:Name}"><xsl:value-of select="tv:Name" /></a>
  <xsl:if test="position() != last()"> | </xsl:if>
</xsl:template>

<xsl:template match="tv:Channel">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="tv:Channel/tv:Name">
  <h2 class="channel">
    <a name="{.}" id="{.}"><xsl:apply-templates /></a>
  </h2>
</xsl:template>

<xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
<xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'" />

<xsl:variable name="keyword" select="'news'" />

<xsl:template match="tv:Program[1]">
  <div class="nowShowing">
    <xsl:apply-templates select="." mode="Details" />
  </div>
</xsl:template>

<xsl:template match="tv:Program">
  <xsl:choose>
    <xsl:when test="@flag = 'favorite' or @flag = 'interesting' or
                    @rating > 6 or 
                    contains(translate(tv:Series, $upper, $lower), $keyword) or
                    contains(translate(tv:Title, $upper, $lower), $keyword) or 
                    contains(translate(tv:Description, $upper, $lower), $keyword)">
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

<xsl:template match="tv:Program" mode="Details">
  <xsl:variable name="programID" select="concat(tv:Series, 'Cast')" />
  <p>
    <xsl:apply-templates select="tv:Start" /><br />
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
    <xsl:if test="starts-with(tv:Series, 'StarTrek')">
      <xsl:copy-of select="$StarTrekLogo" />
    </xsl:if>
    <xsl:apply-templates select="." mode="Title" />
    <br />
    <xsl:apply-templates select="tv:Description" />
    <xsl:apply-templates select="tv:CastList" mode="DisplayToggle">
      <xsl:with-param name="divID" select="$programID" />
    </xsl:apply-templates>
  </p>
  <xsl:apply-templates select="tv:CastList">
    <xsl:with-param name="divID" select="$programID" />
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="tv:Start">
  <xsl:variable name="dateTime" select="normalize-space()" />
  <xsl:variable name="year" select="substring($dateTime, 1, 4)" />
  <xsl:variable name="month" select="number(substring($dateTime, 6, 2))" />
  <xsl:variable name="day" select="number(substring($dateTime, 9, 2))" />
  <xsl:variable name="time" select="substring($dateTime, 12, 5)" />
  <xsl:variable name="duration" 
                select="substring(normalize-space(../Duration), 3)" />
  <xsl:variable name="durationHours">
    <xsl:choose>
      <xsl:when test="contains($duration, 'H')">
        <xsl:value-of select="substring-before($duration, 'H')" />
      </xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="durationMinutes">
    <xsl:choose>
      <xsl:when test="contains($duration, 'M')">
        <xsl:choose>
          <xsl:when test="contains($duration, 'H')">
            <xsl:value-of select="substring-before(
                                  substring-after($duration, 'H'), 'M')" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="substring-before($duration, 'M')" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="durationMins" 
                select="($durationHours * 60) + $durationMinutes" />
  <xsl:variable name="startHours" select="substring($time, 1, 2)" />
  <xsl:variable name="startMinutes" select="substring($time, 4, 2)" />
  <xsl:variable name="endMinutes" 
                select="($startMinutes + $durationMins) mod 60" />
  <xsl:variable name="endHours"
    select="floor((($startMinutes + $durationMins) div 60) + $startHours) 
            mod 24" />
  <span class="date">
    <xsl:value-of select="concat($month, '/', $day, '/', $year, ' ', $time, 
                                 ' - ', format-number($endHours, '00'), 
                                 ':', format-number($endMinutes, '00'))" />
  </span>
</xsl:template>

<xsl:template match="tv:Program" mode="Title">
  <span class="title">
    <xsl:choose>
      <xsl:when test="string(tv:Series)">
       <xsl:value-of select="tv:Series" />
        <xsl:if test="string(tv:Title)">
        - <span class="subtitle"><xsl:value-of select="tv:Title" /></span>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="tv:Title" />
      </xsl:otherwise>
    </xsl:choose>
  </span>
</xsl:template>

<xsl:template match="tv:CastList" mode="DisplayToggle">
  <xsl:param name="divID" />
  <span onclick="toggle({$divID});">[Cast]</span>
</xsl:template>

<xsl:template match="tv:CastList">
  <xsl:param name="divID" />
  <div id="{$divID}" style="display: none;">
    <ul class="castlist"><xsl:apply-templates /></ul>
  </div>
</xsl:template>

<xsl:template match="tv:CastMember">
  <li>
    <xsl:apply-templates select="tv:Character" />
    <xsl:apply-templates select="tv:Actor" />
  </li>
</xsl:template>

<xsl:template match="tv:Character">
  <span class="character">
    <xsl:choose>
      <xsl:when test="tv:Name">
        <xsl:apply-templates select="tv:Name" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates />
      </xsl:otherwise>
    </xsl:choose>
  </span>
</xsl:template>

<xsl:template match="tv:Actor">
  <span class="actor"><xsl:apply-templates select="tv:Name" /></span>
</xsl:template>

<xsl:template match="tv:Description//tv:Actor">
  <span class="actor"><xsl:apply-templates /></span>
</xsl:template>

<xsl:template match="tv:Description//tv:Link">
  <a href="{@href}"><xsl:apply-templates /></a>
</xsl:template>

<xsl:template match="tv:Description//tv:Program">
  <span class="program"><xsl:apply-templates /></span>
</xsl:template>

<xsl:template match="tv:Description//tv:Series">
  <span class="series"><xsl:apply-templates /></span>
</xsl:template>

<xsl:template match="tv:Description//tv:Channel">
  <span class="channel"><xsl:apply-templates /></span>
</xsl:template>

</xsl:stylesheet>