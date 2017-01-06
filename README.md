# iOSDoodleBoard
涂鸦、橡皮擦、矩形、圆、箭头、清除、撤销、恢复


## JRDrawView 使用例子
```
//涂鸦
self.drawView.currentType = kDrawShapeDoodle;
//橡皮擦
self.drawView.currentType = kDrawShapeEraser;
//矩形
self.drawView.currentType = kDrawShapeRect;
//圆
self.drawView.currentType = kDrawShapeRound;
//直线
self.drawView.currentType = kDrawShapeLine;
//箭头
self.drawView.currentType = kDrawShapeArrow;

//清空
[self.drawView clear];
//撤销
[self.drawView back];
//恢复
[self.drawView next];

```