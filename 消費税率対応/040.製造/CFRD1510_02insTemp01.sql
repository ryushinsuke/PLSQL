/*******************************************************************************
*
* プロジェクト : NAM顧問料デイリー算出システム
* 機能名           : 日次SS用外部委託未払計上額接続ファイル作成
*                                バッチ(CFRD1510.csh)用SQL
*                                SS用中間テーブル1 INSERT_SQL
* ファイル名   : CFRD1510_02insTemp01.sql
* 置換変数         : WK_YOKUEI_YYYYMMDD 当csh用翌営業日
*                                JOBID                          JOBID
*                                CFR_SS_SAVE_YEAR       [CFR_SS_STATUS_TBL]保存年数
*
* 作成日           : 2009/02/28
* 作成者           : SRA米原
*
* 更新日           : 2009/06/15
* 作成者           : SRA米原
* 更新概要         : 200906-04.投信外部委託顧問料のSSJ接続追加対応
*                  下記項目のセット内容変更
*                     1)仕訳ID(SWK_ID)
*                     2)借方機能コード4(DR_CODE4)
*                     3)貸方機能コード4(CR_CODE4)
*                     4)管理会計用項目4(KAIKEI_KOUMOKU4)
*                     5)管理用コメント10(KANRI_COMMENT10)
*                     6)管理用コメント4(KANRI_COMMENT4)
*
* 更新日           : 2009/11/05
* 作成者           : SRA米原
* 更新概要         : 200910-01.SSJ改善対応
*                  下記項目のセット内容変更
*                     1)仕訳ID(SWK_ID)
*                     2)借方機能コード4(DR_CODE4)
*                     3)貸方機能コード4(CR_CODE4)
*                     4)借方摘要1(DR_TEKIYO1)
*                     5)貸方摘要1(CR_TEKIYO1)
*                     6)管理会計用項目4(KAIKEI_KOUMOKU4)
*                     7)管理用コメント10(KANRI_COMMENT10)
*                     8)借方税処理コード(DR_ZEI_CODE)
*                     9)貸方税処理コード(CR_ZEI_CODE)
*
* 更新日           : 2010/07/20
* 作成者           : SRA西濱
* 更新概要         : 2010-05.SSJ勘定科目追加対応
*                  下記項目のセット内容変更
*                    ASSET_CODEとTAX_CALC_FLAGをCASE文で振り分け
*                    SWK_IDを取得している部分を、
*                    勘定科目変換テーブルを参照して取得するように変更
*
* 更新日           : 2014/02/12
* 作成者           : GUT高
* 更新概要         : 2014-02-12 消費税対応
*                  下記項目のセット内容変更
*                     1)仕訳ID(SWK_ID)
*                     2)伝票番号(DEN_NO)
*                     3)借方機能コード4(DR_CODE4)
*                     4)借方税額(DR_ZEI_KIN)
*                     5)貸方機能コード4(CR_CODE4)
*                     6)貸方税額(CR_ZEI_KIN)
*                     7)助言／一任区分(K_ADV_LEAVE_FLAG)
*                     8)勘定科目コード(K_ASSET_CODE)
*                     9)アイテム区分(当該）(S_ITEM_FLAG)
*                     10)適用開始日(当該）(S_USE_DATE)
*                     11)税率(当該）(S_TAX_RATE)
*                     12)アイテム区分(前回）(S_ITEM_FLAG_P)
*                     13)適用開始日(前回）(S_USE_DATE_P)
*                     14)税率(前回）(S_TAX_RATE_P)
*******************************************************************************/
INSERT INTO CFR_TMP_SS01_TBL
SELECT
        '*** KUGIRI_STRART_XML ***' KUGIRI_1,
        'NAMD' KAI_CODE,
        'A8' IN_SYS_CODE,
        TO_NUMBER('&&WK_YOKUEI_YYYYMMDD') IN_SYS_DATE,
        0 IN_SYS_DATA_NO,
