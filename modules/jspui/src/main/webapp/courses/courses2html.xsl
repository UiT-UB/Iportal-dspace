<?xml version="1.0" encoding="UTF-8"?>
<!--
This stylesheet converts taxonomies from their XML representation to
an HTML tree. Its basically a preety-printer.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- ************************************ -->
	<xsl:output method="html" version="1.0" indent="yes" encoding="utf-8"/>
	<!-- ************************************ -->
	<xsl:param name="contextPath"/>

	<!-- ************************************ -->
	<xsl:template match="/">
		<ul class="controlledvocabulary">
			<xsl:apply-templates/>
		</ul>
	</xsl:template>
	<!-- ************************************ -->
	<xsl:template match="all">
		<li>
		<img class="controlledvocabulary">
			<xsl:attribute name="src"><xsl:value-of select="$contextPath"/>/image/controlledvocabulary/p.gif</xsl:attribute>
			<xsl:attribute name="onClick">ec(this, '<xsl:value-of select="$contextPath"/>');</xsl:attribute>
		</img>
		<xsl:value-of select="@label"/>

		<ul class="controlledvocabulary">
			<xsl:apply-templates select="unit"/>
		</ul>
		</li>
	</xsl:template>
	<!-- ************************************ -->
	<xsl:template match="unit">
		<li>
		<img class="controlledvocabulary">
			<xsl:attribute name="src"><xsl:value-of select="$contextPath"/>/image/controlledvocabulary/p.gif</xsl:attribute>
			<xsl:attribute name="onClick">ec(this, '<xsl:value-of select="$contextPath"/>');</xsl:attribute>
		</img>
		<xsl:value-of select="@label"/>

		<ul class="controlledvocabulary">
			<li>
			<table>
			<xsl:apply-templates select="course"/>
			</table>
			</li>
		</ul>
		</li>
	</xsl:template>
	<!-- ************************************ -->
	<xsl:template match="course">
		
			<xsl:variable name="collectionID">
				<xsl:value-of select="@collection"/>
			</xsl:variable>
			<xsl:variable name="courseID">
				<xsl:value-of select="@id"/>
			</xsl:variable>
			<xsl:variable name="departmentID">
				<xsl:value-of select="@department"/>
			</xsl:variable>
			<xsl:variable name="departmentName">
				<xsl:value-of select="@departmentname"/>
			</xsl:variable>
			
			<tr>
			<td><input class="controlledvocabulary" type="radio" name="collection" id="tcollection" value="{$collectionID}" onClick="setHidden('{$courseID}', '{$departmentID}', '{$departmentName}');" /></td>
			<td><xsl:value-of select="@id"/>:</td> <td><xsl:value-of select="@label"/></td>
			</tr>
			
		
	</xsl:template>
	<!-- ************************************ -->
</xsl:stylesheet>
