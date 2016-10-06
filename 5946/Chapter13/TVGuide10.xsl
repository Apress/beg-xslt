<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:math="http://exslt.org/math"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:redirect="org.apache.xalan.xslt.extensions.Redirect"
                extension-element-prefixes="math saxon redirect">

<xsl:import href="utils5.xsl" />

<xsl:variable name="series"
              select="document('series.xml', /)/SeriesList" />
<xsl:variable name="listing"
              select="/TVGuide" />

<xsl:param name="userID" select="'default'" />

<xsl:variable name="prefs" 
              select="document(concat($userID, '.xml'))/Prefs" />

<xsl:output method="xml"
            media-type="text/html"
            doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
            doctype-system="DTD/xhtml1-strict.dtd"
            encoding="ISO-8859-1"
            indent="yes" />

<xsl:template match="/">
  <html>
    <head>
      <title>TV Guide</title>
      <link rel="stylesheet" href="TVGuide.css" />
      <script type="text/javascript">
        <![CDATA[
        function toggle(element) {
          if (element.style.display == 'none') {
            element.style.display = 'block';
          } else {
            element.style.display = 'none';
          }
        }
        ]]>
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

<xsl:param name="sortOrder" select="'descending'" />

<xsl:template match="TVGuide">
  <table>
    <tr>
      <th colspan="6">Channel</th>
      <xsl:call-template name="generateTimeline">
        <xsl:with-param name="startHours" select="19" />
        <xsl:with-param name="startMinutes" select="00" />
        <xsl:with-param name="endHours" select="22" />
        <xsl:with-param name="endMinutes" select="30" />
      </xsl:call-template>
    </tr>
    <xsl:apply-templates select="Channel" mode="Table" />
  </table>
  <xsl:choose>
    <xsl:when test="element-available('saxon:output')">
      <xsl:for-each select="Channel">
        <saxon:output href="{translate(Name, ' ', '_')}.html">
          <xsl:apply-templates select="." mode="page" />
        </saxon:output>
      </xsl:for-each>
    </xsl:when>
    <xsl:when test="element-available('redirect:write')">
      <xsl:for-each select="Channel">
        <redirect:write select="concat(translate(Name, ' ', '_'), '.html')">
          <xsl:apply-templates select="." mode="page" />
        </redirect:write>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="Channel" />
    </xsl:otherwise>
  </xsl:choose>
  <h2>Series</h2>
  <xsl:for-each select="$series">
    <xsl:call-template name="alphabetList" />
    <xsl:call-template name="alphabeticalSeriesList" />
  </xsl:for-each>
</xsl:template>

<xsl:template match="Channel" mode="page">
  <html>
    <head>
      <title><xsl:value-of select="Name" /></title>
      <link rel="stylesheet" href="TVGuide.css" />
      <script type="text/javascript">
        <![CDATA[
        function toggle(element) {
          if (element.style.display == 'none') {
            element.style.display = 'block';
          } else {
            element.style.display = 'none';
          }
        }
        ]]>
      </script>
    </head>
    <body>
      <xsl:apply-templates select="." />
    </body>
  </html>
</xsl:template>

<xsl:template match="Channel">
  <xsl:apply-templates select="Name" />
  <p class="average">
    <xsl:text>average rating: </xsl:text>
    <xsl:value-of select="format-number(sum(Program/@rating) div count(Program), '0.0')" />
    <br />
    <xsl:text>good programs for: </xsl:text>
    <xsl:call-template name="totalDuration">
      <xsl:with-param name="programs" select="Program[@rating > 5]" />
    </xsl:call-template>
    <xsl:text>hrs</xsl:text>
    <br />
    <xsl:text>highest rating:</xsl:text>
    <xsl:choose>
      <xsl:when test="function-available('math:max')">
        <xsl:value-of select="math:max(Program/@rating)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="maximum">
          <xsl:with-param name="nodes" select="Program/@rating" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </p>
  <xsl:apply-templates select="Program" />
</xsl:template>

<xsl:template match="Channel/Name">
  <h2 class="channel">
    <a name="{.}" id="{.}"><xsl:apply-templates /></a>
  </h2>
</xsl:template>

<xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
<xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'" />

<xsl:variable name="keyword" select="'news'" />

<xsl:template match="Program[1]">
  <div class="nowShowing">
    <xsl:apply-templates select="." mode="Details" />
  </div>
</xsl:template>

<xsl:template match="Program">
  <div>
    <xsl:if test="@rating > 6">
      <xsl:attribute name="class">interesting</xsl:attribute>
    </xsl:if>
    <xsl:apply-templates select="." mode="Details" />
  </div>
</xsl:template>

<xsl:variable name="StarTrekLogo">
  <img src="StarTrek.gif" alt="[Star Trek]" width="20" height="20" />
</xsl:variable>

