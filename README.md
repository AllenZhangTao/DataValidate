##DataValidate 数据有效性校验

各种语言版本的数据有效性校验函数，从之前自己写的代码中整理得到的，后序应该会继续添加改进

###1.Validate_MSSQL.sql
MSSQL版数据有效性校验     
MSSQL 2000+      
返回值都是 字符串，如果为空则校验成功，否则返回错误原因

相关函数：

    f_validate_isidc                 是否身份证
    f_validate_isemail               是否邮件地址
    f_validate_isurl                 是否网络地址
    f_validate_isyyzz                是否有效营业执照注册号
    f_validate_iszzjgdm              是否有效组织机构代码
    f_validate_isdkkh                是否有效贷款卡号
    f_validate_isxzqh                是否有效行政区划
    f_validate_isgsdjzh              是否有效国税登记证号
    f_validate_isyzbm                是否有效邮政编码

###2.ValiDate.cs 
C#版数据校验类    
返回值为布尔型，错误信息在类变量中

相关函数：

    IsNotEmpty              验证是否为空
    IsNormalChar            验证是不是正常字符 字母，数字，下划线的组合
    IsEnglish               验证是否为英文字符及下划线
    IsChinese               验证是否为中文字符
    IsDate                  是否为有效的日期格式
    IsEmail                 是否为有效的邮箱格式
    IsUrl                   是否为有效的超链接格式
    IsPhone                 是否为有效的电话号码，例如：XXX-XXXXXXX
    IsMobile                是否为有效的手机号码
    IsIP                    是否为有效的IP地址
    IsZipCode               是否为有效的邮政编码
    IsIdCard                是否为有效的身份证号码 没有有效性校验
    IsQQ                    是否为有效的QQ号码
    IsMSN                   是否为有效的MSN帐户
    
    
    
