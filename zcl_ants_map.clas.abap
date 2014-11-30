class ZCL_ANTS_MAP definition
  public
  create public

  global friends ZCL_ANT_CMD_GENERAL
                 ZCL_ANT_CMD_QUEEN
                 ZCL_ANT_CMD_WORKER .

public section.
*"* public components of class ZCL_ANTS_MAP
*"* do not include other source files here!!!

  types:
    BEGIN OF st_position,
               x TYPE i,
               y TYPE i,
             END OF st_position .
  types:
    BEGIN OF st_info,
          position TYPE st_position,
          food     TYPE i,
          wall     TYPE abap_bool,
          enemy    TYPE abap_bool,
        END OF st_info .

  methods RENDER_JSON
    returning
      value(RV_JSON) type STRING .
  methods CONSTRUCTOR
    importing
      !IV_HEIGHT type I
      !IV_WIDTH type I .
  class ZCL_ANTS definition load .
  methods PLACE_COLONY
    importing
      !IS_RACE type ZCL_ANTS=>ST_RACE
      !IV_WORKERS type I default 10
    raising
      CX_UUID_ERROR .
  class ZCL_ANTS_MAP definition load .
  methods GET_INFO
    importing
      !IV_COLONY type I default 0
      !IS_POSITION type ZCL_ANTS_MAP=>ST_POSITION
    returning
      value(RS_INFO) type ZCL_ANTS_MAP=>ST_INFO .
  methods PLACE_FOOD
    importing
      !IV_AMOUNT type I
      !IV_PLACES type I .
  methods TICK .
protected section.
*"* protected components of class ZCL_ANTS_MAP
*"* do not include other source files here!!!

  types:
    BEGIN OF st_queen,
        guid TYPE sysuuid_c22,
        queen TYPE REF TO zif_ant_queen,
        position TYPE st_position,
        colony TYPE i,
      END OF st_queen .
  types:
    BEGIN OF st_worker,
        guid TYPE sysuuid_c22,
        worker TYPE REF TO zif_ant_worker,
        position TYPE st_position,
        colony TYPE i,
      END OF st_worker .
  types:
    tt_queen TYPE TABLE OF st_queen .
  types:
    tt_worker TYPE TABLE OF st_worker .
  types:
    tt_map TYPE SORTED TABLE OF st_info WITH UNIQUE KEY position .

  data MV_HEIGHT type I .
  data MV_WIDTH type I .
  data MT_MAP type TT_MAP .
  data MT_QUEENS type TT_QUEEN .
  data MT_WORKERS type TT_WORKER .

  methods EVENT_DIE
    importing
      !IV_GUID type SYSUUID_C22 .
  methods EVENT_MOVE
    importing
      !IV_GUID type SYSUUID_C22 .
private section.
*"* private components of class ZCL_ANTS_MAP
*"* do not include other source files here!!!

  data MV_COL_COUNT type I value 1. "#EC NOTEXT .
  data MO_RWIDTH type ref to CL_ABAP_RANDOM_INT .
  data MO_RHEIGHT type ref to CL_ABAP_RANDOM_INT .
ENDCLASS.



CLASS ZCL_ANTS_MAP IMPLEMENTATION.


METHOD constructor.

  mv_height = iv_height.
  mv_width  = iv_width.


  mo_rheight = cl_abap_random_int=>create( seed = sy-uzeit - 1
                                           min  = 1
                                           max  = mv_height ).
  mo_rwidth  = cl_abap_random_int=>create( seed = sy-uzeit + 1
                                           min  = 1
                                           max  = mv_width ).

ENDMETHOD.


method EVENT_DIE.
endmethod.


method EVENT_MOVE.
endmethod.


METHOD get_info.

  IF is_position-x < 0
      OR is_position-x > mv_width
      OR is_position-y < 0
      OR is_position-y > mv_height.
    rs_info-wall = abap_true.
    RETURN.
  ENDIF.

  READ TABLE mt_map INTO rs_info
    WITH KEY position-x = is_position-x position-y = is_position-y.

