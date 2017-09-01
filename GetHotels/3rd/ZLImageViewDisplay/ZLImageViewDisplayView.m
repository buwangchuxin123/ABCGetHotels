//
//  ZLImageViewDisplayView.m
//  ZLImageViewDisplay
//
//  Created by Mr.LuDashi on 15/8/14.
//  Copyright (c) 2015年 ludashi. All rights reserved.
//

#import "ZLImageViewDisplayView.h"
#import "UIImageView+WebCache.h"

@interface ZLImageViewDisplayView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIPageControl *mainPageControl;
@property (nonatomic, assign) CGFloat widthOfView;
@property (nonatomic, assign) CGFloat heightView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) UIViewContentMode imageViewcontentModel;
@property (nonatomic, strong) UIPageControl *imageViewPageControl;
@property (nonatomic, strong) TapImageViewButtonBlock block;
@end

@implementation ZLImageViewDisplayView

#pragma -- 遍历构造器
+ (instancetype) zlImageViewDisplayViewWithFrame: (CGRect) frame {
    ZLImageViewDisplayView *instance = [[ZLImageViewDisplayView alloc] initWithFrame:frame];
    return instance;
}


#pragma -- mark 遍历初始化方法
- (instancetype)initWithFrame: (CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _widthOfView = frame.size.width;            //获取滚动视图的宽度
        _heightView = frame.size.height;            //获取滚动视图的高度
        _scrollInterval = 3;
        _animationInterVale = 0.7;
        _currentPage = 1;                           //当前显示页面
        _imageViewcontentModel = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)layoutSubviews {
    [self initMainScrollView];                          //初始化滚动视图
    [self addImageviewsForMainScroll];    //添加ImageView
    [self addTimerLoop];            //添加timer
    [self addPageControl];
    [self initImageViewButton];
}


- (void)addTapEventForImageWithBlock:(TapImageViewButtonBlock) block{
    if (_block == nil) {
        if (block != nil) {
            _block = block;
        }
    }
}


#pragma -- mark 初始化按钮
- (void)initImageViewButton{
    for( int i = 0; i < _imageViewArray.count + 1; i ++) {
        
        CGRect currentFrame = CGRectMake(_widthOfView * i, 0, _widthOfView, _heightView);
        
        UIButton *tempButton = [[UIButton alloc] initWithFrame:currentFrame];
        [tempButton addTarget:self action:@selector(tapImageButton:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            tempButton.tag = _imageViewArray.count;
        } else {
            tempButton.tag = i;
        }
        [_mainScrollView addSubview:tempButton];
    }
}


- (void) tapImageButton: (UIButton *) sender{
    if (_block) {
        _block(sender.tag);
    }
}

/**
 *  初始化ScrollView
 */
- (void) initMainScrollView{
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _widthOfView, _heightView)];
    _mainScrollView.contentSize = CGSizeMake(_widthOfView, _heightView);
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.delegate = self;
    [self addSubview:_mainScrollView];
}

/**
 *  添加PageControl
 */
- (void) addPageControl{
    _imageViewPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _heightView - 20, _widthOfView, 20)];
    
    _imageViewPageControl.numberOfPages = _imageViewArray.count;
    
    _imageViewPageControl.currentPage = _currentPage - 1;
    
    _imageViewPageControl.tintColor = [UIColor blackColor];
    
    [self addSubview:_imageViewPageControl];
}


/**
 *  给ScrollView添加ImageView
 */
-(void) addImageviewsForMainScroll{
    if (_imageViewArray != nil) {
        //设置ContentSize
        _mainScrollView.contentSize = CGSizeMake(_widthOfView * (_imageViewArray.count+1), _heightView);
        
        for ( int i = 0; i < _imageViewArray.count + 1; i ++) {
            CGRect currentFrame = CGRectMake(_widthOfView * i, 0, _widthOfView, _heightView);
            UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:currentFrame];
            tempImageView.contentMode = _imageViewcontentModel;
            tempImageView.clipsToBounds = YES;
            NSString *imageName;
            
            if (i == 0) {
                imageName = [_imageViewArray lastObject];
            } else {
                imageName = _imageViewArray[i - 1];
            }
            
            //说明是URL
         if ([self verifyURL:imageName]){
                NSURL *url = [NSURL URLWithString:imageName];
             
//             
//             NSString *userAgent = @"";
//             userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
//             
//             if (userAgent) {
//                 if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
//                     NSMutableString *mutableUserAgent = [userAgent mutableCopy];
//                     if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
//                         userAgent = mutableUserAgent;
//                     }
//                 }
//                 [[SDWebImageDownloader sharedDownloader] setValue:userAgent forHTTPHeaderField:@"User-Agent"];
//             }

             
                [SDWebImageDownloader.sharedDownloader setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
        //        [tempImageView sd_setImageWithURL:url
        //                         placeholderImage:[UIImage imageNamed:@"酒店-1"]];
  
             
             [tempImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"酒店-1"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                  // NSLog(@"=====error=%@",error);
             }];
             
                
            } else {
//                NSLog(@"名字是：%@",imageName);
//                NSString *str = @"http://ac-tscmo0vq.clouddn.com/8060e54840115e3dc743.png";
//                NSString* imageName1 = imageName;
//                if([imageName1 isEqualToString: str]){
//                    
//                    UIImage *imageTemp = [UIImage imageNamed:@"二"];
//                    [tempImageView setImage:imageTemp];
//                }else{
                UIImage *imageTemp = [UIImage imageNamed:imageName];
                [tempImageView setImage:imageTemp];
                
                // NSLog(@"我不是网址");
                
            }
            
            //
            
            
            [_mainScrollView addSubview:tempImageView];
        }
        _mainScrollView.contentOffset = CGPointMake(_widthOfView, 0);
    }
}

-(BOOL) verifyURL:(NSString *)url{
    
    
    NSString *pattern = @"((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:url];
     return isMatch;
    //return YES;
    
}

- (void) addTimerLoop{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_scrollInterval target:self selector:@selector(changeOffset) userInfo:nil repeats:YES];
    }
}

- (void)changeOffset{
    
    _currentPage ++;
    
    if (_currentPage == _imageViewArray.count + 1) {
        _currentPage = 1;
    }
    
    [UIView animateWithDuration:_animationInterVale animations:^{
        _mainScrollView.contentOffset = CGPointMake(_widthOfView * _currentPage, 0);
    } completion:^(BOOL finished) {
        if (_currentPage == _imageViewArray.count) {
            _mainScrollView.contentOffset = CGPointMake(0, 0);
        }
    }];
    
     _imageViewPageControl.currentPage = _currentPage - 1;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentPage = scrollView.contentOffset.x / _widthOfView;
    if(currentPage == 0){
        _mainScrollView.contentOffset = CGPointMake(_widthOfView * _imageViewArray.count, 0);
        _imageViewPageControl.currentPage = _imageViewArray.count;
        _currentPage = _imageViewArray.count;
        [self resumeTimer];
        return;
    }
    
    if (_currentPage + 1 == currentPage || currentPage == 1) {
        _currentPage = currentPage;
        
        if (_currentPage == _imageViewArray.count + 1) {
            _currentPage = 1;
        }
        
        if (_currentPage == _imageViewArray.count) {
            _mainScrollView.contentOffset = CGPointMake(0, 0);
        }
        
        _imageViewPageControl.currentPage = _currentPage - 1;
        [self resumeTimer];
        return;
    }
    
    
}

/**
 *  暂停定时器
 */
-(void)resumeTimer{
    
    if (![_timer isValid]) {
        return ;
    }
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_scrollInterval-_animationInterVale]];
}


@end
