//
//  GCDTableViewController.m
//  gcdtest
//
//  Created by greatstar on 2018/3/10.
//  Copyright © 2018年 greatstar. All rights reserved.
//

#import "GCDTableViewController.h"
#import "DemoViewController.h"



@interface GCDTableViewController ()


@property (nonatomic,strong) NSArray *dataProvider;
@end

@implementation GCDTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataProvider =  @[@{@"title" : @"队列",@"children":@[@{@"title" : @"串行队列",@"children":@"",@"selector":@"testSerialqueue"},
                                                            @{@"title" : @"并发队列",@"children":@"",@"selector":@"testConcurrentqueue"},
                                                            @{@"title" : @"主队列",@"children":@"",@"selector":@"testMainqueue"}]},
                           @{@"title" : @"任务的追加方式",@"children":@[@{@"title" : @"同步执行",@"children":@"",@"selector":@"testSync"},
                                                                 @{@"title" : @"异步执行",@"children":@"",@"selector":@"testAsync"}]},
                           @{@"title" : @"队列+任务组合",@"children":@[@{@"title" : @"同步执行 and 并发队列",@"children":@"",@"selector":@"syncAndConcurrentqueue"},
                                                                 @{@"title" : @"异步执行 and 并发队列",@"children":@"",@"selector":@"asyncAndConcurrentqueue"},
                                                                 @{@"title" : @"同步执行 and 串行队列",@"children":@"",@"selector":@"syncAndSerialqueue"},
                                                                 @{@"title" : @"异步执行 and 串行队列",@"children":@"",@"selector":@"asyncAndSerialqueue"},
                                                                 @{@"title" : @"同步执行 & 主队列（在主线程中会crash)",@"children":@"",@"selector":@"syncAndMainqueue"},
                                                                 @{@"title" : @"同步执行 & 主队列（在其它线程中）",@"children":@"",@"selector":@"othersyncAndMainqueue"},
                                                                 @{@"title" : @"异步执行 and 主队列",@"children":@"",@"selector":@"asyncAndMainqueue"}]},
                           @{@"title" : @"GCD其它常用API",@"children":@[
                                     @{@"title" : @"Dispatch Queue",@"children":@"",@"selector":@"getQueue"},
                                     @{@"title" : @"dispatch_queue_creat",@"children":@"",@"selector":@"queue_create"},
                                     @{@"title" : @"dispatch_set_target_queue",@"children":@"",@"selector":@"testTargetQueue1"},
                                     @{@"title" : @"dispatch_after",@"children":@"",@"selector":@"dispatch_after"},
                                     @{@"title" : @"dispatch_once",@"children":@"",@"selector":@"dispatch_once_1"},
                                     @{@"title" : @"dispatch_apply",@"children":@"",@"selector":@"dispatch_apply"},
                                     @{@"title" : @"dispatch_group",@"children":@"",@"selector":@"dispatch_group"},
                                     @{@"title" : @"dispatch_semaphore",@"children":@"",@"selector":@"dispatch_semaphore"},
                                     @{@"title" : @"Dispatch I/O",@"children":@"",@"selector":@"dispatch_IO"},
                                     @{@"title" : @"dispatch_barrier_async",@"children":@"",@"selector":@"dispatch_barrier_async"},
                                     @{@"title" : @"dispatch_suspend/dispatchp_resume",@"children":@"",@"selector":@"dispatch_suspend"},]},
                           ];
    
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataProvider.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = [self.dataProvider[section] objectForKey:@"children"];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"commonCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSArray *arr = [self.dataProvider[indexPath.section] objectForKey:@"children"];
    NSDictionary *dict =  arr[indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.dataProvider[section] objectForKey:@"title"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DemoViewController *vc = [[DemoViewController alloc] init];
    NSArray *arr = [self.dataProvider[indexPath.section] objectForKey:@"children"];
    vc.selectorStr = [arr[indexPath.row] objectForKey:@"selector"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
