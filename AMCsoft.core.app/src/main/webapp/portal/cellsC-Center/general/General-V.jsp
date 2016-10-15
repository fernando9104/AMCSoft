<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!--
    Name:   General-V.jsp
    Autor:  Luis F Castaño
    Date:   03-Oct-2016
    Desc:   Modulo Tabs Internos General.

    Autor: Luis F Castaño
    Date:  15-Oct-2016 
    Desc:  Se actualiza el modulo General.
  
-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link href="../../../externals/dhtmlx/skyblue/dhtmlx.css" rel="stylesheet" type="text/css"/>
<script src="../../../externals/dhtmlx/dhtmlx.js" type="text/javascript"></script>
<script type="text/javascript">

//Function dhtmlxEvent
dhtmlxEvent(window,"load",function(){
   //execute dhtmlx init
   generalInit();
});//end function dhtmlxEvent

//Function General Init
function generalInit(){
	
/* INICIALITATION  */

    root  = "../";  //root
   
    //Static XML
    generalTabbarXML    = "GeneralTabbar.xml";    //Center Tabbar Container
    
    //Cells
    generalTabbarCell   = "a";

/* END INICIALITATION  */ 

/* INSTANTIATION  */
	
    //main layout
    pattern         = "1C";
    generalLayout   = new dhtmlXLayoutObject("generalLayoutDiv",pattern);
   	
    /* Container Tabbar */
    generalTabbarContainer = generalLayout.cells(generalTabbarCell);
    generalTabbarContainer.hideHeader();
    
    /* General Tabbar */
    generalTabbar    = generalTabbarContainer.attachTabbar();
   	 
/* END INSTANTIATION  */

/* EVENTS */
/* END EVENTS */

/* LOADS  */
	
    //loadStruct general Tabbar
    generalTabbar.loadStruct(generalTabbarXML + "?etc=" + new Date().getTime());

/* END LOADS  */
	
/* FUNCTIONS */
/* END FUNCTIONS */	

}//fin funcion init 
</script>
</head>
<body>
    <div id="generalLayoutDiv" style="position: fixed; height: 98%; width: 99%;"></div>
</body>
</html>