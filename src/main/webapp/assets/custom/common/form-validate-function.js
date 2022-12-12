//输入框不允许特殊字符
function cuFilteringSpecialCharacters(obj, rules, i, options) {
    var value = obj.val();
    if (value) {
        var patt1 = new RegExp('([<>\'"])');
        if (patt1.test(value)) {
            rules.push('required');
            return '不允许输入<>\'"等特殊字符';
        }
    }
    return true;
}

//分析平台文件名称不允许特殊字符
function fileNameValidation(obj, rules, i, options) {
    var value = obj.val();
    if (value) {
        var patt1 = new RegExp('([<>\'":*?|\\/])');
        if (patt1.test(value)) {
            rules.push('required');
            return '不允许输入<>\'":*?|\\/等特殊字符';
        }
    }
    return true;
}

// 经度校验
function checkLongitude(obj, rules, i, options) {
    var value = obj.val();
    if (value) {
        if (!(/^([-+])?(((\d|[1-9]\d|1[0-7]\d|0{1,3})\.\d{0,6})|(\d|[1-9]\d|1[0-7]\d|0{1,3})|180\.0{0,6}|180)$/.test(value))) {
            return '整数部分为0-180,小数部分为0到6位';
        }
    }
    return true;
}

// 纬度校验
function checkLatitude(obj, rules, i, options) {
    var value = obj.val();
    if (value) {
        if (!(/^([-+])?([0-8]?\d{1}\.\d{0,6}|90\.0{0,6}|[0-8]?\d{1}|90)$/.test(value))) {
            return '纬度整数部分为0-90,小数部分为0到6位';
        }
    }
    return true;
}