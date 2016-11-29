//
//  ViewController.m
//  Carousel
//
//  Created by txx on 16/11/29.
//  Copyright © 2016年 txx. All rights reserved.
//

//适配从0张到n张img

#import "ViewController.h"

#define SCREEN_W  [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView   *scrollView;
@property(nonatomic,strong)UIImageView    *leftImgView;
@property(nonatomic,strong)UIImageView    *centerImgView;
@property(nonatomic,strong)UIImageView    *rightImgView;
@property(nonatomic,strong)UILabel        *titleLabel;
@property(nonatomic,strong)UIPageControl  *pageControl;

@property(nonatomic,strong)NSArray        *imgs;
/**
 img的数量
 */
@property(nonatomic,assign)NSUInteger      imgCount;

/**
 当前展示的index
 */
@property(nonatomic,assign)NSUInteger      currentSelectIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self loadData];
    if (_imgCount) {
        [self.view addSubview:self.scrollView];
        [self.view addSubview:self.pageControl];
        [self.view addSubview:self.titleLabel];
    }
    
}
/**
 滑动停止的时候delegate
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self reloadImg];
}
/**
 重新加载数据
 */
-(void)reloadImg
{
    CGPoint offset = [_scrollView contentOffset];
    if (offset.x > SCREEN_W*1.5) {
        //slip right
        _currentSelectIndex = (_currentSelectIndex +1)%_imgCount;
    }else if(offset.x < SCREEN_W *0.5)
    {
        //slip left
        _currentSelectIndex = (_currentSelectIndex -1 + _imgCount)%_imgCount ;
    }else
    {
        return;
    }
    _centerImgView.image = [UIImage imageNamed:_imgs[_currentSelectIndex][@"name"]];
    
    //resetting left & right img
    
    NSUInteger leftImgIndex = (_currentSelectIndex -1 + _imgCount)%_imgCount ;
    NSUInteger rightImgIndex = (_currentSelectIndex +1)%_imgCount;
    _leftImgView.image = [UIImage imageNamed:_imgs[leftImgIndex][@"name"]];
    _rightImgView.image = [UIImage imageNamed:_imgs[rightImgIndex][@"name"]];
    
    //adjust scrollView offset
    [_scrollView setContentOffset:CGPointMake(SCREEN_W, 0) animated:NO];
    _pageControl.currentPage = _currentSelectIndex ;
    _titleLabel.text = [_imgs[_currentSelectIndex] objectForKey:@"desc"];

}
/**
 加载数据
 */
-(void)loadData
{
    _imgs = @[@{@"name":@"0.jpg",@"desc":@"0.flower"},@{@"name":@"1.jpg",@"desc":@"1.girl"},@{@"name":@"2.jpg",@"desc":@"2.dog"},@{@"name":@"3.jpg",@"desc":@"3.car"},@{@"name":@"4.jpg",@"desc":@"4.sleep girl"}];
    _imgCount = _imgs.count ;
    _currentSelectIndex = 0 ;

}
-(UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.numberOfPages = _imgCount;
        
        //此方法可以根据页数返回UIPageControl合适的大小
        CGSize size = [_pageControl sizeForNumberOfPages:_imgCount];
        _pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
        _pageControl.center = CGPointMake(SCREEN_W/2, 280);
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    }
    return _pageControl;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 80, SCREEN_W-200, 50)];
        _titleLabel.text = [_imgs[0] objectForKey:@"desc"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 200, SCREEN_W, 100)];
        _scrollView.delegate = self ;
        _scrollView.backgroundColor = [UIColor grayColor];
        _scrollView.contentSize = CGSizeMake(SCREEN_W * 3, 100);
        [_scrollView setContentOffset:CGPointMake(SCREEN_W, 0) animated:NO];
        _scrollView.pagingEnabled = YES ;
        _scrollView.showsHorizontalScrollIndicator = NO ;
        [_scrollView addSubview:self.leftImgView];
        [_scrollView addSubview:self.centerImgView];
        [_scrollView addSubview:self.rightImgView];
    }
    return _scrollView ;
}
-(UIImageView *)leftImgView
{
    if (!_leftImgView) {
        NSString *imgName = [_imgs.lastObject objectForKey:@"name"];
        _leftImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgName]];
        _leftImgView.frame = CGRectMake(0, 0, SCREEN_W, 100);
    }
    return _leftImgView ;
}
-(UIImageView *)centerImgView
{
    if (!_centerImgView) {
        NSString *imgName = [_imgs.firstObject objectForKey:@"name"];
        _centerImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgName]];
        _centerImgView.frame = CGRectMake(SCREEN_W, 0, SCREEN_W, 100);
    }
    return _centerImgView ;
}
-(UIImageView *)rightImgView
{
    if (!_rightImgView) {
        NSString *imgName = nil;
        if (_imgCount == 1) {
            imgName = [_imgs[0] objectForKey:@"name"];
        }else
        {
            imgName = [_imgs[1] objectForKey:@"name"];
        }
        _rightImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgName]];
        _rightImgView.frame = CGRectMake(SCREEN_W *2, 0, SCREEN_W, 100);
    }
    return _rightImgView ;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
