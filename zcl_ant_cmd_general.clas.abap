class ZCL_ANT_CMD_GENERAL definition
  public
  abstract
  create public .

public section.
*"* public components of class ZCL_ANT_CMD_GENERAL
*"* do not include other source files here!!!

  methods CONSTRUCTOR .
  methods MESSAGE .
  methods LOOK .
  class ZCL_ANTS definition load .
  methods MOVE
    importing
      !IV_DIRECTION type ZCL_ANTS=>TY_DIRECTION .
  type-pools ABAP .
  methods IS_FRIENDLY
    returning
      value(RV_FRIENDLY) type ABAP_BOOL .
protected section.
*"* protected components of class ZCL_ANT_CMD_GENERAL
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_ANT_CMD_GENERAL
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_ANT_CMD_GENERAL IMPLEMENTATION.


method CONSTRUCTOR.
endmethod.


METHOD is_friendly.



ENDMETHOD.


METHOD look.




ENDMETHOD.


METHOD message.

* todo

ENDMETHOD.


METHOD move.

  IF iv_direction IS INITIAL.

  ENDIF.

* todo

ENDMETHOD.
ENDCLASS.