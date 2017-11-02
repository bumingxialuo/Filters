# 短信拦截本地
在filters里新建一个规则，messageExtension读取这个规则，信息app收到短信后，将短信的sender和内容发送给filter的messageExtension进行检测。messageExtension给出短信的处理方式：允许、过滤、不处理。<br>
filters和messageExtension读取同一份数据(规则)的方式：AppGroup数据共享 		filters里面新建一个规则，存到NSUserDefault里面。messageExtension读取这个规则。<br>
## 1、创建一个工程：Filters
## 2、在Filters中的Capabilities中添加Domians
group.com.yourname.filters <br>
<br>
## 3、在当前工程新建一个MessageFilterExtesion的target。
## 4、通过cocoapods导入YYModel（处理字符串的序列化和反序列化）
Podfile文件如下：<br>
```shell
platform :ios, '11.0'
target 'Filters' do
pod 'YYModel'
end
target 'MessageExtension' do
pod 'YYModel'
end
```
## 5、搭建页面
### 5.1 所有规则展示页面（提供删除功能）
### 5.2 新建规则页面  —规则的标题输入+具体规则
### 5.3具体规则 —关键字 过滤对象 过滤方式
## 6、规则的结构在 MJCondition 文件中 包含
标题：alias<br>
过滤对象：ConditionTarget<br>
        短信发送方号码和消息内容
过滤方式：ConditionType<br>
        前缀匹配、后缀匹配、包含和正则四种
关键字：keyword<br>
方法：- (BOOL)isMatchedForRequest:(MJQueryRequest *)request<br>
```oc
typedef NS_ENUM(NSInteger, MJConditionTarget) {
    MJConditionTargetSender = 0,
    MJConditionTargetContent
};

typedef NS_ENUM(NSInteger, MJConditionType) {
    MJConditionTypeHasPrefix = 0,
    MJConditionTypeHasSuffix,
    MJConditionTypeContains,
    MJConditionTypeContainsRegex
};

@interface MJCondition : NSObject

@property (nonatomic, copy) NSString *alias;
@property (nonatomic, assign) MJConditionTarget conditionTarget;
@property (nonatomic, assign) MJConditionType conditionType;
@property (nonatomic, copy) NSString *keyword;

- (BOOL)isMatchedForRequest:(MJQueryRequest *)request;

@end
```
匹配具体实现<br>
[target hasPrefix:关键字]<br>
[target hasSuffix:关键字]<br>
[target containsString:关键字]<br>
[target rangeOfString:关键字 options:NSRegularExpressionSearch].location != NSNotFound<br>
## 7、MJJudgementRule 单例类
 获取所有规则[MJJudgementRule globalRule].conditionList<br>
 保存规则 [[MJJudgementRule globalRule] save]<br>
 规则匹配 isUnwantedMessageForSystemQueryRequest:<br>
 ```oc
 #define MJGlobalRule [MJJudgementRule globalRule]
static NSString *MJExtentsionAppGroupName = @"group.com.yourname.filters";
static NSString *MJExtentsionRuleKey = @"MJExtentsionRuleKey";

@interface MJJudgementRule : NSObject

@property (nonatomic, strong) NSMutableArray<MJCondition *> *conditionList;

+ (instancetype)globalRule;
+ (void)regenerateShareInstance;

- (BOOL)isUnwantedMessageForSystemQueryRequest:(ILMessageFilterQueryRequest *)systemRequest;
- (BOOL)save;

@end
 ```

## 8、MJQueryRequest
分离sender和messageBody，便于在MJJudgementRule进行分别匹配<br>
```oc
@interface MJQueryRequest : NSObject

@property (nonatomic, readonly, nullable) NSString *sender;
@property (nonatomic, readonly, nullable) NSString *messageBody;

- (instancetype _Nonnull)initWithSystemQueryRequest:(ILMessageFilterQueryRequest *_Nonnull)request;

- (instancetype _Nonnull)initWithSender:(NSString *_Nullable)sender messageBody:(NSString *_Nullable)messageBody;

@end
```
## 9、在短信扩展中进行匹配。
MessageFilterExtension.m的offlineActionForQueryRequest方法中添加一下代码
```oc
NSUserDefaults *extDefaults = [[NSUserDefaults alloc] initWithSuiteName:MJExtentsionAppGroupName];
    NSString *ruleString = [extDefaults objectForKey:MJExtentsionRuleKey];
    if (ruleString.length < 1) {
        return ILMessageFilterActionAllow;
    }
    MJJudgementRule *rule = [MJJudgementRule yy_modelWithJSON:ruleString];
    if (!rule) {
        return ILMessageFilterActionAllow;
    }
    if ([rule isUnwantedMessageForSystemQueryRequest:queryRequest]) {
        return ILMessageFilterActionFilter;
    }
    return ILMessageFilterActionAllow;
```
<br>
<br>
<br>
参考文章：<br>
http://mini.eastday.com/mobile/170612134830747.html?idx=1&fr=search<br>
https://zhuanlan.zhihu.com/p/27560301<br>
https://developer.apple.com/documentation/identitylookup?language=objc#topics<br>
