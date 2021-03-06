CREATE TABLE	CFR_TMP_SS01_TBL(
	KUGIRI_1	CHAR(40)	,	/* KUGIRI_1 */
	KAI_CODE	CHAR(5)	NOT NULL,	/* ïÐR[h */
	IN_SYS_CODE	CHAR(10)	NOT NULL,	/* üÍVXeR[h */
	IN_SYS_DATE	NUMBER(8)	NOT NULL,	/* üÍVXeút */
	IN_SYS_DATA_NO	NUMBER(8)	NOT NULL,	/* üÍVXef[^ */
	SWK_ID	CHAR(5)	NOT NULL,	/* üÍdóhc */
	KESSAN_KBN	CHAR(1)	NOT NULL,	/* Zdóæª */
	IN_USR_ID	CHAR(10)	NOT NULL,	/* üÍ[U[ID */
	DEN_NO	CHAR(8)	NOT NULL,	/* `[Ô */
	GYO_NO	NUMBER(5)	NOT NULL,	/* ¾×sÔ */
	DR_KMK_CODE	CHAR(10)	,	/* Øû¨èÈÚR[h */
	DR_HKM_CODE	CHAR(10)	,	/* ØûâÈÚR[h */
	DR_BMN_CODE	CHAR(10)	,	/* ØûåR[h */
	DR_CODE1	CHAR(10)	,	/* Øû@\R[h1 */
	DR_CODE2	CHAR(10)	,	/* Øû@\R[h2 */
	DR_CODE3	CHAR(10)	,	/* Øû@\R[h3 */
	DR_CODE4	CHAR(10)	,	/* Øû@\R[h4 */
	DR_KIN	NUMBER(21,3)	,	/* Øû~ÝàziÅ²j */
	DR_CUR_CODE	CHAR(3)	,	/* ØûOÝR[h */
	DR_CRT_RATE_TYPE	CHAR(2)	,	/* Øû[g^Cv */
	DR_CRT_RATE	NUMBER(17,12)	,	/* Øû·Z[g */
	DR_CUR_KIN	NUMBER(21,3)	,	/* ØûOÝàz */
	DR_ZEI_CODE	CHAR(4)	,	/* ØûÅR[h */
	DR_ZEI_KBN	CHAR(1)	,	/* ØûÅüÍæª */
	DR_ZEI_KIN	NUMBER(21,3)	,	/* ØûÅz */
	DR_TEKIYO1	VARCHAR2(40)	,	/* ØûEv1 */
	DR_TEKIYO2	VARCHAR2(40)	,	/* ØûEv2 */
	DR_TORI_KBN	CHAR(1)	,	/* Øûæøææª */
	DR_TORI_CODE	CHAR(20)	,	/* ØûæøæR[h */
	CR_KMK_CODE	CHAR(10)	,	/* Ýû¨èÈÚR[h */
	CR_HKM_CODE	CHAR(10)	,	/* ÝûâÈÚR[h */
	CR_BMN_CODE	CHAR(10)	,	/* ÝûåR[h */
	CR_CODE1	CHAR(10)	,	/* Ýû@\R[h1 */
	CR_CODE2	CHAR(10)	,	/* Ýû@\R[h2 */
	CR_CODE3	CHAR(10)	,	/* Ýû@\R[h3 */
	CR_CODE4	CHAR(10)	,	/* Ýû@\R[h4 */
	CR_KIN	NUMBER(21,3)	,	/* Ýû~ÝàziÅ²j */
	CR_CUR_CODE	CHAR(3)	,	/* ÝûOÝR[h */
	CR_CRT_RATE_TYPE	CHAR(2)	,	/* Ýû[g^Cv */
	CR_CRT_RATE	NUMBER(17,12)	,	/* Ýû·Z[g */
	CR_CUR_KIN	NUMBER(21,3)	,	/* ÝûOÝàz */
	CR_ZEI_CODE	CHAR(4)	,	/* ÝûÅR[h */
	CR_ZEI_KBN	CHAR(1)	,	/* ÝûÅüÍæª */
	CR_ZEI_KIN	NUMBER(21,3)	,	/* ÝûÅz */
	CR_TEKIYO1	VARCHAR2(40)	,	/* ÝûEv1 */
	CR_TEKIYO2	VARCHAR2(40)	,	/* ÝûEv2 */
	CR_TORI_KBN	CHAR(1)	,	/* Ýûæøææª */
	CR_TORI_CODE	CHAR(20)	,	/* ÝûæøæR[h */
	SWK_JYO1	CHAR(20)	,	/* dóðÚ1 */
	SWK_JYO2	CHAR(20)	,	/* dóðÚ2 */
	SWK_JYO3	CHAR(20)	,	/* dóðÚ3 */
	SWK_JYO4	CHAR(20)	,	/* dóðÚ4 */
	SWK_JYO5	CHAR(20)	,	/* dóðÚ5 */
	KAIKEI_KOUMOKU1	VARCHAR(40)	,	/* ÇïvpÚ1 */
	KAIKEI_KOUMOKU2	VARCHAR(40)	,	/* ÇïvpÚ2 */
	KAIKEI_KOUMOKU3	VARCHAR(40)	,	/* ÇïvpÚ3 */
	KAIKEI_KOUMOKU4	VARCHAR(40)	,	/* ÇïvpÚ4 */
	KAIKEI_KOUMOKU5	VARCHAR(40)	,	/* ÇïvpÚ5 */
	KANRI_COMMENT1	VARCHAR(40)	,	/* ÇpRg1 */
	KANRI_COMMENT2	VARCHAR(40)	,	/* ÇpRg2 */
	KANRI_COMMENT3	VARCHAR(40)	,	/* ÇpRg3 */
	KANRI_COMMENT4	VARCHAR(40)	,	/* ÇpRg4 */
	KANRI_COMMENT5	VARCHAR(40)	,	/* ÇpRg5 */
	KANRI_COMMENT6	VARCHAR(40)	,	/* ÇpRg6 */
	KANRI_COMMENT7	VARCHAR(40)	,	/* ÇpRg7 */
	KANRI_COMMENT8	VARCHAR(40)	,	/* ÇpRg8 */
	KANRI_COMMENT9	VARCHAR(40)	,	/* ÇpRg9 */
	KANRI_COMMENT10	VARCHAR(40)	,	/* ÇpRg10 */
	AUS_FLG_01	CHAR(1)	,	/* ê³FtO */
	AU_USR_ID_01	CHAR(10)	,	/* ê³F[U[ID */
	AUS_DATE_01	NUMBER(8)	,	/* ê³Fú */
	AUS_FLG_02	CHAR(1)	,	/* ñ³FtO */
	AU_USR_ID_02	CHAR(10)	,	/* ñ³F[U[ID */
	AUS_DATE_02	NUMBER(8)	,	/* ñ³Fú */
	SYO_FLG	CHAR(1)	,	/* tO */
	KUGIRI_2	CHAR(40)	,	/* KUGIRI_2 */
	ZEN_BASE_MONTH	CHAR(6)			NOT NULL,	/* Oñî */
	ZEN_SETTLEMENT_DATE	CHAR(8)		NOT NULL,	/* Oñ÷ú */
	KUGIRI_3	CHAR(40)	,	/* KUGIRI_3 */
	J_CONTRACT_NO	CHAR(20)		NOT NULL,	/* _ñÔ */
	J_BASE_MONTH	CHAR(6)			NOT NULL,	/* î */
	J_CURRENCY_CODE	CHAR(3)	DEFAULT '999'	NOT NULL,	/* ÊÝR[h */
	J_ASSET_TYPE_CODE	CHAR(3)	DEFAULT '999'	NOT NULL,	/* YíÊR[h */
	J_SETTLEMENT_DATE	CHAR(8)		NOT NULL,	/* ÷ú */
	J_FIX_COM_FLAG	CHAR(1)	DEFAULT '0'	NOT NULL,	/* mèOÏõÚâ¿üÍæª */
	J_FIX_COM_J		NUMBER(18,3),			/* mèOÏõÚâ¿i~j */
	KUGIRI_4	CHAR(40)	,	/* KUGIRI_4 */
	K_CONTRACT_NO	CHAR(20)		NOT NULL,	/* _ñÔ */
	K_INSERT_DATE	CHAR(8)		NOT NULL,	/* o^ú */
	K_CONTRACT_FLAG	CHAR(1)	DEFAULT '1'	NOT NULL,	/* _ñæª */
	K_COMPANY_CODE	CHAR(4)		NOT NULL,	/* ^pïÐR[h */
	K_COM_CALC_START	CHAR(8)			,	/* Úâ¿vZJnú */
	K_TAX_CALC_FLAG	CHAR(1)	DEFAULT '0'	NOT NULL,	/* ÁïÅvZL³ */
/*       2014-02-11 ÁïÅÎ START */
	K_ADV_LEAVE_FLAG	CHAR(1)	DEFAULT '0'	NOT NULL,	/* ¾^êCæª */
/*       2014-02-11 ÁïÅÎ STOP */
	K_INVALID_FLAG	CHAR(1)	DEFAULT '0'	NOT NULL,	/* ³øtO */
/*       2014-02-11 ÁïÅÎ START */
	K_ASSET_CODE	CHAR(20)	DEFAULT '                    '	NOT NULL,	/** ¨èÈÚR[h **/
/*       2014-02-11 ÁïÅÎ STOP */
	KUGIRI_5	CHAR(40)	,	/* KUGIRI_5 */
/*       2014-02-11 ÁïÅÎ START */
	S_ITEM_FLAG	CHAR(1)		NOT NULL,		/* ACeæª(Yj */
	S_USE_DATE	CHAR(8)		NOT NULL,		/* KpJnú(Yj */
	S_TAX_RATE	NUMBER(5,2)	NOT NULL,		/* Å¦(Yj */
	S_ITEM_FLAG_P	CHAR(1)	DEFAULT ' ',	/* ACeæª(Oñj */
	S_USE_DATE_P	CHAR(8)	DEFAULT '        ',	/* KpJnú(Oñj */
	S_TAX_RATE_P	NUMBER(5,2)	DEFAULT 0,	/* Å¦(Oñj */
/*       2014-02-11 ÁïÅÎ STOP */
	KUGIRI_6	CHAR(40)	,	/* KUGIRI_6 */
	LAST_UPDATETIME	DATE		NOT NULL,	/* ÅIXVút */
	LAST_UPDATE_ID	CHAR(20)	NOT NULL	/* ÅIXVÒID */
)
TABLESPACE CFRDA01;