/*      200906-04.投信外部委託顧問料のSSJ接続追加対応 START */
/*      CASE KEIYAKU.CONTRACT_FLAG                      */
/*               WHEN '1' THEN                                  */
/*                       CASE KEIYAKU.TAX_CALC_FLAG */
/*                               WHEN '1' THEN 'A8001'  */
/*                               ELSE              'A8002'      */
/*                               END                                    */
/*               WHEN '2' THEN                                  */
/*                       CASE KEIYAKU.TAX_CALC_FLAG */
/*                               WHEN '1' THEN 'A8003'  */
/*                               ELSE              'A8004 ' */
/*                               END                                    */
/*               WHEN '3' THEN                                  */
/*                       CASE KEIYAKU.TAX_CALC_FLAG */
/*                               WHEN '1' THEN 'A8005'  */
/*                               ELSE              'A8006'      */
/*                               END                                    */
/*               WHEN '4' THEN                                  */
/*                       CASE KEIYAKU.TAX_CALC_FLAG */
/*                               WHEN '1' THEN 'A8007'  */
/*                               ELSE              'A8008'      */
/*                               END                                    */
/*      END SWK_ID,                     */
/**      2010-07-20 SSJ接続勘定科目追加対応 START ***********************/
/**      ASSET_CODEとTAX_CALC_FLAGをCASE文で振り分けSWK_IDを取得している
/**      部分を、勘定科目変換テーブルを参照して取得するように変更
/**        CASE                                                              **/
/**                 WHEN AC_W.ASSET_CODE =   '7650'                 THEN     **/
/**             CASE KEIYAKU.TAX_CALC_FLAG                                   **/
/**                 WHEN '1' THEN 'A8001'                                    **/
/**                 ELSE              'A8002'                                **/
/**                 END                                                      **/
/*      200910-01 SSJ改善対応 START ***********************/
/*               WHEN AC_W.ASSET_CODE IN ('7870-99',              */
/*                                '7870-RA',              */
/*                                '7870-FTSE'  ) THEN */
/*                       CASE KEIYAKU.TAX_CALC_FLAG                               */
/*                               WHEN '1' THEN 'A8003'                            */
/*                               ELSE              'A8004'                                */
/*                               END                  */
/**                 WHEN AC_W.ASSET_CODE =   '7870-99'              THEN     **/
/**             CASE KEIYAKU.TAX_CALC_FLAG                                   **/
/**                 WHEN '1' THEN 'A8003'                                    **/
/**                 ELSE              'A8004'                                **/
/**                 END                                                      **/
/**                 WHEN AC_W.ASSET_CODE IN ('7870-RA',                      **/
/**                                  '7870-FQ'        ) THEN                 **/
/**             CASE KEIYAKU.TAX_CALC_FLAG                                   **/
/**                 WHEN '1' THEN 'A8021'                                    **/
/**                 ELSE              'A8022'                                **/
/**                 END                                                      **/
/*      200910-01 SSJ改善対応 STOP ************************/
/**                 WHEN AC_W.ASSET_CODE IN ('7870-01',                      **/
/**                                  '7870-ETF'   ) THEN                     **/
/**             CASE KEIYAKU.TAX_CALC_FLAG                                   **/
/**                 WHEN '1' THEN 'A8005'                                    **/
/**                 ELSE              'A8006'                                **/
/**                 END                                                      **/
/**                 WHEN AC_W.ASSET_CODE =   '7655'                 THEN     **/
/**             CASE KEIYAKU.TAX_CALC_FLAG                                   **/
/**                 WHEN '1' THEN 'A8009'                                    **/
/**                 ELSE              'A8010'                                **/
/**                 END                                                      **/
/**                 WHEN AC_W.ASSET_CODE IN ('7630-USA',                     **/
/**                                  '7630-UK' ,                             **/
/**                                  '7630-SIN',                             **/
/**                                  '7630-HK' ,                             **/
/**                                  '7630-NGA'   ) THEN                     **/
/**             CASE KEIYAKU.TAX_CALC_FLAG                                   **/
/**                 WHEN '1' THEN 'A8011'                                    **/
/**                 ELSE              'A8012'                                **/
/**                END                                                       **/
/**                 WHEN AC_W.ASSET_CODE IN ('7660-NFRT',                    **/
/**                                  '7660-NCRAM' ) THEN                     **/
/**             CASE KEIYAKU.TAX_CALC_FLAG                                   **/
/**                 WHEN '1' THEN 'A8015'                                    **/
/**                 ELSE              'A8016'                                **/
/**                 END                                                      **/
/**                 WHEN AC_W.ASSET_CODE =   '7665-NFRT'   THEN              **/
/**             CASE KEIYAKU.TAX_CALC_FLAG                                   **/
/**                 WHEN '1' THEN 'A8017'                                    **/
/**                 ELSE              'A8018'                                **/
/**                 END                                                      **/
/**                 WHEN AC_W.ASSET_CODE =   '7670'                 THEN     **/
/**             CASE KEIYAKU.TAX_CALC_FLAG                                   **/
/**                 WHEN '1' THEN 'A8019'                                    **/
/**                 ELSE              'A8020'                                **/
/**                 END                                                      **/
/**                 ELSE                                                     **/
/**             CASE KEIYAKU.TAX_CALC_FLAG                                   **/
/**                 WHEN '1' THEN 'A8001'                                    **/
/**                 ELSE              'A8002'                                **/
/**                 END                                                      **/
/**        END SWK_ID,                                                       **/
/*      200906-04.投信外部委託顧問料のSSJ接続追加対応 END */
/**      2010-07-20 SSJ接続勘定科目追加対応 ADDITION ***********************/
/*       2014-02-12 消費税対応 START */
/**        (                                                    **/
/**            SELECT SS_SWK_ID                                 **/
/**            FROM CFR_ASSET_REFARENCE_TBL                     **/
/**            WHERE TRIM(ASSET_CODE) = AC_W.ASSET_CODE         **/
/**            AND TRIM(TAX_CALC_FLAG) = KEIYAKU.TAX_CALC_FLAG  **/
/**        ) SWK_ID,                                            **/
        ' ' SWK_ID,
/*       2014-02-12 消費税対応 STOP */
/**      2010-07-20 SSJ接続勘定科目追加対応 ADDITION ***********************/
        '0' KESSAN_KBN,
        'A8' IN_USR_ID,
/*       2014-02-12 消費税対応 START */
/**        SUBSTR('&&WK_YOKUEI_YYYYMMDD',5,4) || TRIM(TO_CHAR(ROWNUM,'0009')) DEN_NO,  **/
        ' ' DEN_NO,