* todo, fill enemy flag

ENDMETHOD.


METHOD place_colony.

  DATA: lv_x      TYPE i,
        lv_y      TYPE i,
        li_queen  TYPE REF TO zif_ant_queen,
        ls_queen  LIKE LINE OF mt_queens,
        li_worker TYPE REF TO zif_ant_worker,
        ls_worker LIKE LINE OF mt_workers.


  lv_x = mo_rwidth->get_next( ).
  lv_y = mo_rheight->get_next( ).


  CREATE OBJECT li_queen
    TYPE (is_race-queen).
  CLEAR ls_queen.
  ls_queen-guid       = cl_system_uuid=>create_uuid_c22_static( ).
  ls_queen-queen      = li_queen.
  ls_queen-position-x = lv_x.
  ls_queen-position-y = lv_y.
  ls_queen-colony     = mv_col_count.
  APPEND ls_queen TO mt_queens.

  DO iv_workers TIMES.
    CREATE OBJECT li_worker
      TYPE (is_race-worker).
    CLEAR ls_worker.
    ls_worker-guid       = cl_system_uuid=>create_uuid_c22_static( ).
    ls_worker-worker     = li_worker.
    ls_worker-position-x = lv_x.
    ls_worker-position-y = lv_y.
    ls_worker-colony     = mv_col_count.
    APPEND ls_worker TO mt_workers.
  ENDDO.

  mv_col_count = mv_col_count + 1.

ENDMETHOD.


METHOD place_food.

  DATA: lv_x       TYPE i,
        lv_y       TYPE i,
        ls_map     LIKE LINE OF mt_map.


  DO iv_places TIMES.

    lv_x = mo_rwidth->get_next( ).
    lv_y = mo_rheight->get_next( ).

    READ TABLE mt_map INTO ls_map WITH KEY position-x = lv_x position-y = lv_y.
    IF sy-subrc = 0.
      ls_map-food = ls_map-food + iv_amount.
      MODIFY TABLE mt_map FROM ls_map.
    ELSE.
      CLEAR ls_map.
      ls_map-position-x    = lv_x.
      ls_map-position-y    = lv_y.
      ls_map-food = iv_amount.
      INSERT ls_map INTO TABLE mt_map.
    ENDIF.

  ENDDO.

ENDMETHOD.


METHOD render_json.

  FIELD-SYMBOLS: <ls_map> LIKE LINE OF mt_map.


  LOOP AT mt_map ASSIGNING <ls_map>.

  ENDLOOP.

* todo

ENDMETHOD.


METHOD tick.

  DATA: lo_cmd_queen  TYPE REF TO zcl_ant_cmd_queen,
        lo_cmd_worker TYPE REF TO zcl_ant_cmd_worker.

  FIELD-SYMBOLS: <ls_queen>  LIKE LINE OF mt_queens,
                 <ls_worker> LIKE LINE OF mt_workers.


  LOOP AT mt_queens ASSIGNING <ls_queen>.
    CREATE OBJECT lo_cmd_queen
      TYPE zcl_ant_cmd_queen
      EXPORTING
        iv_guid = <ls_queen>-guid
        io_map  = me.
    TRY.
        <ls_queen>-queen->tick( lo_cmd_queen ).
      CATCH zcx_ants.
        event_die( <ls_queen>-guid ).
    ENDTRY.
  ENDLOOP.

  LOOP AT mt_workers ASSIGNING <ls_worker>.
    CREATE OBJECT lo_cmd_worker
      TYPE zcl_ant_cmd_worker
      EXPORTING
        iv_guid = <ls_worker>-guid
        io_map  = me.
    TRY.
        <ls_worker>-worker->tick( lo_cmd_worker ).
      CATCH zcx_ants.
        event_die( <ls_worker>-guid ).
    ENDTRY.
  ENDLOOP.

ENDMETHOD.
ENDCLASS.