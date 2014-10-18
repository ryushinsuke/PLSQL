#!/usr/bin/csh
#
# プロジェクト : NAM顧問料デイリー算出システム
# 機能名       : 日次SS用外部委託未払計上額接続ファイル作成
# ファイル名   : CFRD1510.csh
#
# 使用方法     : % CFRD1510.csh [千手日付]
# 使用例       : % CFRD1510.csh または     ※通常運用
#                  CFRD1510.csh YYYYMMDD
# 引数       1 : WK_SJ_PEX_DATE : 任意入力引数 : 当csh用千手日付
#                  本番運用では設定しない。
#                  ・優先順位
#                  1.当引数が設定されていた場合
#                    当引数を千手日付として使用する(当csh内のみ）
#                    引数値の妥当性チェック
#                    (NUMERIC－CHECK、暦日チェック、営業日チェック)は行わない。
#                  2.当引数が設定されていない場合
#                    2.1　環境変数  SJ_PEX_DATEが設定されていた場合
#                         SJ_PEX_DATEを千手日付として使用する。※通常運用
#                    2.2　環境変数  SJ_PEX_DATEが設定されていない場合
#                         UNIXのマシン日付を千手日付として使用する(当csh内のみ)
#
# EXIT STATUS  : 0   :正常
#              : 255 :異常
# 作成日       : 2009/02/28
# 作成者       : SRA米原
#
# 更新日       : 2009/07/21
# 更新者       : SRA米原
# 更新概要     : 200906-04.投信外部委託顧問料のSSJ接続追加対応
#                SJISの契約名称をSSJファイルに持たせることになったため、
#                SSJファイルを SJIS→UTF-8に変換する処理を追加
#
# 更新日       : 2014/02/18
# 更新者       : GUT高楽
# 更新概要     : 2014-02-18.消費税対応
#                CFRD1510_SQL5INSTMP3を追加
#
################################################################################

#################
#  初期処理     #
#################
##  終了ステータスのセット ##
set CFR_OK     = 0
set CFR_NG     = 255
set CFR_WAIT   = 1
set sts        = ${CFR_OK}
set exitsts    = ${CFR_WAIT}

##  共通環境変数設定  ##
set MYHOSTNAME = `hostname`
switch ($MYHOSTNAME)
    case "ODWNRI"
        set MY_SETENV_DIR = /export/home/cfrbt1/work/test/lib
        set MY_SETENV_FILE = cfr_setenv
        breaksw
    default
        set MY_SETENV_DIR = /gen00/cfr/lib
        set MY_SETENV_FILE = cfr_setenv
        breaksw
endsw

if ( ! -f $MY_SETENV_DIR/$MY_SETENV_FILE ) then
    set exitsts = ${CFR_NG}
    echo "[$0 $*] [abnomal-end]=[$exitsts][cannot find setenv-file=[$MY_SETENV_DIR/$MY_SETENV_FILE]] `date '+%Y/%m/%d-%H:%M:%S'`"
    exit $exitsts
endif

if ( ! -r $MY_SETENV_DIR/$MY_SETENV_FILE ) then
    set exitsts = ${CFR_NG}
    echo "[$0 $*] [abnomal-end]=[$exitsts][cannot read setenv-file=[$MY_SETENV_DIR/$MY_SETENV_FILE]] `date '+%Y/%m/%d-%H:%M:%S'`"
    exit $exitsts
endif

