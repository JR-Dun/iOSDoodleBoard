//
//  HelperCG.m
//  Pods
//
//  Created by BoBo on 15/11/17.
//
//

#import "HelperCG.h"

@implementation HelperCG

+ (double)distanceFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    double num1 = pow(fromPoint.x - toPoint.x, 2);
    double num2 = pow(fromPoint.y - toPoint.y, 2);
    double distance = sqrt(num1 + num2);
    return distance;
}

+ (CGSize)getSizeWithString:(NSString *)str andFont:(UIFont *)font contentWidth:(CGFloat)width contentHeight:(CGFloat)height
{
    CGSize result = CGSizeZero;
    
    if(width<=0)
    {//高度获取宽度
        CGFloat _width = [self getWidthWithContent:str font:font contentHeight:height];
        CGFloat _height = [self getHeightWithContent:str font:font contentWidth:10000];
        if(_height<height)
        {
            result.height = _height;
        }
        else
        {
            result.height = height;
        }
        result.width = _width;
    }
    else
    {//宽度获取高度
        CGFloat _width = [self getWidthWithContent:str font:font contentHeight:10000];
        CGFloat _height = [self getHeightWithContent:str font:font contentWidth:width];
        if(_width<width)
        {
            result.width = _width;
        }
        else
        {
            result.width = width;
        }
        result.height = _height;
    }
    
    return result;
}

+ (CGFloat)getWidthWithContent:(NSString *)content font:(UIFont *)font contentHeight:(CGFloat)height
{
    CGFloat result = .0;
    
    CGSize contentSize = [self getSizeWithString:content font:font contentWidth:CGFLOAT_MAX contentHeight:height];
    result = contentSize.width;
    
    return result;
}

+ (CGFloat)getHeightWithContent:(NSString *)content font:(UIFont *)font contentWidth:(CGFloat)width
{
    CGFloat result = .0;
    
    CGSize contentSize = [self getSizeWithString:content font:font contentWidth:width contentHeight:CGFLOAT_MAX];
    result = contentSize.height;
    
    return result;
}

+ (CGSize)getSizeWithString:(NSString *)string font:(UIFont *)font contentWidth:(CGFloat)width contentHeight:(CGFloat)height
{
    CGSize labelSize = CGSizeZero;
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return labelSize;
    }
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    labelSize = [string boundingRectWithSize:CGSizeMake((width ? width : MAXFLOAT), (height ? height : MAXFLOAT)) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    labelSize.height = ceil(labelSize.height);
    labelSize.width = ceil(labelSize.width);
#else
    labelSize = [string sizeWithFont:font constrainedToSize:CGSizeMake((width ? width : MAXFLOAT), (height ? height : MAXFLOAT)) lineBreakMode:NSLineBreakByCharWrapping];
#endif
    return labelSize;
}
@end
