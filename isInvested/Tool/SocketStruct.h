
/** 登录包 */
#pragma pack(1)
struct LoginPack{
    char                head[4];           //里面放"2010"
    int                 length;           //2010后放着个字段表示后面的长度
    unsigned short      m_nType;	     // 请求类型
    char				m_nIndex;     	 // 请求索引，与请求数据包一致
    char				m_No;            //不用
    int                 m_lKey;		 	 // 一级标识，通常为窗口句柄
    short				m_cCodeType;	//不用
    char				m_cCode[6];		// 不用
    short     			m_nSize;         // 不用
    unsigned short      m_nOption;       // 为了4字节对齐而添加的字段
    char                m_szUser[64];	// 用户名
    char                m_szPWD[64];	// 密码(加密密文），详细参加协议
};
typedef struct LoginPack LoginPack;

/** 心跳包 */
#pragma pack(1)
struct TestSrvData2 {
    char            head[4];            //   32 30 31 30
    int             length;             //04 00 00 00
    unsigned short  m_nType;			//  05 09
    char            m_nIndex;     		// 00
    char            m_cOperator;   		// 00
};
typedef struct TestSrvData2 TestSrvData2;

#pragma pack(1)
struct MorePack {
    char                m_head[4];          //4个字节  32 30 31 30
    int                 m_length;           //4个字节  1c 00 00 00
    unsigned short 		m_nType;            // 2个字节 01 02
    char				m_nIndex;           // 1个字节 00
    char				m_No;               //1个字节 00
    int                 m_lKey;             // 4个字节  00 00 00 00
    unsigned short		m_cCodeType;        //2个字节 00 00
    char				m_cCode[6];         // 6个字节   00 00 00 00 00 00
    unsigned short     	m_nSize;            // 2个字节  01 00
    unsigned short		m_nOption;          // 2个字节   80 00
};
typedef struct MorePack MorePack;

/** code & codeType */
#pragma pack(1)
struct CodeInfo {
    unsigned short      m_cCodeType2;
    char				m_cCode2[6];
};
typedef struct CodeInfo CodeInfo;

#pragma pack(1)
struct DataHead {
    char str[4];
    int  leng;
    unsigned short		m_nType;         // 请求类型，与请求数据包一致   当返回0x0102的时候为成功
    char				m_nIndex;     	 // 请求索引，与请求数据包一致
};
typedef struct DataHead DataHead;

#pragma pack(1)
struct AskData {
    unsigned short 		m_nType;	     // 请求类型
    char				m_nIndex;     	 // 请求索引，与请求数据包一致
    char                m_not;
    int                 m_lKey;		 	 // 一级标识，通常为窗口句柄
    unsigned short      m_cCodeType;	// 证券类型
    char				m_cCode[6];		// 证券代码
    unsigned short      m_nSize;         // 请求证券总数，小于零时，
    // 其绝对值代表后面的字节数
    unsigned short		m_nOption;       // 为了4字节对齐而添加的字段
    unsigned short      m_cCodeType2;	// 证券类型
    char				m_cCode2[6];		// 证券代码
};
typedef struct AskData AskData; // length==28

#pragma pack(1)
struct SizeData {
    char				xxxx[24];
    unsigned short      m_nSize;
    unsigned short      xx;
};
typedef struct SizeData SizeData; //只为取size

/**
 *  主推和实时的时间
 *
 */
#pragma pack(1)
struct StockOtherData2 {
    unsigned short m_nTime;      // 分钟数
    unsigned short m_nSecond;    // 秒数
    unsigned int  m_lCurrent;    // 现在总手
    unsigned int  m_lOutside;    // 外盘
    unsigned int  m_lInside;     // 内盘
    unsigned int  m_lPreClose;   // 对于外汇时，昨收盘数据
    int           m_lSortValue;  // 排名时，为排序后的值
};
typedef struct StockOtherData2 StockOtherData2;


