//
//  JRDrawView.m
//  Pods
//
//  Created by BoBo on 2016/12/27.
//
//

#import "JRDrawView.h"
#import "HelperCG.h"

@implementation JRDrawInfo

- (id)init
{
    self = [super init];
    if(self)
    {
        
    }
    
    return self;
}

- (id)initWithColor:(UIColor *)color andWidth:(CGFloat)width
{
    self = [self init];
    if(self)
    {
        self.lineColor = color;
        self.lineWidth = width;
    }
    
    return self;
}

- (NSMutableArray *)linePoints
{
    if(!_linePoints)
    {
        _linePoints = [NSMutableArray new];
    }
    
    return _linePoints;
}

- (CGFloat)getLogicLineWidth
{
    if(self.drawType == kDrawShapeEraser)
    {
        return kDrawLineWidthMiddle * 10. / 1000.0 * self.drawSize.width;
    }
    else
    {
        return self.lineWidth / 1000.0 * self.drawSize.width;
    }
}

- (void)setDrawSize:(CGSize)drawSize
{
    if(CGSizeEqualToSize(drawSize, CGSizeZero)) return;
    
    if(!CGSizeEqualToSize(_drawSize, drawSize))
    {
        for(int i = 0; i < self.linePoints.count; i++)
        {
            CGPoint nowPoint = [[self.linePoints objectAtIndex:i] CGPointValue];
            CGPoint logicPoint = [self getLogicPoint:nowPoint andSize:_drawSize];
            nowPoint = [self getLocalPoint:logicPoint andSize:drawSize];
            [self.linePoints replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:nowPoint]];
        }
        
        self.startPoint = [self getLogicPoint:self.startPoint andSize:_drawSize];
        self.startPoint = [self getLocalPoint:self.startPoint andSize:drawSize];
        
        self.lastPoint = [self getLogicPoint:self.lastPoint andSize:_drawSize];
        self.lastPoint = [self getLocalPoint:self.lastPoint andSize:drawSize];
            
        _drawSize = drawSize;
    }
}

/**
 获取逻辑坐标

 @param point 实际坐标
 @param size 实际size
 @return 逻辑坐标
 */
- (CGPoint)getLogicPoint:(CGPoint)point andSize:(CGSize)size
{
    CGPoint logicPoint;
    CGFloat XL = point.x/size.width - 0.5;
    CGFloat YL = point.y/size.height - 0.5;
    logicPoint = CGPointMake(XL, YL);
    return logicPoint;
}

/**
 获取实际坐标

 @param point 逻辑坐标
 @param size 逻辑size
 @return 实际坐标
 */
- (CGPoint)getLocalPoint:(CGPoint)point andSize:(CGSize)size
{
    CGPoint localPoint;
    CGFloat X = (point.x + 0.5) * size.width;
    CGFloat Y = (point.y + 0.5) * size.height;
    localPoint = CGPointMake(X, Y);
    return localPoint;
}

@end


@implementation JRDrawView

- (id)init
{
    self = [super init];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.currentType  = kDrawShapeDoodle;
        self.currentWidth = kDrawLineWidthBigger;
        self.currentColor = [UIColor redColor];
    }
    
    return self;
}

#pragma mark - getter setter
- (NSMutableArray *)drawInfos
{
    if(!_drawInfos)
    {
        _drawInfos = [NSMutableArray new];
    }
    
    return _drawInfos;
}

- (void)drawRect:(CGRect)rect
{
    [self drawWithRect:rect];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(event.allTouches.count > 1) return;
    
    CGPoint startPoint = [[touches anyObject] locationInView:self];
    [self drawWithBeganPoint:startPoint];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSArray *pointArray = [touches allObjects];
    CGPoint movePoint = [[pointArray objectAtIndex:0] locationInView:self];
    [self drawWithMovedPoint:movePoint];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.drawInfosBak = [self.drawInfos mutableCopy];
}


/**
 局部刷新时重新draw一次

 @param rect 刷新区域
 */
