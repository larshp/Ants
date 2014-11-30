class ZCL_ANT_CMD_GENERAL definition
  public
  abstract
  create public .

public section.
*"* public components of class ZCL_ANT_CMD_GENERAL
*"* do not include other source files here!!!

  methods GET_POSITION .
  methods CONSTRUCTOR
    importing
      !IV_GUID type SYSUUID_C22
      !IO_MAP type ref to ZCL_ANTS_MAP .
  methods MESSAGE .
  methods LOOK .
  class ZCL_ANTS definition load .
  methods MOVE
    importing
      !IV_DIRECTION type ZCL_ANTS=>TY_DIRECTION
    raising
      ZCX_ANTS .
  type-pools ABAP .
  methods IS_FRIENDLY
    returning
      value(RV_FRIENDLY) type ABAP_BOOL .
protected section.
*"* protected components of class ZCL_ANT_CMD_GENERAL
*"* do not include other source files here!!!

  data MO_MAP type ref to ZCL_ANTS_MAP .
  type-pools ABAP .
  data MV_DONE type ABAP_BOOL .
  data MV_GUID type SYSUUID_C22 .

  methods TURN_DONE
    raising
      ZCX_ANTS .
private section.
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



ENDMETHOD.


METHOD look.




ENDMETHOD.


METHOD message.

* todo

ENDMETHOD.


METHOD move.

  DATA: ls_position TYPE zcl_ants_map=>st_position.

  FIELD-SYMBOLS: <ls_queen> LIKE LINE OF mo_map->mt_queens,
                 <ls_worker> LIKE LINE OF mo_map->mt_workers.


  IF iv_direction IS INITIAL.
    RAISE EXCEPTION TYPE zcx_ants
      EXPORTING
        textid = zcx_ants=>m000.
  ENDIF.

  READ TABLE mo_map->mt_queens ASSIGNING <ls_queen> WITH KEY guid = mv_guid.
  IF sy-subrc <> 0.
    READ TABLE mo_map->mt_workers ASSIGNING <ls_worker> WITH KEY guid = mv_guid.
    IF sy-subrc = 0.
      ls_position = <ls_queen>-position.
    ENDIF.
  ELSE.
    ls_position = <ls_queen>-position.
  ENDIF.
  IF sy-subrc <> 0.
    RAISE EXCEPTION TYPE zcx_ants
      EXPORTING
        textid = zcx_ants=>m003.
  ENDIF.

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

* todo, check target is not occupied by other colony or wall

  turn_done( ).

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