/**
 *  得到返回包的类型后若是实时数据包（RT_REALTIME），用RealTimeData结构体解析,其m_cNowData字段就是多需要的数据（需要转为HSWHRealTime结型）
 *
 *
 */
#pragma pack(1)
struct CommRealTimeData {
    unsigned short	m_cCodeType;            // 证券类型
    char            m_cCode[6];             // 证券代码
    StockOtherData2 m_othData;              // 实时其它数据
};
typedef struct CommRealTimeData CommRealTimeData; //sizeof(CommRealTimeData)==32

/**
 *  得到返回包的类型后若是实时数据包（RT_TECHDATA_EX），用RealTimeData结构体解析,其m_cNowData字段就是多需要的数据（需要转为HSWHRealTime）
 *  下面是外汇结构体 codetype=0x8100和0x8200
 */
#pragma pack(1)
struct HSWHRealTime {
    int		m_lOpen;         	// 今开盘(1/10000元)
    int		m_lMaxPrice;     	// 最高价(1/10000元)
    int		m_lMinPrice;     	// 最低价(1/10000元)
    int		m_lNewPrice;     	// 最新价(1/10000元)
    int		m_lBuyPrice;		// 买价(1/10000元)
    int		m_lSellPrice;		// 卖价(1/10000元)
};
typedef struct HSWHRealTime HSWHRealTime;

/** 大宗用这个 */
#pragma pack(1)
struct HSWHRealTime2 {
    int				m_lOpen;                // 今开盘
    int				m_lMaxPrice;            // 最高价
    int				m_lMinPrice;            // 最低价
    int				m_lNewPrice;            // 最新价
    
    int             m_lTotal;               // 成交量(单位:合约单位)
    int				m_lChiCangLiang;        // 持仓量(单位:合约单位)
    
    int				m_lBuyPrice1;           // 买一价
    int				m_lBuyCount1;           // 买一量
    int				m_lSellPrice1;          // 卖一价
    int				m_lSellCount1;          // 卖一量
    int				m_lPreJieSuanPrice;     // 昨结算价 //44
    
    int				m_lBuyPrice2;			// 买二价
    unsigned short	m_lBuyCount2;		// 买二量
    int				m_lBuyPrice3;			// 买三价
    unsigned short	m_lBuyCount3;		// 买三量
    int				m_lBuyPrice4;			// 买四价
    unsigned short	m_lBuyCount4;		// 买四量
    int				m_lBuyPrice5;			// 买五价
    unsigned short	m_lBuyCount5;		// 买五量
    
    int				m_lSellPrice2;			// 卖二价
    unsigned short	m_lSellCount2;		// 卖二量
    int				m_lSellPrice3;			// 卖三价
    unsigned short	m_lSellCount3;		// 卖三量
    int				m_lSellPrice4;			// 卖四价
    unsigned short	m_lSellCount4;		// 卖四量
    int				m_lSellPrice5;			// 卖五价
    unsigned short	m_lSellCount5;		// 卖五量
    
    int				m_lPreClose1;			// 昨收 9*4 +8*2 +8
    int             m_nHand;				// 每手股数
    int             m_lPreCloseChiCang;		// 昨持仓量(单位:合约单位)
};
typedef struct HSWHRealTime2 HSWHRealTime2;  //length==104

/**
 *  这个结构体是压缩包的信息
 */
#pragma pack(1)
struct TransZipData2 {
    unsigned short	m_nType;		// 请求类型,恒为RT_ZIPDATA
    short 			m_nAlignment;	// 为了4字节对齐而添加的字段
    int             m_lZipLen;		// 压缩后的长度
    int             m_lOrigLen;		// 压缩前的长度
};
typedef struct TransZipData2 TransZipData2;

