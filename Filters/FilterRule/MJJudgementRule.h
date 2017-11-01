//
//  MJJudgementRule.h
//  MessageJudge
//
//  Created by GeXiao on 08/06/2017.
//  Copyright © 2017 GeXiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJCondition.h"

#define MJGlobalRule [MJJudgementRule globalRule]
static NSString *MJExtentsionAppGroupName = @"group.com.erongdu.filters";
static NSString *MJExtentsionRuleKey = @"MJExtentsionRuleKey";

@interface MJJudgementRule : NSObject

@property (nonatomic, strong) NSMutableArray<MJCondition *> *conditionList;

+ (instancetype)globalRule;
+ (void)regenerateShareInstance;

- (BOOL)isUnwantedMessageForSystemQueryRequest:(ILMessageFilterQueryRequest *)systemRequest;
- (BOOL)save;

@end