- (void)drawWithRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    for(JRDrawInfo *drawInfo in self.drawInfos)
    {
        if(drawInfo.linePoints.count <= 0) return;
        
        CGContextMoveToPoint(context, drawInfo.startPoint.x, drawInfo.startPoint.y);
        CGContextSetLineWidth(context, [drawInfo getLogicLineWidth]);
        CGContextSetStrokeColorWithColor(context, drawInfo.lineColor.CGColor);
        
        switch (drawInfo.drawType) {
            case kDrawShapeDoodle:
            {
                CGContextSetBlendMode(context, kCGBlendModeNormal);
                if(drawInfo.linePoints.count > 0)
                {
                    for(int i = 0; i < drawInfo.linePoints.count; i++)
                    {
                        CGPoint movePoint = [[drawInfo.linePoints objectAtIndex:i] CGPointValue];
                        CGContextAddLineToPoint(context, movePoint.x, movePoint.y);
                    }
                }
            }
                break;
                
            case kDrawShapeEraser:
            {
                CGContextSetBlendMode(context, kCGBlendModeClear);
                if(drawInfo.linePoints.count > 0)
                {
                    for(int i = 0; i < drawInfo.linePoints.count; i++)
                    {
                        CGPoint movePoint = [[drawInfo.linePoints objectAtIndex:i] CGPointValue];
                        CGContextAddLineToPoint(context, movePoint.x, movePoint.y);
                    }
                }

            }
                break;
            case kDrawShapeRect:
            {
                CGContextSetBlendMode(context, kCGBlendModeNormal);
                CGRect rect = [self getRectFromPoint:drawInfo.startPoint toPoint:[[drawInfo.linePoints firstObject] CGPointValue]];
                CGContextAddRect(context, rect);
            }
                break;
            case kDrawShapeRound:
            {
                CGContextSetBlendMode(context, kCGBlendModeNormal);
                CGRect rect = [self getRectFromPoint:drawInfo.startPoint toPoint:[[drawInfo.linePoints firstObject] CGPointValue]];
                CGContextAddEllipseInRect(context, rect);
            }
                break;
            case kDrawShapeLine:
            {
                CGContextSetBlendMode(context, kCGBlendModeNormal);
                CGPoint movePoint = [[drawInfo.linePoints firstObject] CGPointValue];
                CGContextAddLineToPoint(context, movePoint.x, movePoint.y);
            }
                break;
            case kDrawShapeArrow:
            {
                CGContextSetBlendMode(context, kCGBlendModeNormal);
                CGPoint movePoint = [[drawInfo.linePoints firstObject] CGPointValue];
                CGContextAddLineToPoint(context, movePoint.x, movePoint.y);
                
                double slopy, cosy, siny;
                //箭头尺寸
                double length = drawInfo.lineWidth * 5;
                double width = drawInfo.lineWidth * 5;
                
                double distance = [HelperCG distanceFromPoint:drawInfo.startPoint toPoint:movePoint];
                if(width >= distance * 0.5)
                {
                    length = width = distance * 0.5;
                }
                
                slopy = atan2((drawInfo.startPoint.y - movePoint.y), (drawInfo.startPoint.x - movePoint.x));
                cosy = cos(slopy);
                siny = sin(slopy);
                
                CGContextStrokePath(context);
                CGContextMoveToPoint(context, movePoint.x, movePoint.y);
                CGContextAddLineToPoint(context,
                                        movePoint.x + (length * cosy - (width / 2.0 * siny)),
                                        movePoint.y + (length * siny + (width / 2.0 * cosy)));
                CGContextMoveToPoint(context, movePoint.x, movePoint.y);
                CGContextAddLineToPoint(context,
                                        movePoint.x + (length * cosy + width / 2.0 * siny),
                                        movePoint.y - (width / 2.0 * cosy - length * siny));
            }
                break;
            default:
                break;
        }
        
        CGContextStrokePath(context);
    }
}

- (void)resetSize
{
    for(JRDrawInfo *drawInfo in self.drawInfos)
    {
        drawInfo.drawSize = self.bounds.size;
    }
    
    for(JRDrawInfo *drawInfo in self.drawInfosBak)
    {
        drawInfo.drawSize = self.bounds.size;
    }
}

