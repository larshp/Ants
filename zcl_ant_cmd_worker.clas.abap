CLASS zcl_ant_cmd_worker DEFINITION
  PUBLIC
  INHERITING FROM zcl_ant_cmd_general
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
*"* public components of class ZCL_ANT_CMD_WORKER
*"* do not include other source files here!!!

    METHODS pick_up
      RAISING
        zcx_ants .
    METHODS drop
      RAISING
        zcx_ants .
    METHODS attack
      RAISING
        zcx_ants .
  PROTECTED SECTION.
*"* protected components of class ZCL_ANT_CMD_WORKER
*"* do not include other source files here!!!
  PRIVATE SECTION.
*"* private components of class ZCL_ANT_CMD_WORKER
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_ANT_CMD_WORKER IMPLEMENTATION.


  METHOD attack.

* todo

    turn_done( ).

  ENDMETHOD.


  METHOD drop.

* todo

    turn_done( ).

  ENDMETHOD.


  METHOD pick_up.

* todo

    turn_done( ).

  ENDMETHOD.
ENDCLASS.
