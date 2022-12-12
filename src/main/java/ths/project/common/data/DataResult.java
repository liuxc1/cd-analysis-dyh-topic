package ths.project.common.data;

import java.io.Serializable;

/**
 * 结果数据封装
 */
public class DataResult implements Serializable {
    private static final long serialVersionUID = 285665732400689963L;

    protected final static int CODE_SUCCESS = 200;
    protected final static int CODE_FAILURE = 500;

    protected final static String MSG_OK = "操作成功";
    protected final static String MSG_FAILURE = "操作失败！";
    protected final static String MSG_FAILURE_NO_DATA = "暂无数据！";
    protected final static String MSG_FAILURE_ERROR = "系统服务异常！";

    protected final static DataResult DATA_OK = new DataResult(CODE_SUCCESS, MSG_OK);
    protected final static DataResult DATA_FAILURE = new DataResult(CODE_FAILURE, MSG_FAILURE);
    protected final static DataResult DATA_FAILURE_NO_DATA = new DataResult(CODE_FAILURE, MSG_FAILURE_NO_DATA);
    protected final static DataResult DATA_FAILURE_ERROR = new DataResult(CODE_FAILURE, MSG_FAILURE_ERROR);

    /**
     * 结果code
     */
    private final int code;
    /**
     * 结果信息
     */
    private final String message;
    /**
     * 更多错误
     */
    private final String[] errors;
    /**
     * 结果数据
     **/
    private Object data;

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

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }

    /**
     * 成功结果
     *
     * @return 结果
     */
    public static DataResult create(int code, String message) {
        return new DataResult(code, message);
    }

    /**
     * 成功结果
     *
     * @return 结果
     */
    public static DataResult success() {
        return DATA_OK;
    }

    /**
     * 成功结果（带数据）
     *
     * @param data 数据
     * @return 结果（带数据）
     */
    public static DataResult success(Object data) {
        DataResult dataResult = new DataResult(CODE_SUCCESS, MSG_OK);
        dataResult.setData(data);
        return dataResult;
    }

    /**
     * 成功结果（待信息和数据）
     *
     * @param message 信息
     * @param data    数据
     * @return 结果（待信息和数据）
     */
    public static DataResult success(String message, Object data) {
        DataResult dataResult = new DataResult(CODE_SUCCESS, message);
        dataResult.setData(data);
        return dataResult;
    }

    /**
     * 失败结果
     *
     * @return 结果
     */
    public static DataResult failure() {
        return DATA_FAILURE;
    }

    /**
     * 失败结果（带信息）
     *
     * @param message 信息
     * @return 结果（带信息）
     */
    public static DataResult failure(String message) {
        DataResult dataResult = new DataResult(CODE_FAILURE, message);
        return dataResult;
    }

    /**
     * 失败结果,多个错误
     *
     * @param errors 多个错误
     * @return 结果
     */
    public static DataResult failure(String[] errors) {
        DataResult dataResult = new DataResult(CODE_FAILURE, MSG_FAILURE, errors);
        return dataResult;
    }

    /**
     * 失败结果，参数缺失
     *
     * @return 结果
     */
    public static DataResult failureNotEmpty(String... nullFields) {
        StringBuilder sb = new StringBuilder("参数不能为空：");
        for (String nullField : nullFields) {
            sb.append(nullField);
            sb.append("、");
        }
        String msg = sb.substring(0, sb.length() - 1);
        DataResult dataResult = new DataResult(CODE_FAILURE, msg);
        return dataResult;
    }

    /**
     * 失败结果,暂无数据
     *
     * @return 结果
     */
    public static DataResult failureNoData() {
        return DATA_FAILURE_NO_DATA;
    }

    /**
     * 失败结果，异常失败
     *
     * @return 结果
     */
    public static DataResult failureError() {
        return DATA_FAILURE_ERROR;
    }
}
