//
//  MatchingTypeTableViewController.m
//  Filters
//
//  Created by xia on 2017/10/31.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "MatchingTypeTableViewController.h"
#import "MJJudgementRule.h"
#import "FilterTableViewController.h"

@interface MatchingTypeTableViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *keyWorldTextField;

@end

@implementation MatchingTypeTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.keyWorldTextField.text = self.condition.keyword ? self.condition.keyword : @"";
    self.keyWorldTextField.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    tap.delegate = self;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    self.title = self.condition.alias;
    [self createNavigationDoneItem];
}

- (void)closeKeyboard {
    [self.keyWorldTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createNavigationDoneItem {
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(finishSetingBtnClick)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)finishSetingBtnClick {
    if ([self.keyWorldTextField.text isEqualToString:@""]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"请输入关键字" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        _condition.keyword = self.keyWorldTextField.text;
        [MJGlobalRule save];
        __weak typeof(self) weakSelf = self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            // 从Storyboard上按照identifier获取指定的界面（VC），identifier必须是唯一的
            FilterTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"FilterTableView"];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}  

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 2;
            break;
        case 2:
            return 4;
            break;
        default:
            return 0;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 1) {
        switch (row) {
            case 0:
                _condition.conditionTarget = MJConditionTargetSender;
                break;
            case 1:
                _condition.conditionTarget = MJConditionTargetContent;
                break;
            default:
                break;
        }
    } else if (section == 2) {
        switch (row) {
            case 0:
                _condition.conditionType = MJConditionTypeHasPrefix;
                break;
            case 1:
                _condition.conditionType = MJConditionTypeHasSuffix;
                break;
            case 2:
                _condition.conditionType = MJConditionTypeContains;
                break;
            case 3:
                _condition.conditionType = MJConditionTypeContainsRegex;
                break;
            default:
                break;
        }
    }
    [tableView reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 1) {
        switch (row) {
            case 0:
                cell.accessoryType = _condition.conditionTarget == MJConditionTargetSender ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
                break;
            case 1:
                cell.accessoryType = _condition.conditionTarget == MJConditionTargetContent ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
                break;
            default:
                break;
        }
    } else if (section == 2) {
        switch (row) {
            case 0:
                cell.accessoryType = _condition.conditionType == MJConditionTypeHasPrefix ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
                break;
            case 1:
                cell.accessoryType = _condition.conditionType == MJConditionTypeHasSuffix ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
                break;
            case 2:
                cell.accessoryType = _condition.conditionType == MJConditionTypeContains ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
                break;
            case 3:
                cell.accessoryType = _condition.conditionType == MJConditionTypeContainsRegex ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
                break;
            default:
                break;
        }
    }
 
}

@end
