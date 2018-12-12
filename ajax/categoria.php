<?php
require_once "../modelos/Categoria.php";

$categoria=new Categoria();

$idcategoria=isset($_POST["idcategoria"])? limpiarCadena($_POST["idcategoria"]):"";
$nombre=isset($_POST["nombre"])? limpiarCadena($_POST["nombre"]):"";
$descripcion=isset($_POST["descripcion"])? limpiarCadena($_POST["descripcion"]):"";

switch ($_GET["op"]){
	case 'guardaryeditar':
		if (empty($idcategoria)){
			$rspta=$categoria->insertar($nombre,$descripcion);
			echo $rspta ? "Categoria registrada" : "Categoria no se pudo registrar";
		}
		else {
			$rspta=$categoria->editar($idcategoria,$nombre,$descripcion);
			echo $rspta ? "Categoria actualizada" : "Categoria no se pudo actualizar";
		}
	break;

	case 'desactivar':
		$rspta=$categoria->desactivar($idcategoria);
		echo $rspta ? "Categoria Desactivada" : "Categoria no se puede desactivar";
    break;

    case 'activar':
		$rspta=$categoria->activar($idcategoria);
		echo $rspta ? "Categoria activada" : "Categoria no se puede activar";
    break;

    case 'mostrar':
		$rspta=$categoria->mostrar($idcategoria);
		//codificar el resultado utilizando json
		echo json_encode($rspta);
    break;

    case 'listar':
		$rspta=$categoria->listar();
		//Vamos a declarar un Array
		$data= Array();

		while ($reg=$rspta->fetch_object()) {
			$data[]=array(
				"0"=>($reg->condicion)?'<button class="btn btn-success btn-sm" onclick="mostrar('.$reg->idcategoria.')"><i class="fa fa-pencil"></i></button>'.
				' <button class="btn btn-danger btn-sm" onclick="desactivar('.$reg->idcategoria.')"><i class="fa fa-close"></i></button>' :  '<button class="btn btn-success btn-sm" onclick="mostrar('.$reg->idcategoria.')"><i class="fa fa-pencil"></i></button>'.
				' <button class="btn btn-warning btn-sm" onclick="activar('.$reg->idcategoria.')"><i class="fa fa-check"></i></button>',
				"1"=>'<span style="letter-spacing: 0.5px; font-weight: bold; text-transform: uppercase;">'.$reg->nombre.'</span>',
				"2"=>$reg->descripcion,
				"3"=>($reg->condicion)?'<span class="label bg-olive">Activado</span>' :  '<span class="label bg-red">Desactivado</span>'
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
