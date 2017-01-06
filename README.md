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


## size有变动的话需要调用method resetSize
```
WS(weakSelf);
[UIView animateWithDuration:0.25 animations:^{
    for(NSLayoutConstraint *constraint in self.drawView.superview.constraints)
    {
        if(constraint.firstItem == self.drawView && constraint.firstANSLayoutAttributeWidth)
        {
            constraint.constant = constraint.constant - 50;
        }
    }
    [weakSelf.view layoutIfNeeded];
} completion:^(BOOL finished) {
    if(finished)
    {
        [weakSelf.drawView resetSize];
    }
}];

```
