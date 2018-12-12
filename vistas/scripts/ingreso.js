var tabla;

//Función que se ejecuta al inicio
function init(){

	mostrarform(false);
	listar();
	// autocompletejquery();

	$(document).ready(function() {

			$('input.global_filter').on( 'keyup click', function () {
					filterGlobal();
			} );

			$('input.column_filter').on( 'keyup click', function () {
					filterColumn( $(this).parents('div').attr('data-column') );
			} );
	} );

	$("#formulario").on("submit",function(e)
	{
		e.preventDefault();
		guardaryeditar(e);
	});


	//Cargamos los items al select proveedor
	$.post("../ajax/ingreso.php?op=selectProveedor", function(r){
	            $("#idproveedor").html(r);
	            $('#idproveedor').selectpicker('refresh');
	});

	//Cargamos los items al select Almacen
	$.post("../ajax/ingreso.php?op=selectAlmacen", function(r){
							$("#idalmacen").html(r);
							$('#idalmacen').selectpicker('refresh');
	});

}

function refresh_auto(event){

event.preventDefault();
		$('#autocomplete').val('');
		$('#autocomplete').focus();
}


//
// function autocompletejquery()
// {
//
//  // Single Select
//  $( "#autocomplete" ).autocomplete({
//
//   source: function( request, response ) {
//    // Fetch data
//    $.ajax({
//     url: "../ajax/ingreso.php?op=select_producto_autocompletev2",
//     type: 'post',
//     dataType: "json",
//     data: {
//
//      search: request.term
//     },
//     success: function( data ) {
//      response( data );
//     }
//    });
//   },
//   select: function (event, ui) {
//    // Set selection
//    $('#autocomplete').val(ui.item.nombreproductojson); // display the selected text
// 	 var idproducto = ui.item.idproductojson;
// 	 var producto = ui.item.nombreproductojson;
// 	 var cantidad=1;
// 	 var precio_compra=1;
// 	 var precio_venta=1;
//
// 	 if (idproducto!="")
// 	 {
// 		 var subtotal=cantidad*precio_compra;
// 		 var fila='<tr class="filas" id="fila'+cont+'">'+
// 		 '<td><button type="button" class="btn btn-danger" onclick="eliminarDetalle('+cont+')">X</button></td>'+
// 		 '<td><input type="hidden" name="idproducto[]" value="'+idproducto+'">'+producto+'</td>'+
// 		 '<td><input type="number" name="cantidad[]" id="cantidad[]" value="'+cantidad+'"></td>'+
// 		 '<td><input type="number" step=".01" name="precio_compra[]" id="precio_compra[]" value="'+precio_compra+'"></td>'+
// 		 '<td><input type="number" step=".01" name="precio_venta[]" value="'+precio_venta+'"></td>'+
// 		 '<td><span name="subtotal" id="subtotal'+cont+'">'+subtotal+'</span></td>'+
// 		 '<td><button type="button" onclick="modificarSubototales()" class="btn btn-info"><i class="fa fa-refresh"></i></button></td>'+
// 		 '</tr>';
// 		 cont++;
// 		 detalles=detalles+1;
// 		 $('#detalles').append(fila);
// 		 modificarSubototales();
// 	 }
// 	 else
// 	 {
// 		 alert("Error al ingresar el detalle, revisar los datos del producto");
// 	 }
//
//
//    return false;
//   }
//  });
//
// }

//Función limpiar
function limpiar(){

	$("#idproveedor").val("");
	$("#idingreso").val("");
	$("#serie_comprobante").val("");
	$("#num_comprobante").val("");
	// $("#impuesto").val("0");

	$("#total_compra").val("");
	$(".filas").remove();
	$("#total").html("0");

	//Obtenemos la fecha actual
	var now = new Date();
	var day = ("0" + now.getDate()).slice(-2);
	var month = ("0" + (now.getMonth() + 1)).slice(-2);
	var today = now.getFullYear()+"-"+(month)+"-"+(day) ;
    $('#fecha_hora').val(today);

    //Marcamos el primer tipo_documento
    $("#tipo_comprobante").val("Boleta");
	$("#tipo_comprobante").selectpicker('refresh');
}

