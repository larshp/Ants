*"* components of interface ZIF_ANT_WORKER
interface ZIF_ANT_WORKER
  public .


  methods TICK
    importing
      !IO_CMD type ref to ZCL_ANT_CMD_WORKER
    raising
      ZCX_ANTS .
endinterface.
