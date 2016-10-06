<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml">

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
            <xsl:variable name="seriesID" select="Series" />
            <xsl:for-each select="$series">
              <xsl:value-of select="key('IDs', $seriesID)/Title" />
            </xsl:for-each>
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

</xsl:stylesheet>