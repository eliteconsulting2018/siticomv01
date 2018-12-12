<?php
//Activamos el almacenamiento en el buffer
ob_start();
session_start();

if (!isset($_SESSION["nombre"]))
{
  header("Location: login.html");
}
else
{
require 'header.php';

if ($_SESSION['compras']==1)
{
?>
<!--Contenido-->
      <!-- Content Wrapper. Contains page content -->
      <div id="contenedor_principal" class="content-wrapper">
        <!-- Main content -->

        <section class="content">
          <div class="box box-success">
            <div class="box-header with-border">

              <button class="btn btn-warning" id="btnagregar" onclick="mostrarform(true)"><i class="fa fa-plus"></i> REPONER STOCK</button></br></br>

              <h3 class="box-title"><i class="fa fa-fw fa-check-circle"></i>Abastecimiento de productos para Almacenes y Puntos de venta</h3>


              <div class="box-tools pull-right">
                <button type="button" class="btn btn-box-tool" data-widget="collapse" data-toggle="tooltip" title="" data-original-title="Collapse">
                  <i class="fa fa-minus"></i></button>
                <button type="button" class="btn btn-box-tool" data-widget="remove" data-toggle="tooltip" title="" data-original-title="Remove">
                  <i class="fa fa-times"></i></button>
              </div>
            </div>
            <div class="box-body" style="border-top: #222d3233 2.1px solid;">
              <div class="row">
                  <div class="col-md-12">
                    <!-- /.box-header -->
                    <!-- centro -->
                    <div class="panel-body table-responsive" id="listadoregistros">
                        <table id="tbllistado" class="table table-striped table-bordered table-condensed table-hover">
                          <thead>
                            <th>Opciones</th>
                            <th>Fecha</th>
                            <th>Proveedor</th>
                            <th>Usuario</th>
                            <th>Documento</th>
                            <th>Numero</th>
                            <th>Total Compra</th>
                            <th>Estado</th>
                          </thead>
                          <tbody>
                          </tbody>
                          <tfoot>
                            <th>Opciones</th>
                            <th>Fecha</th>
                            <th>Proveedor</th>
                            <th>Usuario</th>
                            <th>Documento</th>
                            <th>Numero</th>
                            <th>Total Compra</th>
                            <th>Estado</th>
                          </tfoot>
                        </table>
                    </div>
                    <div class="panel-body" id="formularioregistros">
                      <!-- <h1 style="margin-top:-20px; padding-bottom:15px; font-size: 30px;font-family: 'Source Sans Pro','Helvetica Neue',Helvetica,Arial,sans-serif;">Ingreso</h1> -->
                        <form name="formulario" id="formulario" method="POST" action="#">

                          <div class="form-group col-lg-4 col-md-4 col-sm-4 col-xs-12">
                            <label>Proovedor(*):</label>
                            <input type="hidden" name="idingreso" id="idingreso">
                            <select id="idproveedor" name="idproveedor" class="form-control selectpicker" data-live-search="true" required>
                            </select>
                          </div>

                          <div class="form-group col-lg-4 col-md-4 col-sm-4 col-xs-12">
                            <label>Colocar producto en:</label>
                            <select id="idalmacen" name="idalmacen" class="form-control selectpicker" data-live-search="true" required>
                            </select>
                          </div>

                           <div class="form-group col-lg-4 col-md-4 col-sm-4 col-xs-12">
                            <label>Fecha(*):</label>
                            <input type="date" class="form-control" name="fecha_hora" id="fecha_hora" required>
                          </div>

                          <div class="form-group col-lg-6 col-md-6 col-sm-6 col-xs-12">
                            <label>Tipo Comprobante(*):</label>
                            <select name="tipo_comprobante" id="tipo_comprobante" class="form-control selectpicker" required="">
                               <option value="Boleta">Boleta</option>
                               <option value="Factura">Factura</option>
                               <option value="Ticket">Ticket</option>
                               <option value="Otros">Otros</option>
                            </select>
                          </div>

                          <div class="form-group col-lg-2 col-md-2 col-sm-6 col-xs-12">
                            <label>Serie:</label>
                            <input type="text" class="form-control" name="serie_comprobante" id="serie_comprobante" maxlength="7" placeholder="Serie">
                          </div>

                          <div class="form-group col-lg-2 col-md-2 col-sm-6 col-xs-12">
                            <label>Número:</label>
                            <input type="text" class="form-control" name="num_comprobante" id="num_comprobante" maxlength="10" placeholder="Número">
                          </div>


                          <div class="form-group col-lg-2 col-md-2 col-sm-6 col-xs-12">
                            <label>Impuesto:</label>
                            <input type="text" class="form-control" name="impuesto" id="impuesto" >
                          </div>

                          <div class="form-group col-lg-12 col-md-12 col-sm-6 col-xs-12">
                            <a data-toggle="modal" href="#myModal">
                              <button id="btnAgregarArt" type="button" class="btn btn-warning"> <span class="fa fa-plus"></span> Seleccionar Producto</button>
                            </a>
                          </div>

                        <!-- <div class="form-group col-md-4 col-md-offset-0">
                                <div id="content">
                                      <label for="key">Busqueda sensitiva de productos: </label>
                                      <div class="input-group stylish-input-group">
                                        <span id="refresh_autocomplete" class="input-group-addon">
                                            <button type="button" onclick="refresh_auto(event);" data-toggle="tooltip" data-placement="bottom" title="Actualizar">

                                                <span class="fa fa-refresh"></span>
                                            </button>
                                        </span>
                                          <input class="search_query form-control" type="text" id="autocomplete" autocomplete="off" placeholder="Buscar Producto...">
                                          <span class="input-group-addon">
                                            <a style="color:white;" data-toggle="modal" href="#myModal">
                                              <button data-toggle="tooltip" data-placement="right" title="Buscar Productos similares">
                                                  <span class="fa fa-search"></span> Similares
                                              </button>
                                              </a>
                                          </span>
                                      </div>
                                  
                                </div>
                          </div> -->
<!-- <div id="suggestions"></div> -->
                          <div class="col-lg-12 col-sm-12 col-md-12 col-xs-12">
                              <div class="box-body table-responsive no-padding">
                                <table id="detalles" class="table table-striped table-bordered table-condensed table-hover">
                                  <thead style="background-color:#222d3287; color:white;">
                                        <th>Opciones</th>
                                        <th>Producto</th>
                                        <th>Cantidad</th>
                                        <th>Importe Total</th>
                                        <th>Precio Compra (u)</th>
                                        <th>Precio Venta (u)</th>
                                        <th>Ganancia %</th>
                                        <th>Ganancia Neta</th>
                                        <th>Subtotal</th>
                                    </thead>

                                    <tfoot>
                                        <th></th>
                                        <th></th>
                                        <th></th>
                                        <th></th>
                                        <th></th>
                                        <th></th>
                                        <th></th>
                                        <th id="total_estilo">TOTAL</th>
                                        <th><h4 id="total">S/. 0.00</h4><input type="hidden" name="total_compra" id="total_compra"></th>
                                    </tfoot>
                                    <tbody>
                                  <!-- AQUI IRA EL CUERPO DE DATATABLE -->
                                    </tbody>
                                </table>
                              </div>
                          </div>


                          <div class="form-group col-lg-12 col-md-12 col-sm-12 col-xs-12">
                            <button class="btn btn-info" type="submit" id="btnGuardar"><i class="fa fa-save"></i> Guardar</button>

                            <button id="btnCancelar" class="btn btn-danger" onclick="cancelarform()" type="button"><i class="fa fa-arrow-circle-left"></i>Cancelar</button>
                          </div>

                        </form>
                    </div>
                  </div>
                </div>
            </div>
            <!-- /.box-body -->
            <div class="box-footer" style="">

            </div>
            <!-- /.box-footer-->
          </div>
      </section><!-- /.content -->
    </div><!-- /.content-wrapper -->
  <!--Fin-Contenido-->


    <!-- Modal -->
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog" style="width: 950px">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4 class="modal-title">Seleccione un Producto</h4>
          </div>
          <div class="modal-body">
            <table id="tblproductos" class="table table-striped table-bordered table-condensed table-hover">
              <thead>
                <th>Opciones</th>
                <th>Codigo</th>
                <th>Nombre</th>
                <th>Descripcion</th>
                <th>Categoria</th>
                <th>Talla</th>
                <th>Imagen</th>
              </thead>
              <tbody>
              </tbody>
              <tfoot>
                <th>Opciones</th>
                <th>Codigo</th>
                <th>Nombre</th>
                <th>Descripcion</th>
                <th>Categoria</th>
                <th>Talla</th>
                <th>Imagen</th>
              <tfoot>
            </table>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
          </div>
        </div>
      </div>
    </div>
    <!-- Fin modal -->
  <?php
  }
  else
  {
    require 'noacceso.php';
  }

  require 'footer.php';
  ?>
  <script type="text/javascript" src="scripts/ingreso.js"></script>

  <?php
  }
  ob_end_flush();
  ?>
