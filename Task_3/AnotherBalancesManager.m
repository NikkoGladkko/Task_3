//
//  AnotherBalancesManager.m
//  Task_3
//
//  Created by Евгений Гостев on 25.10.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

#import "AnotherBalancesManager.h"


@implementation AnotherBalancesManager

- (void)viewDidLoad {
  [super viewDidLoad];
  [self getAccounts];
}

- (void)getAccounts {
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSString *uri = @"/rest/personal/krawlly/get_accounts";
    [[[RestService alloc] initWithDelegate:self] getServiceFromURI:uri];
  });
}

//Метод делегата куда вернутся данные по запросу из метода - (void)getAccounts;
- (void)restService:(RestService *)restService didReceiveData:(NSData *)data
            FromURI:(NSString*)uri {
  
  NSError *error = nil;
  NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                              options:NSJSONReadingMutableContainers
                                                                error:&error];
  
  self.balances = [NSMutableArray array];
  self.details = [NSMutableArray array];
  
  if ([uri containsString:@"get"]) {
    for (NSDictionary *json in dict) {
      AnotherBalance *balance = [[AnotherBalance alloc] initWithJSON:json];
      NSArray *detailBalance = [balance getDetailBalanceFromJSON:json];
      [self.details addObject:detailBalance];
      [self.balances addObject:balance];
    }
  }
}

@end
