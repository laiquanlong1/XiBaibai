//
//  ServiceAPIMacro.h
//  XBB
//
//  Created by 殷绍刚 on 15/8/27.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#ifndef XBB_ServiceAPIMacro_h
#define XBB_ServiceAPIMacro_h


#define APIDomain @"http://captainoak.cn/Api/V3"
#define ImgDomain @"http://captainoak.cn"

//#define APIDomain @"http://xbbwx.marnow.com/Api/Indextwo"
//#define ImgDomain @"http://xbbwx.marnow.com"

//#define APIDomain @"http://xbbwx.marnow.com/Api/index"
//#define ImgDomain @"http://192.168.1.113/xbb"


// 轮播
#define XBB_Banner_roop [NSString stringWithFormat:@"%@/lunbo", APIDomain]

// 下单页洗车和优惠券
#define XBB_Wash2Coupons [NSString stringWithFormat:@"%@/washCoupons", APIDomain]

// DIY
#define XBB_DIY_Pro [NSString stringWithFormat:@"%@/diyPro", APIDomain]

// 首页美容
#define XBB_Facial_Pro [NSString stringWithFormat:@"%@/diyCospro", APIDomain]

// 首页产品
#define XBB_Index_Pro [NSString stringWithFormat:@"%@/indexProList", APIDomain]

// 美容接口
#define API_SelectWax  [NSString stringWithFormat:@"%@/product_info", APIDomain]

//请求用户车辆(12.10)
#define XBB_Car_select [NSString stringWithFormat:@"%@/userCars", APIDomain]

//优惠券(12.11)
#define XBB_Coupons_select [NSString stringWithFormat:@"%@/userCoupons", APIDomain]

// 优惠码
#define XBB_exchangeCoupons [NSString stringWithFormat:@"%@/exchangeCoupons", APIDomain]

// 订单详情
#define XBB_orderSelect [NSString stringWithFormat:@"%@/orderSelect", APIDomain]

//查询用户资料
#define Select_user_API [NSString stringWithFormat:@"%@/userInfo", APIDomain]

// 二次请求
#define API_selectOrder_topay [NSString stringWithFormat:@"%@/confirmPay", APIDomain]

//取消订单
#define API_OrderCancel [NSString stringWithFormat:@"%@/orderCancel", APIDomain]

//查询订单详情
#define OrderSelect_detail_API [NSString stringWithFormat:@"%@/orderDetail",APIDomain]












//修改用户头像接口 和名称
#define UpdateUserImg_API [NSString stringWithFormat:@"%@/user_msg_u_img", APIDomain]

//修改用户资料接口
#define updateUserInfo [NSString stringWithFormat:@"%@/user_msg_up", APIDomain]

//请求用户车辆
#define car_select [NSString stringWithFormat:@"%@/car_select", APIDomain]

//查询订单
#define OrderSelect_API [NSString stringWithFormat:@"%@/order_select", APIDomain]



//确认订单时的订单名称
#define API_orderName_price [NSString stringWithFormat:@"%@/proName_select",APIDomain]

//新增订单
#define OrderInsert_API [NSString stringWithFormat:@"%@/order_insert", APIDomain]

//新增用户地址
#define AddUser_address_API [NSString stringWithFormat:@"%@/address_insert",APIDomain]

//查询常用地址车位
#define API_AddressSelect [NSString stringWithFormat:@"%@/selectAddress", APIDomain]




//新增用户车辆
#define Car_Insert_API [NSString stringWithFormat:@"%@/car_insert", APIDomain]

//删除用户车辆
#define Car_Delete_API [NSString stringWithFormat:@"%@/car_delete", APIDomain]

//反馈
#define Advice_Insert_API [NSString stringWithFormat:@"%@/advice_insert", APIDomain]

//查询时间段是否可预约
#define Time_select_make_API [NSString stringWithFormat:@"%@/time_config_select", APIDomain]

//发送验证码
#define sendCode_API [NSString stringWithFormat:@"%@/re_iphone", APIDomain]

//发送验证码--忘记密码
#define sendCode_API2 [NSString stringWithFormat:@"%@/re_iphone2", APIDomain]

//注册用户
#define Register_API [NSString stringWithFormat:@"%@/register", APIDomain]

//注册用户--忘记密码
#define Register_API2 [NSString stringWithFormat:@"%@/register2", APIDomain]

//登录
#define Login_API [NSString stringWithFormat:@"%@/login", APIDomain]

// 服务时间
#define ServerTime [NSString stringWithFormat:@"%@/servertime", APIDomain]

//查询产品
#define API_Pro_select [NSString stringWithFormat:@"%@/pro_select", APIDomain]

//设置默认车辆
#define API_set_default_car [NSString stringWithFormat:@"%@/setup_default_car", APIDomain]

//DIY
#define API_selectDIY [NSString stringWithFormat:@"%@/diy_select", APIDomain]



// 获取洗车方式和优惠券
#define API_Washinfo [NSString stringWithFormat:@"%@/washinfo", APIDomain]


//用户余额
#define API_Balance [NSString stringWithFormat:@"%@/pay_select", APIDomain]

//用户资金记录
#define API_MoneyRecord [NSString stringWithFormat:@"%@/user_pay_manage", APIDomain]

//系统通知
#define API_SystemMsg [NSString stringWithFormat:@"%@/admin_msg_select", APIDomain]

//限行尾号
#define API_CityLimit [NSString stringWithFormat:@"%@/city_limit", APIDomain]



//查询全部评价
#define API_CommentSelect [NSString stringWithFormat:@"%@/comment_select", APIDomain]
//http://s-199705.gotocdn.com/Api/index/comment_select

//修改用户车辆
#define API_CarUpdate [NSString stringWithFormat:@"%@/car_up", APIDomain]



//评论员工
#define API_CommentInsert [NSString stringWithFormat:@"%@/comment_insert", APIDomain]

//投诉
#define API_Complaint [NSString stringWithFormat:@"%@/complaint", APIDomain]

//积分
#define API_MyPointsSelect [NSString stringWithFormat:@"%@/mypoints_select", APIDomain]

//充值
#define API_Recharge [NSString stringWithFormat:@"%@/recharge", APIDomain]

//查询所有车辆品牌
#define API_AllCarbrandSelect [NSString stringWithFormat:@"%@/all_carbrand_select", APIDomain]

//支付宝支付回调
#define Notify_AlipayCallback_Url [NSString stringWithFormat:@"%@/alipay_return", APIDomain]

//上传文件接口
#define API_UploadFile [NSString stringWithFormat:@"%@/UploadFile", APIDomain]

//检查版本更新
#define API_VersionUpdate [NSString stringWithFormat:@"%@/version_up", APIDomain]

//百度推送设置channel id到服务器 chanelid_insert
#define API_ChannelIdInsert [NSString stringWithFormat:@"%@/chanelid_insert", APIDomain]

//申请提现applyfor
#define API_ApplyFor [NSString stringWithFormat:@"%@/applyfor", APIDomain]

// 蒙板接口坐标点接口
#define Lat_Long [NSString stringWithFormat:@"%@/server_latlng", APIDomain]

// 申请开通此城市
#define Applyopen [NSString stringWithFormat:@"%@/applyopen", APIDomain]


#endif
