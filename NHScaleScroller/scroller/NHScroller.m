//
//  NHScroller.m
//  NHScaleScroller
//
//  Created by hu jiaju on 16/3/4.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHScroller.h"

@interface innerScroll : UIScrollView

@end

@implementation innerScroll

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return true;
}

@end

@interface lazyScroll : innerScroll

@end

@implementation lazyScroll

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //self.delegate = self;
        self.clipsToBounds = false;
        self.pagingEnabled = true;
        self.bouncesZoom = false;
        self.showsVerticalScrollIndicator = false;
        self.showsHorizontalScrollIndicator = false;
    }
    return self;
}

@end

@interface NHScroller ()<UIScrollViewDelegate>

@property (nonatomic, strong) lazyScroll *scroll;
@property (nonatomic, strong) MASConstraint *widthConstraint,*heihtConstraint;

@end

static CGFloat minTinderScale = 0.7f;
static CGFloat maxTinderScale = 1.0f;
static CGFloat pageOffset = 10.f;

@implementation NHScroller

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _initSetup];
    }
    return self;
}

- (lazyScroll *)scroll {
    if (_scroll == nil) {
        _scroll = [[lazyScroll alloc] initWithFrame:CGRectZero];
        __weak typeof(self) weakSelf = self;
        _scroll.delegate = weakSelf;
    }
    return _scroll;
}

- (void)setPageWidth:(CGFloat)pageWidth {
    _pageWidth = pageWidth;
    if (pageWidth <= 0) {
        [self.widthConstraint activate];
    }else{
        [self.widthConstraint deactivate];
        [self.scroll mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo([NSNumber numberWithFloat:self.pageWidth]);
        }];
    }
}

- (void)setPageHeiht:(CGFloat)pageHeiht {
    _pageHeiht = pageHeiht;
    if (pageHeiht <= 0) {
        [self.heihtConstraint activate];
    }else{
        [self.heihtConstraint deactivate];
        [self.scroll mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo([NSNumber numberWithFloat:self.pageHeiht]);
        }];
    }
}

- (void)setDataSource:(id<NHScrollerDataSource>)dataSource {
    if (dataSource) {
        _dataSource = dataSource;
        [self reloaData];
    }
}

- (void)_initSetup {
    __weak typeof(self) weakSelf = self;
    [self addSubview:self.scroll];
    [self.scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo([NSNumber numberWithFloat:self.pageWidth]);
        make.height.equalTo([NSNumber numberWithFloat:self.pageHeiht]);
        weakSelf.widthConstraint = make.width.equalTo(self.mas_width).priorityHigh();
        weakSelf.heihtConstraint = make.height.equalTo(self.mas_height).priorityHigh();
    }];
}

- (void)reloaData {
    [self.scroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger counts = [self.dataSource numberOfScroller:self];
    
    for (int i = 0; i < counts; i++) {
        UIView *tmp = [self.dataSource viewForScroller:self forIndex:i];
        
        CGRect frame = CGRectMake(i*self.pageWidth, 0, self.pageWidth, self.pageHeiht);
        UIView *back = [[UIView alloc] initWithFrame:frame];
        back.backgroundColor = [self randomColor];
        CGRect bounds = CGRectInset(back.bounds, pageOffset, pageOffset);
        tmp.frame = bounds;
        [back addSubview:tmp];
        [self.scroll addSubview:back];
    }
    
    CGFloat pageWidth = self.pageWidth;
    if (counts > 2) {
        CGPoint offset = CGPointMake(self.pageWidth, 0);
        [self.scroll setContentOffset:offset animated:false];
    }else{
        pageWidth += (counts == 1?1.f:0.f);
        [self updateSubviewsState];
    }
    self.scroll.contentSize = CGSizeMake(counts*pageWidth, self.pageHeiht);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateSubviewsState];
}

- (void)updateSubviewsState {
    NSArray *subviews = [self.scroll subviews];
    [subviews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *tmp = (UIView *)obj;
        CGFloat percent = fabs((tmp.center.x - (self.scroll.contentOffset.x+self.pageWidth*0.5))/self.pageWidth);
        percent = MIN(1, percent);
        CGFloat scale = maxTinderScale-(maxTinderScale-minTinderScale)*percent;
        tmp.transform = CGAffineTransformMakeScale(scale, scale);
    }];
}

- (UIColor *)randomColor {
    CGFloat randomR = drand48();
    CGFloat randomG = drand48();
    CGFloat randomB = drand48();
    
    return [UIColor colorWithRed:randomR green:randomG blue:randomB alpha:1.0];
}

@end