//这个结构体是解压后数据信息
#pragma pack(1)
struct AnsTrendData2 {
    unsigned short		m_nType;                // 请求类型，与请求数据包一致
    char				m_nIndex;               // 请求索引，与请求数据包一致
    char			    m_cSrv;                 // 服务器使用
    int                 m_lKey;                 // 一级标识，通常为窗口句柄
    unsigned short	    m_cCodeType;            // 证券类型
    char				m_cCode[6];             // 证券代码
    unsigned short      m_nHisLen;              // 分时数据个数
    unsigned short      m_nAlignment;           // 为了4字节对齐而添加的字段
    char				m_othData[24];			// 实时其它数据
    char  			  	m_otnerdata2[112];
};
typedef struct AnsTrendData2 AnsTrendData2;

// 指标类实时数据
struct HSIndexRealTime {
    int		m_lOpen;				// 今开盘
    int		m_lMaxPrice;			// 最高价
    int		m_lMinPrice;			// 最低价
    int		m_lNewPrice;			// 最新价
    unsigned int		m_lTotal;				// 成交量
    float		m_fAvgPrice;			// 成交金额
    short		m_nRiseCount;			// 上涨家数
    short		m_nFallCount;			// 下跌家数
    int		m_nTotalStock1;			/* 对于综合指数：所有股票 - 指数
                                    对于分类指数：本类股票总数 */
    unsigned int		m_lBuyCount;			// 委买数
    unsigned int		m_lSellCount;			// 委卖数
    short		m_nType;				// 指数种类：0-综合指数 1-A股 2-B股
    short		m_nLead;            	// 领先指标
    short		m_nRiseTrend;       	// 上涨趋势
    short		m_nFallTrend;       	// 下跌趋势
    short		m_nNo2[5];				// 保留
    short		m_nTotalStock2;			/* 对于综合指数：A股 + B股
                                         对于分类指数：0 */
    int		m_lADL;					// ADL 指标
    int		m_lNo3[3];				// 保留
    int		m_nHand;				// 每手股数
};
typedef struct HSIndexRealTime HSIndexRealTime;

/** -----------------------------------以下是分时----------------------------------------------------- */

/** 历史分时 */
struct HistoryTrendPack {
    char                m_head[4];           //里面放"2010"
    int                 m_length;           //2010后放着个字段表示后面的长度
    unsigned short 		m_nType;	     // 请求类型
    char				m_nIndex;     	 // 请求索引，与请求数据包一致
    char				m_No;            //不用
    int                 m_lKey;		 	 // 一级标识，通常为窗口句柄
    unsigned short		m_cCodeType;	//不用
    char				m_cCode[6];		// 不用
    short     			m_nSize;         // 请求证券总数，小于零时，
    unsigned short		m_nOption;       // 为了4字节对齐而添加的字段
    unsigned short      m_cCodeType2;	//不用
    char				m_cCode2[6];		// 不用
    int                 m_lDate;               //此处是负数  例如-2表示两天之前的数据
};
typedef struct HistoryTrendPack HistoryTrendPack;

/** 分时数据请求包 */
#pragma pack(1)
struct TrendPack {
    char                m_head[4];          //4个字节 32 30 31 30
    int                 m_length;           //4个字节  1c 00 00 00
    unsigned short 		m_nType;            // 2个字节  01 03
    char				m_nIndex;           // 1个字节 00
    char				m_No;               //1个字节   00
    int                 m_lKey;             // 4个字节   00 00 00 00
    unsigned short		m_cCodeType;        //2个字节    00 81
    char				m_cCode[6];         // 6个字节    45 55 52 55 53 44
    short     			m_nSize;            // 2个字节   00 00
    unsigned short		m_nOption;          // 2个字节     80 00
    unsigned short		m_cCodeType2;       //2个字节   00 81
    char				m_cCode2[6];		// 6个字节     45 55 52 55 53 44
};
typedef struct TrendPack TrendPack;

//分时数据结构
#pragma pack(1)
struct PriceVolItem2 {
    int			    m_lNewPrice;	// 最新价
    int             m_lTotal;		// 成交量(在外汇时，是跳动量)
};
typedef struct PriceVolItem2 PriceVolItem2;


