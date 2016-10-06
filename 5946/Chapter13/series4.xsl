<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:saxon="http://icl.com/saxon"
                extension-element-prefixes="saxon">

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
  <saxon:group select="/SeriesList/Series" group-by="substring(@id, 1, 1)">
    <xsl:sort select="@id" />
    <xsl:variable name="letter" select="substring(@id, 1, 1)" />
    <h3>
      <a id="series{$letter}" name="series{$letter}">
        <xsl:value-of select="$letter" />
      </a>
    </h3>
    <saxon:item>
      <xsl:apply-templates select="." />
    </saxon:item>
  </saxon:group>
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

</xsl:stylesheet>