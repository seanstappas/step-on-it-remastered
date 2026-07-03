
int .debug::_CompareMasked(uint *param_1,uint *param_2,uint *param_3,short param_4)

{
  int iVar1;
  
  iVar1 = 1;
  while( true ) {
    if (param_4 == 0) {
      return iVar1;
    }
    if (iVar1 != 1) break;
    if ((*param_3 & (*param_1 ^ *param_2)) != 0) {
      iVar1 = 0;
    }
    param_1 = param_1 + 1;
    param_2 = param_2 + 1;
    param_3 = param_3 + 1;
    param_4 = param_4 + -1;
  }
  return iVar1;
}

