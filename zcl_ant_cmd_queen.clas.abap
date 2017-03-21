CLASS zcl_ant_cmd_queen DEFINITION
  PUBLIC
  INHERITING FROM zcl_ant_cmd_general
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
*"* public components of class ZCL_ANT_CMD_QUEEN
*"* do not include other source files here!!!

    METHODS spawn_worker
      RAISING
        zcx_ants .
  PROTECTED SECTION.
*"* protected components of class ZCL_ANT_CMD_QUEEN
*"* do not include other source files here!!!
  PRIVATE SECTION.
*"* private components of class ZCL_ANT_CMD_QUEEN
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_ANT_CMD_QUEEN IMPLEMENTATION.


  METHOD spawn_worker.

* todo

    turn_done( ).

  ENDMETHOD.
ENDCLASS.
