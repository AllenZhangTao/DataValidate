/*
MSSQL 2000+ 
返回值都是 字符串，如果为空则校验成功，否则返回错误原因

f_validate_isidc                内: 是否身份证
f_validate_isemail              内: 是否邮件地址
f_validate_isurl                内: 是否网络地址
f_validate_isyyzz               内: 是否有效营业执照注册号
f_validate_iszzjgdm             内: 是否有效组织机构代码
f_validate_isdkkh               内: 是否有效贷款卡号
f_validate_isxzqh               内：是否有效行政区划
f_validate_isgsdjzh             内: 是否有效国税登记证号
f_validate_isyzbm               内: 是否有效邮政编码
/*


/******************************************************************************/
/* 英文名称： f_validate_isidc                                                */
/* 中文名称： 是否有效身份证                                                  */
/* 功    能： 是否有效身份证                                                  */
/*                                                                            */
/* 相关函数：                                                                 */
/* 功能编号:  无                                                              */
/* 对象编号:  无                                                              */
/* 错误编号:  无                                                              */
/*                                                                            */
/******************************************************************************/
/*关键流水和算法说明
  此过程没有事务
*/
/* 修改历史

*/
print 'create function f_validate_isidc ...'
go
set nocount on
go
if exists(select * from sysobjects where name = 'f_validate_isidc' and type = 'FN')
    drop function f_validate_isidc;
go
create function f_validate_isidc (    
    @vc_idc        varchar(32), 
    @l_flag        int = 0 -- 是否开启15位校验,默认 否
)   
    returns         varchar(255)   
as   
begin
    select @vc_idc = isnull(@vc_idc,'')

    declare @vc_date varchar(8),
            @vc_area varchar(6),
            @vc_order varchar(3)

    if datalength(@vc_idc) = 15 and @l_flag = 1 -- 开启15位校验
    begin
        select @vc_date = '19' + substring(@vc_idc,7,6),
            @vc_order = right(@vc_idc,3)
    end
    else if datalength(@vc_idc) = 18
    begin
        select @vc_date = substring(@vc_idc,7,8),
            @vc_order =substring(@vc_idc,14,3)
    end
    else    
        return 'GB11643-1999《公民身份号码》规定身份证号码必须为18位('+@vc_idc+'，长度'+convert(varchar,datalength(@vc_idc))+')'

    
    select  @vc_area = left(@vc_idc,6)

    if(isdate(@vc_date) = 0) or not (convert(int,left(@vc_date,4)) - 1900) between 3 and 500
        return '身份证出生日期不正确('+@vc_date+')'

    if (isnumeric(@vc_order)<>1) or charindex('.',@vc_idc) >0
        return '身份证号格式顺序位有误'+@vc_idc

    if dbo.f_validate_isxzqh(@vc_area,default) <> ''
        return '身份证号有误：'+dbo.f_validate_isxzqh(@vc_area,default)

    if datalength(@vc_idc) = 15
        return ''

    /**//*验证校验位开始*/
    declare @validfactors varchar(17),@validcodes varchar(11),@i tinyint,@itemp int
    select @validfactors='79A584216379A5842',@validcodes='10X98765432',@i=1,@itemp=0
    while @i<18
       begin
          select @itemp=@itemp+cast(substring(@vc_idc,@i,1) as int)*(case substring(@validfactors,@i,1) when 'A' then 10 else substring(@validfactors,@i,1) end)
                ,@i=@i+1
       end
    if substring(@validcodes,@itemp%11+1,1)<>right(@vc_idc,1)
       return '身份证有误，最后一位无法通过校验'+@vc_idc
        
    return '' 
end   
go


/******************************************************************************/
/* 英文名称： f_validate_isemail                                              */
/* 中文名称： 是否有效邮件地址                                                */
/* 功    能： 是否有效邮件地址                                                */
/*                                                                            */
/* 相关函数：                                                                 */
/* 功能编号:  无                                                              */
/* 对象编号:  无                                                              */
/* 错误编号:  无                                                              */
/*                                                                            */
/******************************************************************************/
/*关键流水和算法说明
  此过程没有事务
*/
/* 修改历史

*/ 
print 'create function f_validate_isemail ...'
go
set nocount on
go
if exists(select * from sysobjects where name = 'f_validate_isemail' and type = 'FN')
    drop function f_validate_isemail;
go
create function f_validate_isemail (    
    @vc_email        varchar(255) 
)   
    returns         varchar(255)   
