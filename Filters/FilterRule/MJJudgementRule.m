//
//  MJJudgementRule.m
//  MessageJudge
//
//  Created by GeXiao on 08/06/2017.
//  Copyright © 2017 GeXiao. All rights reserved.
//

#import "MJJudgementRule.h"
#import "YYModel.h"

static MJJudgementRule *sharedInstance;

@implementation MJJudgementRule

+ (instancetype)globalRule {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSUserDefaults *extDefaults = [[NSUserDefaults alloc] initWithSuiteName:MJExtentsionAppGroupName];
        NSString *ruleString = [extDefaults objectForKey:MJExtentsionRuleKey];
        sharedInstance = [MJJudgementRule yy_modelWithJSON:ruleString];
        if (!sharedInstance) {
            sharedInstance = [self new];
        }
    });
    return sharedInstance;
}

+ (void)regenerateShareInstance {
    NSUserDefaults *extDefaults = [[NSUserDefaults alloc] initWithSuiteName:MJExtentsionAppGroupName];
    NSString *ruleString = [extDefaults objectForKey:MJExtentsionRuleKey];
    MJJudgementRule *newInstance = [MJJudgementRule yy_modelWithJSON:ruleString];
    if (newInstance) {
        sharedInstance = newInstance;
    }
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"conditionList" : [MJCondition class],
             };
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _conditionList = [@[] mutableCopy];
    }
    return self;
}

- (BOOL)save {
    NSUserDefaults *extDefaults = [[NSUserDefaults alloc] initWithSuiteName:MJExtentsionAppGroupName];
    NSString *ruleString = [extDefaults objectForKey:MJExtentsionRuleKey];
    ruleString = [self yy_modelToJSONString];
    if (ruleString) {
        [extDefaults setObject:ruleString forKey:MJExtentsionRuleKey];
    }
    return ruleString != nil;
}

- (BOOL)isUnwantedMessageForSystemQueryRequest:(ILMessageFilterQueryRequest *)systemRequest {
    MJQueryRequest *request = [[MJQueryRequest alloc] initWithSystemQueryRequest:systemRequest];
    
    // White list has higher priority
    if (self.conditionList) {
        for (MJCondition *condition in self.conditionList) {
            if ([condition isMatchedForRequest:request]) {
                return NO;
            }
        }
    }
    return NO;
}

@end

