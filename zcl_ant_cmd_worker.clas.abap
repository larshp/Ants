class ZCL_ANT_CMD_WORKER definition
  public
  inheriting from ZCL_ANT_CMD_GENERAL
  final
  create public .

public section.
*"* public components of class ZCL_ANT_CMD_WORKER
*"* do not include other source files here!!!

  methods PICK_UP
    raising
      ZCX_ANTS .
  methods DROP
    raising
      ZCX_ANTS .
  methods ATTACK
    raising
      ZCX_ANTS .
protected section.
*"* protected components of class ZCL_ANT_CMD_WORKER
*"* do not include other source files here!!!
private section.
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