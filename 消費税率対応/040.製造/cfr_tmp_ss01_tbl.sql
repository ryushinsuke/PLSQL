CREATE TABLE	CFR_TMP_SS01_TBL(
	KUGIRI_1	CHAR(40)	,	/* KUGIRI_1 */
	KAI_CODE	CHAR(5)	NOT NULL,	/* 会社コード */
	IN_SYS_CODE	CHAR(10)	NOT NULL,	/* 入力システムコード */
	IN_SYS_DATE	NUMBER(8)	NOT NULL,	/* 入力システム日付 */
	IN_SYS_DATA_NO	NUMBER(8)	NOT NULL,	/* 入力システムデータ№ */
	SWK_ID	CHAR(5)	NOT NULL,	/* 入力仕訳ＩＤ */
	KESSAN_KBN	CHAR(1)	NOT NULL,	/* 決算仕訳区分 */
	IN_USR_ID	CHAR(10)	NOT NULL,	/* 入力ユーザーID */
	DEN_NO	CHAR(8)	NOT NULL,	/* 伝票番号 */
	GYO_NO	NUMBER(5)	NOT NULL,	/* 明細行番号 */
	DR_KMK_CODE	CHAR(10)	,	/* 借方勘定科目コード */
	DR_HKM_CODE	CHAR(10)	,	/* 借方補助科目コード */
	DR_BMN_CODE	CHAR(10)	,	/* 借方部門コード */
	DR_CODE1	CHAR(10)	,	/* 借方機能コード1 */
	DR_CODE2	CHAR(10)	,	/* 借方機能コード2 */
	DR_CODE3	CHAR(10)	,	/* 借方機能コード3 */
	DR_CODE4	CHAR(10)	,	/* 借方機能コード4 */
	DR_KIN	NUMBER(21,3)	,	/* 借方円貨金額（税抜） */
	DR_CUR_CODE	CHAR(3)	,	/* 借方外貨コード */
	DR_CRT_RATE_TYPE	CHAR(2)	,	/* 借方レートタイプ */
	DR_CRT_RATE	NUMBER(17,12)	,	/* 借方換算レート */
	DR_CUR_KIN	NUMBER(21,3)	,	/* 借方外貨金額 */
	DR_ZEI_CODE	CHAR(4)	,	/* 借方税処理コード */
	DR_ZEI_KBN	CHAR(1)	,	/* 借方税入力区分 */
	DR_ZEI_KIN	NUMBER(21,3)	,	/* 借方税額 */
	DR_TEKIYO1	VARCHAR2(40)	,	/* 借方摘要1 */
	DR_TEKIYO2	VARCHAR2(40)	,	/* 借方摘要2 */
	DR_TORI_KBN	CHAR(1)	,	/* 借方取引先区分 */
	DR_TORI_CODE	CHAR(20)	,	/* 借方取引先コード */
	CR_KMK_CODE	CHAR(10)	,	/* 貸方勘定科目コード */
	CR_HKM_CODE	CHAR(10)	,	/* 貸方補助科目コード */
	CR_BMN_CODE	CHAR(10)	,	/* 貸方部門コード */
	CR_CODE1	CHAR(10)	,	/* 貸方機能コード1 */
	CR_CODE2	CHAR(10)	,	/* 貸方機能コード2 */
	CR_CODE3	CHAR(10)	,	/* 貸方機能コード3 */
	CR_CODE4	CHAR(10)	,	/* 貸方機能コード4 */
	CR_KIN	NUMBER(21,3)	,	/* 貸方円貨金額（税抜） */
	CR_CUR_CODE	CHAR(3)	,	/* 貸方外貨コード */
	CR_CRT_RATE_TYPE	CHAR(2)	,	/* 貸方レートタイプ */
	CR_CRT_RATE	NUMBER(17,12)	,	/* 貸方換算レート */
	CR_CUR_KIN	NUMBER(21,3)	,	/* 貸方外貨金額 */
	CR_ZEI_CODE	CHAR(4)	,	/* 貸方税処理コード */
	CR_ZEI_KBN	CHAR(1)	,	/* 貸方税入力区分 */
	CR_ZEI_KIN	NUMBER(21,3)	,	/* 貸方税額 */
	CR_TEKIYO1	VARCHAR2(40)	,	/* 貸方摘要1 */
	CR_TEKIYO2	VARCHAR2(40)	,	/* 貸方摘要2 */
	CR_TORI_KBN	CHAR(1)	,	/* 貸方取引先区分 */
	CR_TORI_CODE	CHAR(20)	,	/* 貸方取引先コード */
	SWK_JYO1	CHAR(20)	,	/* 仕訳条件項目1 */
	SWK_JYO2	CHAR(20)	,	/* 仕訳条件項目2 */
	SWK_JYO3	CHAR(20)	,	/* 仕訳条件項目3 */
	SWK_JYO4	CHAR(20)	,	/* 仕訳条件項目4 */
	SWK_JYO5	CHAR(20)	,	/* 仕訳条件項目5 */
	KAIKEI_KOUMOKU1	VARCHAR(40)	,	/* 管理会計用項目1 */
	KAIKEI_KOUMOKU2	VARCHAR(40)	,	/* 管理会計用項目2 */
	KAIKEI_KOUMOKU3	VARCHAR(40)	,	/* 管理会計用項目3 */
	KAIKEI_KOUMOKU4	VARCHAR(40)	,	/* 管理会計用項目4 */
	KAIKEI_KOUMOKU5	VARCHAR(40)	,	/* 管理会計用項目5 */
	KANRI_COMMENT1	VARCHAR(40)	,	/* 管理用コメント1 */
	KANRI_COMMENT2	VARCHAR(40)	,	/* 管理用コメント2 */
	KANRI_COMMENT3	VARCHAR(40)	,	/* 管理用コメント3 */
	KANRI_COMMENT4	VARCHAR(40)	,	/* 管理用コメント4 */
	KANRI_COMMENT5	VARCHAR(40)	,	/* 管理用コメント5 */
	KANRI_COMMENT6	VARCHAR(40)	,	/* 管理用コメント6 */
	KANRI_COMMENT7	VARCHAR(40)	,	/* 管理用コメント7 */
	KANRI_COMMENT8	VARCHAR(40)	,	/* 管理用コメント8 */
	KANRI_COMMENT9	VARCHAR(40)	,	/* 管理用コメント9 */
	KANRI_COMMENT10	VARCHAR(40)	,	/* 管理用コメント10 */
	AUS_FLG_01	CHAR(1)	,	/* 一次承認フラグ */
	AU_USR_ID_01	CHAR(10)	,	/* 一次承認ユーザーID */
	AUS_DATE_01	NUMBER(8)	,	/* 一次承認日 */
	AUS_FLG_02	CHAR(1)	,	/* 二次承認フラグ */
	AU_USR_ID_02	CHAR(10)	,	/* 二次承認ユーザーID */
	AUS_DATE_02	NUMBER(8)	,	/* 二次承認日 */
	SYO_FLG	CHAR(1)	,	/* 処理フラグ */
	KUGIRI_2	CHAR(40)	,	/* KUGIRI_2 */
	ZEN_BASE_MONTH	CHAR(6)			NOT NULL,	/* 前回基準月 */
	ZEN_SETTLEMENT_DATE	CHAR(8)		NOT NULL,	/* 前回締日 */
	KUGIRI_3	CHAR(40)	,	/* KUGIRI_3 */
	J_CONTRACT_NO	CHAR(20)		NOT NULL,	/* 契約番号 */
	J_BASE_MONTH	CHAR(6)			NOT NULL,	/* 基準月 */
	J_CURRENCY_CODE	CHAR(3)	DEFAULT '999'	NOT NULL,	/* 通貨コード */
	J_ASSET_TYPE_CODE	CHAR(3)	DEFAULT '999'	NOT NULL,	/* 資産種別コード */
	J_SETTLEMENT_DATE	CHAR(8)		NOT NULL,	/* 締日 */
	J_FIX_COM_FLAG	CHAR(1)	DEFAULT '0'	NOT NULL,	/* 確定外部委託顧問料入力区分 */
	J_FIX_COM_J		NUMBER(18,3),			/* 確定外部委託顧問料（円） */
	KUGIRI_4	CHAR(40)	,	/* KUGIRI_4 */
	K_CONTRACT_NO	CHAR(20)		NOT NULL,	/* 契約番号 */
	K_INSERT_DATE	CHAR(8)		NOT NULL,	/* 登録日 */
	K_CONTRACT_FLAG	CHAR(1)	DEFAULT '1'	NOT NULL,	/* 契約区分 */
	K_COMPANY_CODE	CHAR(4)		NOT NULL,	/* 運用会社コード */
	K_COM_CALC_START	CHAR(8)			,	/* 顧問料計算開始日 */
	K_TAX_CALC_FLAG	CHAR(1)	DEFAULT '0'	NOT NULL,	/* 消費税計算有無 */
/*       2014-02-11 消費税対応 START */
	K_ADV_LEAVE_FLAG	CHAR(1)	DEFAULT '0'	NOT NULL,	/* 助言／一任区分 */
/*       2014-02-11 消費税対応 STOP */
	K_INVALID_FLAG	CHAR(1)	DEFAULT '0'	NOT NULL,	/* 無効フラグ */
/*       2014-02-11 消費税対応 START */
	K_ASSET_CODE	CHAR(20)	DEFAULT '                    '	NOT NULL,	/** 勘定科目コード **/
/*       2014-02-11 消費税対応 STOP */
	KUGIRI_5	CHAR(40)	,	/* KUGIRI_5 */
/*       2014-02-11 消費税対応 START */
	S_ITEM_FLAG	CHAR(1)		NOT NULL,		/* アイテム区分(当該） */
	S_USE_DATE	CHAR(8)		NOT NULL,		/* 適用開始日(当該） */
	S_TAX_RATE	NUMBER(5,2)	NOT NULL,		/* 税率(当該） */
	S_ITEM_FLAG_P	CHAR(1)	DEFAULT ' ',	/* アイテム区分(前回） */
	S_USE_DATE_P	CHAR(8)	DEFAULT '        ',	/* 適用開始日(前回） */
	S_TAX_RATE_P	NUMBER(5,2)	DEFAULT 0,	/* 税率(前回） */
/*       2014-02-11 消費税対応 STOP */
	KUGIRI_6	CHAR(40)	,	/* KUGIRI_6 */
	LAST_UPDATETIME	DATE		NOT NULL,	/* 最終更新日付時刻 */
	LAST_UPDATE_ID	CHAR(20)	NOT NULL	/* 最終更新者ID */
)
TABLESPACE CFRDA01;
