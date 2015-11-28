//
//  FacialDIYTableViewCell.h
//  XiBaibai
//
//  Created by HoTia on 15/11/9.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FacialDIYTableViewCell;
@protocol FacialDIYTableViewCellDelegate <NSObject>

- (void)longPressFacialToProD:(NSString *)p_id;
- (void)tapActionFacialToProD:(NSString *)p_id complete:(void(^)(id))complete;

@end


@interface FacialDIYTableViewCell : UITableViewCell
@property(weak,nonatomic) id <FacialDIYTableViewCellDelegate> delegate;
- (void)configCell:(NSArray *)dataArr andWashType:(NSInteger)type andSelectPids:(NSArray *)ids;






@end