source $MY_SETENV_DIR/$MY_SETENV_FILE
set sts = $status
if ( $sts != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "[$0 $*] [abnomal-end]=[$exitsts][error source setenv-file=[$MY_SETENV_DIR/$MY_SETENV_FILE]] `date '+%Y/%m/%d-%H:%M:%S'`"
    exit $exitsts
endif

##  logfile設定 ##
set thisdate    = "date '+%Y%m%d'"              # 現在日付
set thispgmpath = $0                            # foo/var.hoge
set thispgmhead = $thispgmpath:r                # foo/var
set thisname    = $thispgmhead:t                # var

printenv CFR_LOGDIR >& /dev/null
if ( $status != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "[$0 $*] [abnormal-end]=[cannot getenv CFR_LOGDIR] `date '+%Y/%m/%d-%H:%M:%S'`"
    exit $exitsts
endif

if ( ! -d $CFR_LOGDIR ) then
    set exitsts = ${CFR_NG}
    echo "[$0 $*] [abnormal-end]=[cannot find CFR_LOGDIR=[$CFR_LOGDIR]] `date '+%Y/%m/%d-%H:%M:%S'`"
    exit $exitsts
endif

if ( ! -r $CFR_LOGDIR ) then
    set exitsts = ${CFR_NG}
    echo "[$0 $*] [abnormal-end]=[cannot read CFR_LOGDIR=[$CFR_LOGDIR]] `date '+%Y/%m/%d-%H:%M:%S'`"
    exit $exitsts
endif

if ( ! -w $CFR_LOGDIR ) then
    set exitsts = ${CFR_NG}
    echo "[$0 $*] [abnormal-end]=[cannot write CFR_LOGDIR=[$CFR_LOGDIR]] `date '+%Y/%m/%d-%H:%M:%S'`"
    exit $exitsts
endif

setenv CFR_LOGFILENAME    ${thisname}_`eval ${thisdate}`.log
set logfile  = ${CFR_LOGDIR}/${CFR_LOGFILENAME} # ログファイル名

##  開始メッセージ出力  ##
echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] SS用XMLファイル作成開始 ###" >>&! ${logfile}

##  環境変数チェック  ##
####  環境変数:ORACLEユーザID チェック  ####
printenv CFR_ORAUID >& /dev/null
if ( $status != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] ORACLEのユーザID が設定されていません [CFR_ORAUID] ###" >>&! ${logfile}
    goto EndProc
endif

####  環境変数:ORACLEパスワード チェック  ####
printenv CFR_ORAPWD >& /dev/null
if ( $status != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] ORACLEのパスワード が設定されていません [CFR_ORAPWD] ###" >>&! ${logfile}
    goto EndProc
endif

####  環境変数:ORACLESID チェック  ####
printenv CFR_ORASID >& /dev/null
if ( $status != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] ORACLEのSID が設定されていません [CFR_ORASID] ###" >>&! ${logfile}
    goto EndProc
endif

####  環境変数:SS転送ファイル(XML)作成ディレクトリ チェック  ####
printenv CFR_SS_MAKEFILEDIR >& /dev/null
if ( $status != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 転送元ディレクトリ(XML作成ディレクトリ)が設定されていません [CFR_SS_MAKEFILEDIR] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -d $CFR_SS_MAKEFILEDIR ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定された転送元ディレクトリ(XML作成ディレクトリ)がありません [CFR_SS_MAKEFILEDIR]=[$CFR_SS_MAKEFILEDIR] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -r $CFR_SS_MAKEFILEDIR ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定された転送元ディレクトリ(XML作成ディレクトリ)に読込権限がありません [CFR_SS_MAKEFILEDIR]=[$CFR_SS_MAKEFILEDIR] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -w $CFR_SS_MAKEFILEDIR ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定された転送元ディレクトリ(XML作成ディレクトリ)に書込権限がありません [CFR_SS_MAKEFILEDIR]=[$CFR_SS_MAKEFILEDIR] ###" >>&! ${logfile}
    goto EndProc
endif

####  環境変数:SQL格納ディレクトリ チェック  ####
printenv CFR_SQL_DIR >& /dev/null
if ( $status != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] SQL格納ディレクトリが設定されていません [CFR_SQL_DIR] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -d $CFR_SQL_DIR ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定されたSQL格納ディレクトリがありません [CFR_SQL_DIR]=[$CFR_SQL_DIR] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -r $CFR_SQL_DIR ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定されたSQL格納ディレクトリに読込権限がありません [CFR_SQL_DIR]=[$CFR_SQL_DIR] ###" >>&! ${logfile}
    goto EndProc
endif

####  環境変数:AWK格納ディレクトリ チェック  ####
printenv CFR_AWK_DIR >& /dev/null
if ( $status != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] AWK格納ディレクトリが設定されていません [CFR_AWK_DIR] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -d $CFR_AWK_DIR ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定されたAWK格納ディレクトリがありません [CFR_AWK_DIR]=[$CFR_AWK_DIR] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -r $CFR_AWK_DIR ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定されたAWK格納ディレクトリに読込権限がありません [CFR_AWK_DIR]=[$CFR_AWK_DIR] ###" >>&! ${logfile}
    goto EndProc
endif

####  環境変数:XmlFormat格納ディレクトリ チェック  ####
printenv CFR_XMLFORMAT_DIR >& /dev/null
if ( $status != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] XMLFORMAT格納ディレクトリが設定されていません [CFR_XMLFORMAT_DIR] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -d $CFR_XMLFORMAT_DIR ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定されたXMLFORMAT格納ディレクトリがありません [CFR_XMLFORMAT_DIR]=[$CFR_XMLFORMAT_DIR] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -r $CFR_XMLFORMAT_DIR ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定されたXMLFORMAT格納ディレクトリに読込権限がありません [CFR_XMLFORMAT_DIR]=[$CFR_XMLFORMAT_DIR] ###" >>&! ${logfile}
    goto EndProc
endif

####  環境変数:TMPFILE格納ディレクトリ チェック  ####
printenv CFR_TMPDIR >& /dev/null
if ( $status != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] TMPFILE格納ディレクトリが設定されていません [CFR_TMPDIR] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -d $CFR_TMPDIR ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定されたTMPFILE格納ディレクトリがありません [CFR_TMPDIR]=[$CFR_TMPDIR] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -r $CFR_TMPDIR ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定されたTMPFILE格納ディレクトリに読込権限がありません [CFR_TMPDIR]=[$CFR_TMPDIR] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -w $CFR_TMPDIR ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定されたTMPFILE格納ディレクトリに書込権限がありません [CFR_TMPDIR]=[$CFR_TMPDIR] ###" >>&! ${logfile}
    goto EndProc
endif

####  環境変数:XMLタグIN_SYS_CODE設定値 チェック  ####
printenv CFRD1510_IN_SYS_CODE >& /dev/null
if ( $status != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] XMLタグIN_SYS_CODE設定値が設定されていません [CFRD1510_IN_SYS_CODE] ###" >>&! ${logfile}
    goto EndProc
endif

####  環境変数:当処理用TMPファイル チェック  ####
printenv CFRD1510_TMPFILE >& /dev/null
if ( $status != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 当処理用TMPファイルが設定されていません [CFRD1510_TMPFILE] ###" >>&! ${logfile}
    goto EndProc
endif

####  環境変数:当処理用CSVファイル チェック  ####
printenv CFRD1510_CSVFILE >& /dev/null
if ( $status != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 当処理用CSVファイルが設定されていません [CFRD1510_CSVFILE] ###" >>&! ${logfile}
    goto EndProc
endif

####  環境変数:当処理用SQLファイル チェック  ####
######  SQL0
printenv CFRD1510_SQL0GETYOKU >& /dev/null
if ( $status != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 当処理用SQLファイルが設定されていません [CFRD1510_SQL0GETYOKU] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -f $CFR_SQL_DIR/$CFRD1510_SQL0GETYOKU ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定された当処理用SQLファイルがありません [CFRD1510_SQL0GETYOKU]=[$CFR_SQL_DIR/$CFRD1510_SQL0GETYOKU] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -r $CFR_SQL_DIR/$CFRD1510_SQL0GETYOKU ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定された当処理用SQLファイルに読込権限がありません [CFRD1510_SQL0GETYOKU]=[$CFR_SQL_DIR/$CFRD1510_SQL0GETYOKU] ###" >>&! ${logfile}
    goto EndProc
endif

######  SQL1
printenv CFRD1510_SQL1TRUNTMP >& /dev/null
if ( $status != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 当処理用SQLファイルが設定されていません [CFRD1510_SQL1TRUNTMP] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -f $CFR_SQL_DIR/$CFRD1510_SQL1TRUNTMP ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定された当処理用SQLファイルがありません [CFRD1510_SQL1TRUNTMP]=[$CFR_SQL_DIR/$CFRD1510_SQL1TRUNTMP] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -r $CFR_SQL_DIR/$CFRD1510_SQL1TRUNTMP ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定された当処理用SQLファイルに読込権限がありません [CFRD1510_SQL1TRUNTMP]=[$CFR_SQL_DIR/$CFRD1510_SQL1TRUNTMP] ###" >>&! ${logfile}
    goto EndProc
endif

######  SQL2
printenv CFRD1510_SQL2INSTMP1 >& /dev/null
if ( $status != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 当処理用SQLファイルが設定されていません [CFRD1510_SQL2INSTMP1] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -f $CFR_SQL_DIR/$CFRD1510_SQL2INSTMP1 ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定された当処理用SQLファイルがありません [CFRD1510_SQL2INSTMP1]=[$CFR_SQL_DIR/$CFRD1510_SQL2INSTMP1] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -r $CFR_SQL_DIR/$CFRD1510_SQL2INSTMP1 ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定された当処理用SQLファイルに読込権限がありません [CFRD1510_SQL2INSTMP1]=[$CFR_SQL_DIR/$CFRD1510_SQL2INSTMP1] ###" >>&! ${logfile}
    goto EndProc
endif

######  SQL3
printenv CFRD1510_SQL3UPDTMP1 >& /dev/null
if ( $status != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 当処理用SQLファイルが設定されていません [CFRD1510_SQL3UPDTMP1] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -f $CFR_SQL_DIR/$CFRD1510_SQL3UPDTMP1 ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定された当処理用SQLファイルがありません [CFRD1510_SQL3UPDTMP1]=[$CFR_SQL_DIR/$CFRD1510_SQL3UPDTMP1] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -r $CFR_SQL_DIR/$CFRD1510_SQL3UPDTMP1 ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定された当処理用SQLファイルに読込権限がありません [CFRD1510_SQL3UPDTMP1]=[$CFR_SQL_DIR/$CFRD1510_SQL3UPDTMP1] ###" >>&! ${logfile}
    goto EndProc
endif

######  SQL4
printenv CFRD1510_SQL4UPDTMP1 >& /dev/null
if ( $status != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 当処理用SQLファイルが設定されていません [CFRD1510_SQL4UPDTMP1] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -f $CFR_SQL_DIR/$CFRD1510_SQL4UPDTMP1 ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定された当処理用SQLファイルがありません [CFRD1510_SQL4UPDTMP1]=[$CFR_SQL_DIR/$CFRD1510_SQL4UPDTMP1] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -r $CFR_SQL_DIR/$CFRD1510_SQL4UPDTMP1 ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定された当処理用SQLファイルに読込権限がありません [CFRD1510_SQL4UPDTMP1]=[$CFR_SQL_DIR/$CFRD1510_SQL4UPDTMP1] ###" >>&! ${logfile}
    goto EndProc
endif

######  SQL5
printenv CFRD1510_SQL5INSTMP2 >& /dev/null
if ( $status != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 当処理用SQLファイルが設定されていません [CFRD1510_SQL5INSTMP2] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -f $CFR_SQL_DIR/$CFRD1510_SQL5INSTMP2 ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定された当処理用SQLファイルがありません [CFRD1510_SQL5INSTMP2]=[$CFR_SQL_DIR/$CFRD1510_SQL5INSTMP2] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -r $CFR_SQL_DIR/$CFRD1510_SQL5INSTMP2 ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定された当処理用SQLファイルに読込権限がありません [CFRD1510_SQL5INSTMP2]=[$CFR_SQL_DIR/$CFRD1510_SQL5INSTMP2] ###" >>&! ${logfile}
    goto EndProc
endif

#    2014-02-18.消費税対応 START
printenv CFRD1510_SQL5INSTMP3 >& /dev/null
if ( $status != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 当処理用SQLファイルが設定されていません [CFRD1510_SQL5INSTMP3] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -f $CFR_SQL_DIR/$CFRD1510_SQL5INSTMP3 ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定された当処理用SQLファイルがありません [CFRD1510_SQL5INSTMP3]=[$CFR_SQL_DIR/$CFRD1510_SQL5INSTMP3] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -r $CFR_SQL_DIR/$CFRD1510_SQL5INSTMP3 ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定された当処理用SQLファイルに読込権限がありません [CFRD1510_SQL5INSTMP3]=[$CFR_SQL_DIR/$CFRD1510_SQL5INSTMP3] ###" >>&! ${logfile}
    goto EndProc
endif
#    2014-02-18.消費税対応 END

######  SQL6
printenv CFRD1510_SQL6SELTMP2 >& /dev/null
if ( $status != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 当処理用SQLファイルが設定されていません [CFRD1510_SQL6SELTMP2] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -f $CFR_SQL_DIR/$CFRD1510_SQL6SELTMP2 ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定された当処理用SQLファイルがありません [CFRD1510_SQL6SELTMP2]=[$CFR_SQL_DIR/$CFRD1510_SQL6SELTMP2] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -r $CFR_SQL_DIR/$CFRD1510_SQL6SELTMP2 ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定された当処理用SQLファイルに読込権限がありません [CFRD1510_SQL6SELTMP2]=[$CFR_SQL_DIR/$CFRD1510_SQL6SELTMP2] ###" >>&! ${logfile}
    goto EndProc
endif

######  SQL7
printenv CFRD1510_SQL7INS_STS >& /dev/null
if ( $status != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 当処理用SQLファイルが設定されていません [CFRD1510_SQL7INS_STS] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -f $CFR_SQL_DIR/$CFRD1510_SQL7INS_STS ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定された当処理用SQLファイルがありません [CFRD1510_SQL7INS_STS]=[$CFR_SQL_DIR/$CFRD1510_SQL7INS_STS] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -r $CFR_SQL_DIR/$CFRD1510_SQL7INS_STS ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定された当処理用SQLファイルに読込権限がありません [CFRD1510_SQL7INS_STS]=[$CFR_SQL_DIR/$CFRD1510_SQL7INS_STS] ###" >>&! ${logfile}
    goto EndProc
endif

####  環境変数:XMLFORMATファイル チェック  ####
######  XMLFORMAT_ZERO
printenv CFRD1510_XMLFORMAT0 >& /dev/null
if ( $status != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 当処理用XML雛形ファイルが設定されていません [CFRD1510_XMLFORMAT0] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -f $CFR_XMLFORMAT_DIR/$CFRD1510_XMLFORMAT0 ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定された当処理用XML雛形ファイルがありません [CFRD1510_XMLFORMAT0]=[$CFR_XMLFORMAT_DIR/$CFRD1510_XMLFORMAT0] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -r $CFR_XMLFORMAT_DIR/$CFRD1510_XMLFORMAT0 ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定された当処理用XML雛形ファイルに読込権限がありません [CFRD1510_XMLFORMAT0]=[$CFR_XMLFORMAT_DIR/$CFRD1510_XMLFORMAT0] ###" >>&! ${logfile}
    goto EndProc
endif

######  XMLFORMAT_SOME
printenv CFRD1510_XMLFORMATS >& /dev/null
if ( $status != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 当処理用XML雛形ファイルが設定されていません [CFRD1510_XMLFORMATS] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -f $CFR_XMLFORMAT_DIR/$CFRD1510_XMLFORMATS ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定された当処理用XML雛形ファイルがありません [CFRD1510_XMLFORMATS]=[$CFR_XMLFORMAT_DIR/$CFRD1510_XMLFORMATS] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -r $CFR_XMLFORMAT_DIR/$CFRD1510_XMLFORMATS ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定された当処理用XML雛形ファイルに読込権限がありません [CFRD1510_XMLFORMATS]=[$CFR_XMLFORMAT_DIR/$CFRD1510_XMLFORMATS] ###" >>&! ${logfile}
    goto EndProc
endif

####  環境変数:当処理用AWKファイル チェック  ####
printenv CFRD1510_AWKMAKEXMLS >& /dev/null
if ( $status != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 当処理用AWKファイルが設定されていません [CFRD1510_AWKMAKEXMLS] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -f $CFR_AWK_DIR/$CFRD1510_AWKMAKEXMLS ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定された当処理用AWKファイルがありません [CFRD1510_AWKMAKEXMLS]=[$CFR_AWK_DIR/$CFRD1510_AWKMAKEXMLS] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -r $CFR_AWK_DIR/$CFRD1510_AWKMAKEXMLS ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 指定された当処理用AWKファイルに読込権限がありません [CFRD1510_AWKMAKEXMLS]=[$CFR_AWK_DIR/$CFRD1510_AWKMAKEXMLS] ###" >>&! ${logfile}
    goto EndProc
endif

####  環境変数:SSステータステーブル保存年数 チェック  ####
printenv CFR_SS_SAVE_YEAR >& /dev/null
if ( $status != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] SSステータステーブル保存年数が設定されていません [CFR_SS_SAVE_YEAR] ###" >>&! ${logfile}
    goto EndProc
endif

####  環境変数:SS最大件数 チェック  ####
printenv CFR_SS_MAX_NUMBER >& /dev/null
if ( $status != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] SS最大件数が設定されていません [CFR_SS_MAX_NUMBER] ###" >>&! ${logfile}
    goto EndProc
endif

##  当csh用千手日付設定  ##
####  第一引数(任意:当csh用千手日付)
####      当csh用千手日付
####      第一引数＞環境変数SJ_PEX_DATE＞UNIXのマシン日付
if ($#argv > 0) then
    setenv WK_SJ_PEX_DATE $1
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 第一引数が設定されているため、当csh用千手日付を[$WK_SJ_PEX_DATE]とします ###" >>&! ${logfile}
else
    printenv SJ_PEX_DATE >& /dev/null
    if ( $status == ${CFR_OK} ) then
        setenv WK_SJ_PEX_DATE $SJ_PEX_DATE
        echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 第一引数が設定されていないため、当csh用千手日付を環境変数SJ_PEX_DATEの値[$WK_SJ_PEX_DATE]とします ###" >>&! ${logfile}
    else
        setenv WK_SJ_PEX_DATE `date '+%Y%m%d'`
        echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 第一引数が設定されていないため、当csh用千手日付をUNXマシン日付の値[$WK_SJ_PEX_DATE]とします ###" >>&! ${logfile}
    endif
endif

##  当csh用翌営業日取得  ##
\rm -f $CFR_TMPDIR/$CFRD1510_TMPFILE >& /dev/null
set sts = $status
if ( $sts != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 翌営業日取得前のTMPFILE削除でエラーが発生しました[rm error]=[$sts] TMPFILE=[CFRD1510_TMPFILE]=[$CFR_TMPDIR/$CFRD1510_TMPFILE] ###" >>&! ${logfile}
    goto EndProc
endif

sqlplus -S $CFR_ORAUID/$CFR_ORAPWD@$CFR_ORASID << _EOF_  >>&! ${logfile}
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
SET AUTOCOMMIT OFF
@$CFR_SQL_DIR/$CFRD1510_SQL0GETYOKU
$CFR_TMPDIR
$CFRD1510_TMPFILE
$WK_SJ_PEX_DATE
_EOF_

set sts = $status
if ( $sts != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 翌営業日取得でエラーが発生しました[sqlplus error]=[$sts] SQLFILE=[CFRD1510_SQL0GETYOKU]=[$CFR_SQL_DIR/$CFRD1510_SQL0GETYOKU] ###" >>&! ${logfile}
    goto EndProc
endif

if ( ! -f $CFR_TMPDIR/$CFRD1510_TMPFILE ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 翌営業日取得用TMPFILE(SPOOLFILE)が作成されていません[CFRD1510_TMPFILE]=[$CFR_TMPDIR/$CFRD1510_TMPFILE] ###" >>&! ${logfile}
    goto EndProc
endif

set WK_YOKUEI_YYYYMMDD = `grep '^[0-9]\{8\}$' $CFR_TMPDIR/$CFRD1510_TMPFILE`
set sts = $status
if ( $sts != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 翌営業日取得でエラーが発生しました[function error]=[$sts] SQLFILE=[CFRD1510_SQL0GETYOKU]=[$CFR_SQL_DIR/$CFRD1510_SQL0GETYOKU] ###" >>&! ${logfile}
    goto EndProc
endif

echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 当処理用翌営業日=[$WK_YOKUEI_YYYYMMDD] ###" >>&! ${logfile}

##############################
#  XML作成用中間テーブル処理 #
##############################
echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] XML作成用中間テーブル作成開始 ###" >>&! ${logfile}

\rm -f $CFR_TMPDIR/$CFRD1510_TMPFILE >& /dev/null
set sts = $status
if ( $sts != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 中間テーブル作成前のTMPFILE削除でエラーが発生しました[rm error]=[$sts] TMPFILE=[CFRD1510_TMPFILE]=[$CFR_TMPDIR/$CFRD1510_TMPFILE] ###" >>&! ${logfile}
    goto EndProc
endif

#    2014-02-18.消費税対応(CFRD1510_SQL5INSTMP3を追加) START
sqlplus -S $CFR_ORAUID/$CFR_ORAPWD@$CFR_ORASID << _EOF_  >>&! ${logfile}
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
SET AUTOCOMMIT OFF
@$CFR_SQL_DIR/$CFRD1510_SQL1TRUNTMP
@$CFR_SQL_DIR/$CFRD1510_SQL2INSTMP1
$WK_YOKUEI_YYYYMMDD
$thisname
$CFR_SS_SAVE_YEAR
@$CFR_SQL_DIR/$CFRD1510_SQL3UPDTMP1
@$CFR_SQL_DIR/$CFRD1510_SQL4UPDTMP1
@$CFR_SQL_DIR/$CFRD1510_SQL5INSTMP3
@$CFR_SQL_DIR/$CFRD1510_SQL5INSTMP2
@$CFR_SQL_DIR/$CFRD1510_SQL6SELTMP2
$CFR_TMPDIR
$CFRD1510_TMPFILE
COMMIT;
EXIT SQL.SQLCODE
_EOF_
#    2014-02-18.消費税対応(CFRD1510_SQL5INSTMP3を追加) END

set sts = $status
if ( $sts != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] XML作成用中間テーブル作成でエラーが発生しました[sqlplus error]=[$sts] ###" >>&! ${logfile}
    goto EndProc
endif

echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] XML作成用中間テーブル作成終了 ###" >>&! ${logfile}

##################################
#  XML作成用CSVファイル作成処理  #
##################################
echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] XML作成用CSVファイル作成開始 ###" >>&! ${logfile}

if ( ! -f $CFR_TMPDIR/$CFRD1510_TMPFILE ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] CSV作成用TMPFILE(SPOOLFILE)が作成されていません[CFRD1510_TMPFILE]=[$CFR_TMPDIR/$CFRD1510_TMPFILE] ###" >>&! ${logfile}
    goto EndProc
endif

\rm -f $CFR_TMPDIR/$CFRD1510_CSVFILE >& /dev/null
set sts = $status
if ( $sts != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] CSV作成前のCSVFILE削除でエラーが発生しました[rm error]=[$sts] CSVFILE=[CFRD1510_CSVFILE]=[$CFR_TMPDIR/$CFRD1510_CSVFILE] ###" >>&! ${logfile}
    goto EndProc
endif

sed -e '1,$s/ *	/	/g' $CFR_TMPDIR/$CFRD1510_TMPFILE | sed -e '1,$s/	 */	/g' | sed -e '1,$s/ALLSPACE-ALLSPACE/ /g' >&! $CFR_TMPDIR/$CFRD1510_CSVFILE

echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] XML作成用CSVファイル作成終了 ###" >>&! ${logfile}

#########################
#  XMLファイル作成処理  #
#########################
echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] XMLファイル作成開始 ###" >>&! ${logfile}

if ( ! -f $CFR_TMPDIR/$CFRD1510_CSVFILE ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] XMLファイル作成用CSVFILEが作成されていません[CFRD1510_CSVFILE]=[$CFR_TMPDIR/$CFRD1510_CSVFILE] ###" >>&! ${logfile}
    goto EndProc
endif

## 件数制限チェック ##
@ WK_CSV_KENSU = `wc -l $CFR_TMPDIR/$CFRD1510_CSVFILE | nawk '{print $1}'`
if ( $WK_CSV_KENSU > $CFR_SS_MAX_NUMBER ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 対象件数がSS最大件数をオーバーしました [SS最大件数]=[$CFR_SS_MAX_NUMBER] [対象件数]=[$WK_CSV_KENSU] CSVファイル=[$CFR_TMPDIR/CFRD1510_CSVFILE] ###" >>&! ${logfile}
    goto EndProc
endif

set WK_XMLFILENAME0 = "NAMD_A8_${WK_YOKUEI_YYYYMMDD}0000.xml"
set WK_XMLFILENAMES = "NAMD_A8_${WK_YOKUEI_YYYYMMDD}.xml"

\rm -f $CFR_SS_MAKEFILEDIR/$WK_XMLFILENAME0 >& /dev/null
set sts = $status
if ( $sts != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] XML作成前のゼロ件用XMLファイル削除でエラーが発生しました[rm error]=[$sts] XMLFILE=[WK_XMLFILENAME0]=[$CFR_SS_MAKEFILEDIR/$WK_XMLFILENAME0] ###" >>&! ${logfile}
    goto EndProc
endif

\rm -f $CFR_SS_MAKEFILEDIR/$WK_XMLFILENAMES >& /dev/null
set sts = $status
if ( $sts != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] XML作成前の1件以上用XMLファイル削除でエラーが発生しました[rm error]=[$sts] XMLFILE=[WK_XMLFILENAMES]=[$CFR_SS_MAKEFILEDIR/$WK_XMLFILENAMES] ###" >>&! ${logfile}
    goto EndProc
endif

## ゼロ件用XMLファイル作成処理 ##
if ( -z $CFR_TMPDIR/$CFRD1510_CSVFILE ) then
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] ゼロ件用XMLファイルを作成します ###" >>&! ${logfile}

    sed -e '/^[ 	]*<\!--/d' -e '/^[ 	]*$/d' -e "s/CHG_SYS_CODE/$CFRD1510_IN_SYS_CODE/" -e "s/CHG_DATA_YMD/$WK_YOKUEI_YYYYMMDD/" $CFR_XMLFORMAT_DIR/$CFRD1510_XMLFORMAT0 >&! $CFR_SS_MAKEFILEDIR/$WK_XMLFILENAME0

    set sts = $status
    if ( $sts != ${CFR_OK} ) then
        set exitsts = ${CFR_NG}
        echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] ゼロ件用XMLファイル作成でエラーが発生しました[sed error]=[$sts] XMLFILE=[WK_XMLFILENAME0]=[$CFR_SS_MAKEFILEDIR/$WK_XMLFILENAME0] ###" >>&! ${logfile}
        goto EndProc
    endif

    if ( ! -f $CFR_SS_MAKEFILEDIR/$WK_XMLFILENAME0 ) then
        set exitsts = ${CFR_NG}
        echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] ゼロ件用XMLファイルの作成に失敗しました[WK_XMLFILENAME0]=[$CFR_SS_MAKEFILEDIR/$WK_XMLFILENAME0] ###" >>&! ${logfile}
        goto EndProc
    endif

    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] ゼロ件用XMLファイルを作成しました  XMLFILE=[WK_XMLFILENAME0]=[$CFR_SS_MAKEFILEDIR/$WK_XMLFILENAME0] ###" >>&! ${logfile}

## 1件以上用XMLファイル作成処理 ##
else
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 1件以上用XMLファイルを作成します ###" >>&! ${logfile}
#    200906-04.投信外部委託顧問料のSSJ接続追加対応 START   
#    cat $CFR_XMLFORMAT_DIR/$CFRD1510_XMLFORMATS $CFR_TMPDIR/$CFRD1510_CSVFILE | sed -e '/^[ 	]*<\!--/d' -e '/^[ 	]*$/d' | nawk -f $CFR_AWK_DIR/$CFRD1510_AWKMAKEXMLS >&! $CFR_SS_MAKEFILEDIR/$WK_XMLFILENAMES
    cat $CFR_XMLFORMAT_DIR/$CFRD1510_XMLFORMATS $CFR_TMPDIR/$CFRD1510_CSVFILE | sed -e '/^[ 	]*<\!--/d' -e '/^[ 	]*$/d' | nawk -f $CFR_AWK_DIR/$CFRD1510_AWKMAKEXMLS | iconv -f SJIS -t UTF-8 >&! $CFR_SS_MAKEFILEDIR/$WK_XMLFILENAMES
#    200906-04.投信外部委託顧問料のSSJ接続追加対応 END   

    set sts = $status
    if ( $sts != ${CFR_OK} ) then
        set exitsts = ${CFR_NG}
        echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 1件以上用XMLファイル作成でエラーが発生しました[cat/sed/nawk error]=[$sts] XMLFILE=[WK_XMLFILENAMES]=[$CFR_SS_MAKEFILEDIR/$WK_XMLFILENAMES] ###" >>&! ${logfile}
        goto EndProc
    endif

    if ( ! -f $CFR_SS_MAKEFILEDIR/$WK_XMLFILENAMES ) then
        set exitsts = ${CFR_NG}
        echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 1件以上用XMLファイルの作成に失敗しました[WK_XMLFILENAMES]=[$CFR_SS_MAKEFILEDIR/$WK_XMLFILENAMES] ###" >>&! ${logfile}
        goto EndProc
    endif

    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] 1件以上用XMLファイルを作成しました  XMLFILE=[WK_XMLFILENAMES]=[$CFR_SS_MAKEFILEDIR/$WK_XMLFILENAMES] ###" >>&! ${logfile}

endif

echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] XMLファイル作成終了 ###" >>&! ${logfile}

##################################
#  SSステータステーブル登録処理 ##
##################################
echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] SSステータス登録開始 ###" >>&! ${logfile}

sqlplus -S $CFR_ORAUID/$CFR_ORAPWD@$CFR_ORASID << _EOF_  >>&! ${logfile}
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
SET AUTOCOMMIT OFF
@$CFR_SQL_DIR/$CFRD1510_SQL7INS_STS
$WK_YOKUEI_YYYYMMDD
$thisname
COMMIT;
EXIT SQL.SQLCODE
_EOF_

set sts = $status
if ( $sts != ${CFR_OK} ) then
    set exitsts = ${CFR_NG}
    echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] SSステータス登録でエラーが発生しました[sqlplus error]=[$sts] ###" >>&! ${logfile}
    goto EndProc
endif

echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] SSステータス登録終了 ###" >>&! ${logfile}
set exitsts = ${CFR_OK}

#################
#  終了処理     #
#################
EndProc:

switch (${exitsts})
    case ${CFR_OK}:
        echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] SS用XMLファイル作成正常終了 status=[$exitsts] ###" >>&! ${logfile}
        breaksw
    default:
        echo "### [$thisname][`date '+%Y/%m/%d-%H:%M:%S'`] SS用XMLファイル作成異常終了 status=[$exitsts] ###" >>&! ${logfile}
        breaksw
endsw

exit (${exitsts})