/*       2014-02-12 消費税対応 STOP */
        1 GYO_NO,
        NULL DR_KMK_CODE,
    NULL DR_HKM_CODE,
    'HQ0000' DR_BMN_CODE,
    NULL DR_CODE1,
    NULL DR_CODE2,
    NULL DR_CODE3,
/*      200906-04.投信外部委託顧問料のSSJ接続追加対応 START */
/*      CASE KEIYAKU.CONTRACT_FLAG       */
/*               WHEN '1' THEN 'ACMT021' */
/*               WHEN '2' THEN 'ACMT023' */
/*               WHEN '3' THEN 'ACMT025' */
/*               WHEN '4' THEN 'ACMT027' */
/*      END DR_CODE4,                            */
/**      2010-07-20 SSJ接続勘定科目追加対応 START ***********************/
/**      ASSET_CODEをCASE文で振り分けSS_R_CODE4を取得している部分を、
/**      勘定科目変換テーブルを参照して取得するように変更
/**        CASE                                                                              **/
/**                 WHEN AC_W.ASSET_CODE =   '7650'                 THEN 'ACMT021'           **/
/*      200910-01 SSJ改善対応 START *********************************/
/*               WHEN AC_W.ASSET_CODE IN ('7870-99',                                    */
/*                                '7870-RA',                                    */
/*                                '7870-FTSE'  ) THEN 'ACMT023' */
/**                 WHEN AC_W.ASSET_CODE =   '7870-99'              THEN 'ACMT023'           **/
/**                 WHEN AC_W.ASSET_CODE IN ('7870-RA',                                      **/
/**                                  '7870-FQ'        ) THEN 'ACMT040'                       **/
/*      200910-01 SSJ改善対応 STOP **********************************/
/**                 WHEN AC_W.ASSET_CODE IN ('7870-01',                                         **/
/**                                  '7870-ETF'   ) THEN 'ACMT025'                              **/
/**                 WHEN AC_W.ASSET_CODE =   '7655'                 THEN 'ACMT029'              **/
/**                 WHEN AC_W.ASSET_CODE IN ('7630-USA',                                        **/
/**                                  '7630-UK' ,                                                **/
/**                                  '7630-SIN',                                                **/
/**                                  '7630-HK' ,                                                **/
/**                                  '7630-NGA'   ) THEN 'ACMT031'                              **/
/**                 WHEN AC_W.ASSET_CODE IN ('7660-NFRT',                                       **/
/**                                  '7660-NCRAM' ) THEN 'ACMT035'                              **/
/**                 WHEN AC_W.ASSET_CODE =   '7665-NFRT'    THEN 'ACMT037'                      **/
/**                 WHEN AC_W.ASSET_CODE =   '7670'                 THEN 'ACMT039'              **/
/**                 ELSE                                 'ACMT021'                              **/
/**        END DR_CODE4,                                                                        **/
/*      200906-04.投信外部委託顧問料のSSJ接続追加対応 END */
/**      2010-07-20 SSJ接続勘定科目追加対応 ADDITION ***********************/
/*       2014-02-12 消費税対応 START */
/**        (                                             **/
/**            SELECT SS_R_CODE4                         **/
/**            FROM CFR_ASSET_REFARENCE_TBL              **/
/**            WHERE TRIM(ASSET_CODE) = AC_W.ASSET_CODE  **/
/**            AND TRIM(TAX_CALC_FLAG) = '0'             **/
/**        ) DR_CODE4,                                   **/
        NULL DR_CODE4,
/*       2014-02-12 消費税対応 STOP */
/**      2010-07-20 SSJ接続勘定科目追加対応 ADDITION ***********************/
        TRUNC(NVL(JITUBARAI.FIX_COM_J,0),0) DR_KIN,
    NULL DR_CUR_CODE,
    NULL DR_CRT_RATE_TYPE,
    NULL DR_CRT_RATE,
    NULL DR_CUR_KIN,
/*      200910-01 SSJ改善対応 START */
/*      '0' DR_ZEI_CODE,                        */
        NULL DR_ZEI_CODE,
/*      200910-01 SSJ改善対応 STOP      */
        NULL DR_ZEI_KBN,
/*       2014-02-12 消費税対応 START */
/**    CASE KEIYAKU.TAX_CALC_FLAG                                                                         **/
/**                WHEN '1' THEN TRUNC(TRUNC(NVL(JITUBARAI.FIX_COM_J,0),0) * SHOHIZEI.TAX_RATE / 100 , 0) **/
/**        END DR_ZEI_KIN,                                                                                **/
        NULL DR_ZEI_KIN,
/*       2014-02-12 消費税対応 STOP */
        SUBSTR(KEIYAKU.COM_CALC_START,1,4) || '/' || SUBSTR(KEIYAKU.COM_CALC_START,5,2) || ' - ' || SUBSTR(JITUBARAI.SETTLEMENT_DATE,1,4) || '/' || SUBSTR(JITUBARAI.SETTLEMENT_DATE,5,2) DR_TEKIYO1,
        NULL DR_TEKIYO2,
    '2' DR_TORI_KBN,
    KEIYAKU.COMPANY_CODE DR_TORI_CODE,
    NULL CR_KMK_CODE,
    NULL CR_HKM_CODE,
    'HQ0000' CR_BMN_CODE,
    NULL CR_CODE1,
    NULL CR_CODE2,
    NULL CR_CODE3,
