using System;

namespace Youth.Admin
{
    /// <summary>
    /// 表单验证类
    /// </summary>
    public sealed class Validator
    {
        public static string Msg = "无提示信息！";
        private static bool Result = true;

        #region Check(object obj,string reg)验证基函数
        public static bool Check(object obj,string reg)
        {
            return System.Text.RegularExpressions.Regex.IsMatch(obj.ToString(), reg, System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        }
        #endregion

        #region IsNotEmpty验证是否为空
        /// <summary>
        /// IsNotEmpty验证是否为空
        /// </summary>
        public static bool IsNotEmpty(object obj)
        {
            if (!Check(obj, @".?[^\s　]+")) { Msg = "不能为空！";Result = false; } else { Result = true; }
            return Result;
        }
        #endregion

        #region 验证是不是正常字符 字母，数字，下划线的组合
        /// <summary>
        /// 验证是不是正常字符 字母，数字，下划线的组合
        /// </summary>
        /// <param name="source"></param>
        /// <returns></returns>
        public static bool IsNormalChar(object obj)
        {
            if (!Check(obj, @"[\w\d_]+")) { Msg = "必须为字符 字母，数字，下划线的组合！";Result = false; } else { Result = true; }
            return Result;
        }
        #endregion

        #region IsEnglish验证是否为英文字符及下划线
        /// <summary>
        /// IsEnglish验证是否为英文字符及下划线
        /// </summary>
        public static bool IsEnglish(object obj)
        {
            if (!Check(obj, @"^[a-zA-Z0-9_\-]+$")) { Msg = "必须为英文字符及下划线的组合！";Result = false; } else { Result = true; }
            return Result;
        }
        #endregion

        #region IsChinese验证是否为中文字符
        /// <summary>
        /// IsChinese验证是否为中文字符
        /// </summary>
        public static bool IsChinese(object obj)
        {
            if (!Check(obj, @"^[\u0391-\uFFE5]+$")) { Msg = "必须为中文！";Result = false; } else { Result = true; }
            return Result;
        }
        #endregion

        #region IsDate是否为有效的日期格式
        /// <summary>
        /// IsDate是否为有效的日期格式
        /// </summary>
        public static bool IsDate(object obj)
        {
            try
            {
                DateTime time = Convert.ToDateTime(obj);
                return true;
            }
            catch
            {
                Msg = "不是有效的日期格式！";
                return false;
            }
        }
        #endregion

        #region IsEmail是否为有效的邮箱格式
        /// <summary>
        /// IsEmail是否为有效的邮箱格式
        /// </summary>
        public static bool IsEmail(object obj)
        {
            if (!Check(obj, @"^[A-Za-z0-9](([_\.\-]?[a-zA-Z0-9]+)*)@([A-Za-z0-9]+)(([\.\-]?[a-zA-Z0-9]+)*)\.([A-Za-z]{2,})$")) { Msg = "不是有效的邮箱格式！";Result = false; } else { Result = true; }
            return Result;
        }
        #endregion

        #region IsUrl是否为有效的超链接格式
        /// <summary>
        /// IsUrl是否为有效的超链接格式
        /// </summary>
        public static bool IsUrl(object obj)
        {
            if (!Check(obj, @"^(((file|gopher|news|nntp|telnet|http|ftp|https|ftps|sftp)://)|(www\.))+(([a-zA-Z0-9\._-]+\.[a-zA-Z]{2,6})|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(/[a-zA-Z0-9\&amp;%_\./-~-]*)?$")) { Msg = "不是有效的超链接格式！"; Result = false; } else { Result = true; }
            return Result;
        }
        #endregion

        #region IsPhone是否为有效的电话号码
        /// <summary>
        /// 例如：XXX-XXXXXXX
        /// </summary>
        public static bool IsPhone(object obj)
        {
            if (!Check(obj, @"^((\(\d{2,3}\))|(\d{3}\-))?(\(0\d{2,3}\)|0\d{2,3}-)?[1-9]\d{6,7}(\-\d{1,4})?$")) { Msg = "不是有效的电话号码格式！";Result = false; } else { Result = true; }
            return Result;
        }
        #endregion

        #region IsMobile是否为有效的手机号码
        /// <summary>
        ///  IsMobile是否为有效的手机号码
        /// </summary>
        public static bool IsMobile(object obj)
        {
            if (!Check(obj, @"^((\(\d{2,3}\))|(\d{3}\-))?((13\d{9})|(159\d{8}))$")) { Msg = "不是有效的手机号码格式！";Result = false; } else { Result = true; }
            return Result;
        }
        #endregion

        #region IsIP是否为有效的IP地址
        /// <summary>
        /// IsIP是否为有效的IP地址
        /// </summary>
        public static bool IsIP(object obj)
        {
            if (!Check(obj, @"^(0|[1-9]\d?|[0-1]\d{2}|2[0-4]\d|25[0-5]).(0|[1-9]\d?|[0-1]\d{2}|2[0-4]\d|25[0-5]).(0|[1-9]\d?|[0-1]\d{2}|2[0-4]\d|25[0-5]).(0|[1-9]\d?|[0-1]\d{2}|2[0-4]\d|25[0-5])$")) { Msg = "不是有效的IP地址格式！";Result = false; } else { Result = true; }
            return Result;
        }
        #endregion

        #region IsZipCode是否为有效的邮政编码
        /// <summary>
        ///IsZipCode是否为有效的邮政编码
        /// </summary>
        public static bool IsZipCode(object obj)
        {
            if (!Check(obj, @"^[1-9]\d{5}$")) { Msg = "不是有效的邮政编码格式！";Result = false; } else { Result = true; }
            return Result;
        }
        #endregion

        #region IsIdCard是否为有效的身份证号码
        /// <summary>
        /// IsIdCard是否为有效的身份证号码
        /// </summary>
        public static bool IsIdCard(object obj)
        {
            if (!Check(obj, @"(^\d{15}$)|(^\d{17}[0-9Xx]$)")) { Msg = "不是有效的身份证号码格式！";Result = false; } else { Result = true; }
            return Result;
        }
        #endregion

        #region IsQQ是否为有效的QQ号码
        /// <summary>
        /// IsQQ是否为有效的QQ号码
        /// </summary>
        public static bool IsQQ(object obj)
        {
            if (!Check(obj, @"^[1-9]\d{4,10}$")) { Msg = "不是有效的QQ号码！";Result = false; } else { Result = true; }
            return Result;
        }
        #endregion

        #region IsMSN是否为有效的MSN帐户
        /// <summary>
        /// IsMSN是否为有效的MSN帐户
        /// </summary>
        public static bool IsMSN(object obj)
        {
            if (!Check(obj, @"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$")) { Msg = "不是有效的MSN帐户！";Result = false; } else { Result = true; }
            return Result;
        }
        #endregion

        #region IsNumber验证是不是数字
        /// <summary>
        /// IsNumber验证是不是数字
        /// </summary>
        public static bool IsNumber(object obj)
        {
            if (!Check(obj, @"^[-\+]?\d+(\.\d+)?$")) { Msg = "不是有效的数字！";Result = false; } else { Result = true; }
            return Result;
        }
        #endregion

        #region IsInteger验证是不是整数
        /// <summary>
        /// IsInteger验证是不是整数
        /// </summary>
        public static bool IsInteger(object obj)
        {
            if (!Check(obj,  @"^-?\d+$")) { Msg = "不是有效的整数格式！";Result = false; } else { Result = true; }
            return Result;
        }
        #endregion

        #region IsUnsignedInteger验证是不是正整数
        /// <summary>
        /// IsUnsignedInteger验证是不是正整数
        /// </summary>
        public static bool IsUnsignedInteger(object obj)
        {
            if (!Check(obj, @"^[0-9]*[1-9][0-9]*$")) { Msg = "不是正整数！";Result = false; } else { Result = true; }
            return Result;
        }
        #endregion

        #region IsSignedInteger验证是不是负整数
        /// <summary>
        /// IsSignedInteger验证是不是负整数
        /// </summary>
        public static bool IsSignedInteger(object obj)
        {
            if (!Check(obj, @"^-[0-9]*[1-9][0-9]*$")) { Msg = "不是负整数！";Result = false; } else { Result = true; }
            return Result;
        }
        #endregion
    }
}
