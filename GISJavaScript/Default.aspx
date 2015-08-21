<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="GISJavaScript._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
<!DOCTYPE html>
<html>
<head>
<title>Create a Web Map</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<link rel="stylesheet" type="text/css" href="http://js.arcgis.com/3.14/esri/css/esri.css">
<style>
  html,body,#mapDiv,.map.container{
    padding:0;
    margin:0;
    height:100%;
  }
  #legendDiv{
  background-color: #fff;
  position: absolute !important;
  z-index: 99;
  top:10px;
  right:20px;
}
</style>

<script>var dojoConfig = { parseOnLoad: true };</script>
<script src="http://js.arcgis.com/3.14compact/"></script>
<script>
    var map;
    require([
   "esri/map",
   "esri/arcgis/utils",
   "esri/dijit/Legend",
   "dojo/domReady!"
    ], function (Map, arcgisUtils) {
        arcgisUtils.createMap("777e6386cf8a4390909325e90c3033ae", "mapDiv").then(function (response) {
            map = response.map;

            var legend = new Legend({
                map: map,
                layerInfos: (arcgisUtils.getLegendLayers(response))
            }, "legendDiv");

            legend.startup();
        });
    });
</script>
</head>

<body>
  <div id="mapDiv"></div>
    <div id="legendDiv"></div>
</body>
</html>


</asp:Content>
