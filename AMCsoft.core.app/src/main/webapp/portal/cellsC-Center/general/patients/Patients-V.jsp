<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!--
    Name:   Patients-V.jsp
    Autor:  Luis F Castaño
    Date:   15-Oct-2016
    Desc:   Vista principal del modulo Pacientes.

    Autor:  
    Date:   
    Desc:   
  
-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link href="../../../../externals/dhtmlx/skyblue/dhtmlx.css" rel="stylesheet" type="text/css"/>
<script src="../../../../externals/dhtmlx/dhtmlx.js" type="text/javascript"></script>
<script type="text/javascript">

//Function dhtmlxEvent
dhtmlxEvent(window,"load",function(){
   //execute dhtmlx init
   patientsInit();
});//end function dhtmlxEvent

//Function Patients Init
function patientsInit(){
	
/* INICIALITATION  */

    root                = "../../../../";  //root
    iconsPath           = root + "resources/images/icons/"; //rutas de iconos

    //Static XML
    patientsMenuXML     = "Patients-Menu.xml";
    patientsGridXML     = "Patients-Grid.xml";
    patientsFormXML     = "Patients-Form.xml";
    patientsWinMenuXML  = "PatientsWin-Menu.xml";
    
    //CM XML 
    patientsGridLoad    = "TestData-Grid.xml";
    
    //Cells
    gridCell            = "a";
    formCell            = "a";
    
    //Referencias de las columnas
    nameCol             = 0;
    lastNameCol         = 1;
    ageCol              = 2;
    genderCol           = 3;
    DNICol              = 4;
    phoneMovilCol       = 5;
    phoneHomeCol        = 6;
    RUTCol              = 7;       
    addressCol          = 8;       
    emailCol            = 9;       
    birthdateCol        = 10;       
    maritalStatusCol    = 11;       
    citizenshipCol      = 12;       
    observationsCol     = 13;       
    dateAdmissionCol    = 14;       
    
    //Variables Generales
    selectedRow                 = "";   // contiene el id o UUID a seleccionar en la grilla patients.
    name                        = "";   // contiene los nombres del paciente seleccionado
    lastName                    = "";   // contiene los apellidos del paciente seleccionado
    removeConfirmTextSetup      = "";   // contiene el texto de la ventanan modal remove configurado con el nombre completo del paciente
    patientsFormOriginalValues  = "";   // contiene los datos originales del paciente de la fila seleccionada
    patientsFormBackup          = 0;    // contiene la referencia del backup creado de la fila seleccionada

    //Flags Generales  
    firstTime       = true;     // flag que indica al modulo que la carga de datos se hace realiza por primera vez
    canChangeForm   = false;    // flag que indica que la forma esta en estado de edicion o de agregar paciente.
    isAdding        = false;    // flag que indica que la forma esta en proceso de agregar pacientes.
    
    //Variables userData del menu
    formHeader          = "";
    noteDetailText      = "";
    noteAddText         = "";
    noteEditText        = "";
    removeConfirmTitle  = "";
    removeConfirmText   = "";
    okButton            = "";
    cancelButton        = "";

/* END INICIALITATION  */ 

/* INSTANTIATION  */
	
    //Main layout.
    pattern             = "1C";
    patientsLayout      = new dhtmlXLayoutObject("patientsLayoutDiv",pattern);
    
    //Object Windows, crea objeto ventana window y se le instancia layout 1C.
    patientsFormWindow  = patientsLayout.dhxWins.createWindow("patientsFormWindow",0,0,0,0);
    patientsFormLayout  = patientsLayout.dhxWins.window("patientsFormWindow").attachLayout(pattern);
    patientsFormWindow.hide();

    //Container grid.
    patientsGridContainer = patientsLayout.cells(gridCell);
    patientsGridContainer.hideHeader();
    
    //Container Form (window).
    patientsFormContainer = patientsFormLayout.cells(formCell);
    patientsFormContainer.hideHeader();
    
    //Object Menu.
    patientsMenu = patientsGridContainer.attachMenu();
    patientsMenu.setIconsPath(iconsPath);
   
    //Object Grid.
    patientsGrid = patientsGridContainer.attachGrid();
    
    //Object Window Menu.
    patientsWinMenu   =  patientsFormLayout.attachMenu();
    patientsWinMenu.setIconsPath(iconsPath);
    
    //Object Form.
    patientsForm = patientsFormContainer.attachForm();
    patientsForm.lock();
    
    //Bind Master Detail
    patientsForm.bind( patientsGrid );

/* END INSTANTIATION  */

/* EVENTS */
    
    /* Evento onClick del menu */
    patientsMenu.attachEvent("onClick", function(id){
        switch( id ){
            case "addPatients":
                isAdding   = true;  //proceso agregar paciente
                patientsForm.restoreBackup( patientsAddFormBackup );
                //No Break
            case "editPatients":
                canChangeForm   = true; //proceso edicion paciente
                patientsForm.unlock();
                createFormWindow();
                patientsForm.setItemFocus("name");
                patientsMenuButtonSetup();
                messageNoteSetup(); //Configurar Nota
                break;
            case "removePatients":
                removePatientsDialog();
                break;
            case "viewDetail":
                createFormWindow();
                break;  
        }//fin del switch
    });//fin del evento onClick
    
    /* Evento onClick del menu de la Ventana */
    patientsWinMenu.attachEvent("onClick", function(id){
        switch( id ){
            case "editPatients":
                canChangeForm   = true; //proceso edicion paciente
                patientsForm.unlock();
                patientsForm.setItemFocus("name");
                patientsMenuButtonSetup();
                messageNoteSetup();     //Configurar Nota
                break;
            case "removePatients":
                break;
        }//fin del switch
    });//fin del evento onClick
    
    /* Evento onRowSelect de la Grilla Patients */
    patientsGrid.attachEvent("onRowSelect", function(id){
        
        //id de la fila seleccionada
        selectedRow     = id;
        name            = patientsGrid.cellById(selectedRow, nameCol        ).getValue();
        lastName        = patientsGrid.cellById(selectedRow, lastNameCol    ).getValue();
        
        removeConfirmTextSetup  = removeConfirmText.replace("#namePatients#",name +" "+ lastName );
        
        //Se obtiene un backup de la fila seleccionada.
        patientsFormBackup          = patientsForm.saveBackup();
        patientsFormOriginalValues  = patientsForm.getFormData();

        //configura botones de los menus
        patientsMenuButtonSetup();
       
    });//fin del evento onRowSelect
    
    /* Evento onClose de la Ventana con la Forma de Detalle */
    patientsFormWindow.attachEvent("onClose", function(win){
        /* Si esta en proceso de Agregar o Editar */
        if( canChangeForm  ){
            canChangeForm   = false;    //proceso edicion o agregar
            isAdding        = false;    //proceso agregar paciente
            patientsForm.restoreBackup(patientsFormBackup);
            patientsMenuButtonSetup();
        }
        patientsForm.lock();
        patientsFormWindow.hide();
        
        return false;
    });//fin del evento onClose
    
    /* Evento onButtonClick de la forma de Detalle del Paciente */
    patientsForm.attachEvent("onButtonClick",function(name){
        switch( name ){
            case "update":
                break;
            case "clear":
                //se restaura el backup dependiendo del proceso
                if( isAdding ){
                    patientsForm.restoreBackup(patientsAddFormBackup);
                }else{
                    patientsForm.restoreBackup(patientsFormBackup);
                }
                break;
            case "cancel":
                patientsFormWindow.callEvent("onClose");
                break;
        }//fin del switch
    });//fin de la forma Detalle
    
/* END EVENTS */

/* LOADS  */

    //loadStruct Menu
    patientsMenu.loadStruct(patientsMenuXML + "?etc=" + new Date().getTime(), patientsMenuCallback );

    //loadStruct Grid 
    patientsGrid.load(patientsGridXML + "?etc=" + new Date().getTime(), patientsGridCallback );
    
    //loadStruct Menu for Window
    patientsWinMenu.loadStruct(patientsWinMenuXML + "?etc=" + new Date().getTime());

    //loadStruct Form
    patientsForm.loadStruct(patientsFormXML + "?etc=" + new Date().getTime(), patientsFormCallback);
    
/* END LOADS  */
	
/* FUNCTIONS: 
    * 1. Seccion callback, funciones de segundo orden.
    * 2. Seccion de funciones de apoyo o de ayuda.  */
   
   /* funcion callback que maneja la carga de la estructura del menu */
   function patientsMenuCallback(){
       
        /* Se obtiene valores de los userData del menu */
        formHeader          = patientsMenu.getUserData("sp4","headerForm");
        noteDetailText      = patientsMenu.getUserData("sp4","noteDetailText");
        noteAddText         = patientsMenu.getUserData("sp4","noteAddText");
        noteEditText        = patientsMenu.getUserData("sp4","noteEditText");
        removeConfirmTitle  = patientsMenu.getUserData("sp4","removeConfirmTitle");
        removeConfirmText   = patientsMenu.getUserData("sp4","removeConfirmText");
        okButton            = patientsMenu.getUserData("sp4","okButton");
        cancelButton        = patientsMenu.getUserData("sp4","cancelButton");
        
   }//fin funcion patientsMenuCallback
   
   /* funcion callback que maneja la carga de la estructura de la grilla */
   function patientsGridCallback(){
       
        if( firstTime ){
            /* Carga la Data */
            patientsGrid.load( patientsGridLoad + "?etc=" + new Date().getTime(), patientsGridDataCallback ); 
         }else{
            badReturn = "";
            /* Limpia y Carga la Data */
            patientsGrid.clearAndLoad( patientsGridLoad + "?etc=" + new Date().getTime(), patientsGridDataCallback );
         }
         
   }//fin funcion patientsGridCallback
   
   /* funcion callback que manipula la Data de la Grilla */
   function patientsGridDataCallback(){
       
        /* obtiene el numero de filas */
        var rowNum = patientsGrid.getRowsNum();
        
        /* si se cargaron filas ,
         * comprobar para ver si todavia existe la fila seleccionada previamente, si es asi, 
         * seleccionelo ( selectedRow se inicializa a "").
         * si ninguna fila es seleccionada previamente , seleccione la primera de ellas. */
        if (rowNum) {
            
            var oldSelectedRow	= selectedRow;	//row we are going to reselect, if it exists
            selectedRow 	= patientsGrid.getRowId(0);

            if ( oldSelectedRow != "" ) {
                var searchResult = patientsGrid.findCell( oldSelectedRow, patientsUUIDCol,true );		//findRow wi
                if (searchResult.length) {
                    var searchArray = searchResult[0];
                    selectedRow = searchArray[0];
                }
            }
            
            patientsGrid.selectRowById(selectedRow,false,true,true);
            patientsGrid.showRow( selectedRow );   
        }
       
   }//fin funcion patientsGridDataCallback
   
   /* funcion callback que maneja la carga de la estructura de la Forma */
   function patientsFormCallback(){
       
       //Se obtiene un backup de la estructura sin datos para agregar pacientes.
       patientsAddFormBackup  = patientsForm.saveBackup();
       
   }//fin funcion patientsFormCallback
   
   /* funcion que configura los botones del menu */
   function patientsMenuButtonSetup(){
       
        //deshabilita todos los botones
        patientsMenu.setItemDisabled("addPatients");
        patientsMenu.setItemDisabled("editPatients");
        patientsMenu.setItemDisabled("removePatients");
        patientsMenu.setItemDisabled("viewDetail");
        patientsWinMenu.setItemDisabled("editPatients");
        patientsWinMenu.setItemDisabled("removePatients");
        
        /* Procesos que conllevan a tener los botones del menus deshabilitados estos son:
         * 1. Formulario esta en estado de Edicion de Paciente.
         * 2. Formulario esta en proceso de Agregar Pacientes. */
        if( canChangeForm || isAdding ){
            return true;
        }
        
        patientsMenu.setItemEnabled("addPatients");
        patientsMenu.setItemEnabled("editPatients");
        patientsMenu.setItemEnabled("removePatients");
        patientsMenu.setItemEnabled("viewDetail");
        patientsWinMenu.setItemEnabled("editPatients");
        patientsWinMenu.setItemEnabled("removePatients");
        
        //Configurar Nota
        messageNoteSetup();
        
   }//fin funcion patientsMenuButtonSetup
   
   /* funcion encargada de configurar el mensaje de apoyo segun
    * el proceso en que se esta actualmente.
    * Nota para:
    * 1. Boton Ver Detalle.
    * 2. Boton Editar Paciente.
    * 3. Boton Agregar Paciente. */
   function messageNoteSetup(){
       
       var noteText     = noteDetailText; // por defecto nota del boton Ver Detalle

       //Si esta el formulario esta en edicion
       if( canChangeForm ){
           noteText = noteEditText;
           if( isAdding ){
                noteText = noteAddText;
           }
       }//fin condicion
       
        //Nota, que informa al usuario sobre el boton Ver Detalle.
        dhtmlx.message({
                text: noteText, //nota
                expire: 6000    //tiempo que dura la nota.
        });//fin dhtmlx.message
       
   }//fin funcion messageNoteSetup
   
   /* funcion que informa y pregunta al usuario si quiere
    * Eliminar o Desactivar al paciente seleccionado. */
   function removePatientsDialog(){
        dhtmlx.confirm({
             type: "confirm-warning",
             title: removeConfirmTitle,
             text:  removeConfirmTextSetup,
             ok: okButton,
             cancel: cancelButton,
             callback: function(res) {
                //codigo remover
             }
         });
   }//fin funcion removePatientsDialog
   
   /* funcion encargada de crear la ventana que despliega o que contiene
    * el formulario con la informacion en detalle del paciente seleccionado. */
   function createFormWindow(){
       
        //Obtiene los tamaños del layout principal pacientes(PatientsLayout).
        var xWin        = patientsLayout.base.offsetLeft;
        var yWin        = patientsLayout.base.offsetTop;
        var heightWin   = patientsLayout.base.offsetHeight;
        var widthWin    = patientsLayout.base.offsetWidth;

        //Se configura la dimension de la ventana con respecto al layout principal
        patientsFormWindow.show();
        patientsFormWindow.setDimension( widthWin , heightWin );
        patientsFormWindow.setPosition( xWin , yWin );
        patientsFormWindow.setText( formHeader );       //Header de la forma pacientes.
        patientsFormWindow.button("minmax1").hide();    //Esconder el boton maximizar ventana.
        patientsFormWindow.button("park").hide();       //Esconder el boton minimizar ventana.
        patientsFormWindow.denyMove();                  //deshabilitar opcion de mover la ventana.                   
        patientsFormWindow.denyResize();                //deshabilitar opcion de ajuste de tamaño de ventana.

   }//fin de la funcion createFormWindow
    
/* END FUNCTIONS */	

}//fin funcion init 
</script>
</head>
<body>
    <div id="patientsLayoutDiv" style="position: fixed; height: 98%; width: 99%;"></div>
</body>
</html>