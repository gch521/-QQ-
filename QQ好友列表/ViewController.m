//
//  ViewController.m
//  QQ好友列表
//
//  Created by gch on 16/10/14.
//  Copyright © 2016年 gch. All rights reserved.
//

#import "ViewController.h"
#import "Friend.h"
#import "Group.h"
#import "List.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *dataList;   // 数据
@property (nonatomic, retain) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initDataList];   // 初始化数据
    
    // 向下移20
    CGRect frame = self.view.frame;
    frame.origin.y = 20;
    frame.size.height = frame.size.height - 20;
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    
    // 设置委托
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - DataSource实现
// 一共几个section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataList count];
}

// 每个section下有多少个组
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    List *list = [self.dataList objectAtIndex:section];
    NSMutableArray *array = list.groups;
    NSInteger all = [array count];
    for (Group *group in array) {
        if (group.isDelop) {
            all = all + [group.friends count];
        }
    }
    return all;
}

// 显示每个cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isGroup:indexPath]) {
        return [self getGroupCell:tableView and:indexPath];   // 分组的cell
    }
    return [self getFriendCell:tableView and:indexPath];      // 好友cell
}

/*
 * 获得section标题
 **/
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    List *list = [self.dataList objectAtIndex:section];
    return list.title;
}

#pragma mark - 点击事件
// 单击的处理，若是分组 则展开，否则不处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [UIView animateWithDuration:0.5f animations:^{
        Group *group = [self isGroup:indexPath];
        // 如果点击的是分组，则取当前状态的反并更新数据
        if (group) {
            group.isDelop = !group.isDelop;
            [self.tableView reloadData];
        }
    }];
    Friend *f = [self isFriend:indexPath];
    if (f.name.length == 0) {
        
    } else {
    NSLog(@"-------------------------%@", f.name);
    }
}
#pragma mark - 获取点击位置的数据
/*
 * 所点位置是否是分组，返回所点分组数据
 **/
- (Group *)isGroup:(NSIndexPath *)indexPath {
    int num = -1;
    NSUInteger index = indexPath.row;
    
    List *list = [_dataList objectAtIndex:indexPath.section];
    NSMutableArray *groups = list.groups;
    for (Group *group in groups) {
        num++;
        if (index == num) {
            return group;
        }
        if (group.isDelop) {
            num += [group.friends count];
            if (index <= num) {
                return nil;
            }
        }
    }
    return nil;
}

/*
 * 所点位置是否是好友，并返回所点好友数据
 **/
- (Friend *)isFriend:(NSIndexPath *)indexPath {
    int num = -1;
    int index = (int)indexPath.row;
    List *list = [_dataList objectAtIndex:indexPath.section];  // 获取点的section
    NSMutableArray *groups = list.groups;                      // 获取section下的所有分组
    for (Group *group in groups) {
        num++;
      //  NSLog(@"index==%d===num==%d", index, num); 注释:index等于num是分组
        if (index != num) {
            if (group.isDelop) {
                int temp = num;
                num += [group.friends count];
                NSLog(@"a == %d", num);
                if (index <= num ) {
                    int k = index - temp - 1;
                    return [group.friends objectAtIndex:k];
                }
            }
        } else {
            NSLog(@"-------%@", group.title);
        }
    }
    return nil;
}

#pragma mark - 初始化cell
/*
 * 设置分组的cell
 **/
- (UITableViewCell *)getGroupCell:(UITableView *)tableView and:(NSIndexPath *)indexPath {
    Group *nowGroup = [self isGroup:indexPath];
    static NSString *CellWithIdentifier = @"GroupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
        cell.backgroundColor = [UIColor colorWithRed:227/250.0 green:168/250.0 blue:105/250.0 alpha:1];
    }
    
    cell.textLabel.text = nowGroup.title;
    cell.detailTextLabel.text = nowGroup.detail;
    if (nowGroup.isDelop) {
        cell.imageView.image = [UIImage imageNamed:@"collect.png"];
    }
    else {
        cell.imageView.image = [UIImage imageNamed:@"tomore.png"];
    }
    return cell;
}

/*
 * 设置好友cell
 **/
