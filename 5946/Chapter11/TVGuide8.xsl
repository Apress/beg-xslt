<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml">

<xsl:output method="xml"
            media-type="text/html"
            doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
            doctype-system="DTD/xhtml1-strict.dtd"
            encoding="ISO-8859-1" />

<xsl:key name="IDs" match="Series" use="@id" />

<xsl:variable name="ChannelList">
  <p><xsl:apply-templates mode="ChannelList" /></p>
</xsl:variable>

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

<xsl:template match="/">
  <html>
    <head>
      <title>TV Guide</title>
      <link rel="stylesheet" href="TVGuide3.css" />
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
  <xsl:variable name="sortOrder">
    <xsl:choose>
      <xsl:when test="$sortOrder = 'ascending'">ascending</xsl:when>
      <xsl:otherwise>descending</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:apply-templates select="Channel">
    <xsl:sort select="sum(Program/@rating) div count(Program)" 
              data-type="number" order="{$sortOrder}" />
    <xsl:sort select="Name" />
  </xsl:apply-templates>
  <h2>Series</h2>
  <xsl:call-template name="alphabetList" />
  <xsl:call-template name="alphabeticalSeriesList" />
</xsl:template>

<xsl:template name="generateTimeline">
  <xsl:param name="startHours" select="0" />
  <xsl:param name="startMinutes" select="0" />
  <xsl:param name="endHours" select="23" />
  <xsl:param name="endMinutes" select="30" />

  <th colspan="6">
    <xsl:value-of select="format-number($startHours, '00')" />
    <xsl:text>:</xsl:text>
    <xsl:value-of select="format-number($startMinutes, '00')" />
  </th>

  <xsl:if test="$startHours &lt; $endHours or 
                $startMinutes != $endMinutes">
    <xsl:call-template name="generateTimeline">
      <xsl:with-param name="startHours">
        <xsl:choose>
          <xsl:when test="$startMinutes = 0">
            <xsl:value-of select="$startHours" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$startHours + 1" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="startMinutes">
        <xsl:choose>
          <xsl:when test="$startMinutes = 0">30</xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="endHours" select="$endHours" />
      <xsl:with-param name="endMinutes" select="$endMinutes" />
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="Channel" mode="Table">
  <tr>
    <th colspan="6"><xsl:value-of select="Name" /></th>
    <xsl:apply-templates select="Program" mode="Table" />
  </tr>
</xsl:template>

<xsl:template match="Program" mode="Table">
  <td>
    <xsl:attribute name="colspan">
      <xsl:variable name="durationMins">
        <xsl:call-template name="durationMins">
          <xsl:with-param name="duration" select="Duration" />
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="round($durationMins div 5)" />
    </xsl:attribute>
    <xsl:apply-templates select="." mode="TableTitle" />
  </td>
</xsl:template>

<xsl:template match="Program" mode="TableTitle">
  <xsl:call-template name="link">
    <xsl:with-param name="href" select="concat('#', generate-id())" />
    <xsl:with-param name="content">
      <span class="title">
        <xsl:choose>
          <xsl:when test="string(Series)">
            <xsl:value-of select="key('IDs', Series)/Title" />
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
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="alphabetList">
  <xsl:param name="alphabet" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
  <xsl:variable name="letter" select="substring($alphabet, 1, 1)" />
  <xsl:variable name="remainder" select="substring($alphabet, 2)" />

  <xsl:variable name="series" select="key('seriesByFirstLetter', $letter)" />
  <xsl:choose>
    <xsl:when test="$series">
      <xsl:call-template name="link">
        <xsl:with-param name="href" select="concat('#series', $letter)" />
        <xsl:with-param name="content" select="$letter" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$letter" />
    </xsl:otherwise>
  </xsl:choose>

  <xsl:if test="$remainder">
    <xsl:text> . </xsl:text>
    <xsl:call-template name="alphabetList">
      <xsl:with-param name="alphabet" select="$remainder" />
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:key name="seriesByFirstLetter" match="Series" 
         use="substring(@id, 1, 1)" />

<xsl:template name="alphabeticalSeriesList">
  <xsl:param name="alphabet" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
  <xsl:variable name="letter" select="substring($alphabet, 1, 1)" />
  <xsl:variable name="remainder" select="substring($alphabet, 2)" />

  <xsl:variable name="series" 
                select="key('seriesByFirstLetter', $letter)" />
  <xsl:if test="$series">
    <h3>
      <a id="series{$letter}" name="series{$letter}">
        <xsl:value-of select="$letter" />
      </a>
    </h3>
    <xsl:apply-templates select="$series">
      <xsl:sort select="@id" />
    </xsl:apply-templates>
  </xsl:if>

  <xsl:if test="$remainder">
    <xsl:call-template name="alphabeticalSeriesList">
      <xsl:with-param name="alphabet" select="$remainder" />
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:key name="programsBySeries" match="Program" use="Series" />

