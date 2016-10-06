<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:rep="http://www.example.com/replacements"
                exclude-result-prefixes="rep">

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

<xsl:template match="SeriesList/Series">
  <div>
    <h4><a name="{@id}" id="{@id}"><xsl:value-of select="Title" /></a></h4>
    <p>
      <xsl:apply-templates select="Description" />
    </p>
    <h5>Episodes</h5>
    <ul>
      <xsl:variable name="seriesID" select="@id" />
      <xsl:for-each select="$listing">
        <xsl:for-each select="key('programsBySeries', $seriesID)">
          <li>
            <xsl:call-template name="link">
              <xsl:with-param name="href" select="concat('#', generate-id())" />
              <xsl:with-param name="content">
                <xsl:value-of select="parent::Channel/Name" />
                <xsl:text> at </xsl:text>
                <xsl:call-template name="formatDate">
                  <xsl:with-param name="date" select="Start" />
                </xsl:call-template>
                <xsl:if test="string(Title)">
                  <xsl:text>: </xsl:text>
                  <xsl:value-of select="Title" />
                </xsl:if>
              </xsl:with-param>
            </xsl:call-template>
          </li>
        </xsl:for-each>
      </xsl:for-each>
    </ul>
  </div>
</xsl:template>

<rep:replacements xml:space="preserve" xmlns="">
  <search>-01-</search><replace> Jan </replace>
  <search>-02-</search><replace> Feb </replace>
  <search>-03-</search><replace> Mar </replace>
  <search>-04-</search><replace> Apr </replace>
  <search>-05-</search><replace> May </replace>
  <search>-06-</search><replace> Jun </replace>
  <search>-07-</search><replace> Jul </replace>
  <search>-08-</search><replace> Aug </replace>
  <search>-09-</search><replace> Sep </replace>
  <search>-10-</search><replace> Oct </replace>
  <search>-11-</search><replace> Nov </replace>
  <search>-12-</search><replace> Dec </replace>
  <search>T</search><replace> </replace>
</rep:replacements>

</xsl:stylesheet>