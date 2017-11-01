//
//  FilterTableViewController.m
//  Filters
//
//  Created by xia on 2017/10/31.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "FilterTableViewController.h"
#import "MJCondition.h"
#import "MatchingTypeTableViewController.h"
#import "MJJudgementRule.h"
#import "MatchingTypeTableViewController.h"

#define FilterTableViewCellId @"FilterTableViewCellId"

@interface FilterTableViewController ()
@property (nonatomic, strong, readonly) NSMutableArray<MJCondition *> *conditionList;
@end

@implementation FilterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSMutableArray<MJCondition *> *)conditionList {
    return [MJJudgementRule globalRule].conditionList;
}

- (IBAction)editBtnClick:(id)sender {
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MJCondition *indexCondition = self.conditionList[indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // 从Storyboard上按照identifier获取指定的界面（VC），identifier必须是唯一的
    MatchingTypeTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MatchingTypeTableView"];
    vc.condition = indexCondition;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"本地规则";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conditionList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.conditionList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [MJGlobalRule save];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FilterTableViewCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FilterTableViewCellId];
    }
    MJCondition *con = [[MJCondition alloc] init];
    con = self.conditionList[indexPath.row];
    cell.textLabel.text = con.alias;
//    cell.detailTextLabel.text = _conditionList[indexPath.row].conditionTarget;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"resetRule"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MJCondition *condition = self.conditionList[indexPath.row];
        MatchingTypeTableViewController *vc = [[MatchingTypeTableViewController alloc] init];
        vc.condition = condition;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
