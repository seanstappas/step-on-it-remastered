
undefined4 FUN_1002ea68(undefined4 param_1)

{
  undefined4 uVar1;
  
  if ((short)param_1 == -1) {
    uVar1 = 0xffffffce;
  }
  else {
    .glue::CloseResFile(param_1);
    uVar1 = .glue::ResError();
  }
  return uVar1;
}

