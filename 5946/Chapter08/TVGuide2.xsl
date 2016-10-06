<?xml version="1.0" encoding="utf-8" ?> 
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:variable name="ChannelList">
  <xsl:element name="p">
    <xsl:apply-templates mode="ChannelList" /> 
  </xsl:element>
</xsl:variable>

<xsl:template match="/">
  <xsl:element name="html">
    <xsl:element name="head">
      <xsl:element name="title">TV Guide  </xsl:element> 
        <xsl:element name="link">
          <xsl:attribute name="rel">stylesheet</xsl:attribute> 
          <xsl:attribute name="href">TVGuide.css</xsl:attribute> 
        </xsl:element>
        <xsl:element name="script">
          <xsl:attribute name="type">text/javascript</xsl:attribute> 
            <![CDATA[     function toggle(element) {      if (element.style.display == 'none') {        element.style.display = 'block';      } else {        element.style.display = 'none';      }    }    
              ]]> 
        </xsl:element>
      </xsl:element>
      <xsl:element name="body">
        <xsl:element name="h1">TV Guide  </xsl:element> 
        <xsl:copy-of select="$ChannelList" /> 
        <xsl:apply-templates /> 
        <xsl:copy-of select="$ChannelList" /> 
     </xsl:element>
  </xsl:element>
</xsl:template>

<xsl:template match="TVGuide" mode="ChannelList">
<xsl:apply-templates select="Channel" mode="ChannelList" /> 
</xsl:template>

<xsl:template match="Channel" mode="ChannelList">
  <xsl:element name="a">
    <xsl:attribute name="href">
<xsl:value-of select="concat('#', Name)" /> 
</xsl:attribute>
<xsl:value-of select="Name" /> 
  </xsl:element>
<xsl:if test="position() != last()">|</xsl:if> 
</xsl:template>

<xsl:template match="Channel">
<xsl:apply-templates /> 
</xsl:template>

<xsl:template match="Channel/Name">
  <xsl:element name="h2">
    <xsl:attribute name="class">channel</xsl:attribute> 
  <xsl:element name="a">
    <xsl:attribute name="name">
<xsl:value-of select="." /> 
</xsl:attribute>
    <xsl:attribute name="id">
<xsl:value-of select="." /> 
</xsl:attribute>
<xsl:apply-templates /> 
  </xsl:element>
  </xsl:element>
</xsl:template>

<xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" /> 
<xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'" /> 
<xsl:variable name="keyword" select="'news'" /> 

<xsl:template match="Program[1]">
  <xsl:element name="div">
    <xsl:attribute name="class">nowShowing</xsl:attribute> 
<xsl:apply-templates select="." mode="Details" /> 
  </xsl:element>
</xsl:template>

<xsl:template match="Program">
<xsl:choose>
<xsl:when test="@flag = 'favorite' or @flag = 'interesting' or @rating > 6 or contains(translate(Series, $upper, $lower), $keyword) or contains(translate(Title, $upper, $lower), $keyword) or contains(translate(Description, $upper, $lower), $keyword)">
  <xsl:element name="div">
    <xsl:attribute name="class">interesting</xsl:attribute> 
<xsl:apply-templates select="." mode="Details" /> 
  </xsl:element>
</xsl:when>
<xsl:otherwise>
  <xsl:element name="div">
<xsl:apply-templates select="." mode="Details" /> 
  </xsl:element>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:variable name="StarTrekLogo">
  <xsl:element name="img">
    <xsl:attribute name="src">StarTrek.gif</xsl:attribute> 
    <xsl:attribute name="alt">[Star Trek]</xsl:attribute> 
    <xsl:attribute name="width">20</xsl:attribute> 
    <xsl:attribute name="height">20</xsl:attribute> 
  </xsl:element>
</xsl:variable>
<xsl:template match="Program" mode="Details">
<xsl:variable name="programID" select="concat(Series, 'Cast')" /> 
  <xsl:element name="p">
<xsl:apply-templates select="Start" /> 
  <xsl:element name="br" /> 
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
  <xsl:element name="img">
    <xsl:attribute name="src">
<xsl:value-of select="concat($image, '.gif')" /> 
</xsl:attribute>
    <xsl:attribute name="alt">
<xsl:value-of select="concat('[', $alt, ']')" /> 
</xsl:attribute>
    <xsl:attribute name="width">20</xsl:attribute> 
    <xsl:attribute name="height">20</xsl:attribute> 
  </xsl:element>
</xsl:if>
<xsl:if test="starts-with(Series, 'StarTrek')">
<xsl:copy-of select="$StarTrekLogo" /> 
</xsl:if>
<xsl:apply-templates select="." mode="Title" /> 
  <xsl:element name="br" /> 
