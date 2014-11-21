class ZCL_ANT_CMD_WORKER definition
  public
  inheriting from ZCL_ANT_CMD_GENERAL
  final
  create public .

public section.
*"* public components of class ZCL_ANT_CMD_WORKER
*"* do not include other source files here!!!

  methods PICK_UP .
  methods DROP .
  methods ATTACK .
protected section.
*"* protected components of class ZCL_ANT_CMD_WORKER
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_ANT_CMD_WORKER
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_ANT_CMD_WORKER IMPLEMENTATION.


method ATTACK.
endmethod.


method DROP.
endmethod.


method PICK_UP.
endmethod.
ENDCLASS.