CLASS zcl_ants DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
*"* public components of class ZCL_ANTS
*"* do not include other source files here!!!

    TYPES ty_direction TYPE i .
    TYPES:
      BEGIN OF st_race,
        name   TYPE string,
        queen  TYPE seoclsname,
        worker TYPE seoclsname,
      END OF st_race .
    TYPES:
      tt_races TYPE STANDARD TABLE OF st_race .

    CONSTANTS c_nw TYPE ty_direction VALUE 1.               "#EC NOTEXT
    CONSTANTS c_n TYPE ty_direction VALUE 2.                "#EC NOTEXT
    CONSTANTS c_ne TYPE ty_direction VALUE 3.               "#EC NOTEXT
    CONSTANTS c_e TYPE ty_direction VALUE 4.                "#EC NOTEXT
    CONSTANTS c_se TYPE ty_direction VALUE 5.               "#EC NOTEXT
    CONSTANTS c_s TYPE ty_direction VALUE 6.                "#EC NOTEXT
    CONSTANTS c_sw TYPE ty_direction VALUE 7.               "#EC NOTEXT
    CONSTANTS c_w TYPE ty_direction VALUE 8.                "#EC NOTEXT

    METHODS constructor .
    METHODS play
      RAISING
        cx_static_check .
  PROTECTED SECTION.
*"* protected components of class ZCL_ANTS
*"* do not include other source files here!!!
  PRIVATE SECTION.
*"* private components of class ZCL_ANTS
*"* do not include other source files here!!!

    DATA mt_races TYPE tt_races .

    METHODS register_race
      IMPORTING
        !iv_name   TYPE string
        !iv_queen  TYPE seoclsname
        !iv_worker TYPE seoclsname .
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
