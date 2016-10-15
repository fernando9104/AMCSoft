<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!--
    Name:   Portal-V.jsp
    Autor:  Luis F Castaño
    Date:   03-Oct-2016
    Desc:   Modulo principal del Portal de AMCsoft.

    Autor: Luis F Castaño
    Date:  15-Oct-2016 
    Desc:  Se actualiza portal principal.
  
-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Administrador de Consultas Medicas</title>
<link href="../externals/dhtmlx/skyblue/dhtmlx.css" rel="stylesheet" type="text/css"/>
<script src="../externals/dhtmlx/dhtmlx.js" type="text/javascript"></script>
<script type="text/javascript">

//Function dhtmlxEvent
dhtmlxEvent(window,"load",function(){
   //execute dhtmlx init
   portalInit();
});//end function dhtmlxEvent

//Function Portal Init
function portalInit(){
	
/* INICIALITATION  */

    root                = "../";  //root
    iconsPath       	= root + "resources/images/icons/"; 	//rutas de iconos
    dhtmlx.image_path	= root + "externals/dhtmlx/skyblue/imgs/";
    
    //Static XML
    centerTabbarXML 	= "Tabbar.xml"; //Center Tabbar Container
    leftTreeXML     	= "Tree.xml";   //Tree left Container
	
    //Size Containers
    headerHeight	= 40;
    leftWidth		= 200;
    footerHeight	= 40;

    //Cells
    headerCell		= "a";
    leftCell		= "b";
    centerCell		= "c";
    footerCell		= "d";

/* END INICIALITATION  */ 

/* INSTANTIATION  */
	
    //main layout
    pattern      	= "4I";
    portalLayout 	= new dhtmlXLayoutObject("portalLayoutDiv",pattern);

    //container header
    portalHeaderContainer = portalLayout.cells(headerCell);
    portalHeaderContainer.setHeight(headerHeight);
    portalHeaderContainer.hideHeader();

    //container left
    portalLeftContainer = portalLayout.cells(leftCell);
    portalLeftContainer.setWidth(leftWidth);
    portalLeftContainer.setText("Panel de Control");
    portalLeftContainer.hideArrow();

    //container right
    portalCenterContainer = portalLayout.cells(centerCell);
    portalCenterContainer.hideHeader();

    //container footer
    portalFooterContainer = portalLayout.cells(footerCell);
    portalFooterContainer.setHeight(footerHeight);
    portalFooterContainer.hideHeader();

    //fixed Size containers
    portalHeaderContainer.fixSize(true,true);
    portalLeftContainer.fixSize(true,true);
    portalCenterContainer.fixSize(true,true);
    portalFooterContainer.fixSize(true,true);

    //Left Sidebar
    portalLeftTree = portalLeftContainer.attachTree();
    portalLeftTree.setImagePath(dhtmlx.image_path + "dhxtree_skyblue/");
    portalLeftTree.setIconsPath(iconsPath);

    //Center Tabbar
    portalCenterTabs  = portalCenterContainer.attachTabbar();

/* END INSTANTIATION  */

/* EVENTS */
/* END EVENTS */

/* LOADS  */

    //loadStruct Left Siderbar 
    portalLeftTree.load(leftTreeXML + "?etc=" + new Date().getTime());

    //loadStruct Center Tabbar
    portalCenterTabs.loadStruct(centerTabbarXML + "?etc=" + new Date().getTime());

/* END LOADS  */
	
/* FUNCTIONS */
/* END FUNCTIONS */	

}//fin funcion init 
</script>
</head>
<body>
    <div id="portalLayoutDiv" style="position: fixed; height: 98%; width: 99%;"></div>
</body>
</html>