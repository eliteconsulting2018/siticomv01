<?php
if (strlen(session_id()) < 1)
  session_start();
require_once "../modelos/Ingreso.php";


$ingreso=new Ingreso();

$idingreso=isset($_POST["idingreso"])? limpiarCadena($_POST["idingreso"]):"";
// $idalmacen=isset($_POST["idalmacen"])? limpiarCadena($_POST["idalmacen"]):"";
$idproveedor=isset($_POST["idproveedor"])? limpiarCadena($_POST["idproveedor"]):"";
$idusuario=$_SESSION["idusuario"];
$tipo_comprobante=isset($_POST["tipo_comprobante"])? limpiarCadena($_POST["tipo_comprobante"]):"";
$serie_comprobante=isset($_POST["serie_comprobante"])? limpiarCadena($_POST["serie_comprobante"]):"";
$num_comprobante=isset($_POST["num_comprobante"])? limpiarCadena($_POST["num_comprobante"]):"";
$fecha_hora=isset($_POST["fecha_hora"])? limpiarCadena($_POST["fecha_hora"]):"";
$impuesto=isset($_POST["impuesto"])? limpiarCadena($_POST["impuesto"]):"";
$total_compra=isset($_POST["total_compra"])? limpiarCadena($_POST["total_compra"]):"";

