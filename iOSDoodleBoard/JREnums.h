//
//  Enumeration.h
//  Pods
//
//  Created by BoBo on 2016/12/9.
//
//

#ifndef JREnums_h
#define JREnums_h

#import <UIKit/UIKit.h>

/**
 *  涂鸦类型
 */
typedef NS_OPTIONS(NSUInteger, JRDrawShapeType) {
    /**
     *  涂鸦
     */
    kDrawShapeDoodle = 0,
    /**
     *  橡皮擦
     */
    kDrawShapeEraser = 1,
    /**
     *  矩形
     */
    kDrawShapeRect = 1 << 1,
    /**
     *  圆
     */
    kDrawShapeRound = 1 << 2,
    /**
     *  直线
     */
    kDrawShapeLine = 1 << 3,
    /**
     *  箭头
     */
    kDrawShapeArrow = 1 << 4
};

/**
 *  涂鸦宽度
 */
typedef NS_OPTIONS(NSUInteger, JRDrawLineWidthType) {
    /**
     *  宽度2
     */
    kDrawLineWidthThin = 2,
    /**
     *  宽度4
     */
    kDrawLineWidthMiddle = 2 << 1,
    /**
     *  宽度8
     */
    kDrawLineWidthBigger = 2 << 2,
    /**
     *  宽度16
     */
    kDrawLineWidthBiggest = 2 << 3
};


#endif /* Enumeration_h */
