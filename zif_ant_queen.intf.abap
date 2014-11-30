*"* components of interface ZIF_ANT_QUEEN
interface ZIF_ANT_QUEEN
  public .


  methods TICK
    importing
      !IO_CMD type ref to ZCL_ANT_CMD_QUEEN
    raising
      ZCX_ANTS .
endinterface.