//历史分时1分钟数据
#pragma pack(1)
struct StockCompHistoryData {
    int         m_lNewPrice;		// 最新价
    unsigned	m_lTotal;			/* 成交量 //对于股票(单位:股)
                                         对于指数(单位:百股) */
    float       m_fAvgPrice;		/*成交金额 */
    int         m_lBuyCount;        // 委买量
    int         m_lSellCount;       // 委卖量
};
typedef struct StockCompHistoryData StockCompHistoryData;

/** 历史数据请求包 */
#pragma pack(1)
struct TeachPack {
    char                m_head[4];          //4个字节   32 30 31 30
    int                 m_length;           //4个字节     28 00 00 00
    unsigned short 		m_nType;            // 2个字节  02 04
    char				m_nIndex;           // 1个字节 00
    char				m_No;               //1个字节  00
    int                 m_lKey;             // 4个字节 00 00 00 00
    unsigned short		m_cCodeType;        //2个字节  00 81
    char				m_cCode[6];         // 6个字节 45 55 52 55 53 44
    unsigned short      m_nSize;            // 2个字节 01 00
    unsigned short		m_nOption;          // 2个字节 80 00
    short				m_nPeriodNum;		// 2个字节 01 00
    unsigned short		m_nSize2;			// 2个字节 00 00
    int                 m_lBeginPosition;	// 4个字节   00 00 00 00
    unsigned short		m_nDay;				// 2个字节  0a 00
    short				m_cPeriod;          // 2个字节 10 00
    unsigned short      m_cCodeType2;       //2个字节   00 81
    char				m_cCode2[6];		// 6个字节  45 55 52 55 53 44
};
typedef struct TeachPack TeachPack;

/** 分时历史, 解析用的头 */
#pragma pack(1)
struct AnsHisTrend2 {
    unsigned short		m_nType;         // 请求类型，与请求数据包一致
    char				m_nIndex;     	 // 请求索引，与请求数据包一致
    char                m_cSrv;          // 服务器使用
    int                 m_lKey;		 	 // 一级标识，通常为窗口句柄
    unsigned short      m_cCodeType;	// 证券类型
    char				m_cCode[6];		// 证券代码
    int                 m_lDate;		// 日期
    int                 m_lPrevClose;	// 昨收
    char                m_no[112];
    short			    m_nSize;		//  每天数据总个数
    short				m_nAlignment;   //  对齐用
};
typedef struct AnsHisTrend2 AnsHisTrend2;

#pragma pack(1)
struct AnsDayDataEx2 {
    unsigned short		m_nType;            // 请求类型，与请求数据包一致
    char				m_nIndex;           // 请求索引，与请求数据包一致
    char                m_Not;
    int                 m_lKey;             // 一级标识，通常为窗口句柄
    unsigned short	    m_cCodeType;        // 证券类型
    char				m_cCode[6];         // 证券代码
    int                 m_nSize;			//日线数据个数
    //    StockCompDayDataEx  	            m_sdData[1];		//日线数据
    int             m_lDate;                // 日期
    int             m_lOpenPrice;           // 开
    int             m_lMaxPrice;            // 高
    int             m_lMinPrice;            // 低
    int             m_lClosePrice;          // 收
    int             m_lMoney;               // 成交金额
    int             m_lTotal;               // 成交量
    int             m_lNationalDebtRatio;   // 国债利率(单位为0.1分),基金净值(单位为0.1分), 无意义时，须将其设为0 2004年2月26日加入
};
typedef struct AnsDayDataEx2 AnsDayDataEx2; //length==52

#pragma pack(1)
struct StockCompDayDataEx {
    int             m_lDate;                // 日期
    int             m_lOpenPrice;           // 开
    int             m_lMaxPrice;            // 高
    int             m_lMinPrice;            // 低
    int             m_lClosePrice;          // 收
    unsigned int    m_lMoney;               // 成交金额
    int             m_lTotal;               // 成交量
    int             m_lNationalDebtRatio;   // 国债利率(单位为0.1分),基金净值(单位为0.1分), 无意义时，须将其设为0 2004年2月26日加入
};
typedef struct StockCompDayDataEx StockCompDayDataEx;  //32