//Función mostrar formulario
function mostrarform(flag){
	limpiar();
	if (flag)
	{
		$(document).ready(function(){
				$('#serie_comprobante').focus();
		});
		$('#idproveedor').val('Publico General');
		$("#idproveedor").selectpicker('refresh');
		$("#listadoregistros").hide();
		$("#formularioregistros").show();
		// $("#btnGuardar").prop("disabled",false);
		$("#btnagregar").hide();
		listarProductos();

		$("#btnGuardar").hide();
		$("#btnCancelar").show();
		detalles=0;
		$("#btnAgregarArt").show();
	}
	else
	{
		$("#listadoregistros").show();
		$("#formularioregistros").hide();
		$("#btnagregar").show();
	}
}

//Funcion cancelarform
function cancelarform(){
	limpiar();
	mostrarform(false);
	// $("#btnagregar").prop("disabled",false);
	// $("#btnagregar").show();
}

//Funcion listar
function listar(){
	tabla=$('#tbllistado').dataTable(
		{
				"aProcessing": true, //Activamos el procesamiento del datatables
				"aServerSide": true, //Paginacion y filtrado realizados por el servidor
				dom: 'Bfrtip',         //Definimos los elementos del control de tabla
				buttons: [
						'copyHtml5',
						'excelHtml5',
						'csvHtml5',
						'pdf'
			],
	"ajax":
			{
				url: '../ajax/ingreso.php?op=listar',
				type : "get",
				dataType : "json",
				error: function(e){
					console.log(e.responseText);
				}
			},
		"bDestroy": true,
		"iDisplayLength": 5, //Paginación
	    "order": [[ 0, "desc" ]] //Ordenar (columna,orden)
	}).DataTable();
	$("#tbllistado_filter input").focus();
}

//Función ListarProductos
function listarProductos(){
	tabla=$('#tblproductos').dataTable(
	{


		"aProcessing": true,//Activamos el procesamiento del datatables
	   "aServerSide": true,//Paginación y filtrado realizados por el servidor
	    dom: 'Brtip',//Definimos los elementos del control de tabla
	    buttons: [

		        ],
		"ajax":
				{
					url: '../ajax/ingreso.php?op=listarProductos',
					type : "get",
					dataType : "json",
					error: function(e){
						console.log(e.responseText);
					}
				},

			// 	"scrollY":        "430px",
			// "scrollCollapse": true,
			// "paging":         false
		"bDestroy": true,
		"iDisplayLength": 5,//Paginación
	    "order": [[ 0, "desc" ]]//Ordenar (columna,orden)
	}).DataTable();

	$('#myModal').on('shown.bs.modal', function () {
		$('#filter_global input').focus();
		$('#filter_global input').val("");
		$('#filter_col3 input').val("");
		$('#filter_col5 input').val("");
	});
}

//Funcion para guardar o editar

function guardaryeditar(e){
	e.preventDefault(); //No se activara la accion predeterminada del evento
	//$("#btnGuardar").prop("disabled",true);
	var formData = new FormData($("#formulario")[0]);

	$.ajax({
		url: "../ajax/ingreso.php?op=guardaryeditar",
		type: "POST",
		data: formData,
		contentType: false,
		processData: false,

		success: function(datos)
		{
			swal(
		(datos),
		'Satisfactoriamente!',
		'success'
		);
			mostrarform(false);
			listar();
		}

	});
	// $("#btnagregar").show();
	limpiar();
}

function mostrar(idingreso){

	//$("#btnagregar").hide();
	$.post("../ajax/ingreso.php?op=mostrar",{idingreso : idingreso}, function(data, status)
	{
		data = JSON.parse(data);
		mostrarform(true);

		$("#idproveedor").val(data.idproveedor);
		$("#idproveedor").selectpicker('refresh');
		$("#tipo_comprobante").val(data.tipo_comprobante);
		$("#tipo_comprobante").selectpicker('refresh');
		$("#serie_comprobante").val(data.serie_comprobante);
		$("#num_comprobante").val(data.num_comprobante);
		$("#fecha_hora").val(data.fecha);
		$("#impuesto").val(data.impuesto);
		$("#idingreso").val(data.idingreso);

		//Ocultar y mostrar los botones
		$("#btnGuardar").hide();
		$("#btnCancelar").show();
		$("#btnAgregarArt").hide();
	});

	$.post("../ajax/ingreso.php?op=listarDetalle&id="+idingreso,function(r){
					$("#detalles").html(r);
	});
}

