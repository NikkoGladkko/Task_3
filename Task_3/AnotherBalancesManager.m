//
//  AnotherBalancesManager.m
//  Task_3
//
//  Created by Евгений Гостев on 25.10.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

#import "AnotherBalancesManager.h"
// Нет импорта AnotherBalance и RestService

@implementation AnotherBalancesManager

// AnotherBalancesManager наследник NSObject у него нет метода viewDidLoad:
// И даже если бы был, то в нем не стоит вызывать какие либо приватные методы
- (void)viewDidLoad {
  [super viewDidLoad];
  [self getAccounts];
}

- (void)getAccounts {
    // Нет проверки, в каком потоке уже выполняется?
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSString *uri = @"/rest/personal/krawlly/get_accounts";
    [[[RestService alloc] initWithDelegate:self] getServiceFromURI:uri];
      // SELF не отвечает протоколу RestService (не отределен в @implementation, наприммер)
  });
}

//Метод делегата куда вернутся данные по запросу из метода - (void)getAccounts;
- (void)restService:(RestService *)restService didReceiveData:(NSData *)data
            FromURI:(NSString*)uri
// Именование функции: fromURI
// Именование переменных: т.к. это NSString то можно назвать uriString, подчеркивая, что класс не NSURL
{
  NSError *error = nil;
  NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                              options:NSJSONReadingMutableContainers
                                                                error:&error];
  // Нет обработки error после парсинга
  self.balances = [NSMutableArray array];
  self.details = [NSMutableArray array];
  
  if ([uri containsString:@"get"])
  {
      // Если uri все же строка, то лучше проверять через rangeOfString: > N, так как вхождение get может быть где угодно
      // А еще лучше через [uri hasSuffix:@"someString"]; что именно оканчивается на необхлдимую строку
    for (NSDictionary *json in dict)
    {
      AnotherBalance *balance = [[AnotherBalance alloc] initWithJSON:json];
        
      NSArray *detailBalance = [balance getDetailBalanceFromJSON:json];
        
      [self.details addObject:detailBalance];
        
      [self.balances addObject:balance];
    }
  }
}

@end
