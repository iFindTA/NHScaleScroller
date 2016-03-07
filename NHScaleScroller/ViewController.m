//
//  ViewController.m
//  NHScaleScroller
//
//  Created by hu jiaju on 16/3/4.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "ViewController.h"
#import "NHScroller.h"

@interface Page : UIView

@property (nonatomic, assign) NSInteger index;

- (id)initWithFrame:(CGRect)frame withIndex:(NSInteger)index;

@end

@implementation Page

- (id)initWithFrame:(CGRect)frame withIndex:(NSInteger)index {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.index = index;
        [self setNeedsDisplay];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touch index :%zd",self.index);
}

- (void)drawRect:(CGRect)rect {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:30],NSFontAttributeName, nil];
    NSString *info = [NSString stringWithFormat:@"index:%zd",self.index];
    [info drawInRect:rect withAttributes:attributes];
}

@end

@interface ViewController ()<NHScrollerDelegate, NHScrollerDataSource>

@property (nonatomic, strong) NHScroller *scroller;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.scroller];
    [self.scroller mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(270, 0, 270, 0));
    }];
    CGSize cardSize = CGSizeMake(200, 200);
    self.scroller.pageWidth = cardSize.width;
    self.scroller.pageHeiht = cardSize.height;
    self.scroller.dataSource = self;
    self.scroller.delegate = self;
}

- (NHScroller *)scroller {
    if (_scroller == nil) {
        _scroller = [[NHScroller alloc] initWithFrame:CGRectZero];
        _scroller.backgroundColor = [UIColor lightGrayColor];
    }
    return _scroller;
}

- (NSInteger)numberOfScroller:(NHScroller *)scroller {
    return 3;
}

- (UIView *)viewForScroller:(NHScroller *)scroller forIndex:(NSInteger)index {
    Page *page = [[Page alloc] initWithFrame:CGRectZero withIndex:index];
    page.backgroundColor = [UIColor lightGrayColor];
    return page;
}

- (void)scroller:(NHScroller *)scroller didScrollToIndex:(NSInteger)index {
    NSLog(@"did select index :%zd",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
