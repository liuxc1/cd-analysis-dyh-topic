package ths.project.common.util;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.Calendar;
import java.util.Date;

/**
 * 日期操作工具类
 *
 * @author liangdl
 */
public class DateUtil {

    private static final ThreadLocal<DateFormat> DATE_FORMAT_THREAD_LOCAL = new ThreadLocal<>();
    private static final ThreadLocal<DateFormat> TIME_FMT_THREAD_LOCAL = new ThreadLocal<>();
    private static final ThreadLocal<DateFormat> DATE_TIME_FMT_THREAD_LOCAL = new ThreadLocal<>();

    /**
     * 获取日期格式器（yyyy-MM-dd）
     *
     * @return DateFormat
     */
    public static DateFormat getDateFmt() {
        DateFormat dateFormat = DATE_FORMAT_THREAD_LOCAL.get();
        if (dateFormat == null) {
            dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            DATE_FORMAT_THREAD_LOCAL.set(dateFormat);
        }
        return dateFormat;
    }

    /**
     * 获取时间格式器（HH:mm:ss）
     *
     * @return DateFormat
     */
    public static DateFormat getTimeFmt() {
        DateFormat dateFormat = TIME_FMT_THREAD_LOCAL.get();
        if (dateFormat == null) {
            dateFormat = new SimpleDateFormat("HH:mm:ss");
            TIME_FMT_THREAD_LOCAL.set(dateFormat);
        }
        return dateFormat;
    }

    /**
     * 获取日期时间格式器（yyyy-MM-dd HH:mm:ss）
     *
     * @return DateFormat
     */
    public static DateFormat getDateTimeFmt() {
        DateFormat dateFormat = DATE_TIME_FMT_THREAD_LOCAL.get();
        if (dateFormat == null) {
            dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            DATE_TIME_FMT_THREAD_LOCAL.set(dateFormat);
        }
        return dateFormat;
    }

    /**
     * 字符串转为日期 (yyyy-MM-dd)
     *
     * @param date 日期字符串
     * @return 日期
     */
    public static Date parseDate(String date) {
        DateFormat fmt = getDateFmt();
        return parse(date, fmt);
    }

    /**
     * 字符串转为日期 (yyyy-MM-dd HH:mm:ss)
     *
     * @param date 日期字符串
     * @return 日期
     */
    public static Date parseDateTime(String date) {
        DateFormat dateTimeFmt = getDateTimeFmt();
        return parse(date, dateTimeFmt);
    }

    /**
     * 字符串转为日期 (根据dateFormat定义)
     *
     * @param date 日期字符串
     * @param fmt  格式定义
     * @return 日期
     */
    public static Date parse(String date, String fmt) {
        SimpleDateFormat dateFormat = new SimpleDateFormat(fmt);
        return parse(date, dateFormat);
    }