/*      200906-04.投信外部委託顧問料のSSJ接続追加対応 START */
/*      CASE KEIYAKU.CONTRACT_FLAG       */
/*               WHEN '1' THEN 'ACMT021' */
/*               WHEN '2' THEN 'ACMT023' */
/*               WHEN '3' THEN 'ACMT025' */
/*               WHEN '4' THEN 'ACMT027' */
/*      END CR_CODE4,                            */
/**      2010-07-20 SSJ接続勘定科目追加対応 START ***********************/
/**      ASSET_CODEをCASE文で振り分けSS_R_CODE4を取得している部分を、
/**      勘定科目変換テーブルを参照して取得するように変更
/**        CASE                                                                                 **/
/**                 WHEN AC_W.ASSET_CODE =   '7650'                 THEN 'ACMT021'              **/
/*      200910-01 SSJ改善対応 START *********************************/
/*               WHEN AC_W.ASSET_CODE IN ('7870-99',                                    */
/*                                '7870-RA',                                    */
/*                                '7870-FTSE'  ) THEN 'ACMT023' */
/**                 WHEN AC_W.ASSET_CODE =   '7870-99'              THEN 'ACMT023'              **/
/**                 WHEN AC_W.ASSET_CODE IN ('7870-RA',                                         **/
/**                                  '7870-FQ'        ) THEN 'ACMT040'                          **/
/*      200910-01 SSJ改善対応 STOP **********************************/
/**                 WHEN AC_W.ASSET_CODE IN ('7870-01',                                         **/
/**                                  '7870-ETF'   ) THEN 'ACMT025'                              **/
/**                 WHEN AC_W.ASSET_CODE =   '7655'                 THEN 'ACMT029'              **/
/**                 WHEN AC_W.ASSET_CODE IN ('7630-USA',                                        **/
/**                                  '7630-UK' ,                                                **/
/**                                  '7630-SIN',                                                **/
/**                                  '7630-HK' ,                                                **/
/**                                  '7630-NGA'   ) THEN 'ACMT031'                              **/
/**                 WHEN AC_W.ASSET_CODE IN ('7660-NFRT',                                       **/
/**                                  '7660-NCRAM' ) THEN 'ACMT035'                              **/
/**                 WHEN AC_W.ASSET_CODE =   '7665-NFRT'    THEN 'ACMT037'                      **/
/**                 WHEN AC_W.ASSET_CODE =   '7670'                 THEN 'ACMT039'              **/
/**                 ELSE                                 'ACMT021'                              **/
/**        END CR_CODE4,                                                                        **/
/*      200906-04.投信外部委託顧問料のSSJ接続追加対応 END */
/**      2010-07-20 SSJ接続勘定科目追加対応 ADDITION ***********************/
/*       2014-02-12 消費税対応 START */
/**        (                                             **/
/**            SELECT SS_R_CODE4                         **/
/**            FROM CFR_ASSET_REFARENCE_TBL              **/
/**            WHERE TRIM(ASSET_CODE) = AC_W.ASSET_CODE  **/
/**            AND TRIM(TAX_CALC_FLAG) = '0'             **/
/**        ) CR_CODE4,                                   **/
        NULL CR_CODE4,
/*       2014-02-12 消費税対応 STOP */
/**      2010-07-20 SSJ接続勘定科目追加対応 ADDITION ***********************/
        TRUNC(NVL(JITUBARAI.FIX_COM_J,0),0) CR_KIN,
    NULL CR_CUR_CODE,
    NULL CR_CRT_RATE_TYPE,
    NULL CR_CRT_RATE,
    NULL CR_CUR_KIN,
/*      200910-01 SSJ改善対応 START */
/*      '0' CR_ZEI_CODE,                        */
        NULL CR_ZEI_CODE,
/*      200910-01 SSJ改善対応 STOP      */
        NULL CR_ZEI_KBN,
/*       2014-02-12 消費税対応 START */
/**    CASE KEIYAKU.TAX_CALC_FLAG                                                                          **/
/**                WHEN '1' THEN TRUNC(TRUNC(NVL(JITUBARAI.FIX_COM_J,0),0) * SHOHIZEI.TAX_RATE / 100 , 0)  **/
/**                ELSE NULL                                                                               **/
/**        END CR_ZEI_KIN,                                                                                 **/
        NULL CR_ZEI_KIN,
/*       2014-02-12 消費税対応 STOP */
        SUBSTR(KEIYAKU.COM_CALC_START,1,4) || '/' || SUBSTR(KEIYAKU.COM_CALC_START,5,2) || ' - ' || SUBSTR(JITUBARAI.SETTLEMENT_DATE,1,4) || '/' || SUBSTR(JITUBARAI.SETTLEMENT_DATE,5,2) CR_TEKIYO1,
        NULL CR_TEKIYO2,
    '2' CR_TORI_KBN,
    KEIYAKU.COMPANY_CODE CR_TORI_CODE,
        NULL SWK_JYO1,
    NULL SWK_JYO2,
    NULL SWK_JYO3,
    NULL SWK_JYO4,
    NULL SWK_JYO5,
    'RVN000' KAIKEI_KOUMOKU1,
    'RVNMF0' KAIKEI_KOUMOKU2,
    NULL KAIKEI_KOUMOKU3,
