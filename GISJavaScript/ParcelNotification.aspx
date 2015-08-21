<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml">
    <head>
	    <title>ArcGIS Server JavaScript API | Notification List Generator</title>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
    		
		<style type="text/css">
		    @import "http://serverapi.arcgisonline.com/jsapi/arcgis/1/js/dojo/dijit/themes/tundra/tundra.css";
		</style>
		
		<link rel="STYLESHEET" type="text/css" href="demo_parcel_picker.css" />
		
        <script type="text/javascript" src="http://serverapi.arcgisonline.com/jsapi/arcgis/?v=1"></script>
		 
        <script type="text/javascript">
        dojo.require("esri.map");
        dojo.require("esri.geometry");
        dojo.require("esri.tasks.gp");
        dojo.require("esri.tasks.query");
        dojo.require("dojo.parser");
        dojo.require("dijit.TitlePane");
        dojo.require("dijit.ProgressBar");
        dojo.require("dijit.Dialog")
	 
        var map, queryTask, query, queryNH, curFeature, featureSet;
        var Imagery, LandRecord, Transportation;
	 
        function init() {
	 
            //Set the initial extent of the map to downtown.
            var startExtent = new esri.geometry.Extent({ xmin: -12989859.39, ymin: 5413247.49, xmax: -12987709.60, ymax: 5414680.68, spatialReference: new esri.SpatialReference({ wkid: 2243 }) });
            map = new esri.Map("map", { extent:startExtent } );

            //Add the I-cubed imagery from ArcGIS Online as the primary basemap layer.
            Imagery = new esri.layers.ArcGISTiledMapServiceLayer("http://gistestdev:6080/arcgis/rest/services/Basemap/MapServer", { id: "Imagery", visible: true });
            map.addLayer(Imagery);
            dojo.byId("rdImg").checked=true;
  			 
  			////Add the ArcGIS Online Streetmap layer as a secondary basemap.
            //Transportation = new esri.layers.ArcGISDynamicMapServiceLayer("http://*****/ArcGIS/rest/services/Internal/AGS_TP/MapServer", { id: "Transportation", visible: false });
  			//map.addLayer(Transportation);
  			//dojo.byId("rdTrans").checked=false;
  			 
  			////Add the  neighborhoods layer from the ArcGIS Online sample services as the Neighborhoods layer.
  			//Neighborhoods = new esri.layers.ArcGISDynamicMapServiceLayer("http://*******/ArcGIS/rest/services/Internal/AGS_City/MapServer", {id:"Neighborhoods", opacity:"0.3", visible:false});
  			//map.addLayer(Neighborhoods);
  			//dojo.byId("cbNH").checked=false;
  			 
  			////Add the  Tax Lots layer from the ArcGIS Online sample services as the LandRecords layer.
  			//LandRecords = new esri.layers.ArcGISDynamicMapServiceLayer("http://*****/ArcGIS/rest/services/Internal/TPtest/MapServer", { id: "LandRecords", opacity: "0.3", visible: true });
  			//map.addLayer(LandRecords);
  			//dojo.byId("cbLR").checked=true;
  			 
  			////Listen for click event on the map, when the user clicks on the map call executeQueryTask function.
  			//dojo.connect(map, "onClick", executeQueryTask);
  	 
  			////build query tasks
  			//queryTask = new esri.tasks.QueryTask("http://******/ArcGIS/rest/services/Internal/AGS_TP/MapServer/0");
  	        //queryTaskNH = new esri.tasks.QueryTask("http://*****/ArcGIS/rest/services/Internal/AGS_City/MapServer/1");
  	 
  			////build query filter
  			//query = new esri.tasks.Query();
  			//queryNH = new esri.tasks.Query();
  			//query.returnGeometry = true;
  			//queryNH.returnGeometry = true;
  			 
  			////set the query task output fields
  			//query.outFields = ["ACCOUNT", "OwnerName", "Address", "City", "State", "ZipCode"];
  		  
  		    ////build the gp task by referencing the tool name in the ArcGIS online sample service.
  			//gp = new esri.tasks.Geoprocessor("http://sampleserver2.arcgisonline.com/ArcGIS/rest/services/Portland/ESRI_CadastralData_Portland_Sync/GPServer/MailingList");
	 
        }
		   
        function executeQueryTask(evt) {
  			map.infoWindow.hide();
  			map.graphics.clear();
  			featureSet = null;
  	 
  			//onClick event returns the evt point where the user clicked on the map.
  			//This is contains the mapPoint (esri.geometry.point) and the screenPoint (pixel xy where the user clicked).
  			//set query geometry = to evt.mapPoint Geometry
  			query.where = null;
  			query.geometry = evt.mapPoint;
  			 
  			//Execute task and call showResults on completion
  			queryTask.execute(query, function(fset) {
  			    if (fset.features.length === 1) {
  				showFeature(fset.features[0],evt);
  			    } else if (fset.features.length !== 0) {
  				showFeatureSet(fset,evt);
  			    } else{ 
  				alert ("No parcels found at that location, try another spot.");}
  			});
        }
	 
        function showFeature(feature,evt) {
            map.graphics.clear();
  			 
  			curFeature = feature;
            var fExtent = feature.geometry.getExtent();
  			var centerPt = fExtent.getCenter();
  			var symbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_NONE, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_DASHDOT, new dojo.Color([255,0,0]), 2), new dojo.Color([255,255,0,0.25]));
  			feature.setSymbol(symbol);

            feature.setInfoTemplate(new esri.InfoTemplate("Parcel ID : <pre style='display:inline;'>${ACCOUNT}</pre>",
  			    "<form>Zip Code : ${ZipCode}"
                + "<br />Owner Name : ${OwnerName}"
                + "<br />Address : ${Address}"
                + "<br />City : ${City}"
                + "<br />State : ${State}"
                + "<br />"
                + "<br /><b>Generate Mailing List: </b>"
                + "<br/>     Enter buffer distance in ft: "
                + "<br/><input id='txtgpdist' width='30px' type='text' name='txtgpdist' value='100'> <input id='btnGP' type='button' onclick='RunGP(dojo.byId('txtgpdist').value)' value='Submit' ></form>"
            ));

            map.graphics.add(feature);
            map.infoWindow.resize(210, 210);
  			map.infoWindow.setTitle(feature.getTitle()).setContent(feature.getContent());
  	 
  	        if (evt != null){
  			    (evt) ? map.infoWindow.show(evt.screenPoint,map.getInfoWindowAnchor(evt.screenPoint)) : null;
            }
		    else
		    {
                map.infoWindow.show(map.toScreen(centerPt), map.getInfoWindowAnchor(map.toScreen(centerPt)));   //Waiting on a fix from Jayant.
            }
        }
	 
		function showFeatureSet(fset,evt) {
  		    //remove all graphics on the maps graphics layer
  			map.graphics.clear();
  			var screenPoint = evt.screenPoint;
  	 
  			featureSet = fset;
  	 
  			var numFeatures = featureSet.features.length;
  	 
  			//QueryTask returns a featureSet.  Loop through features in the featureSet and add them to the infowindow.
  			var title = "You have selected " + numFeatures + " fields. &nbsp;Please select desired field from the list below.";
  			var content = "";
  	 
  			for (var i=0; i<numFeatures; i++) {
  			    var graphic = featureSet.features[i];
  			    content = content + graphic.attributes.FIELD_NAME + " Field (<A href='javascript:showFeature(featureSet.features[" + i + "]);'>show</A>)<br/>";
            }
  			map.infoWindow.setTitle(title);
  			map.infoWindow.setContent(content);
  			map.infoWindow.show(screenPoint,map.getInfoWindowAnchor(evt.screenPoint));
  			//dijit.byId('control_panel').toggle();
        }
		   
		function RunGP(distance) {
		     
            dojo.byId("progresstext").innerHTML = "Running Analysis...";
            toggleProgressBar();
  			if (distance > 300){alert("Maximum Distance exceeded. \nPlease enter a distance less than 300 Feet");
  			    toggleProgressBar();
  			}
  			else{
  			    var attr = curFeature.attributes;
  			    var dash = attr.ACCOUNT.indexOf(" -");
			    var params = { "Parcel_ID":attr.ACCOUNT, "SearchDistance_ft":distance };
			    gp.outputSpatialReference = new esri.SpatialReference({wkid: 4326});
			    gp.execute(params, showGPResults);  //A syncrhonous call to the gp task
            }
        }
	
		function showGPResults(results, messages) {
		    //the synchronous call to a GP service automatically sends all messages and results to a pre-defined function.
  			var reportURL = results[1].value.url;
  	 	    var feature = results[0].value.features[0];
            feature.symbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_DASHDOT, new dojo.Color([255,0,0]), 2), new dojo.Color([200,200,0,0.25]));
  			map.graphics.add(feature);
  			dojo.byId("resultFrame").src = reportURL;
            dijit.byId("gp_results").show();
			toggleProgressBar();
        }
			 
		//Switch between the basemap layers, or toggle the parcel layer
        function changeMap(layerid) {
  		    var curLayer = map.getLayer(layerid);
  			toggleLayer(curLayer);
        }
	 
		function toggleLayer(layer) {
		//if the layer is visible, turn it off and update the control panel. If invisible, do the same.
         		 
  			switch (layer.id)
  			{
  			    case "Imagery":
  				if(dojo.byId("rdImg").Checked){
                    //do nothing
                }
  			else{
                if (layer.visible){
                    layer.hide();
  				    map.getLayer("Transportation").show();
  				    dojo.byId("rdTrans").Checked = true;
  				    dojo.byId("rdImg").Checked = false;
                }
   			    else{
                    layer.show();
   				    map.getLayer("Transportation").hide();
   				    dojo.byId("rdTrans").Checked = false;
   				    dojo.byId("rdImg").Checked = true;
                }
            }
             
                break;
  			    case "Transportation":
  				if(dojo.byId("rdTrans").Checked){
                    //do nothing
  				}
  				else{
                    if (layer.visible){
                        map.getLayer("Imagery").show();
    				    layer.hide();
                        dojo.byId("rdTrans").Checked = false;
    				    dojo.byId("rdImg").Checked = true;
                    }
    				else{
                        map.getLayer("Imagery").hide();
    				    layer.show();
                        dojo.byId("rdTrans").Checked = true;
    				    dojo.byId("rdImg").Checked = false;
                    }
                }
                break;
  			    case "Neighborhoods":
  				var tmpNH = dojo.byId("cbNH");
                if (layer.visible){
  				    tmpNH.Checked = false;
  				    layer.hide();
               }
  				else{
  				    tmpNH.Checked = true;
  				    layer.show();
                }
  				   
                break;
  			    case "LandRecords":
  				var tmpLR = dojo.byId("cbLR");
  				if (layer.visible){
  				    tmpLR.Checked = false;
  				    layer.hide();
                }
                else{
                    tmpLR.Checked = true;
  				    layer.show();
                }
  				
            break;
  			}
        }
	 
		function centerMap(feature, ddValue){
		   
            var fExtent = feature.geometry.getExtent();
            var centerPt = new esri.geometry.Point;
            centerPt = fExtent.getCenter();
            map.centerAt(centerPt);
			 
        }
		   
		function ZoomMap(feature, ddValue){
		   
            var fExtent = feature.geometry.getExtent();
			map.setExtent(fExtent);
			 
        }
		   
		function pan_PID(){
            var w = document.PIDform.goPID.selectedIndex;
  			var selected_text;
  			//hide the control panel and show the progress bar.
  			dijit.byId('control_panel').toggle();
  			 
  			switch (w){
                case 0:
  				    //do nothing
  				    break;
  				case 1:
                    selected_text = "R1234500000";
                    break;
  				case 2:
  				    selected_text = "21E10BB07200";
  				    break;
  				case 3:
  				    selected_text = "21E13CD00700";
  				    break;
  				case 4:
  				    selected_text = "1S3E03AC  -06400";
  				    break;
                case 5:
  				    selected_text = "1N3E20DD  -00912";
  				    break;
                case 6:
  				    selected_text = "1N1E02A   -01800";
  				    break;
  			   } 
  			 
  			 
            //zero out the query Geometry
  			query.geometry = null;
  			 
  			if (w > 0){
  			    query.where = "ACCOUNT = '" + selected_text + "'";
  			    //hide the control panel and show the progress bar.
    			dijit.byId('control_panel').toggle();
    			dojo.byId("progresstext").innerHTML = "Locating Parcel...";
                toggleProgressBar()
  			 
  			    //Execute the queryTask and call showResults on completion
  			    queryTask.execute(query, function(fset) {
  			        if (fset.features.length === 1) {
  				    centerMap(fset.features[0],selected_text);
  				    showFeature(fset.features[0], null);
  				    toggleProgressBar();
  			        } else if (fset.features.length !== 0) {
                    showFeatureSet(fset,null);
  			        } else{
  				    alert ("No features returned from server.")}
  			    });
            }
  			else{} //Do Nothing}
        }
		   
        function zoom_NH(){
            var w = document.NHform.goNH.selectedIndex;
  			var selected_text = document.NHform.goNH.options[w].value;
  			   			 
  			if (w > 0){
    		    //hide the control panel and show the progress bar.
    			dijit.byId('control_panel').toggle();
    			dojo.byId("progresstext").innerHTML = "Locating Neighborhood...";
                toggleProgressBar()
    			 
    			//zero out the query Geometry
    			queryNH.geometry = null;
    			queryNH.where = "PLAT_NAME = '" + selected_text + "'";
    			//Execute the queryTask and call showResults on completion
    			queryTaskNH.execute(queryNH, function(fset) {
      			    if (fset.features.length === 1) {
      				ZoomMap(fset.features[0],selected_text);
      				toggleProgressBar();
      			    } else{
      				alert ("No features returned from server.")}
                });
            }
  			else{} //Do Nothing}
        }
			  
        function dropdown(mySel){
		    var myWin, myVal;
		    myVal = mySel.options[mySel.selectedIndex].value;
		    if(myVal){
			    if(mySel.form.target)myWin = parent[mySel.form.target];
			    else myWin = window;
			    if (! myWin) return true;
			    myWin.location = myVal;
            }
		return false;
        }
	
        function toggleProgressBar() {
		    var progressbar_container = dojo.byId("progressbar_container");
			var control_panel = dojo.byId("control_panel");
				
			if (progressbar_container.style.display=="block") {
			    progressbar_container.style.display="none";
            }
            else {
                progressbar_container.style.display="block";
            }
        }
        dojo.addOnLoad(init);
		
		</script>
	</head>
	
	<!-- not sure what this dojo class on the body does 							-->
	<body class="tundra">

		<!-- DEMO BANNER 															-->
		<div id="demo_banner"><img src="banner_jsapi.gif" /></div> 
			
		<!-- DEMO PLAYGROUND 														-->

		<div id="demo_playground">

	    <!-- DEMO HEADER 														-->
			<div id="demo_header">
                      
		    <!-- DEMO TITLEBAR													-->
				<div id="header_titlebar">
				
					<!-- DEMO TITLE 												-->
					<h1>Notification List Generator</h1>
					
					<!-- DEMO SUBTITLE 												-->

					<h2>Using property data supplied by  office</h2>
					
				</div> <!-- CLOSES DEMO_TITLEBAR 									-->
				
			</div> <!-- CLOSES DEMO_HEADER	 										-->
		
			<!-- MAP HOLDER 														-->
			<div id="map_holder">
		    <!-- MAP 															-->
				<div id="map"></div>	
			</div> <!-- CLOSES MAP_HEADER	 	 									-->

				
	    <!-- CONTROL PANEL  													-->
			<div dojoType="dijit.TitlePane" title="Control Panel" id="control_panel">  
			  <a href="#" onclick="dijit.byId('help_dialog').show()" class="right">How it works</a><br />
			  <fieldset>
			  <legend>Map Layers:</legend><br />
			  <input type="radio" NAME="baseMapGroup" id="rdImg" onClick="changeMap(['Imagery']);" CHECKED/>
			  <label for="rdImg">Satellite Imagery</label><br>

			  <input type="radio" id="rdTrans" NAME="baseMapGroup" onClick="changeMap(['Transportation']);"/>
			  <label for="rdTrans">Transportation</label><br>
	    <input type="checkbox" id="cbLR" onClick="changeMap(['LandRecords']);" CHECKED/>
					<label for="cbLR">Land Records</label><br>
	    <input type="checkbox" id="cbNH" onClick="changeMap(['Neighborhoods']);" CHECKED/>
					<label for="cbNH">Neighborhoods</label><br>
			  </fieldset>

				
					<legend>Search for Parcel by Account number:</legend><br />
                    <input type="text" id="searchText" value="R12345" />
      <input type="button" value="Find" onclick="execute(dojo.byId('searchText').value);"/>
		 <!-- <form NAME="PIDform">
						<select NAME="goPID" onChange="pan_PID()">
							<option VALUE=""></option>
							<option VALUE="R1234500000" >R1234500000</option>
							<option VALUE="21E10BB07200" >21E10BB07200</option>

							<option VALUE="21E13CD00700" >21E13CD00700</option>
							<option VALUE="1S3E03AC  -06400" >1S3E03AC&nbsp; -06400</option>
							<option VALUE="1N3E20DD  -00912" >1N3E20DD&nbsp; -00912</option>
							<option VALUE="N1E02A   -01800" >1N1E02A&nbsp;&nbsp; -01800</option>

						</select>
					</form >
				</fieldset>
				<fieldset>
					<legend>Zoom to Neighborhood:</legend><br />
		  <form NAME="NHform">
						<select NAME="goNH" onChange="zoom_NH()">
							<option VALUE=""></option>
                          
							<option VALUE="WEST PARK SUB" >West Park Sub</option>
							<option VALUE="PALISADES" >Palisades</option>
							<option VALUE="FOSTER-POWELL" >Foster-Powell</option>
							<option VALUE="MONTAVILLA" >Montavilla</option>
							<option VALUE="MILL PARK" >Mill&nbsp;Park</option>
							<option VALUE="FIVE OAKS" >Five&nbsp;Oaks</option>

							<option VALUE="CATHEDRAL PARK" >Cathedral&nbsp;Park</option>
							<option VALUE="ROSEWOOD" >Rosewood</option>
						</select>
					</form >
				</fieldset>-->
			</div> <!-- CLOSES THE CONTROL PANEL 									-->
				
	    <!-- PROGRESS BAR CONTAINER												-->

			<div id="progressbar_container">
				<!-- PROGRESS BAR 		-->
       		  <h5><b id ="progresstext">Running Analysis...</b></h5>											
				<div dojoType="dijit.ProgressBar" jsId="jsProgress" id="progressbar" indeterminate="true"></div>
			</div>
			
			<!-- HELP DIALOG BOX													-->
			<div dojoType="dijit.Dialog" id="help_dialog" title="How it works">
			
				<p>Click on a parcel on the map or choose a parcel from the list, then type in a notification distance.</p>

                <p>When you click "Submit" the chosen parcel and notification distance are sent to ArcGIS Server and input to the ArcGIS Geoprocessing Model hosted by ESRI and a list of all parcels that need to be notified is displayed.</p>

			</div><!-- CLOSES HELP DIALOG BOX 										-->
			
			<div dojoType="dijit.Dialog" id="gp_results" href="" execute="" title="Mailing List">
			<!---->
			   <iframe src="" id="resultFrame" longdesc="" frameborder="0" height="557px" width="100%"></iframe>

			</div> <!-- Closes the report results                  -->
		
        <!-- Powered by emblem 														--> 
             <a href="http://www.esri.com" title="ESRI home page" target="_blank"><img src="poweredby.gif" width="77" height="37" class="right" id="emblem" /></a>
             
		</div> 
		<!-- CLOSES DEMO_PLAYGROUND 											-->
		
		<!-- DEMO DOCUMENTATION 													-->
		<div id="demo_documentation">

			<br> 	<!-- This was needed to fix a margin/padding issue in IE7 and Safari 				-->
			<table id="demo_documentation_table" class="clear_both" cellspacing="0">
				<tr>
					<!-- COLUMN ONE 												-->
					<td class="table_column" width="33%">
					
					<!-- DEMO WRITE UP 												-->
					<h3>Notification List Generator</h3>
						<p>GIS helps local governments share information with citizens. For example, city governments must notify nearby property owners about changes to a specific property. This demonstration uses ESRI's ArcGIS JavaScript API and <a href="http://www.esri.com/software/arcgis/arcgisserver/index.html" title="ArcGIS Server">ArcGIS Server</a> to deliver a lightweight, focused GIS application on the Web.</p>

                        <h4>To use this application</h4>
						<ol>
                            <li>In Control Panel, choose the background map layers you want to see (e.g., satellite imagery or land records).</li>
                            <li>Click on a parcel in the map. Alternatively, you can choose from a list of parcel numbers in the Pan to Parcel by ID drop-down list or you can zoom to a neighborhood and then click on a parcel in the map.</li>
                            <li>In the Parcel ID info box, enter a buffer distance less than 300 feet—the default is 100 feet.</li>
                            <li>Click Submit. A list of property owners and their addresses appears.</li>

                        </ol>
		
					</td>
					<!-- COLUMN TWO 												-->
					<td class="table_column" width="33%">	
						<!-- DEMO TECHNICAL SPECIFICATIONS  						-->
						<h3>ArcGIS JavaScript API</h3>
						<p>The ArcGIS JavaScript API provides an easy-to-use framework for rapid development of Web mapping applications using only HTML and JavaScript. It gives end users the capability to mash up GIS-based Web services from ArcGIS Server with other Web content including content from other GIS servers. No client downloads are required, and only minimal resources are required from your computer. Analysis processing takes place on the server. </p>  
					</td>
					<!-- COLUMN THREE 												-->

					<td class="table_column" width="33%">	
						<!-- ADDITIONAL DEMOS  										-->
                        <!-- this is just a placeholder                             --> 
					</td>
				</tr>	
			</table>

            
            </div>
            
		<!-- FOOTER  																-->
	
	
	</body>
</html>
