//
//  APPUIMacro.h
//  XiBaibai
//
//  Created by HoTia on 15/11/26.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#ifndef APPUIMacro_h
#define APPUIMacro_h

/**
 * @brief 判断手机
 **/
#define XBB_Screen [UIScreen mainScreen]
#define XBB_Screen_bounds [XBB_Screen bounds]
#define XBB_Screen_width  XBB_Screen_bounds.size.width
#define XBB_Screen_height  XBB_Screen_bounds.size.height
#define XBB_Screen_scale [[UIScreen mainScreen] scale]
#define XBB_Size_w_h(pt) ((pt)/2.f)
#define XBB_IsIphone4s  ((XBB_Screen_bounds.size.width == 320.f && XBB_Screen_bounds.size.height == 480.f)? YES : NO)
#define XBB_IsIphone5_5s  ((XBB_Screen_bounds.size.width == 320.f && XBB_Screen_bounds.size.height == 568.f)? YES : NO)
#define XBB_IsIphone6_6s  ((XBB_Screen_bounds.size.width == 375.f && XBB_Screen_bounds.size.height == 667.f)? YES : NO)
#define XBB_IsIphone6P_6SPlus  ((XBB_Screen_bounds.size.width == 414.f && XBB_Screen_bounds.size.height == 736.f)? YES : NO)

#define XBB_Bg_Color kUIColorFromRGB(0xf1f1f1)
#define XBB_NavBar_Color kUIColorFromRGB(0x106ab1)
#define XBB_Forground_Color kUIColorFromRGB(0xffffff)

#define XBB_NavBar_Font [UIFont systemFontOfSize:18.f]
#define XBB_Prompt_Font [UIFont systemFontOfSize:16.f]

#define XBB_CellTitleColor [UIColor grayColor]
#define XBB_Promat_Color [UIColor lightGrayColor]
#define XBB_separatorColor kUIColorFromRGB(0xdddddd)
#define XBB_HeadEdge UIEdgeInsetsMake(6, 0, 0, 0)


#define XBB_CellTitleFont [UIFont systemFontOfSize:16.f]
#define XBB_CellContentFont [UIFont systemFontOfSize:16.f]
#define XBB_CellPriceFont [UIFont systemFontOfSize:16.f]
#define XBB_TXTFont [UIFont systemFontOfSize:13.f]

#define XBB_SelectedColor [UIColor redColor]
#define XBB_NotSelectColor [UIColor grayColor]




#endif /* APPUIMacro_h */
