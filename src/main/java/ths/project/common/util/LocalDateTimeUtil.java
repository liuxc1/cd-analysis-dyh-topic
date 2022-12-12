package ths.project.common.util;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAccessor;

public class LocalDateTimeUtil {
    private static final DateTimeFormatter DATETIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    /**
     * 取得当前日期。日期格式为：yyyy-MM-dd
     *
     * @return 当前日期字符串。
     */
    public static String getNowDate() {
        return DATE_FORMATTER.format(LocalDate.now());
    }

    /**
     * 取得当前日期时间。日期格式为：yyyy-MM-dd hh:mm:ss
     *
     * @return 当前日期字符串。
     */
    public static String getNowDateTime() {
        return DATETIME_FORMATTER.format(LocalDateTime.now());
    }

    /**
     * 字符串转为日期 (yyyy-MM-dd)
     *
     * @param date 日期字符串
     * @return 日期
     */
    public static LocalDateTime parseDate(String date) {
        return parse(date, DATE_FORMATTER);
    }

    /**
     * 字符串转为日期 (yyyy-MM-dd HH:mm:ss)
     *
     * @param date 日期字符串
     * @return 日期
     */
    public static LocalDateTime parseDateTime(String date) {
        return parse(date, DATETIME_FORMATTER);
    }

    /**
     * 字符串转为日期 (根据dateFormat定义)
     *
     * @param date 日期字符串
     * @param fmt  格式定义
     * @return 日期
     */
    public static LocalDateTime parse(String date, String fmt) {
        return parse(date, DateTimeFormatter.ofPattern(fmt));
    }

    /**
     * 字符串转为日期 (根据dateFormat定义)
     *
     * @param date 日期字符串
     * @param fmt  格式定义
     * @return 日期
     */
    public static LocalDateTime parse(String date, DateTimeFormatter fmt) {
        return LocalDateTime.parse(date, fmt);
    }

    /**
     * 日期转换为字符串 (yyyy-MM-dd)
     *
     * @param date 日期
     * @return 日期字符串
     */
    public static String formatDate(TemporalAccessor date) {
        return format(date, DATE_FORMATTER);
    }

    /**
     * 日期转换为字符串 (yyyy-MM-dd HH:mm:ss)
     *
     * @param date 日期
     * @return 日期字符串
     */
    public static String formatDateTime(TemporalAccessor date) {
        return format(date, DATETIME_FORMATTER);
    }

    /**
     * 日期转换为字符串 (按照指定格式)
     *
     * @param date 日期
     * @param fmt  格式
     * @return 日期字符串
     */
    public static String format(TemporalAccessor date, String fmt) {
        return format(date, DateTimeFormatter.ofPattern(fmt));
    }

    /**
     * 日期转换为字符串 (按照指定格式)
     *
     * @param date 日期
     * @param fmt  格式
     * @return 日期字符串
     */
    public static String format(TemporalAccessor date, DateTimeFormatter fmt) {
        return fmt.format(date);
    }
}
