CREATE OR REPLACE PACKAGE egame IS
  /****** 游戏编码（1=双色球；2=3D；4=七乐彩；5=时时彩；6=幸运农场） ******/

  ssq                 /* 1=双色球               */  CONSTANT NUMBER := 1;
  threed              /* 2=3D                   */  CONSTANT NUMBER := 2;
  qlc                 /* 4=七乐彩               */  CONSTANT NUMBER := 4;
  ssc                 /* 5=时时彩               */  CONSTANT NUMBER := 5;
  koc6hc              /* 6=七龙星               */  CONSTANT NUMBER := 6;
  kocssc              /* 7=天天赢               */  CONSTANT NUMBER := 7;
  kockeno             /* 8=基诺                 */  CONSTANT NUMBER := 8;
  kk2                 /* 9=快二                 */  CONSTANT NUMBER := 9;
  kk3                 /* 11=快三                */  CONSTANT NUMBER := 11;
  s11q5               /* 12=11选5               */  CONSTANT NUMBER := 12;
  tema                /* 13=40选1-特码游戏      */  CONSTANT NUMBER := 13;
  fbs                 /* 14=FBS足球游戏         */  CONSTANT NUMBER := 14;

END;
