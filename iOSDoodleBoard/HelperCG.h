//
//  HelperCG.h
//  Pods
//
//  Created by BoBo on 15/11/17.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HelperCG : NSObject

/**
 获取两点间距离

 @param fromPoint 开始点
 @param toPoint 结束点
 @return double
 */
+ (double)distanceFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;

/**
 *  获取文本size
 *
 *  @param str    内容文本
 *  @param font   字体
 *  @param width  宽度（无限大：0）
 *  @param height 高度（无限大：0）
 *
 *  @return CGSize
 */
+ (CGSize)getSizeWithString:(NSString *)str andFont:(UIFont *)font contentWidth:(CGFloat)width contentHeight:(CGFloat)height;

@end