- (void)back
{
    if(self.drawInfos.count <= 0) return;
    
    [self.drawInfos removeLastObject];
    [self setNeedsDisplay];
}

- (void)next
{
    if(self.drawInfos.count >= self.drawInfosBak.count) return;
    
    [self.drawInfos addObject:self.drawInfosBak[self.drawInfos.count]];
    [self setNeedsDisplay];
}

- (void)clear
{
    [self.drawInfos removeAllObjects];
    [self setNeedsDisplay];
}

- (void)drawWithBeganPoint:(CGPoint)point
{
    JRDrawInfo *drawInfo = [JRDrawInfo new];
    drawInfo.lineColor = self.currentColor;
    drawInfo.lineWidth = self.currentWidth;
    drawInfo.drawType  = self.currentType;
    drawInfo.drawSize = self.bounds.size;
    drawInfo.startPoint = drawInfo.lastPoint = point;
    [self.drawInfos addObject:drawInfo];
    
    CGRect needsDisplayRect = [self getRectFromPoint:point toPoint:point lineWidth:drawInfo.lineWidth];
    [self setNeedsDisplayInRect:needsDisplayRect];
}

- (void)drawWithMovedPoint:(CGPoint)point
{
    JRDrawInfo *lastDrawInfo = [self.drawInfos lastObject];
    if(lastDrawInfo.linePoints.count == 0 || lastDrawInfo.drawType == kDrawShapeDoodle || lastDrawInfo.drawType == kDrawShapeEraser)
    {
        [lastDrawInfo.linePoints addObject:[NSValue valueWithCGPoint:point]];
    }
    else
    {
        [lastDrawInfo.linePoints replaceObjectAtIndex:0 withObject:[NSValue valueWithCGPoint:point]];
    }
    
    switch (lastDrawInfo.drawType) {
        case kDrawShapeDoodle:
        case kDrawShapeEraser:
        {
            CGRect needsDisplayRect = [self getRectFromPoint:lastDrawInfo.lastPoint toPoint:point lineWidth:lastDrawInfo.lineWidth];
            [self setNeedsDisplayInRect:needsDisplayRect];
            lastDrawInfo.lastPoint = point;
        }
            break;
        default:
        {
            CGRect needsDisplayRect = [self getRectFromPoint:lastDrawInfo.startPoint toPoint:lastDrawInfo.lastPoint lineWidth:lastDrawInfo.lineWidth];
            [self setNeedsDisplayInRect:needsDisplayRect];
            
            if(!CGRectContainsPoint(needsDisplayRect, point))
            {
                needsDisplayRect = [self getRectFromPoint:lastDrawInfo.startPoint toPoint:point lineWidth:lastDrawInfo.lineWidth];
                [self setNeedsDisplayInRect:needsDisplayRect];
            }
            
            lastDrawInfo.lastPoint = point;
        }
            break;
    }
}

/**
 *  根据移动的前后两个点计算足够的画板刷新区域
 *
 *  @param fromPoint  前一个点
 *  @param toPoint 后一个点
 *
 *  @return drawRect方法的刷新区域
 */
- (CGRect)getRectFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint lineWidth:(CGFloat)lineWidth
{
    CGFloat brushWidth = lineWidth * 10;
    CGRect drawRect = CGRectMake(MIN(fromPoint.x, toPoint.x) - brushWidth, MIN(fromPoint.y, toPoint.y) - brushWidth, ABS(fromPoint.x- toPoint.x) + brushWidth + lineWidth, ABS(fromPoint.y - toPoint.y) + brushWidth + lineWidth);
    drawRect.size.width *= 1.2;
    drawRect.size.height *= 1.2;
    return drawRect;
}

- (CGRect)getRectFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    CGRect drawRect = CGRectMake(fromPoint.x, fromPoint.y, toPoint.x - fromPoint.x , toPoint.y - fromPoint.y);
    return drawRect;
}

@end
