package ths.project.common.vo;

import ths.project.common.data.DataResult;

/**
 * 响应结果封装对象
 */
// @Deprecated
public class ResponseVo {
    /**
     * 数据结果封装对象
     */
    private DataResult dataResult;

    /**
     * 基本信息（兼容旧版）
     **/
    private final Meta meta = new Meta();

    public ResponseVo() {
        dataResult = DataResult.success();
    }

    public int getCode() {
        return this.dataResult.getCode();
    }

    public String getMessage() {
        return this.dataResult.getMessage();
    }

    public String[] getErrors() {
        return this.dataResult.getErrors();
    }

    public boolean isSuccess() {
        return this.dataResult.isSuccess();
    }

    public Meta getMeta() {
        return meta;
    }

    public Object getData() {
        return this.dataResult.getData();
    }

    public void setData(Object data) {
        this.dataResult.setData(data);
    }

    /**
     * 复制结果对象
     *
     * @param dataResult 结果
     */
    private ResponseVo resolve(DataResult dataResult) {
        this.dataResult = dataResult;
        return this;
    }

    /**
     * 成功返回
     *
     * @return 自己
     */
    public ResponseVo success() {
        return this.resolve(DataResult.success());
    }

    /**
     * 成功返回
     *
     * @param data 返回数据
     * @return 自己
     */
    public ResponseVo success(Object data) {
        return this.resolve(DataResult.success(data));
    }

    /**
     * 失败返回
     *
     * @return 自己
     */
    public ResponseVo failure() {
        return this.resolve(DataResult.failure());
    }

    /**
     * 失败返回
     *
     * @param message 失败信息
     * @return 自己
     */
    public ResponseVo failure(String message) {
        return this.resolve(DataResult.failure(message));
    }

    /**
     * 失败返回,多个错误
     *
     * @param errors 失败信息
     * @return 自己
     */
    public ResponseVo failure(String[] errors) {
        return this.resolve(DataResult.failure(errors));
    }

    /**
     * 失败返回，响应缺失的参数
     *
     * @return 自己
     */
    public ResponseVo failureNotEmpty(String... nullFields) {
        return this.resolve(DataResult.failureNotEmpty(nullFields));
    }

    /**
     * 失败返回,暂无数据
     *
     * @return 自己
     */
    public ResponseVo failureNoData() {
        return this.resolve(DataResult.failureNoData());
    }

    /**
     * 失败返回,异常
     *
     * @return 自己
     */
    public ResponseVo failureError() {
        return this.resolve(DataResult.failureError());
    }

    /**
     * 内部类，作为基础信息(兼容旧版)
     */
    private class Meta {

        public String[] getErrorList() {
            return ResponseVo.this.getErrors();
        }

        public boolean isSuccess() {
            return ResponseVo.this.isSuccess();
        }

        public String getMessage() {
            return ResponseVo.this.getMessage();
        }
    }
}