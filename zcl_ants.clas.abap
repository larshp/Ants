class ZCL_ANTS definition
  public
  final
  create public .

public section.
*"* public components of class ZCL_ANTS
*"* do not include other source files here!!!

  types TY_DIRECTION type I .
  types:
    BEGIN OF st_race,
           name TYPE string,
           queen TYPE seoclsname,
           worker TYPE seoclsname,
         END OF st_race .
  types:
    TT_RACES type standard table of st_race .

  constants C_NW type TY_DIRECTION value 1. "#EC NOTEXT
  constants C_N type TY_DIRECTION value 2. "#EC NOTEXT
  constants C_NE type TY_DIRECTION value 3. "#EC NOTEXT
  constants C_E type TY_DIRECTION value 4. "#EC NOTEXT
  constants C_SE type TY_DIRECTION value 5. "#EC NOTEXT
  constants C_S type TY_DIRECTION value 6. "#EC NOTEXT
  constants C_SW type TY_DIRECTION value 7. "#EC NOTEXT
  constants C_W type TY_DIRECTION value 8. "#EC NOTEXT

  methods CONSTRUCTOR .
  methods PLAY
    raising
      CX_STATIC_CHECK .
protected section.
*"* protected components of class ZCL_ANTS
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_ANTS
*"* do not include other source files here!!!

  data MT_RACES type TT_RACES .

  methods REGISTER_RACE
    importing
      !IV_NAME type STRING
      !IV_QUEEN type SEOCLSNAME
      !IV_WORKER type SEOCLSNAME .
ENDCLASS.



CLASS ZCL_ANTS IMPLEMENTATION.


METHOD constructor.

  register_race( iv_name   = 'First Ant'
                 iv_queen  = 'ZCL_ANT_FIRST_QUEEN'
                 iv_worker = 'ZCL_ANT_FIRST_WORKER' ).

ENDMETHOD.


METHOD play.

  DATA: ls_race LIKE LINE OF mt_races,
        lo_map  TYPE REF TO zcl_ants_map.


  READ TABLE mt_races INDEX 1 INTO ls_race.

****

  CREATE OBJECT lo_map
    EXPORTING
      iv_height = 100
      iv_width  = 100.

  lo_map->place_food( iv_amount = 10
                      iv_places = 10 ).

  lo_map->place_colony( ls_race ).

****

  DO 1000 TIMES.
    lo_map->tick( ).

    lo_map->render_json( ).
  ENDDO.

***

* return table of turns
* turn 0 = initial
*
* actions:
* move(including spawn)
* pick up
* drop
* attack
*
* ant:
* type
* colour/race
* unique id

ENDMETHOD.


METHOD register_race.

  DATA: ls_race TYPE st_race.


  ls_race-name   = iv_name.
  ls_race-queen  = iv_queen.
  ls_race-worker = iv_worker.
  APPEND ls_race TO mt_races.

* todo, validate class names vs interfaces

ENDMETHOD.
ENDCLASS.