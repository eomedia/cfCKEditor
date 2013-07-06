###cfCKEditor
=============

A ColdFusion wrapper for CKEditor & CKFinder, simplifies usage of editor/finder by wrapping customization outside of the editor for easier updates.

```
##Dual licensed under the MIT and GPL licenses:
* http://www.opensource.org/licenses/mit-license.php
* http://www.gnu.org/license
```

```
Quick use case example<br>

<cfoutput>
	<form>
	#cfCKEditor("instanceName", "this is my value")#
	<br><br>
	#cfCKEditor(instanceName="instanceName2", instanceValue="this is my second value", type="cfkPopup")#
	<br><br>
	#cfCKEditor(instanceName="instanceName3", instanceValue="this is my third value", type="cfkAlone", height="300px")#
	</form>
</cfoutput>
```