as   
begin
    select @vc_email = isnull(@vc_email,'')
    if @vc_email like '%_@%_.%_'
        return ''
    
    return '邮件地址不正确：'+@vc_email
end   
go


/******************************************************************************/
/* 英文名称： f_validate_isurl                                                */
/* 中文名称： 是否有效网络地址                                                */
/* 功    能： 是否有效网络地址                                                */
/*                                                                            */
/* 相关函数：                                                                 */
/* 功能编号:  无                                                              */
/* 对象编号:  无                                                              */
/* 错误编号:  无                                                              */
/*                                                                            */
/******************************************************************************/
/*关键流水和算法说明
  此过程没有事务
*/
/* 修改历史

*/
print 'create function f_validate_isurl ...'
go
set nocount on
go
if exists(select * from sysobjects where name = 'f_validate_isurl' and type = 'FN')
    drop function f_validate_isurl;
go
create function f_validate_isurl (    
    @vc_url        varchar(255) 
)   
    returns         varchar(255)   
as   
begin
    select @vc_url = isnull(@vc_url,'')
    if @vc_url like 'http://%_.%_' or @vc_url like 'https://%_.%_'
  	return ''
    
    return '网址格式必须以 http(s):// 开头：'+@vc_url
end   
go


/******************************************************************************/
/* 英文名称： f_validate_isyyzz                                               */
/* 中文名称： 是否有效营业执照注册号                                          */
/* 功    能： 是否有效营业执照注册号                                          */
/*                                                                            */
/* 相关函数：                                                                 */
/* 功能编号:  无                                                              */
/* 对象编号:  无                                                              */
/* 错误编号:  无                                                              */
/*                                                                            */
/******************************************************************************/
/*关键流水和算法说明
  此过程没有事务
*/
/* 修改历史

*/
print 'create function f_validate_isyyzz ...'
go
set nocount on
go
if exists(select * from sysobjects where name = 'f_validate_isyyzz' and type = 'FN')
    drop function f_validate_isyyzz;
go
create function f_validate_isyyzz (    
    @vc_zzno        varchar(32) 
)   
    returns         varchar(255)   
as   
begin

    select @vc_zzno = isnull(ltrim(rtrim(@vc_zzno)),'') 
    declare 
        @l_len int, @m int,@n int, @s int , @p int ,@i int ,@result int 
    select @m=10,@n=11,@p=@m
    
    select @l_len = datalength(@vc_zzno)
    if @l_len =13 and isnumeric(@vc_zzno) =1 
       return ''
     
    if @l_len <>15
        return '营业执照必须为13位或者15位（2007年升至15位）'
    
    set @i=1
    while @i <=14
    begin 
        set @s = substring(@vc_zzno,@i,1)
        set @p = @p+@s
        set @p =@p%@m
        if @p = 0
        begin
           set @p= @m
        end 
        set @p = @p *2 
        set @p = @p%@n
        set @i=@i+1
    end 
    set @p = @p+substring(@vc_zzno,15,1)
    set @p = @p%@m
    
    if @p<>1 
        return '营业执照末位校验不通过'   


return ''
end
go


/******************************************************************************/
/* 英文名称： f_validate_iszzjgdm                                               */
/* 中文名称： 是否有效组织机构代码                                            */
/* 功    能： 是否有效组织机构代码                                            */
/*                                                                            */
/* 相关函数：                                                                 */
/* 功能编号:  无                                                              */
/* 对象编号:  无                                                              */
/* 错误编号:  无                                                              */
/*                                                                            */
/******************************************************************************/
/*关键流水和算法说明
  此过程没有事务
*/
/* 修改历史

*/
use hswinsql2
go 
print 'create function f_validate_iszzjgdm ...'
go
set nocount on
go
if exists(select * from sysobjects where name = 'f_validate_iszzjgdm' and type = 'FN')
    drop function f_validate_iszzjgdm;
go
create function f_validate_iszzjgdm (    
    @vc_zzjgdm        varchar(32) 
)   
    returns         varchar(255)   
