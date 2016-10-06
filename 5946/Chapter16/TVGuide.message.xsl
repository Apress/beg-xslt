<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<axsl:stylesheet xmlns:axsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sch="http://www.ascc.net/xml/schematron" version="1.0">
   <axsl:template match="*|@*" mode="schematron-get-full-path">
      <axsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <axsl:text>/</axsl:text>
      <axsl:if test="count(. | ../@*) = count(../@*)">@</axsl:if>
      <axsl:value-of select="name()"/>
      <axsl:text>[</axsl:text>
      <axsl:value-of select="1+count(preceding-sibling::*[name()=name(current())])"/>
      <axsl:text>]</axsl:text>
   </axsl:template>
   <axsl:template match="/">
      <axsl:apply-templates select="/" mode="M1"/>
   </axsl:template>
   <axsl:template match="/" priority="4000" mode="M1">
      <axsl:choose>
         <axsl:when test="TVGuide"/>
         <axsl:otherwise>
            <axsl:message>The document element must be a &lt;TVGuide&gt; element.</axsl:message>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates mode="M1"/>
   </axsl:template>
   <axsl:template match="text()" priority="-1" mode="M1"/>
   <axsl:template match="text()" priority="-1"/>
</axsl:stylesheet>