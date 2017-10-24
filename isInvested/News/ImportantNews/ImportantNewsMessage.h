//
//  ImportantNewsMessage.h
//  isInvested
//
//  Created by Blue on 16/9/27.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImportantNewsMessage : NSObject

/** 标题 */
@property (nonatomic, copy) NSString *Art_Title;
/** 来源 */
@property (nonatomic, copy) NSString *Art_Media_Name;
/** 时间 */
@property (nonatomic, copy) NSString *Art_ShowTime;
/** 所有图片 */
@property (nonatomic, copy) NSString *Art_Image;

/** 来源 & 时间 */
@property (nonatomic, copy) NSString *Art_MediaAndTime;
/** 所有图片数组 */
@property (nonatomic, strong) NSArray<NSString *> *Art_Images;
@property (nonatomic, copy) NSString *Art_Code;
@property (nonatomic, assign) CGFloat cellHeight;

/** 分享的描述 */
@property (nonatomic, copy) NSString *Art_Docu_Reader;
@property (nonatomic, copy) NSString *Art_VisitCount;
@property (nonatomic, copy) NSString *Art_Content;
@property (nonatomic, copy) NSString *ShareUrl;
/** 来源 & 时间 */
@property (nonatomic, copy) NSString *mediaAndTime;
@end
//{
//    "Art_Code" = 2016092789232934;
//    "Art_ColumnId" = 710;
//    "Art_Docu_Reader" = "英国工业联盟和普华永道在本月对115家英国金融服务公司进行了调查。公布的调查结果显示，英国金融业信心创下金融危机以来的最低点。金融业是英国经济最大税收来源，因为英国金融公司受益于欧盟的“护照”，能以英国为基地，在欧盟进行运作。";
//    "Art_Image" = "http://img.cngold.com.cn/2016/9/27/201609271003321124500111_m.jpg|http://img.cngold.com.cn/2016/9/27/201609271005091072406188_m.jpg|http://img.cngold.com.cn/2016/9/27/201609271010011861029915_m.jpg";
//    "Art_Media_Name" = "中金网";
//    "Art_ShowTime" = "2016-09-27 10:40:00";
//    "Art_Title" = "英国脱欧重挫国内金融服务业信心";
//    "Art_VisitCount" = 475;
//},


//model =     {
//    "Art_ArtRelationJson" = "[{"As_Code":"2016092789367019","As_Title":"“硬退欧”或致英国损失100亿税收","As_URL":"http://news.cngold.com.cn/20160927d1702n89367019.html","As_Type":"1","As_Time":"2016/9/27 19:18:00","As_Var":"","As_Img":"http://img.cngold.com.cn/2016/9/27/20160927195646109045853_m.jpg","As_Visit":"146"},{"As_Code":"2016092789232934","As_Title":"英国脱欧重挫国内金融服务业信心","As_URL":"http://forex.cngold.com.cn/20160927d1710n89232934.html","As_Type":"1","As_Time":"2016/9/27 9:36:28","As_Var":"","As_Img":"http://img.cngold.com.cn/2016/9/27/201609271003321124500111_m.jpg","As_Visit":"135"},{"As_Code":"2016092689044855","As_Title":"脱欧致76%的CEO考虑将总部迁出英国","As_URL":"http://www.cngold.com.cn/stock/20160926d1986n89044855.html","As_Type":"1","As_Time":"2016/9/26 14:58:42","As_Var":"","As_Img":"http://img.cngold.com.cn/2016/9/26/20160926191148380717273_m.jpg","As_Visit":"134"},{"As_Code":"2016092688960322","As_Title":"为何英国退欧担忧被过分夸大了","As_URL":"http://www.cngold.com.cn/zjsd/20160926d1861n88960322.html","As_Type":"1","As_Time":"2016/9/26 14:58:42","As_Var":"","As_Img":"http://img.cngold.com.cn/2016/9/26/201609261651281878066788_m.jpg","As_Visit":"135"}]";
//    "Art_Code" = 2016092889549969;
//    "Art_Content" = "<p>　　<strong><span id='Info.3193'>中金网</span>09月28日讯</strong>，在今日（9月28日）英国央行副行长夏菲克（Nemat Shafik）表示，英国为了应对脱欧带来的经济冲击，央行在某一时点注入一剂猛药，提升经济的发展。</p><center><img src='http://img.cngold.com.cn/2016/9/28/20160928170313544161598.jpg  ' alt='英国央行' title='英国央行' style='border:#d1d1d1 1px solid;padding:3px;margin:5px 0;' /></center><p>　　夏菲克在要讲话中曾经表示，公投过后英国正在经受巨大的经济冲击。</p><p>　　英国央行此前曾暗示，可能会在今年晚些时候降息，不过一直有迹象显示，英国经济受退欧冲击的程度没有央行原本预想的那么大。</p><p>　　夏菲克指出，英国企业对欧盟市场的准入机会有可能减少，“退欧进程拖延”这种结果带来的不确定性打击商业投资前景。</p><p>　　6月23日英国公投以来<span id='Info.333156'>英镑汇率</span>下跌，正提振英国经济，而英国经济的灵活性足以应对这种变动。但夏菲克表示，调整过程可能是痛苦的。</p><p>　　夏菲克称，“这是货币政策可以帮上忙的地方，在我看来，似乎需要在某个时候进一步实施货币刺激政策，以便帮助确保经济活动放缓不会演化成更恶性的事件。”</p><p>　　英国脱欧公投对英国经济的冲击相当大，有迹象显示外资企业对在英国投资更加谨慎，而<span id='Info.3649'>英镑</span>贬值正有助于推动经济找到新的均衡点。</p>";
//    "Art_Docu_Reader" = "在今日（9月28日）英国央行副行长夏菲克（Nemat Shafik）表示，英国为了应对脱欧带来的经济冲击，央行在某一时点注入一剂猛药，提升经济的发展。";
//    "Art_Guidance" = "中金网09月28日讯，在今日9月28日“英国”央行副行长“夏菲克”NematShafik表示，英国为了应对脱欧带来的经济冲击，央行在某一时点注入一剂猛药，提升经济的发展。6月23日英国公投以来英镑汇率下跌，正提振英国经济，而英国经济的灵活性足以应对这种变动。英国脱欧公投对英国经济的冲击相当大，有迹象显示外资企业对在英国投资更加谨慎，而英镑贬值正有助于推动经济找到新的均衡点。";
//    "Art_Image" = "http://img.cngold.com.cn/2016/9/28/20160928170313544161598.jpg";
//    "Art_Key" = "夏菲克,英国,英银";
//    "Art_Media_Name" = "中金网";
//    "Art_OriginalTitle" = "";
//    "Art_ShowTime" = 1475054220;
//    "Art_SimTitle" = "夏菲克：英央行或将注入一剂“猛药”";
//    "Art_Title" = "夏菲克：英央行或将注入一剂“猛药”";
//    "Art_Url" = "http://forex.cngold.com.cn/20160928d1710n89549969.html";
//    "Art_VisitCount" = 120;
//    ShareUrl = "http://m.cngold.com.cn/app/newsdetail.aspx?id=2016092889549969";
//};