<xsl:template match="Program" mode="Details">
  <xsl:variable name="programID" select="concat(generate-id(), 'Cast')" />
  <p>
    <a name="{generate-id()}" id="{generate-id()}">
      <xsl:apply-templates select="Start" />
    </a>
    <br />
    <xsl:apply-templates select="." mode="generateStars" />
    <br />
    <xsl:apply-templates select="." mode="flag" />
    <xsl:if test="starts-with(Series, 'StarTrek')">
      <xsl:copy-of select="$StarTrekLogo" />
    </xsl:if>
    <xsl:apply-templates select="." mode="Title" />
    <br />
    <xsl:apply-templates select="Description" />
    <xsl:apply-templates select="CastList" mode="DisplayToggle">
      <xsl:with-param name="divID" select="$programID" />
    </xsl:apply-templates>
  </p>
  <xsl:apply-templates select="CastList">
    <xsl:with-param name="divID" select="$programID" />
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="Start">
  <xsl:variable name="dateTime" select="normalize-space()" />
  <xsl:variable name="year" select="substring($dateTime, 1, 4)" />
  <xsl:variable name="month" select="number(substring($dateTime, 6, 2))" />
  <xsl:variable name="day" select="number(substring($dateTime, 9, 2))" />
  <xsl:variable name="time" select="substring($dateTime, 12, 5)" />
  <xsl:variable name="endDateTime"
    select="parent::Program/following-sibling::Program[1]/Start" />
  <xsl:variable name="endTime">
    <xsl:choose>
      <xsl:when test="$endDateTime">
        <xsl:value-of select="substring(normalize-space($endDateTime), 12, 5)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="durationMins">
          <xsl:call-template name="durationMins">
            <xsl:with-param name="duration" select="../Duration" />
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="startHours" select="substring($time, 1, 2)" />
        <xsl:variable name="startMinutes" select="substring($time, 4, 2)" />
        <xsl:variable name="endMinutes" 
                      select="($startMinutes + $durationMins) mod 60" />
        <xsl:variable name="endHours"
          select="floor((($startMinutes + $durationMins) div 60) + $startHours) 
                  mod 24" />
        <xsl:value-of select="concat(format-number($endHours, '00'), ':',
                                     format-number($endMinutes, '00'))" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <span class="date">
    <xsl:value-of select="concat($month, '/', $day, '/', $year, ' ', $time, 
                                 ' - ', $endTime)" />
  </span>
</xsl:template>

<xsl:template match="Program" mode="generateStars" name="generateStars">
  <xsl:param name="rating" select="@rating" />
  <xsl:if test="$rating > 0">
    <img src="star.gif" alt="*" height="15" width="15" />
    <xsl:call-template name="generateStars">
      <xsl:with-param name="rating" select="$rating - 1" />
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="Program" mode="flag">
  <xsl:variable name="favorite" select="$prefs/Series/Series/@ref = Series" />
  <xsl:variable name="channel" select="parent::Channel/Name" />
  <xsl:variable name="start" select="Start" />
  <xsl:variable name="interesting" 
                select="$prefs/Programs/Program[@channel = $channel and
                                                @start = $start]" />
  <xsl:if test="$favorite or $interesting">
    <xsl:variable name="image">
      <xsl:choose>
        <xsl:when test="$favorite">favorite</xsl:when>
        <xsl:when test="$interesting">interest</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="alt">
      <xsl:choose>
        <xsl:when test="$favorite">Favorite</xsl:when>
        <xsl:when test="$interesting">Interest</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <img src="{$image}.gif" alt="[{$alt}]" width="20" height="20" />
  </xsl:if>
</xsl:template>

<xsl:key name="IDs" match="Series" use="@id" />

<xsl:template match="Program" mode="Title">
  <span class="title">
    <xsl:choose>
      <xsl:when test="string(Series)">
        <xsl:call-template name="link">
          <xsl:with-param name="href" select="concat('#', Series)" />
          <xsl:with-param name="content">
            <xsl:variable name="seriesID" select="Series" />
            <xsl:for-each select="$series">
              <xsl:value-of select="key('IDs', $seriesID)/Title" />
            </xsl:for-each>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:if test="string(Title)">
          <xsl:text> - </xsl:text>
          <span class="subtitle"><xsl:value-of select="Title" /></span>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="Title" />
      </xsl:otherwise>
    </xsl:choose>
  </span>
</xsl:template>

<xsl:template match="CastList" mode="DisplayToggle">
  <xsl:param name="divID" />
  <span onclick="toggle({$divID});">[Cast]</span>
</xsl:template>

<xsl:template match="CastList">
  <xsl:param name="divID" />
  <div id="{$divID}" style="display: none;" class="castlist">
    <xsl:apply-templates select="CastMember">
      <xsl:sort select="substring-after(Character/Name, ' ')" />
      <xsl:sort select="substring-before(Character/Name, ' ')" />
    </xsl:apply-templates>
  </div>
</xsl:template>

<xsl:template match="CastMember">
  <div class="castmember">
    <span class="number">
      <xsl:number value="position()" format="{{1}}" />
    </span>
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="Character" />
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="Actor" />
  </div>
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

<xsl:include href="description.xsl" />

<xsl:include href="channelList.xsl" />
<xsl:include href="table.xsl" />
<xsl:include href="series6.xsl" />

<xsl:attribute-set name="linkEvents">
  <xsl:attribute name="style">
    <xsl:text>color: black; border-bottom: 1pt groove #CCC</xsl:text>
  </xsl:attribute>
  <xsl:attribute name="onmouseover">
    <xsl:text>javascript:this.style.background = '#CCC';</xsl:text>
  </xsl:attribute>
  <xsl:attribute name="onmouseout">
    <xsl:text>javascript:this.style.background = 'transparent';</xsl:text>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:template name="link">
  <xsl:param name="href" />
  <xsl:param name="content" />
  <a href="{$href}" xsl:use-attribute-sets="linkEvents">
    <xsl:copy-of select="$content" />
  </a>
</xsl:template>

</xsl:stylesheet>