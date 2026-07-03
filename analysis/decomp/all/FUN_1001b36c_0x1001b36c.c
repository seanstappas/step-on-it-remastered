
undefined4 FUN_1001b36c(undefined4 param_1,short param_2)

{
  undefined4 uStack00000018;
  short sStack0000001e;
  undefined4 local_18;
  undefined1 auStack_14 [8];
  undefined1 auStack_c [12];
  
  uStack00000018 = param_1;
  sStack0000001e = param_2;
  .glue::GetDialogItem(param_1,(int)param_2,auStack_c,&local_18,auStack_14);
  return local_18;
}

