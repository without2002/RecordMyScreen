//
//  CSPictureListViewController.m
//  RecordMyScreen
//
//  Created by 吴海涛 on 7/8/15.
//  Copyright (c) 2015 CoolStar Organization. All rights reserved.
//

#import "CSPictureListViewController.h"
#import "CSRecordingPicListViewController.h"

@interface CSPictureListViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation CSPictureListViewController
{
    UITableView *_tableview;
    NSMutableArray *_arrPicDirs;
}

-(id)init{
    if (self = [super init]) {
        _arrPicDirs = [[NSMutableArray alloc] init];
        self.title = @"Picture";
        self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"list"] tag:0] autorelease];
    }
    
    return self;
}

-(void)dealloc{
    [_arrPicDirs release];
    [super dealloc];
}

-(void)initData{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    
    [_arrPicDirs removeAllObjects];
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:cacheDirectory];
    [dirEnum skipDescendants];
    
    NSString *file = nil;
    while (file = [dirEnum nextObject]) {
        BOOL bFlagDir = NO;
        [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@", cacheDirectory, file] isDirectory:&bFlagDir];
        if (bFlagDir) {
            [dirEnum skipDescendants];
        }
        if ([file hasPrefix:@"Picture_"]) {
            [_arrPicDirs addObject:file];
        }
    }
}

-(void)initView{
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.view addSubview:_tableview];
    [_tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initView];
}

-(void)viewDidAppear:(BOOL)animated{
    [self initData];
    [_tableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)removeDirectory:(NSString *)dir
{
    [[NSFileManager defaultManager] removeItemAtPath:dir error:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrPicDirs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = _arrPicDirs[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    NSString *dirPicPath = [NSString stringWithFormat:@"%@/%@", cacheDirectory, _arrPicDirs[indexPath.row]];
    
    UICollectionViewFlowLayout *layout = [[[UICollectionViewFlowLayout alloc] init] autorelease];
    layout.itemSize = CGSizeMake(([[UIScreen mainScreen] bounds].size.width - 30) / 2, 240);
    layout.minimumLineSpacing = 15;
    CSRecordingPicListViewController *picViewVC = [[[CSRecordingPicListViewController alloc] initWithCollectionViewLayout:layout] autorelease];
    picViewVC.dirPicPath = dirPicPath;
    
    [self.navigationController pushViewController:picViewVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cacheDirectory = [paths objectAtIndex:0];
        NSString *dirPicPath = [NSString stringWithFormat:@"%@/%@", cacheDirectory, _arrPicDirs[indexPath.row]];
        [self removeDirectory:dirPicPath];

        [_arrPicDirs removeObjectAtIndex:indexPath.row];
        
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
