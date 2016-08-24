CLASS zcl_ant_cmd_general DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PUBLIC .

  PUBLIC SECTION.
*"* public components of class ZCL_ANT_CMD_GENERAL
*"* do not include other source files here!!!

    METHODS get_position .
    METHODS constructor
      IMPORTING
        !iv_guid TYPE sysuuid_c22
        !io_map  TYPE REF TO zcl_ants_map .
    METHODS message .
    METHODS look .
    CLASS zcl_ants DEFINITION LOAD .
    METHODS move
      IMPORTING
        !iv_direction TYPE zcl_ants=>ty_direction
      RAISING
        zcx_ants .
    TYPE-POOLS abap .
    METHODS is_friendly
      RETURNING
        VALUE(rv_friendly) TYPE abap_bool .
  PROTECTED SECTION.
*"* protected components of class ZCL_ANT_CMD_GENERAL
*"* do not include other source files here!!!

    DATA mo_map TYPE REF TO zcl_ants_map .
    TYPE-POOLS abap .
    DATA mv_done TYPE abap_bool .
    DATA mv_guid TYPE sysuuid_c22 .

    CLASS zcl_ants_map DEFINITION LOAD .
    CLASS zcl_ants DEFINITION LOAD .
    METHODS translate
      IMPORTING
        !is_position       TYPE zcl_ants_map=>st_position
        !iv_direction      TYPE zcl_ants=>ty_direction
      RETURNING
        VALUE(rs_position) TYPE zcl_ants_map=>st_position
      RAISING
        zcx_ants .
    METHODS turn_done
      RAISING
        zcx_ants .
  PRIVATE SECTION.
*"* private components of class ZCL_ANT_CMD_GENERAL
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_ANT_CMD_GENERAL IMPLEMENTATION.


  METHOD constructor.

    mo_map  = io_map.
    mv_done = abap_false.
    mv_guid = iv_guid.

  ENDMETHOD.


  METHOD get_position.

* todo

  ENDMETHOD.


  METHOD is_friendly.
* todo
  ENDMETHOD.


  METHOD look.
* todo
  ENDMETHOD.


  METHOD message.

* todo

  ENDMETHOD.


  METHOD move.

    DATA: ls_info     TYPE zcl_ants_map=>st_info,
          ls_position TYPE zcl_ants_map=>st_position,
          lv_colony   TYPE i,
          ls_new_pos  TYPE zcl_ants_map=>st_position.

    FIELD-SYMBOLS: <ls_queen>  LIKE LINE OF mo_map->mt_queens,
                   <ls_worker> LIKE LINE OF mo_map->mt_workers.


    IF iv_direction IS INITIAL.
      RAISE EXCEPTION TYPE zcx_ants
        EXPORTING
          textid = zcx_ants=>m000.
    ENDIF.

* todo, refactor?

    READ TABLE mo_map->mt_queens ASSIGNING <ls_queen> WITH KEY guid = mv_guid.
    IF sy-subrc <> 0.
      READ TABLE mo_map->mt_workers ASSIGNING <ls_worker> WITH KEY guid = mv_guid.
      IF sy-subrc = 0.
        ls_position = <ls_worker>-position.
        lv_colony = <ls_worker>-colony.
      ENDIF.
    ELSE.
      ls_position = <ls_queen>-position.
      lv_colony = <ls_queen>-colony.
    ENDIF.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_ants
        EXPORTING
          textid = zcx_ants=>m003.
    ENDIF.

    ls_new_pos = translate( is_position  = ls_position
                            iv_direction = iv_direction ).

    ls_info = mo_map->get_info( iv_colony   = lv_colony
                                is_position = ls_new_pos ).
    IF ls_info-wall = abap_true.
      RAISE EXCEPTION TYPE zcx_ants
        EXPORTING
          textid = zcx_ants=>m004.
    ENDIF.
    IF ls_info-enemy = abap_true.
      RAISE EXCEPTION TYPE zcx_ants
        EXPORTING
          textid = zcx_ants=>m005.
    ENDIF.

    turn_done( ).

  ENDMETHOD.


  METHOD translate.

    CASE iv_direction.
      WHEN zcl_ants=>c_e.
* todo

      WHEN zcl_ants=>c_n.
      WHEN zcl_ants=>c_ne.
      WHEN zcl_ants=>c_nw.
      WHEN zcl_ants=>c_s.
      WHEN zcl_ants=>c_se.
      WHEN zcl_ants=>c_sw.
      WHEN zcl_ants=>c_w.
      WHEN OTHERS.
        RAISE EXCEPTION TYPE zcx_ants
          EXPORTING
            textid = zcx_ants=>m001.
    ENDCASE.

  ENDMETHOD.


  METHOD turn_done.

    IF mv_done = abap_true.
      RAISE EXCEPTION TYPE zcx_ants
        EXPORTING
          textid = zcx_ants=>m002.
    ENDIF.

    mv_done = abap_true.

  ENDMETHOD.
ENDCLASS.