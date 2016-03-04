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
 *  @brief <#Description#>
 *
 *  @param scroller <#scroller description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)numberOfScroller:(NHScroller *)scroller;

/*!
 *  @brief <#Description#>
 *
 *  @param scroller <#scroller description#>
 *  @param index    <#index description#>
 *
 *  @return <#return value description#>
 */
- (UIView *)viewForScroller:(NHScroller *)scroller forIndex:(NSInteger)index;

@end

@protocol NHScrollerDelegate <NSObject>

/*!
 *  @brief <#Description#>
 *
 *  @param scroller <#scroller description#>
 *  @param index    <#index description#>
 */
- (void)scroller:(NHScroller *)scroller didScrollToIndex:(NSInteger)index;

@end