switch ($_GET["op"]){
	case 'guardaryeditar':
		if (empty($idingreso)){
			$rspta=$ingreso->insertar($idproveedor,$idusuario,$tipo_comprobante,$serie_comprobante,
      $num_comprobante,$fecha_hora,$impuesto,$total_compra,$_POST["idalmacen"],$_POST["idproducto"],$_POST["cantidad"],$_POST["importe"],$_POST["precio_compra"],$_POST["precio_venta"],$_POST["gananciaporcentaje"],$_POST["ganancianeta"]);
			echo $rspta ? "Ingreso registrado" : "No se pudieron registrar todos los datos del ingreso";
		}
		else {
		}
	break;

	case 'anular':
		$rspta=$ingreso->anular($idingreso);
		echo $rspta ? "Ingreso anulado" : "Ingreso no se puede anular";
    break;

  case 'mostrar':
		$rspta=$ingreso->mostrar($idingreso);
		//codificar el resultado utilizando json
		echo json_encode($rspta);
    break;

    case 'listarDetalle':
      //Recibimos el idingreso
      $id=$_GET['id'];

      $rspta = $ingreso->listarDetalle($id);
      $total=0;
      echo '<thead style="background-color:#222d3287; color:white;">
                                      <th>Opciones</th>
                                      <th>Producto</th>
                                      <th>Cantidad</th>
                                      <th>Importe Total</th>
                                      <th>Precio Compra (u)</th>
                                      <th>Precio Venta (u)</th>
                                      <th>Ganancia %</th>
                                      <th>Ganancia Neta</th>
                                      <th>Subtotal</th>
                                  </thead>';





      while ($reg = $rspta->fetch_object())
          {
            echo '<tr class="filas"><td></td><td>'.$reg->nombre.'</td><td>'.$reg->cantidad.'</td><td>'.$reg->importe.'</td><td>'.$reg->precio_compra.'</td><td>'.$reg->precio_venta.'</td><td>'.$reg->gananciaporcentaje.'</td><td>'.$reg->ganancianeta.'</td><td>'.$reg->precio_compra*$reg->cantidad.'</td></tr>';
            $total=$total+($reg->precio_compra*$reg->cantidad);
          }
      echo '<tfoot>
                                      <th>TOTAL</th>
                                      <th></th>
                                      <th></th>
                                      <th></th>
                                      <th></th>
                                      <th></th>
                                      <th></th>
                                      <th></th>
                                      <th><h4 id="total">S/.'.$total.'</h4><input type="hidden" name="total_compra" id="total_compra"></th>
                                  </tfoot>';
    break;

    case 'listar':
		$rspta=$ingreso->listar();
		//Vamos a declarar un Array
		$data= Array();

		while ($reg=$rspta->fetch_object()) {
			$data[]=array(
				"0"=>($reg->estado=='Aceptado')?'<button class="btn btn-warning" onclick="mostrar('.$reg->idingreso.')"><i class="fa fa-eye"></i></button>'.
				' <button class="btn btn-danger" onclick="anular('.$reg->idingreso.')"><i class="fa fa-close"></i></button>' :
        '<button class="btn btn-info" onclick="mostrar('.$reg->idingreso.')"><i class="fa fa-eye"></i></button>',
				"1"=>$reg->fecha,
        "2"=>$reg->proveedor,
        "3"=>$reg->usuario,
				"4"=>$reg->tipo_comprobante,
        "5"=>$reg->serie_comprobante.'-'.$reg->num_comprobante,
        "6"=>$reg->total_compra,
				"7"=>($reg->estado=='Aceptado')?'<span class="label bg-olive">Activado</span>' :  '<span class="label bg-red">Desactivado</span>'
				);
		}
		$results = array(
 			"sEcho"=>1, //Información para el datatables
 			"iTotalRecords"=>count($data), //enviamos el total registros al datatable
 			"iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
 			"aaData"=>$data);
		echo json_encode($results);

	break;

  case 'select_producto_autocomplete':
  require_once "../modelos/Producto.php";

    $html = '';
    $key = $_POST['key'];
    $producto = new Producto();
    $result = $producto->listarautocomplete($key);


    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $html .= '<div><a class="suggest-element" data="'.utf8_encode($row['nombre']).'" id="' .$row['idproducto'].'">'.utf8_encode($row['nombre']). '</a></div>';
        }
    }
    echo $html;

  break;

  case 'select_producto_autocompletev2':
  require_once "../modelos/Producto.php";

  $producto = new Producto();

  if(isset($_POST['search'])){

      $search = $_POST['search'];
      $result = $producto->listarautocomplete($search);

      while($row = mysqli_fetch_array($result) ){
          $response[] = array("value"=>$row['nombre'].', Stock: '.$row['stock'],"nombreproductojson"=>$row['nombre'],"idproductojson"=>$row['idproducto']);
      }

      echo json_encode($response);
  }

  break;

  case 'selectProveedor':
		require_once "../modelos/Persona.php";
		$persona = new Persona();

		$rspta = $persona->listarP();

		while ($reg = $rspta->fetch_object())
				{
				echo '<option value=' . $reg->idpersona . '>' . $reg->nombre . '</option>';
				}
	break;

  case 'selectAlmacen':
    require_once "../modelos/Almacen.php";
    $almacen = new Almacen();

    $rspta = $almacen->select_almacen();

    while ($reg = $rspta->fetch_object())
        {
        echo '<option value=' . $reg->idalmacen . '>' . $reg->nombre . '</option>';
        }
  break;

  case 'listarProductos':
        require_once "../modelos/Producto.php";
        $producto=new Producto();
        $rspta=$producto->listarActivos();
        //Vamos a declarar un array
        $data= Array();
        while ($reg=$rspta->fetch_object()){
          	// $imagentest=(empty($reg->imagen))?"<img src='../files/productos/defaultpro.png' height='55px' width='65px'>":'<img src="../files/productos/'.$reg->imagen.'" height="55px" width="70px" onclick="mostrarclick(this.src)">';
          $data[]=array(
            "0"=>'<button class="btn btn-info" onclick="agregarDetalle('.$reg->idproducto.',\''.limpiarCadena($reg->nombre).'\')"><span class="fa fa-plus"></span></button>',
            "1"=>'<span style="color:#bd0000; font-weight:bold;" class="">'.$reg->codigo.'</span>',
            "2"=>$reg->nombre,
            "3"=>$reg->descripcion,
            "4"=>$reg->categoria,
            "5"=>'<span style="color:#337ab7; font-size:16px; font-weight:bold;" class="">'.$reg->abreviatura.'</span>',
            "6"=>"<img src='../files/productos/".$reg->imagen."' height='50px' width='50px' >"            
            );
        }
        $results = array(
          "sEcho"=>1, //Información para el datatables
          "iTotalRecords"=>count($data), //enviamos el total registros al datatable
          "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
          "aaData"=>$data);
        echo json_encode($results);
    break;

}
?>
