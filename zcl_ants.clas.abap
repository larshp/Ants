class ZCL_ANTS definition
  public
  final
  create public .

public section.
*"* public components of class ZCL_ANTS
*"* do not include other source files here!!!
protected section.
*"* protected components of class ZCL_ANTS
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_ANTS
*"* do not include other source files here!!!

  methods REGISTER
    importing
      !IV_NAME type STRING
      !IV_QUEEN type SEOCLSNAME
      !IV_WORKER type SEOCLSNAME .
  methods REGISTRATION .
ENDCLASS.



CLASS ZCL_ANTS IMPLEMENTATION.


method REGISTER.
endmethod.


METHOD registration.

  register( iv_name = 'First Ant'
            iv_queen = 'ZCL_ANT_FIRST_QUEEN'
            iv_worker = 'ZCL_ANT_FIRST_WORKER' ).

ENDMETHOD.
ENDCLASS.