/*      200906-04.投信外部委託顧問料のSSJ接続追加対応 START */
/*      NULL KAIKEI_KOUMOKU4, */
        SUBSTR(KEIYAKU.COM_CALC_START,1,4) || '/' || SUBSTR(KEIYAKU.COM_CALC_START,5,2) || '/' || SUBSTR(KEIYAKU.COM_CALC_START,7,2) || '-' || SUBSTR(JITUBARAI.SETTLEMENT_DATE,1,4) || '/' || SUBSTR(JITUBARAI.SETTLEMENT_DATE,5,2) || '/' || SUBSTR(JITUBARAI.SETTLEMENT_DATE,7,2) KAIKEI_KOUMOKU4,
/*      200906-04.投信外部委託顧問料のSSJ接続追加対応 END */
        NULL KAIKEI_KOUMOKU5,
    NULL KANRI_COMMENT1,
    NULL KANRI_COMMENT2,
    NULL KANRI_COMMENT3,
/*      200906-04.投信外部委託顧問料のSSJ接続追加対応 START */
/*      KEIYAKU.COMPANY_CODE KANRI_COMMENT4, */
        NULL KANRI_COMMENT4,
/*      200906-04.投信外部委託顧問料のSSJ接続追加対応 END */
        NULL KANRI_COMMENT5,
    NULL KANRI_COMMENT6,
    NULL KANRI_COMMENT7,
    NULL KANRI_COMMENT8,
    NULL KANRI_COMMENT9,
/*      200906-04.投信外部委託顧問料のSSJ接続追加対応 START */
/*      NULL KANRI_COMMENT10, */
        SUBSTR(KEIYAKU.COM_CALC_START,3,6) || '-' || SUBSTR(JITUBARAI.SETTLEMENT_DATE,3,6) || ' ' || SUBSTR(KEIYAKU.CONTRACT_NO,8,8) || ' ' || SUBSTR(KEIYAKU.CONTRACT_NAME,1,8) KANRI_COMMENT10,
/*      200906-04.投信外部委託顧問料のSSJ接続追加対応 END */
        '0' AUS_FLG_01,
    NULL AU_USR_ID_01,
    NULL AUS_DATE_01,
    '0' AUS_FLG_02,
    NULL AU_USR_ID_02,
    NULL AUS_DATE_02,
    '0' SYO_FLG,
    '*** KUGIRI_START_ZENKAI ***' KUGIRI_2,
         NVL((SELECT MAX(JITU_W3.BASE_MONTH) FROM CFR_OTHER_REAL_COM_TBL JITU_W3
                 WHERE JITU_W3.CONTRACT_NO = JITUBARAI.CONTRACT_NO
                 AND JITU_W3.BASE_MONTH < JITUBARAI.BASE_MONTH
                 AND JITU_W3.CURRENCY_CODE = JITUBARAI.CURRENCY_CODE
                 AND JITU_W3.ASSET_TYPE_CODE = JITUBARAI.ASSET_TYPE_CODE),'0') ZEN_BASE_MONTH,
         NVL((SELECT JITU_W4.SETTLEMENT_DATE FROM CFR_OTHER_REAL_COM_TBL JITU_W4
                 WHERE JITU_W4.CONTRACT_NO = JITUBARAI.CONTRACT_NO
                 AND JITU_W4.BASE_MONTH =
                 (SELECT MAX(JITU_W5.BASE_MONTH) FROM CFR_OTHER_REAL_COM_TBL JITU_W5
                 WHERE JITU_W5.CONTRACT_NO = JITUBARAI.CONTRACT_NO
                 AND JITU_W5.BASE_MONTH < JITUBARAI.BASE_MONTH
                 AND JITU_W5.CURRENCY_CODE = JITUBARAI.CURRENCY_CODE
                 AND JITU_W5.ASSET_TYPE_CODE = JITUBARAI.ASSET_TYPE_CODE)
                 AND JITU_W4.CURRENCY_CODE = JITUBARAI.CURRENCY_CODE
                 AND JITU_W4.ASSET_TYPE_CODE = JITUBARAI.ASSET_TYPE_CODE),'0') ZEN_SETTLEMENT_DATE,
        '*** KUGIRI_START_JITUBARAI ***' KUGIRI_3,
        JITUBARAI.CONTRACT_NO J_CONTRACT_NO,
        JITUBARAI.BASE_MONTH J_BASE_MONTH,
        JITUBARAI.CURRENCY_CODE J_CURRENCY_CODE,
        JITUBARAI.ASSET_TYPE_CODE J_ASSET_TYPE_CODE,
        JITUBARAI.SETTLEMENT_DATE J_SETTLEMENT_DATE,
        JITUBARAI.FIX_COM_FLAG J_FIX_COM_FLAG,
        JITUBARAI.FIX_COM_J J_FIX_COM_J,
        '*** KUGIRI_START_KEIYAKU ***' KUGIRI_4,
        KEIYAKU.CONTRACT_NO K_CONTRACT_NO,
        KEIYAKU.INSERT_DATE K_INSERT_DATE,
        KEIYAKU.CONTRACT_FLAG K_CONTRACT_FLAG,
        KEIYAKU.COMPANY_CODE K_COMPANY_CODE,
        KEIYAKU.COM_CALC_START K_COM_CALC_START,
        KEIYAKU.TAX_CALC_FLAG K_TAX_CALC_FLAG,