as   
begin
    declare @c varchar(20),@zz int,@z int,@i int,@jaz varchar(30),@c9 varchar(10)
    set @vc_zzjgdm =isnull(ltrim(rtrim(@vc_zzjgdm)),'') 
    if datalength(@vc_zzjgdm) <> 10 or substring(@vc_zzjgdm,9,1) <> '-'
        return '组织机构代码必须为10位,且第9位必须为“-”'

    set @i=1
    while @i <=8
    begin
        set @c= substring(@vc_zzjgdm,@i,1)
        if @c>='A' and @c<='Z'
        begin
          set @z = (ascii(@c)-55) * (case @i when 1 then 3 when 2 then 7 when 3 then 9 when 4 then 10 when 5 then 5 when 6 then 8 when 7 then 4 when 8 then 2 end)
        end 
        else if @c>='0' and @c<='9' 
        begin
          set @z=convert(numeric,@c) * (case @i when 1 then 3 when 2 then 7 when 3 then 9 when 4 then 10 when 5 then 5 when 6 then 8 when 7 then 4 when 8 then 2 end)
        end
        else
        begin
            return '组织结构代码（必须为大写）中有不合法字符：'+@vc_zzjgdm
        end  
        set @zz = isnull(@zz,0)+@z 
        set @i = @i+1
    end
    
    
    set @jaz = 11-(@zz%11)
    if @jaz=10
    begin
        set @c9 = 'X'
    end 
    else if @jaz =11
    begin
        set @c9='0'    
    end
    else 
    begin
        set @c9=ltrim(rtrim(@jaz))
    end 
    
    
    if @vc_zzjgdm <> substring(@vc_zzjgdm,1,8) +'-'+@c9
        return '组织机构代码末位（大写）校验失败'
    
return ''
end
go



/******************************************************************************/
/* 英文名称： f_validate_isdkkh                                               */
/* 中文名称： 是否有效贷款卡号                                                */
/* 功    能： 是否有效贷款卡号                                                */
/*                                                                            */
/* 相关函数：                                                                 */
/* 功能编号:  无                                                              */
/* 对象编号:  无                                                              */
/* 错误编号:  无                                                              */
/*                                                                            */
/******************************************************************************/
/*关键流水和算法说明
  此过程没有事务
*/
/* 修改历史

*/
use hswinsql2
go 
print 'create function f_validate_isdkkh ...'
go
set nocount on
go
if exists(select * from sysobjects where name = 'f_validate_isdkkh' and type = 'FN')
    drop function f_validate_isdkkh;
go
create function f_validate_isdkkh (    
    @vc_dkkh        varchar(32) 
)   
    returns         varchar(255)   
as   
begin
    declare @c char(1),@z int,@i int,@jaz int,@ck char(2)
    set @vc_dkkh =isnull(ltrim(rtrim(@vc_dkkh)),'') 
    if datalength(@vc_dkkh) <> 16 
        return '贷款卡号必须为16位:'+@vc_dkkh

    set @i=1
    set @z=0
    while @i <=14
    begin
        set @c= substring(@vc_dkkh,@i,1)
        if (@i >3) and (@c<'0' or @c>'9')
            return '贷款卡号4-14位必须为数字:'+@vc_dkkh
        
        if @c>='A' and @c<='Z'
            select @jaz = ascii(@c)-55 
        else if @c>='0' and @c<='9' 
            select @jaz = ascii(@c)-48 
        else
            return '贷款卡号(必须为大写)中存在有非法字符:'+@vc_dkkh

        select @z = @z + @jaz *
        case @i 
            when 1 then 1
            when 2 then 3
            when 3 then 5 
            when 4 then 7
            when 5 then 11
            when 6 then 2
            when 7 then 13
            when 8 then 1
            when 9 then 1
            when 10 then 17
            when 11 then 19
            when 12 then 97
            when 13 then 23
            when 14 then 29
        end
        set @i = @i+1
    end
    
    
    set @jaz = @z % 97 +1 
    if @jaz < 10
        select @ck = '0'+convert(varchar,@jaz)
    else 
        select @ck = convert(varchar,@jaz)

    if right(@vc_dkkh,2) <> @ck 
        return '贷款卡号最后两位校验不成功:'+@vc_dkkh
 
return ''
end
go




/******************************************************************************/
/* 英文名称： f_validate_isxzqh                                               */
/* 中文名称： 是否有效行政区划                                                */
/* 功    能： 是否有效行政区划                                                */
/*                                                                            */
/* 相关函数：                                                                 */
/* 功能编号:  无                                                              */
/* 对象编号:  无                                                              */
/* 错误编号:  无                                                              */
/*                                                                            */
/******************************************************************************/
/*关键流水和算法说明
  此过程没有事务
*/
/* 修改历史

*/
use hswinsql2
go 
print 'create function f_validate_isxzqh ...'
go
set nocount on
go
if exists(select * from sysobjects where name = 'f_validate_isxzqh' and type = 'FN')
    drop function f_validate_isxzqh;
go
create function f_validate_isxzqh (    
    @vc_xzqh        varchar(32),
    @l_len          int = 6
)   
    returns         varchar(255)   
