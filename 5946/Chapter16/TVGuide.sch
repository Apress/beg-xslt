<?xml version="1.0"?>
<sch:schema xmlns:sch="http://www.ascc.net/xml/schematron">

<sch:title>TV Guide Schematron Schema</sch:title>

<sch:pattern name="TV Guide Structure">
  <sch:rule context="/">
    <sch:assert test="TVGuide">
      The document element must be a &lt;TVGuide&gt; element.
    </sch:assert>
  </sch:rule>
</sch:pattern>

</sch:schema>