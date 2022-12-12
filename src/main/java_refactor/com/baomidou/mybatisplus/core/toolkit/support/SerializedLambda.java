/*
 * Copyright (c) 2011-2020, baomidou (jobob@qq.com).
 * <p>
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 * <p>
 * https://www.apache.org/licenses/LICENSE-2.0
 * <p>
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */
package com.baomidou.mybatisplus.core.toolkit.support;

import com.baomidou.mybatisplus.core.toolkit.ClassUtils;
import com.baomidou.mybatisplus.core.toolkit.ExceptionUtils;

import java.io.Serializable;
import java.lang.reflect.Method;

/**
 * 这个类是从 {@link java.lang.invoke.SerializedLambda} 里面 copy 过来的，
 * 字段信息完全一样
 * <p>负责将一个支持序列的 Function 序列化为 SerializedLambda</p>
 *
 * @author HCL
 * @since 2018/05/10
 */
public class SerializedLambda implements Serializable {

    private static final long serialVersionUID = 8025925345765570181L;

    private String functionalInterfaceClass;
    private String implClass;
    private String implMethodName;
    private String instantiatedMethodType;

    /**
     * 通过反序列化转换 lambda 表达式，该方法只能序列化 lambda 表达式，不能序列化接口实现或者正常非 lambda 写法的对象
     *
     * @param lambda lambda对象
     * @return 返回解析后的 SerializedLambda
     */
    public static SerializedLambda resolve(SFunction<?, ?> lambda) {
        Class<?> clz = lambda.getClass();
        if (!clz.isSynthetic()) {
            throw ExceptionUtils.mpe("该方法仅能传入 lambda 表达式产生的合成类");
        }
        try {
            //通过函数式接口实例的writeReplace方法获取对应的SerializedLambda实例
            Method write = clz.getDeclaredMethod("writeReplace");
            write.setAccessible(true);
            java.lang.invoke.SerializedLambda serializedLambda = (java.lang.invoke.SerializedLambda) write.invoke(lambda);

            SerializedLambda _this = new SerializedLambda();

            _this.functionalInterfaceClass = serializedLambda.getFunctionalInterfaceClass();
            _this.implClass = serializedLambda.getImplClass();
            _this.implMethodName = serializedLambda.getImplMethodName();
            _this.instantiatedMethodType = serializedLambda.getInstantiatedMethodType();
            return _this;
        } catch (Exception e) {
            throw ExceptionUtils.mpe("This is impossible to happen", e);
        }
    }

    /**
     * 获取接口 class
     *
     * @return 返回 class 名称
     */
    public String getFunctionalInterfaceClassName() {
        return normalizedName(functionalInterfaceClass);
    }

    /**
     * 获取实现的 class
     *
     * @return 实现类
     */
    public Class<?> getImplClass() {
        return ClassUtils.toClassConfident(getImplClassName());
    }

    /**
     * 获取 class 的名称
     *
     * @return 类名
     */
    public String getImplClassName() {
        return normalizedName(implClass);
    }

    /**
     * 获取实现者的方法名称
     *
     * @return 方法名称
     */
    public String getImplMethodName() {
        return implMethodName;
    }

    /**
     * 正常化类名称，将类名称中的 / 替换为 .
     *
     * @param name 名称
     * @return 正常的类名
     */
    private String normalizedName(String name) {
        return name.replace('/', '.');
    }

    /**
     * @return 获取实例化方法的类型
     */
    public Class<?> getInstantiatedType() {
        String instantiatedTypeName = normalizedName(instantiatedMethodType.substring(2, instantiatedMethodType.indexOf(';')));
        return ClassUtils.toClassConfident(instantiatedTypeName);
    }

    /**
     * @return 字符串形式
     */
    @Override
    public String toString() {
        String interfaceName = getFunctionalInterfaceClassName();
        String implName = getImplClassName();
        return String.format("%s -> %s::%s",
                interfaceName.substring(interfaceName.lastIndexOf('.') + 1),
                implName.substring(implName.lastIndexOf('.') + 1),
                implMethodName);
    }

}
