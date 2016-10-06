<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/2000/svg"
                xmlns:xlink="http://www.w3.org/1999/xlink">

<xsl:strip-space elements="*" />

<xsl:output method="xml" media-type="image/svg+xml"
            indent="yes" encoding="ISO-8859-1" />

<xsl:variable name="height" 
              select="(count(/TVGuide/Channel) * 100) + 100" />

<xsl:template match="TVGuide">
  <svg viewBox="0 0 1400 {$height}">
    <title>TV Guide</title>
    <xsl:call-template name="timelineMarkers" />
    <xsl:call-template name="verticalGridlines" />
    <xsl:apply-templates select="Channel"/>
    <xsl:call-template name="horizontalGridlines" />
  </svg>
</xsl:template>

<xsl:template name="timelineMarkers">
  <g text-anchor="middle" font-size="20" fill="black">
    <desc>Timeline markers</desc>
    <xsl:call-template name="generateTimeLine" />
  </g>
</xsl:template>

<xsl:template name="generateTimeLine">
  <xsl:param name="indent" select="200"/>
  <xsl:param name="hour" select="7"/>
  <xsl:param name="minute" select="0"/>
  <text x="{$indent}" y="70">
    <xsl:value-of select="$hour"/>
    <xsl:text>:</xsl:text>
    <xsl:value-of select="format-number($minute, '00')"/>
  </text>
  <xsl:if test="$hour &lt; 10">
    <xsl:call-template name="generateTimeLine">
      <xsl:with-param name="indent" select="$indent + 100"/>
      <xsl:with-param name="hour">
        <xsl:choose>
          <xsl:when test="$minute = 45">
            <xsl:value-of select="$hour + 1"/>
          </xsl:when>
          <xsl:otherwise><xsl:value-of select="$hour"/></xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="minute" select="($minute + 15) mod 60"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="verticalGridlines">
  <g stroke="black" stroke-width="2">
    <desc>Vertical grid lines</desc>
    <xsl:call-template name="generateVerticalGridlines"/>
  </g>
</xsl:template>

<xsl:template name="generateVerticalGridlines">
  <xsl:param name="indent" select="200"/>
  <line x1="{$indent}" y1="80" x2="{$indent}" y2="{$height}"/>
  <xsl:if test="$indent &lt; 1400">
    <xsl:call-template name="generateVerticalGridlines">
      <xsl:with-param name="indent" select="$indent + 100"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="horizontalGridlines">
  <g stroke="black" stroke-width="2">
    <desc>Horizontal grid lines</desc>
    <xsl:for-each select="/TVGuide/Channel">
      <line x1="0"    y1="{position() * 100}" 
            x2="1400" y2="{position() * 100}" />
      <xsl:if test="position() = last()">
        <line x1="0"    y1="{(position() * 100) + 100}"
              x2="1400" y2="{(position() * 100) + 100}" />
      </xsl:if>
    </xsl:for-each>
  </g>
</xsl:template>

<xsl:template match="Channel">
  <g transform="translate(0, {position() * 100})">
    <desc><xsl:value-of select="Name"/></desc>
    <g>
      <desc>Channel Label</desc>
      <rect x="0" y="0" height="100" width="200" fill="#C00"/>
      <text x="195" y="70" text-anchor="end" font-size="40" fill="yellow">
        <xsl:value-of select="Name"/>
      </text>
    </g>
    <g>
      <desc>Programs</desc>
      <xsl:apply-templates select="Program"/>
    </g>
  </g>
</xsl:template>

<xsl:template match="Program">
  <xsl:variable name="hour" select="substring(Start, 12, 2)"/>
  <xsl:if test="$hour &gt;= 19 and $hour &lt; 22">
    <xsl:variable name="minute" select="substring(Start, 15, 2)"/>
    <xsl:variable name="indent" 
      select="format-number((($hour - 19) * 4 + $minute div 15) * 100 + 200, 
                            '0.##')"/>
    <xsl:variable name="durHour">
      <xsl:choose>
        <xsl:when test="contains(Duration, 'H')">
          <xsl:value-of 
            select="substring-before(substring-after(Duration, 'PT'), 'H')"/>
        </xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="durMinute">
      <xsl:choose>
        <xsl:when test="contains(Duration, 'M')">
          <xsl:choose>
            <xsl:when test="contains(Duration, 'H')">
              <xsl:value-of select="substring-before(
                                      substring-after(Duration, 'H'), 'M')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="substring-before(
                                      substring-after(Duration, 'PT'), 'M')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="duration"
                  select="$durMinute + (60 * $durHour)"/>
    <g transform="translate({$indent})">
      <rect x="0" y="0" fill="#CCC" height="100"
            stroke="black" stroke-width="2"
            width="{format-number(($duration div 15) * 100, '0.##')}" />
      <text y="0" font-size="20" fill="black">
        <xsl:apply-templates select="Series[string()]"/>
        <xsl:apply-templates select="Title[string()]"/>
      </text>
    </g>
  </xsl:if>
</xsl:template>

<xsl:variable name="seriesDocument" select="document('series.xml')" />

<xsl:key name="series" match="Series" use="@id" />

<xsl:template match="Program/Series">
  <tspan font-weight="bold" x="0.5em" dy="25">
    <xsl:variable name="series" select="."/>
    <xsl:for-each select="$seriesDocument">
      <xsl:value-of select="key('series', $series)/Title"/>
    </xsl:for-each>
  </tspan>
</xsl:template>

<xsl:template match="Title">
  <tspan x="0.5em" dy="25" font-style="italic">
    <xsl:value-of select="."/>
  </tspan>
</xsl:template>

</xsl:stylesheet>