/*       2014-02-12 消費税対応 START */
        KEIYAKU.ADV_LEAVE_FLAG K_ADV_LEAVE_FLAG,
/*       2014-02-12 消費税対応 STOP */
        KEIYAKU.INVALID_FLAG K_INVALID_FLAG,
/*       2014-02-12 消費税対応 START */
        AC_W.ASSET_CODE K_ASSET_CODE,
/*       2014-02-12 消費税対応 STOP */
        '*** KUGIRI_START_SHOHIZEI ***' KUGIRI_5,
/*       2014-02-12 消費税対応 START */
/**        SHOHIZEI.ITEM_FLAG S_ITEM_FLAG,  **/
/**        SHOHIZEI.USE_DATE S_USE_DATE,    **/
/**        SHOHIZEI.TAX_RATE S_TAX_RATE,    **/
        SHOHIZEI1.ITEM_FLAG S_ITEM_FLAG,
        SHOHIZEI1.USE_DATE S_USE_DATE,
        SHOHIZEI1.TAX_RATE S_TAX_RATE,
        NVL(SHOHIZEI2.ITEM_FLAG,' ') S_ITEM_FLAG_P,
        NVL(SHOHIZEI2.USE_DATE,'        ') S_USE_DATE_P,
        NVL(SHOHIZEI2.TAX_RATE,0) S_TAX_RATE_P,
/*       2014-02-12 消費税対応 STOP */
        '*** KUGIRI_START_ME ***' KUGIRI_6,
        SYSDATE LAST_UPDATETIME,
        '&&JOBID'       LAST_UPDATE_ID
FROM
CFR_OTHER_REAL_COM_TBL JITUBARAI,
(       SELECT
                KEIYAKU_W3.CONTRACT_NO CONTRACT_NO,
                KEIYAKU_W3.INSERT_DATE INSERT_DATE,
                KEIYAKU_W3.CONTRACT_NAME CONTRACT_NAME,
                KEIYAKU_W3.CONTRACT_NAME_E CONTRACT_NAME_E,
                KEIYAKU_W3.CONTRACT_FLAG CONTRACT_FLAG,
                KEIYAKU_W3.COMPANY_CODE COMPANY_CODE,
                KEIYAKU_W3.FOREIGN_ACCOUNT_CODE FOREIGN_ACCOUNT_CODE,
                KEIYAKU_W3.OFFICE_CODE OFFICE_CODE,
                KEIYAKU_W3.COM_CALC_START COM_CALC_START,
                KEIYAKU_W3.COM_CALC_END COM_CALC_END,
                KEIYAKU_W3.TAX_CALC_FLAG TAX_CALC_FLAG,
                KEIYAKU_W3.ADV_LEAVE_FLAG ADV_LEAVE_FLAG,
                KEIYAKU_W3.INVALID_FLAG INVALID_FLAG,
                KEIYAKU_W3.LAST_UPDATETIME LAST_UPDATETIME,
                KEIYAKU_W3.LAST_UPDATE_ID LAST_UPDATE_ID
        FROM CFR_CONTRACT_TBL KEIYAKU_W3,
        (       SELECT
                        KEIYAKU_W1.CONTRACT_NO CONTRACT_NO,
                        MAX(KEIYAKU_W1.INSERT_DATE) INSERT_DATE
                FROM CFR_CONTRACT_TBL KEIYAKU_W1
                WHERE
                        KEIYAKU_W1.INVALID_FLAG = '0'
                GROUP BY KEIYAKU_W1.CONTRACT_NO)  KEIYAKU_W2
                WHERE
                        KEIYAKU_W3.CONTRACT_NO = KEIYAKU_W2.CONTRACT_NO
                AND KEIYAKU_W3.INSERT_DATE = KEIYAKU_W2.INSERT_DATE ) KEIYAKU,
/*       2014-02-12 消費税対応 START */
(       SELECT
                TAX_WK1.ITEM_FLAG ITEM_FLAG,
                TAX_WK1.USE_DATE USE_DATE,
                TAX_WK1.TAX_RATE TAX_RATE,
                SHOHIZEI_T1.CONTRACT_NO CONTRACT_NO,
                SHOHIZEI_T1.BASE_MONTH BASE_MONTH,
                SHOHIZEI_T1.CURRENCY_CODE CURRENCY_CODE,
                SHOHIZEI_T1.ASSET_TYPE_CODE ASSET_TYPE_CODE
        FROM CFR_TAX_TBL TAX_WK1,
             (SELECT
                      REAL_T1.CONTRACT_NO,
                      REAL_T1.BASE_MONTH,
                      REAL_T1.CURRENCY_CODE,
                      REAL_T1.ASSET_TYPE_CODE,
                      MAX(TAX1.USE_DATE) USE_DATE
              FROM CFR_OTHER_REAL_COM_TBL REAL_T1, CFR_TAX_TBL TAX1
              WHERE TAX1.ITEM_FLAG='1' AND REAL_T1.SETTLEMENT_DATE >= TAX1.USE_DATE
              GROUP BY REAL_T1.CONTRACT_NO,
                       REAL_T1.BASE_MONTH,
                       REAL_T1.CURRENCY_CODE,
                       REAL_T1.ASSET_TYPE_CODE) SHOHIZEI_T1
        WHERE
                TAX_WK1.ITEM_FLAG='1'
                AND TAX_WK1.USE_DATE = SHOHIZEI_T1.USE_DATE ) SHOHIZEI1,
