<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. �See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. �If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (�GPL�) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, �the copyright holders of Mura CMS grant you permission
to combine Mura CMS �with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the �/trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 �without this exception. �You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<cfsilent><cfparam name="attributes.siteID" default="">
<cfparam name="attributes.parentID" default="">
<cfparam name="attributes.nestLevel" default="1">
<cfset rslist=application.categoryManager.getCategories(attributes.siteID,attributes.ParentID) />
</cfsilent>
<cfif rslist.recordcount>
<ul>
<cfoutput query="rslist">
<cfsilent>
<cfquery name="rsIsMember" dbtype="query">
select * from request.rsCategoryAssign
where categoryID='#rslist.categoryID#' and ContentHistID='#request.newBean.getcontentHistID()#'
</cfquery>
<cfset catTrim=replace(rslist.categoryID,'-','','ALL') />
<cfif not application.permUtility.getCategoryPerm(rslist.restrictGroups,attributes.siteid)>
<cfset disabled="disabled" />
<cfelse>
<cfset disabled="" />
</cfif>
</cfsilent>
<li>
<ul>
<li>#rslist.name#<cfif rslist.isOpen eq 1>
<select  name="categoryAssign#catTrim#" #disabled#  onchange="javascript: this.selectedIndex==3?toggleDisplay2('editDates#catTrim#',true):toggleDisplay2('editDates#catTrim#',false);">
<option <cfif not rsIsMember.recordcount>selected</cfif> value="">No</option>
<option <cfif rsIsMember.recordcount and not rsIsMember.isFeature>selected</cfif> value="0">Yes</option>
<option value="1" <cfif rsIsMember.recordcount and rsIsMember.isFeature eq 1>selected</cfif>>Feature</option>
<option value="2" <cfif rsIsMember.recordcount and rsIsMember.isFeature eq 2>selected</cfif>>Feature Per Start/Stop Dates</option>
</select>
	  <dl id="editDates#catTrim#" <cfif not (rsIsMember.recordcount and rsIsMember.isFeature eq 2)>style="display: none;"</cfif>>
		<dt>Start Date / Time</dt>
		<dd><input type="text" name="featureStart#catTrim#" #disabled#  value="#LSDateFormat(rsIsMember.featurestart,session.dateKeyFormat)#" class="textAlt"><input class="calendar" type="image" src="images/icons/cal_24.png" width="14" height="14" #disabled#  hidefocus onclick="window.open('date_picker/index.cfm?form=contentForm&field=featureStart#catTrim#&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;">
		<select name="starthour#catTrim#" #disabled#  class="dropdown"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rsIsMember.featurestart)  and h eq 12 or (LSisDate(rsIsMember.featurestart) and (hour(rsIsMember.featurestart) eq h or (hour(rsIsMember.featurestart) - 12) eq h or hour(rsIsMember.featurestart) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
		<select name="startMinute#catTrim#" #disabled# class="dropdown"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif LSisDate(rsIsMember.featurestart) and minute(rsIsMember.featurestart) eq m>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
		<select name="startDayPart#catTrim#" class="dropdown"><option value="AM">AM</option><option value="PM" <cfif LSisDate(rsIsMember.featurestart) and hour(rsIsMember.featurestart) gte 12>selected</cfif>>PM</option></select>
		</dd>
		<dt>Stop Date / Time</dt>
		<dd><input type="text" name="featureStop#catTrim#" #disabled# value="#LSDateFormat(rsIsMember.featurestop,session.dateKeyFormat)#" class="textAlt"><input class="calendar" type="image" src="images/icons/cal_24.png" width="14" height="14" #disabled#  hidefocus onclick="window.open('date_picker/index.cfm?form=contentForm&field=featureStop#catTrim#&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;">
	<select name="stophour#catTrim#" class="dropdown"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rsIsMember.featurestop)  and h eq 11 or (LSisDate(rsIsMember.featurestop) and (hour(rsIsMember.featurestop) eq h or (hour(rsIsMember.featurestop) - 12) eq h or hour(rsIsMember.featurestop) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
		<select name="stopMinute#catTrim#" #disabled#  class="dropdown"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif (not LSisDate(rsIsMember.featurestop) and m eq 59) or (LSisDate(rsIsMember.featurestop) and minute(rsIsMember.featurestop) eq m)>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
		<select name="stopDayPart#catTrim#" #disabled# class="dropdown"><option value="AM">AM</option><option value="PM" <cfif (LSisDate(rsIsMember.featurestop) and (hour(rsIsMember.featurestop) gte 12)) or not LSisDate(rsIsMember.featurestop)>selected</cfif>>PM</option></select>
		</dd>
		</dl>
</cfif>
<cfif rslist.hasKids><cf_dsp_categories_import_nest siteID="#attributes.siteID#" parentID="#rslist.categoryID#" nestLevel="#evaluate(attributes.nestLevel +1)#" ></cfif>
</li>
</ul>
</li>
</cfoutput>
</ul>
</cfif>

