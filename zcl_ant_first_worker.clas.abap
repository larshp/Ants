class ZCL_ANT_FIRST_WORKER definition
  public
  final
  create public .

public section.
*"* public components of class ZCL_ANT_FIRST_WORKER
*"* do not include other source files here!!!

  interfaces ZIF_ANT_WORKER .
protected section.
*"* protected components of class ZCL_ANT_FIRST_WORKER
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_ANT_FIRST_WORKER
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_ANT_FIRST_WORKER IMPLEMENTATION.


METHOD zif_ant_worker~tick.

  DATA: lv_direction TYPE zcl_ants=>ty_direction.


  lv_direction = ( sy-uzeit+5(1) MOD 7 ) + 1.

  io_cmd->move( lv_direction ).

ENDMETHOD.
ENDCLASS.