(       SELECT
                TAX_WK2.ITEM_FLAG ITEM_FLAG,
                TAX_WK2.USE_DATE USE_DATE,
                TAX_WK2.TAX_RATE TAX_RATE,
                SHOHIZEI_T2.CONTRACT_NO CONTRACT_NO,
                SHOHIZEI_T2.BASE_MONTH BASE_MONTH,
                SHOHIZEI_T2.CURRENCY_CODE CURRENCY_CODE,
                SHOHIZEI_T2.ASSET_TYPE_CODE ASSET_TYPE_CODE
        FROM CFR_TAX_TBL TAX_WK2
             RIGHT JOIN
             (SELECT
                     TAX_TMP.CONTRACT_NO,
                     TAX_TMP.BASE_MONTH,
                     TAX_TMP.CURRENCY_CODE,
                     TAX_TMP.ASSET_TYPE_CODE,
                     MAX(TAX3.USE_DATE) USE_DATE
              FROM CFR_TAX_TBL TAX3
                   RIGHT JOIN
                   (SELECT
                           JITU2.CONTRACT_NO,
                           JITU2.BASE_MONTH,
                           JITU2.CURRENCY_CODE,
                           JITU2.ASSET_TYPE_CODE,
                           MAX(TAX2.USE_DATE) USE_DATE
                    FROM CFR_TAX_TBL TAX2, CFR_OTHER_REAL_COM_TBL JITU2
                    WHERE TAX2.ITEM_FLAG='1' AND TAX2.USE_DATE <= JITU2.SETTLEMENT_DATE
                    GROUP BY JITU2.CONTRACT_NO,
                             JITU2.BASE_MONTH,
                             JITU2.CURRENCY_CODE,
                             JITU2.ASSET_TYPE_CODE ) TAX_TMP
              ON TAX3.ITEM_FLAG='1' AND TAX3.USE_DATE < TAX_TMP.USE_DATE
              GROUP BY TAX_TMP.CONTRACT_NO,
                       TAX_TMP.BASE_MONTH,
                       TAX_TMP.CURRENCY_CODE,
                       TAX_TMP.ASSET_TYPE_CODE ) SHOHIZEI_T2
        ON
              TAX_WK2.ITEM_FLAG='1'
              AND TAX_WK2.USE_DATE = SHOHIZEI_T2.USE_DATE ) SHOHIZEI2,
/**(       SELECT                                                        **/
/**                SHOHIZEI_W1.ITEM_FLAG ITEM_FLAG,                      **/
/**                SHOHIZEI_W1.USE_DATE USE_DATE,                        **/
/**                SHOHIZEI_W1.TAX_RATE TAX_RATE                         **/
/**        FROM CFR_TAX_TBL SHOHIZEI_W1,                                 **/
/**        (       SELECT                                                **/
/**                        SHOHIZEI_W2.ITEM_FLAG ITEM_FLAG,              **/
/**                        MAX(SHOHIZEI_W2.USE_DATE) USE_DATE            **/
/**                FROM CFR_TAX_TBL SHOHIZEI_W2                          **/
/**                WHERE                                                 **/
/**                        SHOHIZEI_W2.ITEM_FLAG = '1'                   **/
/**                GROUP BY SHOHIZEI_W2.ITEM_FLAG ) SHOHIZEI_W3          **/
/**         WHERE                                                        **/
/**                SHOHIZEI_W1.ITEM_FLAG = SHOHIZEI_W3.ITEM_FLAG         **/
/**         AND SHOHIZEI_W1.USE_DATE = SHOHIZEI_W3.USE_DATE ) SHOHIZEI,  **/
/*       2014-02-12 消費税対応 STOP */
(        SELECT
                 JITU_W1.CONTRACT_NO CONTRACT_NO,
                 JITU_W1.BASE_MONTH BASE_MONTH,
                 JITU_W1.CURRENCY_CODE CURRENCY_CODE,
                 JITU_W1.ASSET_TYPE_CODE ASSET_TYPE_CODE
         FROM CFR_OTHER_REAL_COM_TBL JITU_W1
         WHERE NOT EXISTS
         (SELECT 'X' FROM CFR_SS_STATUS_TBL STATUS_W1
          WHERE JITU_W1.CONTRACT_NO = STATUS_W1.CONTRACT_NO AND
                        JITU_W1.BASE_MONTH = STATUS_W1.BASE_MONTH AND
                        JITU_W1.CURRENCY_CODE = STATUS_W1.CURRENCY_CODE AND
/*      200906-04.投信外部委託顧問料のSSJ接続追加対応 START */
/*                      JITU_W1.ASSET_TYPE_CODE = STATUS_W1.ASSET_TYPE_CODE)) JITU_W2 */
                        JITU_W1.ASSET_TYPE_CODE = STATUS_W1.ASSET_TYPE_CODE)) JITU_W2,
