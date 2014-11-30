class ZCL_ANT_CMD_QUEEN definition
  public
  inheriting from ZCL_ANT_CMD_GENERAL
  final
  create public .

public section.
*"* public components of class ZCL_ANT_CMD_QUEEN
*"* do not include other source files here!!!

  methods SPAWN_WORKER
    raising
      ZCX_ANTS .
protected section.
*"* protected components of class ZCL_ANT_CMD_QUEEN
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_ANT_CMD_QUEEN
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_ANT_CMD_QUEEN IMPLEMENTATION.


METHOD spawn_worker.

* todo

  turn_done( ).

ENDMETHOD.
ENDCLASS.