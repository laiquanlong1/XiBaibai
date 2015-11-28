//
//  ConstantMacro.h
//  XBB
//
//  Created by Apple on 15/8/30.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#ifndef XBB_ConstantMacro_h
#define XBB_ConstantMacro_h

/**
 * @brief 内存规则
 * @detail 强引用与弱引用
 **/
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

/**
 * @brief 进度条展示时间
 * @detail 进度条展示时间
 **/
#define SVDisplayDuration(strLen) MIN((float)strLen*0.06 + 0.5, 5.0)

/**
 * @brief 阿里支付
 * @detail 支付宝支付需要 AliPartner:合作号  AliSeller:卖方账号   AliPrivateKey:阿里私钥
 **/
#define AliPartner @"2088021381515671"
#define AliSeller @"xbb@xbb.la"
#define AliPrivateKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALitmxIbx038zYto0LSK/Q3qna1Qhim0BN1WmEUlq2h/YL2cDIc3DlxTl08lvOtI6tdRZpzQaWbV7e/BEKD6b/uTnUQ4k82V/kOdpOc/DX/DL1zV1QuPZLfDY2wX0k1qF+IFI7qSmRVzjLJjzmFrQ4q/91dMpk/OZ0DWZrEsv3slAgMBAAECgYAcBuzT0LdslIM1NxEFdVp2NDb9yIyz44ghdzTguZjL4Rjzba1RD//z7xO1hUqogoZxav8hqVd1rd3QVwKJC7jWuU7lOZxsuRGiPoiEsGvyq7mDAboMbY93zbsyD8qgXdHPMtL1MgVqG47SYgEQfFWOcUBf6Ox1dzAC0e71OMQbgQJBANo9Ye01gzEplqwZ8CWSIxzK5aeXUs80ebrX43ide1tdn984P2tXsngOSSYw5OiNWasnWnqVtvnHIIXepuVQGXUCQQDYoai6nwqS/1Ena6/HQVFvqqmmDf9jerIjB86OGRHg9Yjp/tYW+QFa6PjXzlOMsoRM5wUTOfmrdOJwgURNRPTxAkEAh/Yn1P06n102hj+ekfmKMHzjOFaY+4fIsrOe/ly2JkScvhcvw3MeN5dG0Sky4wJ0s6FPyAEPvmrlAyGkPkZ5pQJBALsM+zAI24yJwH0VUrXuBG8zIUEsnPQ8oUv2FbhElVd1Kz9At4MmhrEEsLlGgoXeLrZoU82CJb6SMmOKenttq0ECQFeLmVE4daUjyyh9QH3EgaQf/IWeYf6fttYkKfUy/UIXbs6JuqayP+CQ0tXCGYK4BHVuk62Eryw1U8M9b4XLIIU="

#endif
