//
//  XBBAnnotation.h
//  XBB
//
//  Created by Apple on 15/9/18.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @brief 自定义地图注释
 * @detail 自定义地图注释
 **/
@interface XBBAnnotation : NSObject<BMKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title, *subtitle;

@end
