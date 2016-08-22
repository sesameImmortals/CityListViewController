//
//  MYCityEntyM.h
//  CityListViewController
//
//  Created by NengQuan on 16/1/8.
//  Copyright © 2016年 NengQuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
@interface MYCityEntyM : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *cityCode;         //城市Id
@property (strong, nonatomic) NSString *cityName;      //城市名称
@property (strong, nonatomic) NSString *pinyin;          //城市拼音
@property (strong, nonatomic) NSString *firstLetter;     //首字母

@end
