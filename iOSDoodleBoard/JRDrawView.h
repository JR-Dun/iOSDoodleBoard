//
//  JRDrawView.h
//  Pods
//
//  Created by BoBo on 2016/12/27.
//
//

#import <UIKit/UIKit.h>
#import "JREnums.h"

@interface JRDrawInfo : NSObject

@property (nonatomic, strong) NSMutableArray *linePoints;
@property (nonatomic, strong) UIColor        *lineColor;
@property (nonatomic, assign) CGFloat         lineWidth;

@property (nonatomic, assign) NSInteger       drawType;
@property (nonatomic, assign) CGSize          drawSize;

@property (nonatomic, assign) CGPoint         startPoint;
@property (nonatomic, assign) CGPoint         lastPoint;

- (id)initWithColor:(UIColor *)color andWidth:(CGFloat)width;

- (CGFloat)getLogicLineWidth;

@end


@interface JRDrawView : UIView

@property (nonatomic, strong) NSMutableArray *drawInfos;
@property (nonatomic, strong) NSMutableArray *drawInfosBak;
@property (nonatomic, strong) UIColor        *currentColor;
@property (nonatomic, assign) CGFloat         currentWidth;

@property (nonatomic, assign) JRDrawShapeType currentType;

/**
 画布大小有变动，需要重置数据
 */
- (void)resetSize;

/**
 后退
 */
- (void)back;

/**
 前进
 */
- (void)next;

/**
 清空
 */
- (void)clear;

@end
