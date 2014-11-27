class ZCL_ANTS_MAP definition
  public
  create public .

public section.
*"* public components of class ZCL_ANTS_MAP
*"* do not include other source files here!!!

  types:
    BEGIN OF st_info,
             x TYPE i,
             y TYPE i,
             food TYPE i,
           END OF st_info .

  methods CONSTRUCTOR
    importing
      !IV_HEIGHT type I
      !IV_WIDTH type I .
  methods PLACE_COLONY .
  class ZCL_ANTS_MAP definition load .
  methods GET_INFO
    importing
      !IV_X type I
      !IV_Y type I
    returning
      value(RS_INFO) type ZCL_ANTS_MAP=>ST_INFO .
  methods PLACE_FOOD
    importing
      !IV_AMOUNT type I
      !IV_PLACES type I .
protected section.
*"* protected components of class ZCL_ANTS_MAP
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_ANTS_MAP
*"* do not include other source files here!!!

  types:
    tt_map TYPE SORTED TABLE OF st_info WITH UNIQUE KEY x y .

  data MV_HEIGHT type I .
  data MV_WIDTH type I .
  data MT_MAP type TT_MAP .
  data MO_RWIDTH type ref to CL_ABAP_RANDOM_INT .
  data MO_RHEIGHT type ref to CL_ABAP_RANDOM_INT .
ENDCLASS.



CLASS ZCL_ANTS_MAP IMPLEMENTATION.


METHOD constructor.

  mv_height = iv_height.
  mv_width  = iv_width.


  mo_rheight = cl_abap_random_int=>create( seed = sy-uzeit - 1
                                           min = 1
                                           max = mv_height ).
  mo_rwidth  = cl_abap_random_int=>create( seed = sy-uzeit + 1
                                           min = 1
                                           max = mv_width ).

ENDMETHOD.


METHOD get_info.

  IF iv_x < 0
      OR iv_x > mv_width
      OR iv_y < 0
      OR iv_y > mv_height.
* todo, wall?
  ENDIF.

  READ TABLE mt_map INTO rs_info WITH KEY x = iv_x y = iv_y.

ENDMETHOD.


METHOD place_colony.

  DATA: lv_x TYPE i,
        lv_y TYPE i.


  lv_x = mo_rwidth->get_next( ).
  lv_y = mo_rheight->get_next( ).

* todo

ENDMETHOD.


METHOD place_food.

  DATA: lv_x       TYPE i,
        lv_y       TYPE i,
        ls_map     LIKE LINE OF mt_map.


  DO iv_places TIMES.

    lv_x = mo_rwidth->get_next( ).
    lv_y = mo_rheight->get_next( ).

    READ TABLE mt_map INTO ls_map WITH KEY x = lv_x y = lv_y.
    IF sy-subrc = 0.
      ls_map-food = ls_map-food + iv_amount.
      MODIFY TABLE mt_map FROM ls_map.
    ELSE.
      CLEAR ls_map.
      ls_map-x    = lv_x.
      ls_map-y    = lv_y.
      ls_map-food = iv_amount.
      INSERT ls_map INTO TABLE mt_map.
    ENDIF.

  ENDDO.

ENDMETHOD.
ENDCLASS.