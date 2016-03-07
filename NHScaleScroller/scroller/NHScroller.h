//
//  NHScroller.h
//  NHScaleScroller
//
//  Created by hu jiaju on 16/3/4.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NHScrollerDataSource;
@protocol NHScrollerDelegate;
@interface NHScroller : UIView

@property (nonatomic, assign) CGFloat pageWidth,pageHeiht;

@property (nonatomic, assign) id<NHScrollerDataSource> dataSource;
@property (nonatomic, assign) id<NHScrollerDelegate> delegate;

@end

@protocol NHScrollerDataSource <NSObject>

/*!
 *  @brief requery the number
 *
 *  @param scroller the scroller
 *
 *  @return the number of scroller
 */
- (NSInteger)numberOfScroller:(NHScroller *)scroller;

/*!
 *  @brief query view
 *
 *  @param scroller the scroller
 *  @param index    index for view
 *
 *  @return the destnation view
 */
- (UIView *)viewForScroller:(NHScroller *)scroller forIndex:(NSInteger)index;

@end

@protocol NHScrollerDelegate <NSObject>

/*!
 *  @brief did scroll
 *
 *  @param scroller the scroller
 *  @param index    index for view
 */
- (void)scroller:(NHScroller *)scroller didScrollToIndex:(NSInteger)index;

@end