- (UITableViewCell *)getFriendCell:(UITableView *)tableView and:(NSIndexPath *)indexPath {
    Friend *nowFriend = [self isFriend:indexPath];
    static NSString *CellWithIdentifier = @"FriendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellWithIdentifier];
    }
    // 设置cell数据
    cell.textLabel.text = nowFriend.name;
    cell.detailTextLabel.text = nowFriend.state;
    cell.imageView.image = [UIImage imageNamed:nowFriend.image];
    return cell;
}

#pragma mark - 大小样式设置
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isGroup:indexPath]) {
        return 30;   // 分组高
    }
    return 40;       // 好友的行高
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

#pragma mark - 所显示的数据
/*
 * 数据初始化构造
 **/
- (void)initDataList {
    
    NSArray *friendNameArray1 = @[@"苦海无涯", @"段天涯", @"小妹妹", @"呼哈"];
    NSArray *friendStatesArray1 = @[@"[在线] 哎 心疼!!", @"[在线] 心疼!!", @"[在线] 疼!!", @"[在线]心疼!!"  ];
    NSMutableArray *array1 = [NSMutableArray array];
    for (int i = 0; i < 4; i ++) {
        Friend *friend1 = [[Friend alloc] init];
        friend1.name = friendNameArray1[i];
        friend1.state = friendStatesArray1[i];
        [array1 addObject:friend1];
        
    }
    
    
    
    Group *group1 = [[Group alloc] init];
    group1.detail = @"4/4";
    group1.title = @"家人";
    group1.isDelop = NO;
    group1.friends = array1;
    
    
    NSArray *friendNameArray2 = @[@"段", @"商人", @"大哥"];
    NSArray *friendStatesArray2 = @[@"[在线]心疼!!", @"[在线]疼!!", @"[离线] 疼!!"];
    NSMutableArray *array2 = [NSMutableArray array];
    for (int i = 0; i < 3; i ++) {
        Friend *friend1 = [[Friend alloc] init];
        friend1.name = friendNameArray2[i];
        friend1.state = friendStatesArray2[i];
        [array2 addObject:friend1];
        
    }
    Group *group2 = [[Group alloc] init];
    group2.detail = @"2/3";
    group2.title = @"朋友";
    group2.isDelop = NO;
    group2.friends = array2;
    
    NSArray *friendNameArray3 = @[@"顾", @"成", @"辉", @"我", @"还", @"是", @"大", @"哥"];
    NSArray *friendStatesArray3 = @[@"[在线]心疼!!", @"[在线]疼!!", @"[离线] 疼!!", @"[在线]疼!!", @"[离线] 疼!!" ,@"[在线]疼!!", @"[离线] 疼!!", @"[在线]疼!!"];
    NSMutableArray *array3 = [NSMutableArray array];
    for (int i = 0; i < friendNameArray3.count; i ++) {
        Friend *friend1 = [[Friend alloc] init];
        friend1.name = friendNameArray3[i];
        friend1.state = friendStatesArray3[i];
        [array3 addObject:friend1];
        
    }
    Group *group3 = [[Group alloc] init];
    group3.detail = @"3/8";
    group3.title = @"工作";
    group3.isDelop = NO;
    group3.friends = array3;
    
    NSMutableArray *l1 = [NSMutableArray arrayWithObjects:group1, group2, group3,nil];
    List *list1 = [[List alloc] init];
    list1.title = @"我的好友";
    list1.groups = l1;
    
    Friend *mobile = [[Friend alloc] init];
    mobile.name = @"我的手机";
    mobile.state = @"[离线]手机未上线";
    NSMutableArray *array = [NSMutableArray arrayWithObjects:mobile, nil];
    Group *group = [[Group alloc] init];
    group.detail = @"0/1";
    group.title = @"我的设备";
    group.isDelop = NO;
    group.friends = array;
    
    NSMutableArray *l2 = [NSMutableArray arrayWithObjects:group, nil];
    List *list2 = [[List alloc] init];
    list2.title = @"我的手机";
    list2.groups = l2;
    self.dataList = [NSMutableArray arrayWithObjects:list2, list1, nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
