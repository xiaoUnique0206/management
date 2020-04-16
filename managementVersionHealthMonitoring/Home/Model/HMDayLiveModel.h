//
//  HMDayLiveModel.h
//  managementVersionHealthMonitoring
//
//  Created by Mr - 宋 on 2020/3/26.
//  Copyright © 2020 song. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMDayLiveModel : NSObject
//            [0]    (null)    @"departmentCode" : @"b32"  // 企业ID
//            [1]    (null)    @"effectiveNumberTotal" : (long)0  有效检测的总数
//            [2]    (null)    @"admDepartment" : @"市监狱局"  // 上级部门
//            [3]    (null)    @"leafNode" : YES // 是不是叶子节点
//            [4]    (null)    @"total" : (long)6 // 总数
//            [5]    (null)    @"companyMatched" : YES
//            [6]    (null)    @"ratio" : @"16.7%" // 日活率
//            [7]    (null)    @"parentTotal" : (long)281
//            [8]    (null)    @"bootNumberTotal" : (long)1 // 开机的总数
//            [9]    (null)    @"number" : (long)1 // 日活数
//            [10]    (null)    @"children" : @"0 elements"
//            [11]    (null)    @"bootNumber" : (long)1
//            [12]    (null)    @"effectiveNumber" : (long)0
//            [13]    (null)    @"departmentName" : @"延庆监狱" 本级部门
//[0]    (null)    @"value" : (no summary)
//[1]    (null)    @"timepoint" : @"2020-04-06T21:13:19.000+0000"
@property(nonatomic,assign)float effectiveNumberTotal;
@property(nonatomic,assign)BOOL leafNode;
@property(nonatomic,assign)float total;
@property(nonatomic,assign)float ratio;
@property(nonatomic,assign)float bootNumberTotal;
@property(nonatomic,strong)NSArray *children;
@property(nonatomic,strong)NSString *departmentName;
@property(nonatomic,assign)float number;
@property(nonatomic,assign)float dayLive;
@property(nonatomic,strong)NSString *departmentCode;
@property(nonatomic,strong)NSString *value;
@property(nonatomic,strong)NSString *timepoint;

@end


@interface HMPersonModel : NSObject
//[0]    (null)    @"username" : @"陈永芳"
//[1]    (null)    @"lastTemp" : (double)36.4
//[2]    (null)    @"mobile" : @"13681225924"
//[3]    (null)    @"userId" : @"14497bb965c840d7941280b997788642"
//[4]    (null)    @"companyMatched" : YES
//[5]    (null)    @"lastActiveTime" : @"10:40:08"
@property(nonatomic,strong)NSString *username;
@property(nonatomic,assign)float lastTemp;
@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *lastActiveTime;
@property(nonatomic,assign)BOOL companyMatched;
@property(nonatomic,strong)NSString *userId;
@end

//Abnormal
@interface HMabnormalModel : NSObject
//[0]    (null)    @"userId" : @"e79d5c35827b4b63aa9797654c7f1f24"
//[1]    (null)    @"mobile" : @"13811872982"
//[2]    (null)    @"userName" : @"宋晨"
//[3]    (null)    @"parent" : @"市商务局"
//[4]    (null)    @"lastRecord" : @"历史案例，无异常"
//[5]    (null)    @"company" : @"中国全聚德集团和平门店"
//[6]    (null)    @"code" : @"b8028"
//[7]    (null)    @"level" : (long)3
//[8]    (null)    @"have" : NO
//[9]    (null)    @"dateTime" : (long)1585771200000
//[2]    (null)    @"commentBy" : @"c1220008"
//[3]    (null)    @"commentTime" : @"2020-04-06T03:12:25.000+0000"
//[7]    (null)    @"comment" : @"王义江为佑安职工餐厅厨师，在工作中厨房灶台温度高，体温记录异常。经现场反复测量，体温为36.4°正常。"
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *parent;
@property(nonatomic,strong)NSString *lastRecord;
@property(nonatomic,strong)NSString *company;
@property(nonatomic,assign)int level;
@property(nonatomic,assign)NSInteger dateTime;
@property(nonatomic,strong)NSString *commentBy;
@property(nonatomic,strong)NSString *commentTime;
@property(nonatomic,strong)NSString *comment;


@property(nonatomic,strong)NSString *username;
@property(nonatomic,strong)NSString *companyCode;
@property(nonatomic,strong)NSString *parentCompany;
@end

NS_ASSUME_NONNULL_END
