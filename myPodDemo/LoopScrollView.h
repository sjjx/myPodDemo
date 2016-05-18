//
//  LoopScrollView.h
//  SJLoopScrollView
//
//  Created by tuandai on 16/3/17.
//  Copyright © 2016年 sj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIScrollViewDirection) {
    /*水平方向*/
    UIScrollViewHorizontalDirection,
    /*垂直方向*/
    UIScrollViewVerticalDirection
};

@protocol LoopScrollViewDataSource <NSObject>

@optional

- (UIView *)LoopScrollView:(NSInteger)pageIndex;

@end


@protocol LoopScrollViewDelegate <NSObject>

- (void)LoopScrollViewAction:(NSInteger)tapAction;

@end

@interface LoopScrollView : UIScrollView

@property (nonatomic, weak) id<LoopScrollViewDataSource> loopScrollDataSource;

@property (nonatomic, weak) id<LoopScrollViewDelegate> loopScrollDelegate;

/**
 *  @author SJ, 16-03-17 14:03:36
 *
 *  初始化一个轮巡的scrollview，并指定滚动的方向
 *
 *  @param frame     frame
 *  @param direction 垂直／水平
 *  @param direction 时间间隔
 *
 *  @return UIScrollView
 */
- (instancetype)initWithFrame:(CGRect)frame
                withDirection:(UIScrollViewDirection)direction
                 withDuration:(CGFloat)duration;


@end
