CLASS zcl_ants_map DEFINITION
  PUBLIC
  CREATE PUBLIC
  GLOBAL FRIENDS zcl_ant_cmd_general
                 zcl_ant_cmd_queen
                 zcl_ant_cmd_worker .

  PUBLIC SECTION.
*"* public components of class ZCL_ANTS_MAP
*"* do not include other source files here!!!

    TYPES:
      BEGIN OF st_position,
        x TYPE i,
        y TYPE i,
      END OF st_position .
    TYPES:
      BEGIN OF st_info,
        position TYPE st_position,
        food     TYPE i,
        wall     TYPE abap_bool,
        enemy    TYPE abap_bool,
      END OF st_info .

    METHODS render_json
      RETURNING
        VALUE(rv_json) TYPE string .
    METHODS constructor
      IMPORTING
        !iv_height TYPE i
        !iv_width  TYPE i .
    CLASS zcl_ants DEFINITION LOAD .
    METHODS place_colony
      IMPORTING
        !is_race    TYPE zcl_ants=>st_race
        !iv_workers TYPE i DEFAULT 10
      RAISING
        cx_uuid_error .
    CLASS zcl_ants_map DEFINITION LOAD .
    METHODS get_info
      IMPORTING
        !iv_colony     TYPE i DEFAULT 0
        !is_position   TYPE zcl_ants_map=>st_position
      RETURNING
        VALUE(rs_info) TYPE zcl_ants_map=>st_info .
    METHODS place_food
      IMPORTING
        !iv_amount TYPE i
        !iv_places TYPE i .
    METHODS tick .
  PROTECTED SECTION.
*"* protected components of class ZCL_ANTS_MAP
*"* do not include other source files here!!!

    TYPES:
      BEGIN OF st_queen,
        guid     TYPE sysuuid_c22,
        queen    TYPE REF TO zif_ant_queen,
        position TYPE st_position,
        colony   TYPE i,
      END OF st_queen .
    TYPES:
      BEGIN OF st_worker,
        guid     TYPE sysuuid_c22,
        worker   TYPE REF TO zif_ant_worker,
        position TYPE st_position,
        colony   TYPE i,
      END OF st_worker .
    TYPES:
      tt_queen TYPE TABLE OF st_queen .
    TYPES:
      tt_worker TYPE TABLE OF st_worker .
    TYPES:
      tt_map TYPE SORTED TABLE OF st_info WITH UNIQUE KEY position .

    DATA mv_height TYPE i .
    DATA mv_width TYPE i .
    DATA mt_map TYPE tt_map .
    DATA mt_queens TYPE tt_queen .
    DATA mt_workers TYPE tt_worker .

    METHODS event_die
      IMPORTING
        !iv_guid TYPE sysuuid_c22 .
    METHODS event_move
      IMPORTING
        !iv_guid TYPE sysuuid_c22 .
  PRIVATE SECTION.
*"* private components of class ZCL_ANTS_MAP
*"* do not include other source files here!!!

    DATA mv_col_count TYPE i VALUE 1.                     "#EC NOTEXT .
    DATA mo_rwidth TYPE REF TO cl_abap_random_int .
    DATA mo_rheight TYPE REF TO cl_abap_random_int .
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


  METHOD event_die.
  ENDMETHOD.


  METHOD event_move.
  ENDMETHOD.


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

    DATA: lv_x   TYPE i,
          lv_y   TYPE i,
          ls_map LIKE LINE OF mt_map.


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
