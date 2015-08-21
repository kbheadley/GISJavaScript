<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Working.aspx.cs" Inherits="GISJavaScript.Working" %>

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <!--The viewport meta tag is used to improve the presentation and behavior of the samples 
      on iOS devices-->
    <meta name="viewport" content="initial-scale=1, maximum-scale=1,user-scalable=no">
    <title>Create Map and add a dynamic layer</title>
    <link rel="stylesheet" href="http://js.arcgis.com/3.14/esri/css/esri.css"/>
    <style>
      html, body, #mapDiv{
        padding: 0;
        margin: 0;
        height: 100%;
      }
    </style>
    <script src="http://js.arcgis.com/3.14/"></script>
    <script>
      var map;

      require([
        "esri/map",
        "esri/layers/ArcGISDynamicMapServiceLayer",
        "esri/layers/ImageParameters"
      ], function (
        Map, ArcGISDynamicMapServiceLayer, ImageParameters) {

        map = new Map("mapDiv", {
          sliderOrientation : "horizontal"
        });

        var imageParameters = new ImageParameters();
        //imageParameters.format = "jpeg"; //set the image type to PNG24, note default is PNG8.

          //Takes a URL to a non cached map service.
          // WORKS :
          //var dynamicMapServiceLayer = new ArcGISDynamicMapServiceLayer("http://gistestdev:6080/arcgis/rest/services/Basemap/MapServer", {
          // WORKS :
          var dynamicMapServiceLayer = new ArcGISDynamicMapServiceLayer("https://gisitservices.suffolkcountyny.gov/arcgis/rest/services/BasemapRealProperty/MapServer", {
          // DOES NOT WORK:
       // var dynamicMapServiceLayer = new ArcGISDynamicMapServiceLayer("https://gisservices.suffolkcountyny.gov/arcgis/rest/services/Basemap/MapServer", {
                //"opacity" : 0.5,
          //"opacity" : 0.5,
          "imageParameters" : imageParameters
        });

        map.addLayer(dynamicMapServiceLayer);
      });
    </script>
  </head>
  <body>
    <div id="mapDiv" class="map"></div>
  </body>
</html>
