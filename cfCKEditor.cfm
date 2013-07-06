<cfscript>
/**
 * A simple way to manage CKEditor instances
 * 
 * @param instanceName 		name of the instance (form name) (Required)
 * @param instanceValue 	value of the instance (Required)
 * @param baseURL			sets the baseURL which determines which folders to manage
 * @param jsURL				sets teh jsURL for where the CKEditor and CKFinder folders are stored
 * @param height			sets the height of the instance (px or %)
 * @param width				sets the width of the instance (px or %)
 * @param toolbarSet		sets the toolbarSet to use (you can customize any number of toolbarSets below)
 * @param contentCSS		sets the CSS that should be applied to the instance's content
 * @param type				flag, set to desired display (CKEditor, popup, CKFinder)
 * @param addBtn			href link to the add button for type=popup
 * 
 * @author Ryan Smith (rsmith@eomedia.com) 
 * @version 1, July 2013 
 * 
 * @licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/license
 * 
 * CKEditor 4 Documentation
 * http://docs.ckeditor.com/#!/guide
 */


public string function cfCKEditor(required string instanceName, required string instanceValue, string baseURL, string jsURL, string height, string width, string toolbarSet, string contentCSS, string type, string addBtn) {

	// default the parameters
	param name="arguments.instanceName" default="CKEInstance";
	param name="arguments.instanceValue" default="CKEInstance value";
	param name="arguments.baseURL" default="#expandPath(".")#";
	param name="arguments.jsURL" default="/cfCKEditor";
	param name="arguments.height" default="100";
	param name="arguments.width" default="100%";
	param name="arguments.toolbarSet" default="cfeo";
	param name="arguments.contentCSS" default="";
	param name="arguments.type" default="CKEditor";
	param name="arguments.addBtn" default="http://cdn3.iconfinder.com/data/icons/eightyshades/512/14_Add-16.png";

	/**
	* CKFinder (config.cfm) uses config.baseURL to set the path to open files (e.g. /ckfinder/userfiles/)
	* either modify value in file, or reset value to use the session variable set below to make it dynamic
	*/
	session.baseURL = arguments.baseURL;

	// output CKEditor, popup or CKFinder(stand alone)
	if (arguments.type EQ "CKEditor") {

		// ensure the ckeditor.js file is included
		if (!isDefined("request.ckeditorjs")){
			writeOutput("<script type='text/javascript' src='#arguments.jsURL#/ckeditor/ckeditor.js'></script>");
			request.ckeditorjs = "true"; // set the scoped variable to last through the entire request, so it's included only once
		}

		// toolbarSet - manage CKEditor toolbar options (customize and/or add new toolbarSet options) - 
		// CKEditor sample toolbar configurations (http://nightly.ckeditor.com/13-07-06-13-05/standard/samples/plugins/toolbar/toolbar.html)
		if (arguments.toolbarSet EQ "cfeo"){
			var toolbarConfig = "[
				[ 'Bold', 'Italic', '-', 'NumberedList', 'BulletedList', '-', 'Link', 'Unlink', 'About', 'Image' ], '/',
				{ name: 'links', items: [ 'Link', 'Unlink', 'Anchor' ] },
				[ 'Source' ]
			]";

		} else if (arguments.toolbarSet EQ "cfeoImg") {
			var toolbarConfig = "[
				[ 'Image' ]
			]";
		}

		// style sets (customize as desired)
		var styles = "
			/* Block Styles */
			{ name : 'Blue Title'		, element : 'h3', styles : { 'color' : 'Blue' } },
			{ name : 'Red Title'		, element : 'h3', styles : { 'color' : 'Red' } },
			/* Inline Styles */
			{ name : 'Marker: Yellow'	, element : 'span', styles : { 'background-color' : 'Yellow' } },
			{ name : 'Marker: Green'	, element : 'span', styles : { 'background-color' : 'Lime' } },
			{ name : 'Big'				, element : 'big' },
			{ name : 'Small'			, element : 'small' },
			{ name : 'Typewriter'		, element : 'tt' },
			{ name : 'Computer Code'	, element : 'code' },
			{ name : 'Keyboard Phrase'	, element : 'kbd' },
			{ name : 'Sample Text'		, element : 'samp' },
			{ name : 'Variable'			, element : 'var' },
			{ name : 'Deleted Text'		, element : 'del' },
			{ name : 'Inserted Text'	, element : 'ins' },
			{ name : 'Cited Work'		, element : 'cite' },
			{ name : 'Inline Quotation'	, element : 'q' },
			{ name : 'Language: RTL'	, element : 'span', attributes : { 'dir' : 'rtl' } },
			{ name : 'Language: LTR'	, element : 'span', attributes : { 'dir' : 'ltr' } },
			/* Object Styles */
			{ name : 'Image on Left'	, element : 'img', attributes :  { 'style' : 'padding: 5px; margin-right: 5px', 'border' : '2', 'align' : 'left' } },
			{ name : 'Image on Right'	, element : 'img', attributes :  { 'style' : 'padding: 5px; margin-left: 5px', 	'border' : '2', 'align' : 'right' } }
		";
		// include the textarea instance
		writeOutput("<textarea name='#arguments.instanceName#' id='#arguments.instanceName#'>#arguments.instanceValue#</textarea>");

		// include jScript to add the included styles to the editor
		writeOutput("
			<script type='text/javascript'>
			//<![CDATA[
			
				// create the sytles to be used in the Styles section
				CKEDITOR.addStylesSet( 'styles_#arguments.instanceName#',
					[
					   #styles#
					]);
				
				// Replace the textarea id='editor' with a CKEditor
				// instance, using default configurations.
				CKEDITOR.replace( '#arguments.instanceName#',
					{		
						 on :
					      {
					         instanceReady : function( ev )
					         {
					            this.dataProcessor.writer.setRules( 'p',
					               {
					                  indent : false,
					                  breakBeforeOpen : true,
					                  breakAfterOpen : false,
					                  breakBeforeClose : false,
					                  breakAfterClose : true
					               });
					         }
					      }	
					      ,
					    // control the editor via this configuration instead of editing the config.js file  			
						//uiColor : '##9AB8F3',
						toolbar : #toolbarConfig#,
						language : 'en',
						defaultLanguage : 'en',
						contentsCss : '#arguments.contentCSS#',
						height : '#arguments.height#',
						width : '#arguments.width#',
						resize_enabled : true,
						
						// configure the fileBrower to enable 'browse server, upload, etc.'
						// ensure checkAuthentication() in config.cfm for CKFinder has been set correctly to use this below

						filebrowserBrowseUrl : '#arguments.jsURL#/ckfinder/ckfinder.html',
						filebrowserImageBrowseUrl : '#arguments.jsURL#/ckfinder/ckfinder.html?Type=Images',
						filebrowserFlashBrowseUrl : '#arguments.jsURL#/ckfinder/ckfinder.html?Type=Flash',
						filebrowserUploadUrl : '#arguments.jsURL#/ckfinder/core/connector/cfm/connector.cfm?command=QuickUpload&type=Files',
						filebrowserImageUploadUrl : '#arguments.jsURL#/ckfinder/core/connector/cfm/connector.cfm?command=QuickUpload&type=Images',
						filebrowserFlashUploadUrl : '#arguments.jsURL#/ckfinder/core/connector/cfm/connector.cfm?command=QuickUpload&type=Flash',
						filebrowserWindowWidth : '640',
						filebrowserWindowHeight : '480'
					}
				);	
			//]]>
			</script>
		");


		} else if (arguments.type EQ "cfkPopup") {

			// Requires CKFinder - will display CKFinder as a popup option (ensure checkAuthentication() in config.cfm for CKFinder has been set correctly)

			// ensure the ckfinder.js file is included
			if (!isDefined("request.ckfinderjs")){
				writeOutput("<script type='text/javascript' src='#arguments.jsURL#/ckfinder/ckfinder.js'></script>");
				request.ckfinderjs = "true"; // set the scoped variable to last through the entire request, so it's included only once
			}

			// include jScript to create the popup option
			writeOutput("

				<script type='text/javascript'>

				function BrowseServer()
				{
					// You can use the 'CKFinder' class to render CKFinder in a page:
					var finder = new CKFinder();
					finder.basePath = '#arguments.jsURL#/ckfinder/';	// The path for the installation of CKFinder (default = '/ckfinder/').
					finder.selectActionFunction = SetFileField;
					finder.popup();
				
					// It can also be done in a single line, calling the 'static'
					// Popup( basePath, width, height, selectFunction ) function:
					// CKFinder.Popup( '../../', null, null, SetFileField ) ;
					//
					// The 'Popup' function can also accept an object as the only argument.
					// CKFinder.Popup( { BasePath : '../../', selectActionFunction : SetFileField } ) ;
				}
				
				// This is a sample function which is called when a file is selected in CKFinder.
				function SetFileField( fileUrl )
				{
					document.getElementById( '#arguments.instanceName#' ).value = fileUrl;
				}

				</script>

				<input id='#arguments.instanceName#' name='#arguments.instanceName#' type='text' />
				<input type='button' value='Browse Server' onclick='BrowseServer();' />
			");


		} else if (arguments.type EQ "cfkAlone"){

			// Requires CKFinder - display CKFinder as a stand alone option (ensure checkAuthentication() in config.cfm for CKFinder has been set correctly)

			// ensure the ckfinder.js file is included
			if (!isDefined("request.ckfinderjs")){
				writeOutput("<script type='text/javascript' src='#arguments.jsURL#/ckfinder/ckfinder.js'></script>");
				request.ckfinderjs = "true"; // set the scoped variable to last through the entire request, so it's included only once
			}

			writeOutput("
				<script type='text/javascript'>

				var finder = new CKFinder();
				finder.basePath = '#arguments.jsURL#/ckfinder/';
				finder.width = '#arguments.width#';
				finder.height = '#arguments.height#';
				finder.selectActionData = 'container';
				finder.selectActionFunction = function( fileUrl, data ) {
					alert( 'Selected file: ' + fileUrl );
					// Using CKFinderAPI to show simple dialog.
					this.openMsgDialog( '', 'File size: ' + data['fileSize'] + 'KB <br>' + ' Last modified:' + data['fileDate'] );
					document.getElementById( data['selectActionData'] ).innerHTML = fileUrl;
				}
				finder.create();

			</script>

			");
			writeOutput("end");

		} else {

			// provided type does not exist
			writeOutput("Editor type does not exist");

		}

	
	return;
}


</cfscript>
