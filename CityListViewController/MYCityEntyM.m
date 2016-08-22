//
//  MYCityEntyM.m
//  CityListViewController
//
//  Created by NengQuan on 16/1/8.
//  Copyright © 2016年 NengQuan. All rights reserved.
//

#import "MYCityEntyM.h"

@implementation MYCityEntyM

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{ @"cityCode" : @"cityCode" ,
              @"cityName" : @"cityName" ,
              @"pinyin" : @"pinyin",
              @"firstLetter" : @"firstLetter"
              };
}

@end
