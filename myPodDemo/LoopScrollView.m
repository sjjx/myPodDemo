//
//  LoopScrollView.m
//  SJLoopScrollView
//
//  Created by tuandai on 16/3/17.
//  Copyright © 2016年 sj. All rights reserved.
//

#import "LoopScrollView.h"

@interface NSTimer (Addition)

/**
 *  @author SJ, 16-03-17 15:03:04
 *
 *  取消定时器
 */
- (void)pause ;

/**
 *  @author SJ, 16-03-17 15:03:17
 *
 *  重新开启定时器
 */
- (void)resume ;

@end

@implementation NSTimer (Addition)

- (void)pause
{
    [self setFireDate:[NSDate distantFuture]];
}

- (void)resume
{
    [self setFireDate:[NSDate date]];
}

@end

@interface LoopScrollView ()<UIScrollViewDelegate>

/**
 *  @author SJ, 16-03-17 15:03:59
 *
 *  滚动的方向
 */
@property (nonatomic, assign) UIScrollViewDirection direction;

/**
 *  @author SJ, 16-03-17 15:03:25
 *
 *  滚动的时间间隔
 */
@property (nonatomic, assign) CGFloat duration;

/**
 *  @author SJ, 16-03-17 15:03:44
 *
 *  是否使用运行循环
 */
@property (nonatomic, assign) BOOL isLoop;

/**
 *  @author SJ, 16-03-17 15:03:53
 *
 *  控制scrollview运行循环
 */
@property (nonatomic, strong) NSTimer *scrollTimerLoop;


/**
 *  @author SJ, 16-03-17 15:03:28
 *
 *  手势触碰后的等待循环
 */
@property (nonatomic, strong) NSTimer *waitTimeLoop;

/**
 *  @author SJ, 16-03-18 14:03:15
 *
 *  左边的view
 */
@property (nonatomic, strong) UIView *leftView;

/**
 *  @author SJ, 16-03-18 14:03:24
 *
 *  中间的view
 */
@property (nonatomic, strong) UIView *middleView;

/**
 *  @author SJ, 16-03-18 14:03:41
 *
 *  右边的view
 */
@property (nonatomic, strong) UIView *rightView;


@end

@implementation LoopScrollView

- (instancetype)initWithFrame:(CGRect)frame
                withDirection:(UIScrollViewDirection)direction
                 withDuration:(CGFloat)duration {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.direction      = direction;
        self.delegate       = self;
        self.pagingEnabled  = YES;
        self.duration       = duration;
        
        self.showsHorizontalScrollIndicator = YES;
        self.showsVerticalScrollIndicator   = YES;
        
        
        self.scrollTimerLoop =  [NSTimer timerWithTimeInterval:duration
                                                        target:self
                                                      selector:@selector(loopAction)
                                                      userInfo:nil
                                                       repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.scrollTimerLoop
                                     forMode:NSDefaultRunLoopMode];
        
    }
    
    return self;
    
}


#pragma mark - OverWrite

- (void)setDirection:(UIScrollViewDirection)direction {
    
    _direction = direction;
    if (_direction == UIScrollViewHorizontalDirection) {
        self.contentSize = CGSizeMake(3*self.frame.size.width, self.frame.size.height);
    }else {
        self.contentSize = CGSizeMake(self.frame.size.width, 3*self.frame.size.height);
    }
    
}

#pragma mark - private

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    return 1;
}

/**
 *  @author SJ, 16-03-17 15:03:15
 *
 *  重新启用定时器
 */
- (void)resumeTimerWithDelay
{
    [self.scrollTimerLoop pause] ;
    
    if (!self.isLoop)
    {
        if ([self.waitTimeLoop isValid])
        {
            [self.waitTimeLoop invalidate] ;
        }
        
        self.waitTimeLoop = [NSTimer timerWithTimeInterval:self.duration
                                                    target:self
                                                  selector:@selector(timerIsOverflow)
                                                  userInfo:nil
                                                   repeats:NO] ;
        
        [[NSRunLoop currentRunLoop] addTimer:self.waitTimeLoop
                                     forMode:NSDefaultRunLoopMode] ;
        
    }
}

- (void)timerIsOverflow
{
    self.isLoop = YES;
    
    [self.scrollTimerLoop resume];
    self.isLoop = NO;
    
    [self.waitTimeLoop invalidate];
    self.waitTimeLoop = nil ;
}

- (void)loopAction {
    CGPoint newOffset;
    if (self.direction == UIScrollViewHorizontalDirection) {
       newOffset = CGPointMake(self.contentOffset.x + CGRectGetWidth(self.frame), self.contentOffset.y);
    }else {
       newOffset = CGPointMake(self.contentOffset.x , self.contentOffset.y + CGRectGetHeight(self.frame));
    }
    [self setContentOffset:newOffset animated:YES];
    
    CGFloat contentOffsetX = self.contentOffset.x;
    
    [self configLoopScrollView:contentOffsetX];
}

- (void)configLoopScrollView:(CGFloat)contentOffsetX {
    
    NSInteger index = contentOffsetX/CGRectGetWidth(self.bounds);
    
    if (index >= 5) {
        index = 0;
    }
    
    if (index == 4) {
        [self setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0) animated:NO];
    }
    
    if ([self.loopScrollDataSource respondsToSelector:@selector(LoopScrollView:)]) {
        UIView *view = [self.loopScrollDataSource LoopScrollView:index];
        [self addSubview:view];
    }
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self resumeTimerWithDelay];
    
    [self configLoopScrollView:self.contentOffset.x];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

@end
