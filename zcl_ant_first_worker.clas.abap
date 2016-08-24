CLASS zcl_ant_first_worker DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
*"* public components of class ZCL_ANT_FIRST_WORKER
*"* do not include other source files here!!!

    INTERFACES zif_ant_worker .
  PROTECTED SECTION.
*"* protected components of class ZCL_ANT_FIRST_WORKER
*"* do not include other source files here!!!
  PRIVATE SECTION.
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