//Funcion para desactivar registros
function anular(idingreso){
	swal({
	  title: '¿Está seguro de anular el ingreso?',
		imageUrl: 'http://img.freepik.com/vector-gratis/trabajador-con-dudas_1012-193.jpg?size=338&ext=jpg',
		imageWidth: 250,
		imageHeight: 250,
		animation: false,
	  showCancelButton: true,
	  confirmButtonColor: '#00c0ef',
	  cancelButtonColor: '#d33',
	  confirmButtonText: 'Deacuerdo',
		cancelButtonText: 'Cancelar'
	}).then(function (e) {
		$.post("../ajax/ingreso.php?op=anular", {idingreso : idingreso}, function(e){
			swal(
  		(e),
  		'Satisfactoriamente!',
  		'success'
)
			tabla.ajax.reload(null,false);

		});
	})
}

// //Declaración de variables necesarias para trabajar con las compras y
// //sus detalles
var impuesto=18;
var cont=0;
var detalles=0;

// $("#guardar").hide();
$("#btnGuardar").hide();
// $("#btnGuardar").hide();
$("#tipo_comprobante").change(marcarImpuesto);

function marcarImpuesto()
  {
  	var tipo_comprobante=$("#tipo_comprobante option:selected").text();
  	if (tipo_comprobante=='Factura')
    {
        $("#impuesto").val(impuesto);
    }
    else
    {
        $("#impuesto").val("0");
    }
  }


	function agregarDetalle(idproducto,producto)
	{

			var idproducto_ubicacion ="";
	  	var cantidad=1;
			var valor1=100;
			var valor2=100;
	    var precio_compra=0.00;
	    var precio_venta=0.00;
			var ganancia = 0;
			var ganancianeta = 1;
				var importe=0;
	    if (idproducto!="")
	    {
	    	var subtotal;

	    	var fila='<tr class="filas" id="fila'+cont+'">'+
	    	'<td><button type="button" class="btn btn-danger" onclick="eliminarDetalle('+cont+')">X</button></td>'+
	    	'<td><input class="form-control" type="hidden" name="idproducto[]" value="'+idproducto+'">'+producto+'</td>'+
	    	'<td style="width: 10%;"><input class="form-control" type="number" name="cantidad[]" id="cantidad" onchange="modificarSubototales()" onkeyup="modificarSubototales()" onblur="onBlur(this)" onfocus="onFocus(this)"  oninput="validaLength(this)" maxlength="4" min="1" max="10000" value="'+cantidad+'" required=""></td>'+
				'<td><span class="input-symbol-euro"><input class="form-control" type="number" step=".01" min="1" max="100000" onchange="calculacompraunitaria()" onkeyup="calculacompraunitaria()" onblur="onBlur(this)" onfocus="onFocus(this)" id="importe" name="importe[]" placeholder="0.00" value="'+importe+'"></span></td>'+
				'<td><span class="input-symbol-euro"><input class="form-control" type="number" step=".01" min="1" max="100000" onchange="calculaimporte()" onkeyup="calculaimporte()" onblur="onBlur(this)" onfocus="onFocus(this)" id="precio_compra" name="precio_compra[]" value="'+precio_compra+'"></span></td>'+
	    	// '<td><input class="form-control" type="number" step=".01" min="1" max="100000" onchange="calculaganancia()" id="precio_venta" name="precio_venta[]" value="'+precio_venta+'"></td>'+
				'<td><span class="input-symbol-euro"><input class="form-control" type="number" step="0.01" min="0.00" max="10000.00" onchange="calculaganancia()" onblur="onBlur(this)" onfocus="onFocus(this)" id="precio_venta" name="precio_venta[]" value="'+precio_venta+'"></span></td>'+
				'<td><span class="valuePadding input-holder"><input type="number" onblur="onBlur(this)" onfocus="onFocus(this)" accuracy="2" min="0" name="gananciaporcentaje[]" value="'+ganancia+'" style="text-align:left;"></span></td>'+
				'<td style="width: 10%;"><span class="input-symbol-euro"><input class="form-control" type="number" onblur="onBlur(this)" onfocus="onFocus(this)" step=".01" min="1" max="100000" name="ganancianeta[]" value="'+ganancianeta+'"></span></td>'+
	    	'<td style="width: 10%;"><center><span name="subtotal" id="subtotal'+cont+'">'+subtotal+'</span></center></td>'+
      	'<td><button type="button" onclick="modificarSubototales()" class="btn btn-info"><i class="fa fa-refresh"></i></button></td>'+
				'<td id="p_none"><input  type="hidden" name="valor1[]" value="'+valor1+'"></td>'+
				'<td id="p_none"><input  type="hidden" name="valor2[]" value="'+valor2+'"></td>'+
				'</tr>';
	    	cont++;
	    	detalles=detalles+1;

	    	$('#detalles').append(fila);
	    	modificarSubototales();

	    }
	    else
	    {
	    	alert("Error al ingresar el detalle, revisar los datos del producto");
	    }
	 }

	 /*---------------------------------------------------*
 	|FUNCION PARA LIMPIAR CAMPOS DETALLE VENTA AL INICIAR|
 	.---------------------------------------------------*/
 	function onBlur(el) {
 	    if (el.value == '') {
 	        el.value = el.defaultValue;
 	    }
 	}
 	function onFocus(el) {
 	    if (el.value == el.defaultValue) {
 	        el.value = '';
 	    }
 	}

	 /*---------------------------------------------------*
	 |FUNCION PARA VALIDAR EL MAXIMO DE IN INPUT MAXLENGTH|
	 .---------------------------------------------------*/
	 function validaLength(id)
	  {
	    if (id.value.length > id.maxLength)
	      id.value = id.value.slice(0, id.maxLength)
	  }

		//FUNCION PARA CALCULAR IMPORTE
		function calculaimporte(){

			// calculaganancia();

			var cantx = document.getElementsByName("cantidad[]");
			var precx = document.getElementsByName("precio_compra[]");
 			var impox = document.getElementsByName("importe[]");
			var subx = document.getElementsByName("subtotal");
			for (var i = 0; i <cantx.length; i++) {
	 		 var inpCx=cantx[i];
	 		 var inpPx=precx[i];
			 var inpIx=impox[i];
			 var inpSx=subx[i];

	 		inpIx.value= parseFloat(Math.round((inpCx.value * inpPx.value) * 100) / 100).toFixed(2);

			inpSx.value= inpCx.value * inpPx.value;
		  document.getElementsByName("subtotal")[i].innerHTML = "S/. " + parseFloat(Math.round(inpSx.value * 100) / 100).toFixed(2);
	 	 }
		 			calcularTotales();
		}

		//FUNCION PARA CALCULAR GANANCIA
		function calculaganancia(){
			var g_cant = document.getElementsByName("cantidad[]");
			var g_prec = document.getElementsByName("precio_compra[]");
			var g_prev = document.getElementsByName("precio_venta[]");
 			var g_gan = document.getElementsByName("gananciaporcentaje[]");
			var g_gann = document.getElementsByName("ganancianeta[]");
			var g_sub = document.getElementsByName("subtotal");

			var g_val1 = document.getElementsByName("valor1[]");
			var g_val2 = document.getElementsByName("valor2[]");
			for (var i = 0; i <g_cant.length; i++) {
	 		 var inpCant=g_cant[i];
	 		 var inpPrec=g_prec[i];
			 var inpPrev=g_prev[i];
			 var inpGan=g_gan[i];
			 var inpGann=g_gann[i];
			 var inpSub=g_sub[i];

			 var inpVal1=g_val1[i];
			 var inpVal2=g_val2[i];


// parseFloat(Math.round((() * 100) / 100).toFixed(2)

			// (inpPrev.value*100/inpPrec.value)-100;
			inpGann.value = inpPrev.value - inpPrec.value;

			// if (inpGan.value < 0 ) {
			// 	inpGan.style.color="#CC0000";
			// 	inpGan.style.fontWeight="bold";
			// 	inpGann.style.color="#CC0000";
			// 	inpGann.style.fontWeight="bold";
			//
			// 	return false;
			// }else {
			// 	inpGan.style.color="#337ab7";
			// 	inpGan.style.fontWeight="bold";
			// 	inpGann.style.color="#337ab7";
			// 	inpGann.style.fontWeight="bold";
			// }
inpGan.value	= (inpPrev.value*inpVal1.value/inpPrec.value)-inpVal2.value;
// alert(inpGan.value);
	 	 }
		 			// calcularTotales();
		}

		//FUNCION PARA CALCULAR COMPRA UNITARIA
		function calculacompraunitaria(){

				// calculaganancia();

			var cantxy = document.getElementsByName("cantidad[]");
			var precxy = document.getElementsByName("precio_compra[]");
 			var impoxy = document.getElementsByName("importe[]");
			var subxy = document.getElementsByName("subtotal");
			for (var i = 0; i <cantxy.length; i++) {

		 	  var inpCxy=cantxy[i];
		  	var inpPxy=precxy[i];
		 	  var inpIxy=impoxy[i];
		 	  var inpSxy=subxy[i];

			  inpPxy.value = parseFloat(Math.round((inpIxy.value / inpCxy.value) * 100) / 100).toFixed(2);

				inpSxy.value = inpCxy.value * inpPxy.value;
				document.getElementsByName("subtotal")[i].innerHTML = "S/. " + parseFloat(Math.round(inpSxy.value * 100) / 100).toFixed(2);
	 	 }
		 				calcularTotales();
		}


		//FUNCION PARA MODIFICAR SUBTOTALES
		  function modificarSubototales()
		  {
					// calculacompraunitaria();
					calculaimporte();
					// calculaganancia();

		  	var cant = document.getElementsByName("cantidad[]");
		    var precc = document.getElementsByName("precio_compra[]");
				var precv = document.getElementsByName("precio_venta[]");
		    var sub = document.getElementsByName("subtotal");
				var imp = document.getElementsByName("importe[]");
				var gan = document.getElementsByName("gananciaporcentaje[]");
				var gannet = document.getElementsByName("ganancianeta[]");


		    for (var i = 0; i <cant.length; i++) {
		    	var inpC=cant[i];
		    	var inpPc=precc[i];
		    	var inpS=sub[i];

		  		inpS.value=inpC.value * inpPc.value;
		    	document.getElementsByName("subtotal")[i].innerHTML = "S/. " + parseFloat(Math.round(inpS.value * 100) / 100).toFixed(2);
		    }
		    calcularTotales();
		  }




			function calcularTotales(){
				var sub = document.getElementsByName("subtotal");
				var total = 0.0;

				for (var i = 0; i <sub.length; i++) {
				total += document.getElementsByName("subtotal")[i].value;
			}
			total = parseFloat(Math.round(total * 100) / 100).toFixed(2);
			$("#total").html("S/. " + total);
				$("#total_compra").val(total);
				evaluar();
			}

			function evaluar(){
				if (detalles>0)
				{
					$("#btnGuardar").show();
				}
				else
				{
					$("#btnGuardar").hide();
					cont=0;
				}
			}
			function eliminarDetalle(indice){
				$("#fila" + indice).remove();
				calcularTotales();
				detalles=detalles-1;
				evaluar();
			}


																									//***************************
																									//FUNCION PARA FILTRAR todo |
																									//**************************


function filterGlobal () {
$('#tblproductos').DataTable().search(
$('#global_filter').val(),
$('#global_regex').prop('checked'),
$('#global_smart').prop('checked')
).draw();

}


																									//******************************
																									//FUNCION PARA FILTRAR COLUMNAS|
																									//*****************************


function filterColumn ( i ) {

$('#tblproductos').DataTable().column( i ).search(
$('#col'+i+'_filter').val(),
$('#col'+i+'_regex').prop('checked'),
$('#col'+i+'_smart').prop('checked')
).draw();

}




init();