as   
begin
    select @vc_xzqh =isnull(ltrim(rtrim(@vc_xzqh)),'') 
    
    if (isnumeric(@vc_xzqh)<>1) or charindex('.',@vc_xzqh) >0 
        return '行政区划有误'+@vc_xzqh

    if @l_len = 2 
    begin
        if not (convert(numeric,@vc_xzqh) between 10  and 90) 
            return '无此行政区划代码'
    end

    if @l_len = 4 
    begin
        if not (convert(numeric,@vc_xzqh) between 1000  and 9000) 
            return '无此行政区划代码'
    end

    if @l_len = 6 
    begin
        if not (convert(numeric,@vc_xzqh) between 100000  and 900000) 
            return '无此行政区划代码'
    end
return ''
end
go

/******************************************************************************/
/* 英文名称： f_validate_isgsdjzh                                             */
/* 中文名称： 是否有效国税登记证号                                            */
/* 功    能： 是否有效国税登记证号                                                */
/*                                                                            */
/* 相关函数：                                                                 */
/* 功能编号:  无                                                              */
/* 对象编号:  无                                                              */
/* 错误编号:  无                                                              */
/*                                                                            */
/******************************************************************************/
/*关键流水和算法说明
  此过程没有事务
*/
/* 修改历史

*/
use hswinsql2
go 
print 'create function f_validate_isgsdjzh ...'
go
set nocount on
go
if exists(select * from sysobjects where name = 'f_validate_isgsdjzh' and type = 'FN')
    drop function f_validate_isgsdjzh;
go
create function f_validate_isgsdjzh (    
    @vc_gsdjzh        varchar(32) 
)   
    returns         varchar(255)   
as   
begin
    declare @l_len int,@vc_temp varchar(32),@vc_error varchar(255)
    select @vc_gsdjzh =isnull(ltrim(rtrim(@vc_gsdjzh)),''),
        @vc_error = ''

    select @l_len = datalength(@vc_gsdjzh)
    if not @l_len in (15, 20)
    begin
        return '国税登记证号长度不正确：'+@vc_gsdjzh
    end

    if  @l_len = 15
    begin
        select @vc_error = dbo.f_validate_isxzqh(left(@vc_gsdjzh,6),6)
        if @vc_error <> ''
            return '国税登记号错误:'+@vc_error

        select @vc_temp = substring(@vc_gsdjzh,7,8)+'-'+upper(right(@vc_gsdjzh,1))
        select @vc_error = dbo.f_validate_iszzjgdm(@vc_temp)
        if @vc_error <> ''
            return '国税登记号错误:'+@vc_error
        
    end

    if @l_len = 20
    begin
        select @vc_temp = right(@vc_gsdjzh,2)
        if isnumeric(@vc_temp) <> 1 or charindex('.',@vc_temp)>0
            return '国税登记号最后两位出错'+@vc_gsdjzh
        
        select @vc_error = dbo.f_validate_isidc(left(@vc_gsdjzh,18),default)

        if @vc_error <> '' 
        begin
            if substring(@vc_gsdjzh,16,3) <> '000' or dbo.f_validate_isidc(left(@vc_gsdjzh,15),0) <> '' --兼容15位
                return '国税登记号中身份证有误：'+@vc_error
        end
    end
 
return ''
end
go

/******************************************************************************/
/* 英文名称： f_validate_isyzbm                                              */
/* 中文名称： 是否有效邮政编码                                               */
/* 功    能： 是否有效邮政编码                                               */
/*                                                                            */
/* 相关函数：                                                                 */
/* 功能编号:  无                                                              */
/* 对象编号:  无                                                              */
/* 错误编号:  无                                                              */
/*                                                                            */
/******************************************************************************/
/*关键流水和算法说明
  此过程没有事务
*/
/* 修改历史

*/
use hswinsql2
go 
print 'create function f_validate_isyzbm ...'
go
set nocount on
go
if exists(select * from sysobjects where name = 'f_validate_isyzbm' and type = 'FN')
    drop function f_validate_isyzbm;
go
create function f_validate_isyzbm (    
    @vc_yzbm        varchar(32) 
)   
    returns         varchar(255)   
as   
begin
    select @vc_yzbm = isnull(@vc_yzbm,'')
    
    if datalength(@vc_yzbm) <> 6 or (isnumeric(@vc_yzbm)<>1) or convert(numeric,@vc_yzbm) not between 100000 and 999999
        return '邮政编码有误'+@vc_yzbm
 
return ''
end
go
