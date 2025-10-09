<cfscript>
include '/Inc/header.cfm'
act = new dbo.proc().usr('act.list')
grp = new dbo.proc().exec('grp.where_name','act')
cat = new dbo.proc().exec('cat.where_grp',grp.grpid)
</cfscript>

<cfoutput>
<form class="card">
	<div class="card-header alert-primary">
	</div>
	<div class="card-body">
		<table>
			<thead>
				<tr>
					<th>Category</th>
					<th>Activity</th>
					<th class="text-center">Assigned</th>
					<th>Day</th>
					<th class="text-center">Due</th>
					<th class="text-end">Earned</th>
					<cfif request.usr.isAdmin>
						<th></th>
					</cfif>
				</tr>
			</thead>
			<tbody>
				<cfloop query="act">
					<cfif !isRejected OR request.usr.isAdmin>
						<tr data-actid=#actid#>
							<td>
								<cfif request.usr.isAdmin>
									<select id="catid">
										<option value="0"></option>
										<cfloop query="cat">
											<option value="#catid#"<cfif catid eq act_cat> selected</cfif>>#catname#</option>
										</cfloop>
									</select>
								<cfelse>
									#catname#
								</cfif>
							</td>
							<td>
								<!--- 
								This way we can turn session on to have them stay logged in 
								But still pass the activity id through the url scope
								So that they can press alt-d enter.
								--->
								<cfif isRejected>
									<button formaction="#actlink#?actid=#actid#">
										#actname#
									</button>
								<cfelse>
									<button class="btn-link" formaction="#actlink#?actid=#actid#">
										#actname#
									</button>
								</cfif>
							</td>
							<td class="text-center">
								<cfif ListFindNoCase('The Rundown AI,UX Roundup',actname)>
									#DateFormat(actdate,'mm/dd')#
								</cfif>
							</td>
							<td>#Left(DayOfWeekAsString(DayOfWeek(assndate)),3)#</td>
							<td class="assndate text-center"<cfif request.usr.isAdmin> contenteditable</cfif>>#DateFormat(assndate,'mm/dd')#</td>
							<td class="text-end">#earned#</td>
							<cfif request.usr.isAdmin>
								<td class="isRejected" contenteditable>#isRejected#</td>
							</cfif>
						</tr>
					</cfif>
				</cfloop>
			</tbody>
		</table>
	</div>
	<cfif request.usr.isAdmin>
		<div class="card-footer">
			<ul>
				<li><a href="Act/act.cfm">New Activity</a></li>
			</ul>
		</div>
	</cfif>
	<input hidden name="id" value="#request.usr.id#">
</form>
<cfinclude template="/Inc/footer.cfm">
</cfoutput>