<xsl:template match="TVGuide/Series">
  <div>
    <h4><a name="{@id}" id="{@id}"><xsl:value-of select="Title" /></a></h4>
    <p>
      <xsl:apply-templates select="Description" />
    </p>
    <h5>Episodes</h5>
    <ul>
      <xsl:for-each select="key('programsBySeries', @id)">
        <li>
          <xsl:call-template name="link">
            <xsl:with-param name="href" select="concat('#', generate-id())" />
            <xsl:with-param name="content">
              <xsl:value-of select="parent::Channel/Name" />
              <xsl:text> at </xsl:text>
              <xsl:value-of select="Start" />
              <xsl:if test="string(Title)">
                <xsl:text>: </xsl:text>
                <xsl:value-of select="Title" />
              </xsl:if>
            </xsl:with-param>
          </xsl:call-template>
        </li>
      </xsl:for-each>
    </ul>
  </div>
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
    <xsl:if test="@flag = 'favorite' or @flag = 'interesting' or
                    @rating > 6 or 
                    contains(translate(Series, $upper, $lower), $keyword) or
                    contains(translate(Title, $upper, $lower), $keyword) or 
                    contains(translate(Description, $upper, $lower), $keyword)">
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
    <xsl:apply-templates select="@flag" />
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

<xsl:template name="durationMins">
  <xsl:param name="duration" select="'PT0H0M'" />
  <xsl:variable name="d" 
                select="substring(normalize-space($duration), 3)" />
  <xsl:variable name="durationHours">
    <xsl:choose>
      <xsl:when test="contains($d, 'H')">
        <xsl:value-of select="substring-before($d, 'H')" />
      </xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="durationMinutes">
    <xsl:choose>
      <xsl:when test="contains($d, 'M')">
        <xsl:choose>
          <xsl:when test="contains($d, 'H')">
            <xsl:value-of select="substring-before(
                                  substring-after($d, 'H'), 'M')" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="substring-before($d, 'M')" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="($durationHours * 60) + $durationMinutes" />
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

<xsl:template match="@flag">
  <xsl:variable name="image">
    <xsl:choose>
      <xsl:when test=". = 'favorite'">favorite</xsl:when>
      <xsl:when test=". = 'interesting'">interest</xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="alt">
    <xsl:choose>
      <xsl:when test=". = 'favorite'">Favorite</xsl:when>
      <xsl:when test=". = 'interesting'">Interest</xsl:when>
    </xsl:choose>
  </xsl:variable>
  <img src="{$image}.gif" alt="[{$alt}]" width="20" height="20" />
</xsl:template>

<xsl:template match="Program" mode="Title">
  <span class="title">
    <xsl:choose>
      <xsl:when test="string(Series)">
        <xsl:call-template name="link">
          <xsl:with-param name="href" select="concat('#', Series)" />
          <xsl:with-param name="content" select="string(key('IDs', Series)/Title)" />
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

<xsl:template match="Description//Actor">
  <span class="actor"><xsl:apply-templates /></span>
</xsl:template>

<xsl:template match="Description//Link">
  <xsl:call-template name="link">
    <xsl:with-param name="href" select="@href" />
    <xsl:with-param name="content">
      <xsl:apply-templates />
    </xsl:with-param>
  </xsl:call-template>
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

<xsl:template match="Description//text()">
  <xsl:call-template name="highlightKeywords">
    <xsl:with-param name="string" select="." />
  </xsl:call-template>
</xsl:template>

<xsl:template name="highlightKeywords">
  <xsl:param name="string" />
  <xsl:param name="keywords" select="/TVGuide/Keywords/Keyword" />
  <xsl:variable name="keyword" 
                select="$keywords[contains($string, .)][1]" />
  <xsl:choose>
    <xsl:when test="$keyword">
      <xsl:call-template name="highlightKeywords">
        <xsl:with-param name="string"
                        select="substring-before($string, $keyword)" />
        <xsl:with-param name="keywords" select="$keywords" />
      </xsl:call-template>
      <span class="keyword">
        <xsl:value-of select="$keyword" />
      </span>
      <xsl:call-template name="highlightKeywords">
        <xsl:with-param name="string"
                        select="substring-after($string, $keyword)" />
        <xsl:with-param name="keywords" select="$keywords" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$string" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="totalDuration">
  <xsl:param name="programs" select="/.." />
  <xsl:param name="totalHours" select="0" />
  <xsl:param name="totalMinutes" select="0" />
  <xsl:choose>
    <xsl:when test="$programs">
      <xsl:variable name="duration" 
                    select="normalize-space($programs[1]/Duration)" />
      <xsl:variable name="hours">
        <xsl:choose>
          <xsl:when test="contains($duration, 'H')">
            <xsl:value-of select="substring-before(
                                  substring-after($duration, 'PT'), 
                                  'H')" />
          </xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="minutes">
        <xsl:choose>
          <xsl:when test="contains($duration, 'M')">
            <xsl:choose>
              <xsl:when test="contains($duration, 'H')">
                <xsl:value-of select="substring-before(
                                      substring-after($duration, 'H'), 
                                      'M')" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring-before(
                                      substring-after($duration, 'PT'), 
                                      'M')" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:call-template name="totalDuration">
        <xsl:with-param name="programs" 
                        select="$programs[position() > 1]" />
        <xsl:with-param name="totalHours" select="$totalHours + $hours" />
        <xsl:with-param name="totalMinutes"
                        select="$totalMinutes + $minutes" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="finalHours" 
                    select="$totalHours + floor($totalMinutes div 60)" />
      <xsl:variable name="finalMinutes"
                    select="($totalMinutes mod 60) div 60" />
      <xsl:value-of select="format-number($finalHours + $finalMinutes, '0.00')" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>