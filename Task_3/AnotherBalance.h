//
//  AnotherBalance.h
//  Task_3
//
//  Created by Евгений Гостев on 25.10.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NSDictionary JSON;


@interface AnotherBalance : NSObject

@property (assign, nonatomic) int accountId;
@property (strong, nonatomic) NSString *currentTime;
@property (strong, nonatomic) NSString *balanceName;
@property (strong, nonatomic) NSString *balanceResult;
@property (strong, nonatomic) NSString *baseBalanceValue;
@property (strong, nonatomic) NSString *iconURL;
@property (strong, nonatomic) NSString *accountName;
@property (strong, nonatomic) NSString *tariff;

- (instancetype)initWithJSON:(JSON *)json;
- (NSMutableArray *)getDetailBalanceFromJSON:(JSON *)json;

@end


