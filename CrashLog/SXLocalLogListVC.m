//
//  SXLocalLogListVC.m
//  SXExceptionLog
//
//  Created by Sunny on 2018/11/23.
//  Copyright © 2018 Sunny. All rights reserved.
//

#import "SXLocalLogListVC.h"
#import "SXMacro.h"
#import "SXLogHelper.h"
#import "SXLocalLogDetailVC.h"

@interface SXLocalLogListVC ()
<UIAlertViewDelegate
,UITableViewDelegate
,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *mAryLogs;

@end

@implementation SXLocalLogListVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = @"藏经阁";
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];

    [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];

    [rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [rightButton setTitle:@"挥刀自宫" forState:UIControlStateNormal];

    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];

    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    
    [self loadData];
    [self.view sendSubviewToBack:self.tableView];
}

- (void)loadData
{
    [self.mAryLogs removeAllObjects];
    
    NSArray *aryLocalLog = [SXLogHelper getLogsWithPrefixName:SX_CrashExceptionLog];
    
    if (SX_Ary_Is_Valid(aryLocalLog))
    {
        [self.mAryLogs addObjectsFromArray:aryLocalLog];
    }
    
    NSArray *aryLocalKSCrashLog = [SXLogHelper getLogsWithPrefixName:SX_CrashLocalExceptionLog];
    if (SX_Ary_Is_Valid(aryLocalKSCrashLog))
    {
        [self.mAryLogs addObjectsFromArray:aryLocalKSCrashLog];
    }
    [self.tableView reloadData];
}

#pragma  mark - getter
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView =  [[UITableView alloc] initWithFrame:CGRectMake(0, SX_NavBar_H, screenW, screenH - SX_NavBar_H) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)mAryLogs
{
    if (!_mAryLogs)
    {
        _mAryLogs = [NSMutableArray array];
    }
    return _mAryLogs;
}


#pragma  mark - UIResponse

- (void)rightButtonClick
{
    [self deleteAllLog:nil];
}

- (void)actionPop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteAllLog:(id)sender
{
    [self showWaringAlert];
}

- (void)showWaringAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"骚年你还年轻"
                                                        message:@"自宫后,将丢失所有测试环境日志"
                                                       delegate:self
                                              cancelButtonTitle:@"算了"
                                              otherButtonTitles:@"拿刀来!", nil];
    alertView.tag = 10086;
    [alertView show];
}

- (void)showAlertWithText:(NSString *)strText
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:strText
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}

#pragma  mark - alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10086)
    {
        if (buttonIndex==0)
        {
            [self showAlertWithText:@"这个世界充满了危险，等等再下结论吧!"];
        }
        if (buttonIndex==1)
        {
            [self.mAryLogs removeAllObjects];
            _mAryLogs = nil;
            [self.tableView reloadData];
            [SXLogHelper deleteAllLogsWithPrefixName:SX_CrashLocalExceptionLog];
            [SXLogHelper deleteAllLogsWithPrefixName:SX_CrashExceptionLog];
            [self showAlertWithText:@"果然神清气爽!"];
        }
    }
}


#pragma  mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mAryLogs.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LogCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenW, 20)];
        time.tag = 10;
        time.font = [UIFont systemFontOfSize:17.0f];
        [cell.contentView addSubview:time];
        
        UILabel *reason = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, screenW, 44)];
        reason.tag = 11;
        reason.numberOfLines = 2;
        reason.lineBreakMode = NSLineBreakByCharWrapping;
        reason.font = [UIFont systemFontOfSize:12.0f];
        [cell.contentView addSubview:reason];
    }
    
    id logDict = [self.mAryLogs objectAtIndex:indexPath.row];
    
    UILabel *time = (UILabel*)[cell.contentView viewWithTag:10];
    UILabel *reason = (UILabel*)[cell.contentView viewWithTag:11];
    
    if ([logDict isKindOfClass:[NSDictionary class]])
    {
        time.text = [logDict valueForKey:@"createTime"];
        reason.text = [logDict valueForKey:@"reason"];
    }
    else
    {
        reason.text = @"卡顿日志";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SXLocalLogDetailVC *logDetailVC = [[SXLocalLogDetailVC alloc] initWithLogDict:[self.mAryLogs objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:logDetailVC animated:YES];
}

@end
