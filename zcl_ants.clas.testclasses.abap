
*----------------------------------------------------------------------*
*       CLASS lcl_Test DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_test DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.
* ================

    METHODS: play FOR TESTING RAISING cx_static_check.

ENDCLASS.       "lcl_Test


*----------------------------------------------------------------------*
*       CLASS lcl_Test IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_test IMPLEMENTATION.
* ==============================

  METHOD play.
* ============

    DATA: lo_ants TYPE REF TO zcl_ants.


    CREATE OBJECT lo_ants.

* just check it doesnt dump and no exceptions
    lo_ants->play( ).

  ENDMETHOD.       "play

ENDCLASS.       "lcl_Test