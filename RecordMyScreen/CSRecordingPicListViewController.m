//
//  CSRecordingPicListViewController.m
//  RecordMyScreen
//
//  Created by 吴海涛 on 7/8/15.
//  Copyright (c) 2015 CoolStar Organization. All rights reserved.
//

#import "CSRecordingPicListViewController.h"

#define CELL_ID @"hello"

@interface CSRecordingPicListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSMutableArray *_arrData;
}

@end

@implementation CSRecordingPicListViewController

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithCollectionViewLayout:layout]) {
        _arrData = [[NSMutableArray alloc] init];
        self.title = @"Picture";
        self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"list"] tag:0] autorelease];
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELL_ID];
    }
    
    return self;
}

-(void)dealloc
{
    [_arrData release];
    
    [super dealloc];
}

-(void)initData{
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:_dirPicPath];
    [_arrData removeAllObjects];
    
    NSString *file = nil;
    while (file = [dirEnum nextObject]) {
        if ([file hasPrefix:@"frame_"]) {
            [_arrData addObject:[NSString stringWithFormat:@"%@/%@", _dirPicPath, file]];
        }
    }
    
    [_arrData sortedArrayUsingSelector:@selector(compare:)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

-(void)viewDidDisappear:(BOOL)animated{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [self initData];
    [self.collectionView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arrData.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[[UICollectionViewCell alloc] init] autorelease];
    }
    
//    cell.backgroundColor = [UIColor redColor];
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:101];
    if (!imgView) {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ([[UIScreen mainScreen] bounds].size.width - 60) / 2, 240)];
        [cell.contentView addSubview:imgView];
    }
    
//    NSData *data = [NSData dataWithContentsOfFile:_arrData[indexPath.row]];
    
//    CGDataProviderRef provider =  CGDataProviderCreateWithData(NULL,  data.bytes, [[UIScreen mainScreen] bounds].size.width * [[UIScreen mainScreen] bounds].size.height * 4, NULL);
//    CGImageRef cgImage = CGImageCreate([[UIScreen mainScreen] bounds].size.width,
//                                       [[UIScreen mainScreen] bounds].size.height,
//                                       8,
//                                       8*4,
//                                       4 * [[UIScreen mainScreen] bounds].size.width,
//                                       CGColorSpaceCreateDeviceRGB(),
//                                       kCGImageAlphaNoneSkipFirst |kCGBitmapByteOrder32Little,
//                                       provider,
//                                       NULL,
//                                       YES,
//                                       kCGRenderingIntentDefault);
//    UIImage *image = [UIImage imageWithCGImage:cgImage];
    imgView.image = [UIImage imageWithContentsOfFile:_arrData[indexPath.row]];
    
    return cell;
}

@end
