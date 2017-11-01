//
//  NewFilterStaticTableViewController.m
//  Filters
//
//  Created by xia on 2017/10/31.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "NewFilterStaticTableViewController.h"
#import "MJCondition.h"
#import "MJJudgementRule.h"

@interface NewFilterStaticTableViewController ()<UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (nonatomic, strong) MJCondition *condition;
@end

@implementation NewFilterStaticTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleTextField.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)];
    tap.delegate = self;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelBtnClick:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"确认退出吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf performSegueWithIdentifier:@"backToFilterTableView" sender:nil];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)doneBtnClick:(id)sender {
    if ([self.titleTextField.text isEqualToString:@""]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"请填写过滤名称" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ([_condition.keyword isEqualToString:@""] || _condition.keyword == nil) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"请填写过滤关键字" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)closeKeyBoard {
    [self.view endEditing:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:NSClassFromString(@"MatchingTypeTableViewController")]) {
        if ([self.titleTextField.text isEqualToString:@""]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"请填写过滤名称" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            _condition = [MJCondition new];
            _condition.alias = self.titleTextField.text;
            _condition.conditionTarget = MJConditionTargetSender;
            _condition.conditionType = MJConditionTypeContains;
            [[MJJudgementRule globalRule].conditionList addObject:_condition];
            [[MJJudgementRule globalRule] save];
            [segue.destinationViewController setValue: _condition forKey:@"condition"];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

@end