    /**
     * 字符串转为日期 (根据dateFormat定义)
     *
     * @param date 日期字符串
     * @param fmt  格式定义
     * @return 日期
     */
    public static Date parse(String date, DateFormat fmt) {
        try {
            return fmt.parse(date);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * 获取当前日期的字符串
     */
    public static String now() {
        return getNowDate();
    }

    /**
     * 取得当前日期。日期格式为：yyyy-MM-dd
     *
     * @return 当前日期字符串。
     */
    public static String getNowDate() {
        return getDateFmt().format(new Date());
    }

    /**
     * 取得当前日期时间。日期格式为：yyyy-MM-dd hh:mm:ss
     *
     * @return 当前日期字符串。
     */
    public static String getNowDateTime() {
        return getDateTimeFmt().format(new Date());
    }

    /**
     * 日期转换为字符串 (yyyy-MM-dd)
     *
     * @param date 日期
     * @return 日期字符串
     */
    public static String formatDate(Date date) {
        return getDateFmt().format(date);
    }

    /**
     * 日期转换为字符串 (yyyy-MM-dd HH:mm:ss)
     *
     * @param date 日期
     * @return 日期字符串
     */
    public static String formatDateTime(Date date) {
        return getDateTimeFmt().format(date);
    }

    /**
     * 日期转换为字符串 (HH:mm:ss)
     *
     * @param date 日期
     * @return 日期字符串
     */
    public static String formatTime(Date date) {
        return getTimeFmt().format(date);
    }

    /**
     * 日期转换为字符串 (按照指定格式)
     *
     * @param date 日期
     * @param fmt  格式
     * @return 日期字符串
     */
    public static String format(Date date, String fmt) {
        return new SimpleDateFormat(fmt).format(date);
    }

    /**
     * 日期转换为字符串 (按照指定格式)
     *
     * @param date 日期
     * @param fmt  格式
     * @return 日期字符串
     */
    public static String format(Date date, SimpleDateFormat fmt) {
        return fmt.format(date);
    }

    /**
     * 日期小时增减
     *
     * @param date 源日期
     * @param hour 加减小时数
     * @return 结果日期
     */
    public static Date addHour(Date date, int hour) {
        return new Date(date.getTime() + hour * 1000 * 60 * 60L);
    }

    /**
     * 日期加减
     *
     * @param date 日期
     * @param base 加减天数
     * @return 结果日期
     */
    public static Date addDay(Date date, int base) {
        return new Date(date.getTime() + base * 24 * 60 * 60 * 1000L);
    }

    /**
     * 月加减
     *
     * @param date 日期
     * @param base 加减月数
     * @return 结果日期
     */
    public static Date addMonth(Date date, int i) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.add(Calendar.MONTH, i);
        return calendar.getTime();
    }

    /**
     * 计算两个日期之间相差的天数
     *
     * @param date1 起始日期
     * @param date2 终止日期
     * @return 相差天数
     */
    public static int daysBetween(Date date1, Date date2) {
        long time1 = date1.getTime();
        long time2 = date2.getTime();
        long betweenDays = (time2 - time1) / (1000 * 60 * 60 * 24);
        return (int) betweenDays;
    }

    /**
     * 计算与当前时间相差的分钟
     *
     * @param date 起始时间
     * @return 分钟
     */
    public static Long minuteBetween(Date date) {
        LocalDateTime end = LocalDateTime.now();
        LocalDateTime start = date.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
        Long minute = ChronoUnit.SECONDS.between(start, end) / 60;
        return minute;
    }

    /**
     * 判断是否是闰年
     *
     * @param year 年份
     * @return 是否是闰年
     */
    public static int isLeapYear(int year) {
        boolean isLeapYear = (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
        return (isLeapYear ? 366 : 365);
    }

    /**
     * 获取星期
     *
     * @param date 日期
     * @return 星期几（1~7）
     */
    public static int getWeekDay(Date date) {
        Calendar c = Calendar.getInstance();
        c.setTime(date);
        int dayForWeek;
        if (c.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY) {
            dayForWeek = 7;
        } else {
            dayForWeek = c.get(Calendar.DAY_OF_WEEK) - 1;
        }
        return dayForWeek;
    }

    /**
     * 获取季度
     *
     * @param date 日期
     * @return 季度（1~4）
     */
    public static int getQuarter(Date date) {
        Calendar c = Calendar.getInstance();
        c.setTime(date);
        // 月份（0~11）
        int month = c.get(Calendar.MONTH);
        return (month / 3) + 1;
    }

    /**
     * 获取时间对应年份
     *
     * @param date 日期
     * @return 年份
     */
    public static int getFullYear(Date date) {
        Calendar a = Calendar.getInstance();
        a.setTime(date);
        return a.get(Calendar.YEAR);
    }

    /**
     * 获取时间对应月份
     *
     * @param date 日期
     * @return 月份
     */
    public static int getMonth(Date date) {
        Calendar a = Calendar.getInstance();
        a.setTime(date);
        return a.get(Calendar.DAY_OF_MONTH);
    }

    /***
     * 获取日期的季度第一天
     *
     * @param date 日期
     * @return 当前季度的第一天对应日期
     */
    public static Date getQuarterStartTime(Date date) {
        Calendar c = Calendar.getInstance();
        c.setTime(date);
        int year = c.get(Calendar.YEAR);
        // 该日期对应季度起始月份
        int startMonth = ((c.get(Calendar.MONTH) / 3) * 3) + 1;
        return parseDate(year + (startMonth < 10 ? "-0" : "-") + startMonth + "-01");
    }

    /**
     * 获取日期的当年第一天
     *
     * @param date 日期
     * @return 当年第一天对应日期
     */
    public static Date getYearStartTime(Date date) {
        Calendar currCal = Calendar.getInstance();
        currCal.setTime(date);
        int year = currCal.get(Calendar.YEAR);
        return parseDate(year + "-01-01");
    }

    /**
     * 获取历史时间
     *
     * @param f    时间格式
     * @param base 历史时间基数，以当前时间为基准。+1为明天，-1为昨天。
     */
    public static String history(String f, int base) {
        SimpleDateFormat dateFormat = new SimpleDateFormat(f);
        Date date = addDay(new Date(), base);
        return format(date, dateFormat);
    }

    /**
     * 获取历史时间
     *
     * @param f    时间格式
     * @param base 历史时间基数，以当前时间为基准。+1为明天，-1为昨天。
     */
    public static Date history2(String f, int base) {
        SimpleDateFormat dateFormat = new SimpleDateFormat(f);
        Date date = addDay(new Date(), base);
        return date;
    }




    public static String stringFormatZh2(String dateString, String format, String formatZh) {
        Calendar calendar = dateFormat(dateString, format);
        String year = String.valueOf(calendar.get(Calendar.YEAR));
        String month = (calendar.get(Calendar.MONTH) + 1) < 10 ? "" + (calendar.get(Calendar.MONTH) + 1) : String.valueOf(calendar.get(Calendar.MONTH) + 1);
        String date = calendar.get(Calendar.DATE) < 10 ? "" + calendar.get(Calendar.DATE) : String.valueOf(calendar.get(Calendar.DATE));
        String hour = calendar.get(Calendar.HOUR_OF_DAY) < 10 ? "0" + calendar.get(Calendar.HOUR_OF_DAY) : String.valueOf(calendar.get(Calendar.HOUR_OF_DAY));
        String minute = calendar.get(Calendar.MINUTE) < 10 ? "0" + calendar.get(Calendar.MINUTE) : String.valueOf(calendar.get(Calendar.MINUTE));
        String second = calendar.get(Calendar.SECOND) < 10 ? "0" + calendar.get(Calendar.SECOND) : String.valueOf(calendar.get(Calendar.SECOND));
        return formatZh.replaceAll("yyyy", year).replaceAll("MM", month).replaceAll("dd", date).replaceAll("HH", hour).replaceAll("mm", minute).replaceAll("ss", second);
    }

    /**
     * 将字符串转换为Calendar
     *
     * @param sdate
     * @param f
     * @return
     */
    public static Calendar dateFormat(String sdate, String f) {
        SimpleDateFormat sdf = new SimpleDateFormat(f);
        Date date = null;
        try {
            date = sdf.parse(sdate);
        } catch (ParseException e) {
            System.out.println("日期转换出错");
            e.printStackTrace();
        }
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        return calendar;
    }
    /**
     * 年加减
     * @param time 时间字符串
     * @param num 偏移量
     * @return
     * @throws ParseException
     */
    public static String yearAddNum(String time, Integer num) throws ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(sdf.parse(time));
        calendar.add(Calendar.YEAR, num);
        return sdf.format(calendar.getTime());
    }

    /**
     * 获取当期时间的字符串
     *
     * @return
     */
    public static String nowHMS() {
        return format(new Date(), "yyyy/MM/dd HH:mm:ss");
    }
}
