
undefined4 FUN_10020450(char *param_1,char *param_2)

{
  undefined4 uVar1;
  
  if (*param_1 == *param_2) {
    if (param_1[1] == param_2[1]) {
      if (param_1[2] == param_2[2]) {
        if (param_1[3] == param_2[3]) {
          uVar1 = 0;
        }
        else {
          uVar1 = 1;
        }
      }
      else {
        uVar1 = 1;
      }
    }
    else {
      uVar1 = 1;
    }
  }
  else {
    uVar1 = 1;
  }
  return uVar1;
}

