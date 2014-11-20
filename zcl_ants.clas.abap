class ZCL_ANTS definition
  public
  final
  create public .

public section.
*"* public components of class ZCL_ANTS
*"* do not include other source files here!!!

  types:
    BEGIN OF st_race,
           name TYPE string,
           queen TYPE seoclsname,
           worker TYPE seoclsname,
         END OF st_race .
  types:
    TT_RACES type standard table of st_race .

  methods CONSTRUCTOR .
  methods PLAY .
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


  register_race( iv_name = 'First Ant'
                 iv_queen = 'ZCL_ANT_FIRST_QUEEN'
                 iv_worker = 'ZCL_ANT_FIRST_WORKER' ).

ENDMETHOD.


METHOD play.

  DATA: ls_race       LIKE LINE OF mt_races,
        lt_queens     TYPE TABLE OF REF TO zif_ant_queen,
        lo_queen      TYPE REF TO zif_ant_queen,
        lo_cmd_queen  TYPE REF TO zcl_ant_cmd_queen,
        lo_cmd_worker TYPE REF TO zcl_ant_cmd_worker,
        lt_workers    TYPE TABLE OF REF TO zif_ant_worker,
        lo_worker     TYPE REF TO zif_ant_worker.


  READ TABLE mt_races INDEX 1 INTO ls_race.


  CREATE OBJECT lo_queen
    TYPE (ls_race-queen).
  APPEND lo_queen TO lt_queens.

  DO 10 TIMES.
    CREATE OBJECT lo_worker
      TYPE (ls_race-worker).
    APPEND lo_worker TO lt_workers.
  ENDDO.

****

  DO 1000 TIMES.

    LOOP AT lt_queens INTO lo_queen.
      CREATE OBJECT lo_cmd_queen
        TYPE zcl_ant_cmd_queen.
      lo_queen->tick( lo_cmd_queen ).
    ENDLOOP.

    LOOP AT lt_workers INTO lo_worker.
      CREATE OBJECT lo_cmd_worker
        TYPE zcl_ant_cmd_worker.
      lo_worker->tick( lo_cmd_worker ).
    ENDLOOP.

  ENDDO.

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