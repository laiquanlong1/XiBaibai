//
//  ServiceAPIMacro.h
//  XBB
//
//  Created by 殷绍刚 on 15/8/27.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#ifndef XBB_ServiceAPIMacro_h
#define XBB_ServiceAPIMacro_h


//#define APIDomain @"http://captainoak.cn/Api/V3"
//#define ImgDomain @"http://captainoak.cn"

#define APIDomain @"http://xbbwx.marnow.com/Api/V3"
#define ImgDomain @"http://xbbwx.marnow.com"

//#define APIDomain @"http://xbbwx.marnow.com//Api/V3"
//#define ImgDomain @"http://192.168.1.113/xbb"



// 01 发送验证码
#define sendCode_API [NSString stringWithFormat:@"%@/authCode", APIDomain]

// 01 发送验证码--忘记密码
#define sendCode_API2 [NSString stringWithFormat:@"%@/authCodePwd", APIDomain]

// 02 注册用户
#define Register_API [NSString stringWithFormat:@"%@/register", APIDomain]

// 02 注册用户--忘记密码
#define Register_API2 [NSString stringWithFormat:@"%@/forgetPwd", APIDomain]

// 03 登录
#define Login_API [NSString stringWithFormat:@"%@/login", APIDomain]

// 04 新增订单
#define OrderInsert_API [NSString stringWithFormat:@"%@/createOrder", APIDomain]

// 05 查询订单列表
#define XBB_orderSelect [NSString stringWithFormat:@"%@/orderSelect", APIDomain]

// 06 查询订单详情
#define OrderSelect_detail_API [NSString stringWithFormat:@"%@/orderDetail",APIDomain]

// 07 二次请求（1-10前暂时未用）
#define API_selectOrder_topay [NSString stringWithFormat:@"%@/confirmPay", APIDomain]

// 08 获取用户优惠券 和使用 规则链接
#define API_couponsInfo [NSString stringWithFormat:@"%@/couponsInfo", APIDomain]

// 09 优惠码(1-10 后)
#define XBB_exchangeCoupons [NSString stringWithFormat:@"%@/exchangeCoupons", APIDomain]

// 10 下单页洗车和优惠券
#define XBB_Wash2Coupons [NSString stringWithFormat:@"%@/washCoupons", APIDomain]

// 11 取消订单
#define API_OrderCancel [NSString stringWithFormat:@"%@/orderCancel", APIDomain]

// 12 评论订单
#define API_CommentInsert [NSString stringWithFormat:@"%@/evaluate", APIDomain]

// 13 请求用户车辆
#define car_select [NSString stringWithFormat:@"%@/carSelect", APIDomain]

// 14 设置默认车辆
#define API_set_default_car [NSString stringWithFormat:@"%@/setDefaultCar", APIDomain]

// 15 优惠券(12.11)
#define XBB_Coupons_select [NSString stringWithFormat:@"%@/userCoupons", APIDomain]

// 16 查询用户资料
#define Select_user_API [NSString stringWithFormat:@"%@/userInfo", APIDomain]

// 17 修改用户资料接口
#define updateUserInfo [NSString stringWithFormat:@"%@/updateUserInfo", APIDomain]

// 18 修改用户头像接口
#define UpdateUserImg_API [NSString stringWithFormat:@"%@/updateHeadImg", APIDomain]

// 19 新增用户车辆
#define Car_Insert_API [NSString stringWithFormat:@"%@/carAdd", APIDomain]

// 20 修改用户车辆
#define API_CarUpdate [NSString stringWithFormat:@"%@/updateCarInfo", APIDomain]

// 21 删除用户车辆
#define Car_Delete_API [NSString stringWithFormat:@"%@/deleteCar", APIDomain]

// 22 新增用户地址
#define AddUser_address_API [NSString stringWithFormat:@"%@/addAddress",APIDomain]

// 23 查询常用地址车位
#define API_AddressSelect [NSString stringWithFormat:@"%@/selectAddress", APIDomain]

// 24 查询所有车辆品牌
#define API_AllCarbrandSelect [NSString stringWithFormat:@"%@/carBrands", APIDomain]

// 25 美容接口
#define API_SelectWax  [NSString stringWithFormat:@"%@/productInfo", APIDomain]

// 26 查询预约时间段
#define Time_select_make_API [NSString stringWithFormat:@"%@/appointTime", APIDomain]

// 27 反馈
#define Advice_Insert_API [NSString stringWithFormat:@"%@/userFeedback", APIDomain]

// 28 检查版本更新（还没有做ios 2）
#define API_VersionUpdate [NSString stringWithFormat:@"%@/checkVersion", APIDomain]

// 29 轮播
#define XBB_Banner_roop [NSString stringWithFormat:@"%@/lunbo", APIDomain]

// 30 DIY子页面
#define XBB_DIY_Pro [NSString stringWithFormat:@"%@/diyPro", APIDomain]

// 31 首页美容
#define XBB_Facial_Pro [NSString stringWithFormat:@"%@/diyCospro", APIDomain]

// 31 首页diy产品
#define XBB_Index_Pro [NSString stringWithFormat:@"%@/indexProList", APIDomain]

// 32 零元支付
#define XBB_Zone_Pay [NSString stringWithFormat:@"%@/directPay", APIDomain]

// 33 服务时间
#define ServerTime [NSString stringWithFormat:@"%@/serviceTime", APIDomain]

// 34 服务城市
#define ServerCity [NSString stringWithFormat:@"%@/serviceCity", APIDomain]








//支付宝支付回调（充值页面）
#define Notify_AlipayCallback_Url [NSString stringWithFormat:@"%@/alipay_return", APIDomain]

//确认订单时的订单名称
#define API_orderName_price [NSString stringWithFormat:@"%@/proName_select",APIDomain]



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

//投诉
#define API_Complaint [NSString stringWithFormat:@"%@/complaint", APIDomain]

//积分
#define API_MyPointsSelect [NSString stringWithFormat:@"%@/mypoints_select", APIDomain]

//充值
#define API_Recharge [NSString stringWithFormat:@"%@/recharge", APIDomain]













//上传文件接口
#define API_UploadFile [NSString stringWithFormat:@"%@/UploadFile", APIDomain]



//百度推送设置channel id到服务器 chanelid_insert
#define API_ChannelIdInsert [NSString stringWithFormat:@"%@/chanelid_insert", APIDomain]

//申请提现applyfor
#define API_ApplyFor [NSString stringWithFormat:@"%@/applyfor", APIDomain]

// 蒙板接口坐标点接口
#define Lat_Long [NSString stringWithFormat:@"%@/server_latlng", APIDomain]

// 申请开通此城市
#define Applyopen [NSString stringWithFormat:@"%@/applyopen", APIDomain]


#endif