(        SELECT
                 KEIYAKU_W7.CONTRACT_NO CONTRACT_NO,
                 NVL(TRIM(MAX(AC.ASSET_CODE)),'7650') ASSET_CODE
         FROM
         (       SELECT
                        KEIYAKU_W6.CONTRACT_NO CONTRACT_NO,
                        KEIYAKU_W6.INSERT_DATE INSERT_DATE,
                        KEIYAKU_W6.CONTRACT_NAME CONTRACT_NAME,
                        KEIYAKU_W6.CONTRACT_NAME_E CONTRACT_NAME_E,
                        KEIYAKU_W6.CONTRACT_FLAG CONTRACT_FLAG,
                        KEIYAKU_W6.COMPANY_CODE COMPANY_CODE,
                        KEIYAKU_W6.FOREIGN_ACCOUNT_CODE FOREIGN_ACCOUNT_CODE,
                        KEIYAKU_W6.OFFICE_CODE OFFICE_CODE,
                        KEIYAKU_W6.COM_CALC_START COM_CALC_START,
                        KEIYAKU_W6.COM_CALC_END COM_CALC_END,
                        KEIYAKU_W6.TAX_CALC_FLAG TAX_CALC_FLAG,
                        KEIYAKU_W6.ADV_LEAVE_FLAG ADV_LEAVE_FLAG,
                        KEIYAKU_W6.INVALID_FLAG INVALID_FLAG,
                        KEIYAKU_W6.LAST_UPDATETIME LAST_UPDATETIME,
                        KEIYAKU_W6.LAST_UPDATE_ID LAST_UPDATE_ID
                FROM CFR_CONTRACT_TBL KEIYAKU_W6,
                (       SELECT
                KEIYAKU_W4.CONTRACT_NO CONTRACT_NO,
                MAX(KEIYAKU_W4.INSERT_DATE) INSERT_DATE
                        FROM CFR_CONTRACT_TBL KEIYAKU_W4
                        WHERE
                KEIYAKU_W4.INVALID_FLAG = '0'
                        GROUP BY KEIYAKU_W4.CONTRACT_NO)  KEIYAKU_W5
                        WHERE
                KEIYAKU_W6.CONTRACT_NO = KEIYAKU_W5.CONTRACT_NO
                        AND KEIYAKU_W6.INSERT_DATE = KEIYAKU_W5.INSERT_DATE ) KEIYAKU_W7,
        CFR_ASSET_COMPANY_TBL AC
        WHERE
                KEIYAKU_W7.CONTRACT_FLAG IN ('1', '2', '3', '4') AND
                KEIYAKU_W7.COMPANY_CODE = AC.COMPANY_CODE(+) AND
                KEIYAKU_W7.ADV_LEAVE_FLAG = AC.ADV_LEAVE_FLAG(+)
        GROUP BY KEIYAKU_W7.CONTRACT_NO ) AC_W
/*      200906-04.投信外部委託顧問料のSSJ接続追加対応 END */
WHERE
        JITUBARAI.CONTRACT_NO = JITU_W2.CONTRACT_NO
AND JITUBARAI.BASE_MONTH = JITU_W2.BASE_MONTH
AND JITUBARAI.CURRENCY_CODE = JITU_W2.CURRENCY_CODE
AND JITUBARAI.ASSET_TYPE_CODE = JITU_W2.ASSET_TYPE_CODE
AND KEIYAKU.CONTRACT_FLAG IN ('1', '2', '3', '4')
AND JITUBARAI.FIX_COM_FLAG <> '0'
AND JITUBARAI.SETTLEMENT_DATE >= TO_CHAR(ADD_MONTHS(TO_DATE('&&WK_YOKUEI_YYYYMMDD'),-12*(&&CFR_SS_SAVE_YEAR)),'YYYYMMDD')
AND JITUBARAI.CONTRACT_NO = KEIYAKU.CONTRACT_NO
/*      200906-04.投信外部委託顧問料のSSJ接続追加対応 START */
AND JITUBARAI.CONTRACT_NO = AC_W.CONTRACT_NO
/*      200906-04.投信外部委託顧問料のSSJ接続追加対応 END */
/*       2014-02-12 消費税対応 START */
AND JITUBARAI.CONTRACT_NO = SHOHIZEI1.CONTRACT_NO
AND JITUBARAI.BASE_MONTH = SHOHIZEI1.BASE_MONTH
AND JITUBARAI.CURRENCY_CODE = SHOHIZEI1.CURRENCY_CODE
AND JITUBARAI.ASSET_TYPE_CODE = SHOHIZEI1.ASSET_TYPE_CODE
AND JITUBARAI.CONTRACT_NO = SHOHIZEI2.CONTRACT_NO
AND JITUBARAI.BASE_MONTH = SHOHIZEI2.BASE_MONTH
AND JITUBARAI.CURRENCY_CODE = SHOHIZEI2.CURRENCY_CODE
AND JITUBARAI.ASSET_TYPE_CODE = SHOHIZEI2.ASSET_TYPE_CODE
/*       2014-02-12 消費税対応 END */
ORDER BY
JITUBARAI.CONTRACT_NO,
JITUBARAI.CURRENCY_CODE,
JITUBARAI.ASSET_TYPE_CODE,
JITUBARAI.BASE_MONTH
;