<xsl:apply-templates select="Description" /> 
<xsl:apply-templates select="CastList" mode="DisplayToggle">
<xsl:with-param name="divID" select="$programID" /> 
</xsl:apply-templates>
  </xsl:element>
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
<xsl:variable name="endDateTime" select="parent::Program/following-sibling::Program[1]/Start" /> 
<xsl:variable name="endTime">
<xsl:choose>
<xsl:when test="$endDateTime">
<xsl:value-of select="substring(normalize-space($endDateTime), 12, 5)" /> 
</xsl:when>
<xsl:otherwise>
<xsl:variable name="duration" select="substring(normalize-space(../Duration), 3)" /> 
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
<xsl:value-of select="substring-before( substring-after($duration, 'H'), 'M')" /> 
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="substring-before($duration, 'M')" /> 
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>0</xsl:otherwise> 
</xsl:choose>
</xsl:variable>
<xsl:variable name="durationMins" select="($durationHours * 60) + $durationMinutes" /> 
<xsl:variable name="startHours" select="substring($time, 1, 2)" /> 
<xsl:variable name="startMinutes" select="substring($time, 4, 2)" /> 
<xsl:variable name="endMinutes" select="($startMinutes + $durationMins) mod 60" /> 
<xsl:variable name="endHours" select="floor((($startMinutes + $durationMins) div 60) + $startHours) mod 24" /> 
<xsl:value-of select="concat(format-number($endHours, '00'), ':', format-number($endMinutes, '00'))" /> 
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
  <xsl:element name="span">
    <xsl:attribute name="class">date</xsl:attribute> 
<xsl:value-of select="concat($month, '/', $day, '/', $year, ' ', $time, ' - ', $endTime)" /> 
  </xsl:element>
</xsl:template>
<xsl:template match="Program" mode="Title">
  <xsl:element name="span">
    <xsl:attribute name="class">title</xsl:attribute> 
<xsl:choose>
<xsl:when test="string(Series)">
<xsl:value-of select="Series" /> 
<xsl:if test="string(Title)">
  - 
  <xsl:element name="span">
    <xsl:attribute name="class">subtitle</xsl:attribute> 
<xsl:value-of select="Title" /> 
  </xsl:element>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="Title" /> 
</xsl:otherwise>
</xsl:choose>
  </xsl:element>
</xsl:template>
<xsl:template match="CastList" mode="DisplayToggle">
<xsl:param name="divID" /> 
  <xsl:element name="span">
    <xsl:attribute name="onclick">
<xsl:value-of select="concat('toggle(', $divID, ');')" /> 
</xsl:attribute>
<xsl:text>[Cast]</xsl:text> 
  </xsl:element>
</xsl:template>
<xsl:template match="CastList">
<xsl:param name="divID" /> 
  <xsl:element name="div">
    <xsl:attribute name="id">
<xsl:value-of select="$divID" /> 
</xsl:attribute>
    <xsl:attribute name="style">display: none;</xsl:attribute> 
  <xsl:element name="ul">
    <xsl:attribute name="class">castlist</xsl:attribute> 
<xsl:apply-templates /> 
  </xsl:element>
  </xsl:element>
</xsl:template>
<xsl:template match="CastMember">
  <xsl:element name="li">
<xsl:apply-templates select="Character" /> 
<xsl:apply-templates select="Actor" /> 
  </xsl:element>
</xsl:template>
<xsl:template match="Character">
  <xsl:element name="span">
    <xsl:attribute name="class">character</xsl:attribute> 
<xsl:choose>
<xsl:when test="Name">
<xsl:apply-templates select="Name" /> 
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates /> 
</xsl:otherwise>
</xsl:choose>
  </xsl:element>
</xsl:template>
<xsl:template match="Actor">
  <xsl:element name="span">
    <xsl:attribute name="class">actor</xsl:attribute> 
<xsl:apply-templates select="Name" /> 
  </xsl:element>
</xsl:template>
<xsl:template match="Description//Actor">
  <xsl:element name="span">
    <xsl:attribute name="class">actor</xsl:attribute> 
<xsl:apply-templates /> 
  </xsl:element>
</xsl:template>
<xsl:template match="Description//Link">
  <xsl:element name="a">
    <xsl:attribute name="href">
<xsl:value-of select="@href" /> 
</xsl:attribute>
<xsl:apply-templates /> 
  </xsl:element>
</xsl:template>
<xsl:template match="Description//Program">
  <xsl:element name="span">
    <xsl:attribute name="class">program</xsl:attribute> 
<xsl:apply-templates /> 
  </xsl:element>
</xsl:template>
<xsl:template match="Description//Series">
  <xsl:element name="span">
    <xsl:attribute name="class">series</xsl:attribute> 
<xsl:apply-templates /> 
  </xsl:element>
</xsl:template>
<xsl:template match="Description//Channel">
  <xsl:element name="span">
    <xsl:attribute name="class">channel</xsl:attribute> 
<xsl:apply-templates /> 
  </xsl:element>
</xsl:template>
</xsl:stylesheet>