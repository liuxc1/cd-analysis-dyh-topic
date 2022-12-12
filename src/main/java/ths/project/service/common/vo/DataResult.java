package ths.project.service.common.vo;

import java.io.Serializable;

/**
 * 结果数据封装
 */
public class DataResult<T> implements Serializable {
    private static final long serialVersionUID = 285665732400689963L;

    protected final static int CODE_SUCCESS = 200;
    protected final static int CODE_FAILURE = 500;

    protected final static String MSG_OK = "操作成功";
    protected final static String MSG_FAILURE = "操作失败！";
    protected final static String MSG_FAILURE_NO_DATA = "暂无数据！";
    protected final static String MSG_FAILURE_ERROR = "系统服务异常！";

    /**
     * 结果code
     */
    private int code;
    /**
     * 结果信息
     */
    private String message;
    /**
     * 更多错误
     */
    private String[] errors;
    /**
     * 结果数据
     **/
    private T data;

    public DataResult() {
    }

    /**
     * 获取实例
     *
     * @return
     */
    protected static DataResult build() {
        return new DataResult();
    }

    protected DataResult(int code, String message) {
        this.code = code;
        this.message = message;
        this.errors = null;
    }

    protected DataResult(int code, String message, String[] errors) {
        this.code = code;
        this.message = message;
        this.errors = errors;
    }


    public int getCode() {
        return this.code;
    }

    public String getMessage() {
        return this.message;
    }

    public String[] getErrors() {
        return errors;
    }

    public boolean isSuccess() {
        return this.getCode() == CODE_SUCCESS;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    /**
     * 成功结果
     *
     * @return 结果
     */
    public DataResult<T> success() {
        this.code = CODE_SUCCESS;
        this.message = MSG_OK;
        return this;
    }

    /**
     * 成功结果（带数据）
     *
     * @param data 数据
     * @return 结果（带数据）
     */
    public DataResult<T> success(T data) {
        this.success();
        this.data = data;
        return this;
    }

    /**
     * 成功结果（待信息和数据）
     *
     * @param message 信息
     * @param data    数据
     * @return 结果（待信息和数据）
     */
    public DataResult<T> success(String message, T data) {
        this.code = CODE_SUCCESS;
        this.message = message;
        this.data = data;
        return this;
    }

    /**
     * 成功方法
     * start
     */
    public static <T> DataResult<T> ok(String message, T data) {
        return build().success(message, data);
    }

    public static <T> DataResult<T> ok(T data) {
        return build().success(data);
    }

    public static <T> DataResult<T> ok() {
        return build().success();
    }
    /**
     * 成功方法
     * end
     */

    /**
     * 失败结果
     *
     * @return 结果
     */
    public DataResult<T> failure() {
        this.code = CODE_FAILURE;
        this.message = MSG_FAILURE;
        return this;
    }

    /**
     * 失败结果（带信息）
     *
     * @param message 信息
     * @return 结果（带信息）
     */
    public DataResult<T> failure(String message) {
        this.code = CODE_FAILURE;
        this.message = message;
        return this;
    }

    /**
     * 失败结果,多个错误
     *
     * @param errors 多个错误
     * @return 结果
     */
    public DataResult<T> failure(String[] errors) {
        this.code = CODE_FAILURE;
        this.message = MSG_FAILURE;
        this.errors = errors;
        return this;
    }

    /**
     * 失败结果，参数缺失
     *
     * @return 结果
     */
    public DataResult<T> failureNotEmpty(String... nullFields) {
        StringBuilder sb = new StringBuilder("参数不能为空：");
        for (String nullField : nullFields) {
            sb.append(nullField);
            sb.append("、");
        }
        String msg = sb.substring(0, sb.length() - 1);
        this.code = CODE_FAILURE;
        this.message = msg;
        return this;
    }

    /**
     * 失败结果,暂无数据
     *
     * @return 结果
     */
    public DataResult<T> failureNoData() {
        this.code = CODE_FAILURE;
        this.message = MSG_FAILURE_NO_DATA;
        return this;
    }

    /**
     * 失败结果，异常失败
     *
     * @return 结果
     */
    public DataResult<T> failureError() {
        this.code = CODE_FAILURE;
        this.message = MSG_FAILURE_ERROR;
        return this;
    }

    /**
     * 失败方法
     * start
     */
    public static <T> DataResult<T> fail() {
        return build().failure();
    }

    public static <T> DataResult<T> fail(String message) {
        return build().failure(message);
    }

    public static <T> DataResult<T> fail(String[] message) {
        return build().failure(message);
    }

    public static <T> DataResult<T> failNotEmpty(String... message) {
        return build().failureNotEmpty(message);
    }

    public static <T> DataResult<T> failNoData() {
        return build().failureNoData();
    }

    public static <T> DataResult<T> failError() {
        return build().failureError();
    }
    /**
     * 失败方法
     * end
     */
}
