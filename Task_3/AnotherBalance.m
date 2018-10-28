//
//  AnotherBalance.m
//  Task_3
//
//  Created by Евгений Гостев on 25.10.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

#import "AnotherBalance.h"

@implementation AnotherBalance

// #pragma mark Разметка кода

- (instancetype)initWithJSON:(JSON *)json
{
    // Где super init? self = [super init];
    // Отступы?!
  if (json && [json isKindOfClass:[NSDictionary class]])
  {
    if ([json objectForKey:@"accountId"])
    {
      self.accountId = [json[@"accountId"] intValue];
    }
      
    if ([json objectForKey:@"iconUrl"])
    {
      self.iconURL = json[@"iconUrl"];
    }
    
    NSDictionary* balanceDict = json[@"balance"];
    // А если прилетит не словарь, то в ближайшем методе упадет.
    // Отствует проверка на тип
    if (balanceDict)
    {
      NSTimeInterval unixTimeStamp = [balanceDict[@"time"] doubleValue];

      NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixTimeStamp];
        
      NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        // Именование переменных camelCase: *dateFormatter
      [dateformatter setLocale:[NSLocale currentLocale]];
      [dateformatter setDateFormat:@"HH:mm"];
        // Можно использовать setTimeFormat:
        // Не сработает для AM/PM в некоторых локалях в iOS < 12
        // Безопаснее использовать setLocalizedDateFormatFromTemplate:
        
      NSString *dateString = [dateformatter stringFromDate:date];
        
      self.currentTime = dateString;
      
      NSDictionary *resultDict = balanceDict[@"result"];
        // Неинформативное именование переменных
        
      if (![resultDict objectForKey:@"__tariff"])
          // Так как есть else, то в if лучше проверять выражение без отрцания!
          // Отствует проверка на тип
      {
        self.tariff = [NSString string];
      }
      else
      {
        self.tariff = resultDict[@"__tariff"];
      }
      
      NSDictionary *balanceNameDict = resultDict[@"balance"];
        
      if (balanceNameDict)
      {
        if ([balanceNameDict objectForKey:@"name"])
        {
          self.balanceName = balanceNameDict[@"name"];
        }
        
        NSString *units = [NSString string];
          
        if ([balanceNameDict objectForKey:@"value"])
        {
          self.baseBalanceValue = balanceNameDict[@"value"];
        }
          
        if (![balanceNameDict objectForKey:@"units"])
        {
          units = @"";
        }
        else if ([balanceNameDict[@"units"] isEqualToString:@" {@currency}"])
        {
          if ([resultDict[@"currency"] isKindOfClass:[NSDictionary class]])
          {
            NSDictionary *currencyDict = resultDict[@"currency"];
            units = currencyDict[@"value"];
          }
          else
          {
            units = resultDict[@"currency"];
          }
        }
        else
        {
          units = balanceNameDict[@"units"];
        }
        self.baseBalanceValue = [NSString stringWithFormat:@"%@%@",
                                 balanceNameDict[@"value"],
                                 units];
          // В результирующей строке значение и величина не разделены пробелом
          // Не учтена разница в форматировании валют, напрмер $10 но 10 ₽
      }
      else
      {
        self.balanceName = [NSString string];
        self.baseBalanceValue = [NSString string];
      }
    }
    NSDictionary *accountSettings = json[@"accountSettings"];
    if (accountSettings) {
      self.accountName = accountSettings[@"name"];
    }
  }
  else
  {
      // короткие проверки с return лучше выносить вверх, чтобы сразу обозначать исход
      // init лучше бы реализовать тогда [NSException raise:format:] или с возвращением NSError
      // в котором указывать на отсутсвующие Обязательные параметры при парсинге
    return nil;
  }
    
  return self;
    
    // Можно было бы разбить на отдельные методы,
    // с безопасной проверкой на тип, существование значения
    // и с наполнением стандартными значениями.
}

// Почему это метод экземпляра а не класса? Что он использует от self?
- (NSMutableArray *)getDetailBalanceFromJSON:(JSON *)json
{
  if (!json || ![json isKindOfClass:[NSDictionary class]])
  {
    return nil;
  }
  else
  {
    NSMutableArray *details = [NSMutableArray array];
    NSDictionary* balanceDict = json[@"balance"];
      
    if (balanceDict)
    {
      NSDictionary *resultDict = balanceDict[@"result"];
        
      if (resultDict)
      {
        for (NSString *key in [resultDict allKeys])
            // А чем не устроило тогда for (NSDictionary *subresultDict in resultDict)
        {
          if ([resultDict[key] isKindOfClass:[NSDictionary class]])
          {
            NSMutableDictionary *detail = [NSMutableDictionary dictionary];
              
            [detail setObject:[resultDict[key] objectForKey:@"value"] forKey:@"value"];
            [detail setObject:[resultDict[key] objectForKey:@"name"] forKey:@"name"];
              // Нет проверки на nil ([resultDict[key] objectForKey:@"value"])
            
            if ([resultDict[key] objectForKey:@"units"])
            {
              if ([[resultDict[key] objectForKey:@"units"] isEqualToString:@" {@currency}"])
              {
                if ([[resultDict objectForKey:@"currency"] isKindOfClass:[NSDictionary class]])
                {
                  NSDictionary *currencyDict = resultDict[@"currency"];
                  [detail setObject:currencyDict[@"value"] forKey:@"currency"];
                }
                else
                {
                  [detail setObject:[resultDict objectForKey:@"currency"] forKey:@"currency"];
                }
              }
              else
              {
                [detail setObject:[resultDict[key] objectForKey:@"units"] forKey:@"units"];
              }
            }
            
            if ([resultDict[key] objectForKey:@"format"]) {
              [detail setObject:[resultDict[key] objectForKey:@"format"] forKey:@"format"];
            }
            [details addObject:detail];
          }
        }
      }
    }
    return details;
  }
}

// все строковые литералы лучше вынести в константы
// Например NSString *const kFormat = @"format";

@end
