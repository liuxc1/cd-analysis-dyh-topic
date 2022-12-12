const userInfo = [
    {
        userId: '1342',
        userName: '张蕾',
    },
    {
        userId: '1343',
        userName: '陈曦',
    },
    {
        userId: '1340',
        userName: '张恬月',
    },
    {
        userId: '1341',
        userName: '王源程',
    },
    {
        userId: '1726',
        userName: '叶智',
    },
    {
        userId: '2022',
        userName: '杨欣悦',
    },
    {
        userId: '2023',
        userName: '许云凡',
    },
];

function assembleData(forecastTime, dataList, userName) {
    let tableData = [];
    tableData.push({
        "id": "1",
        "name": userName,
    });
    //预报时间
    let forecastDateList = [];
    //O3 PM25
    let O3List = [];
    let PM25List = [];
    let otherList = [];
    //计算数据
    let calcData = {
        "msg": "success",
        "code": 0,
        "affirm": [],
        "PM25List": [],
        "O3List": [],
        "otherList": []
    }
    //污染等级
    let polluteLevel = [];
    for (let i = 0; i < dataList.length; i++) {
        let data = dataList[i];
        let resultTime = data['RESULT_TIME'].split(" ")[0]
        forecastDateList.push(resultTime.split("-")[1] + '月' + resultTime.split("-")[2] + '日');
        O3List.push({
            "type": 'O3',
            "IAQI": data['O3_IAQI'],
            "IAQI_dr": data['O3_MIN_IAQI'] + '~' + data['O3_MAX_IAQI'],
            "con": data['O3_MEDIAN'],
            "con_dr": data['O3'],
            "day": i + 1,
            "err": false
        });
        PM25List.push({
            "type": 'PM25',
            "IAQI": data['PM25_IAQI'],
            "IAQI_dr": data['PM25_MIN_IAQI'] + '~' + data['PM25_MAX_IAQI'],
            "con": data['PM25_MEDIAN'],
            "con_dr": data['PM25'],
            "day": i + 1,
            "err": false
        });
        //otherList 首要污染源非O3\PM25
        if (data['PRIM_POLLUTE'] && (data['PRIM_POLLUTE'] !== 'O3' || data['PRIM_POLLUTE'] !== 'PM2.5')) {
            otherList.push({
                "type": data['PRIM_POLLUTE'].replace(".",""),
                "IAQI": data['AQI_MEDIAN'],
                "IAQI_dr": data['AQI'],
                "con": "",
                "con_dr": "",
                "day": i + 1,
                "isShow": true,
                "err": false,
                "isGood": false,
                "correct": "y",
                "blank": false
            })
        } else {
            otherList.push({
                "type": "",
                "IAQI": "",
                "IAQI_dr": "",
                "con": "",
                "con_dr": "",
                "day": i + 1,
                "isShow": true,
                "err": false,
                "isGood": false,
                "correct": "y",
                "blank": false
            })
        }
        //calcData
        calcData.affirm.push({
            "O3": data['O3_IAQI'],
            "PM25": data['PM25_IAQI'],
            "grade": data['AQI_LEVEL'],
            "AQI": data['AQI'],
            "day": i + 1,
            "primary": data['PRIM_POLLUTE'].replace(".",""),
        })
        calcData.PM25List.push({
            "IAQI": data['PM25_IAQI'],
            "con": data['PM25_MEDIAN'],
            "IAQI_dr": data['PM25_MIN_IAQI'] + '~' + data['PM25_MAX_IAQI'],
            "con_dr": data['PM25'],
            "err": false,
            "grade": getAqiLevel(data['PM25_IAQI']),
            "type": "PM25",
            "day": i + 1
        });
        calcData.O3List.push({
            "IAQI": data['O3_IAQI'],
            "con": data['O3_MEDIAN'],
            "IAQI_dr": data['O3_MIN_IAQI'] + '~' + data['O3_MAX_IAQI'],
            "con_dr": data['O3'],
            "err": false,
            "grade": getAqiLevel(data['O3_IAQI']),
            "type": "O3",
            "day": i + 1
        });
        //otherList 首要污染源非O3\PM25
        if (data['PRIM_POLLUTE'] && (data['PRIM_POLLUTE'] !== 'O3' || data['PRIM_POLLUTE'] !== 'PM2.5')) {
            calcData.otherList.push({
                "type": data['PRIM_POLLUTE'].replace(".",""),
                "IAQI": data['AQI_MEDIAN'],
                "IAQI_dr": data['AQI'],
                "con": "",
                "blank": false,
                "con_dr": "",
                "err": false,
                "isGood": false,
                "correct": "y",
                "day": i + 1,
                "isShow": true
            });
        } else {
            calcData.otherList.push({
                "type": "",
                "IAQI": "",
                "IAQI_dr": "",
                "con": "",
                "blank": false,
                "con_dr": "",
                "err": false,
                "isGood": false,
                "correct": "y",
                "day": i + 1,
                "isShow": true
            });
        }
        //污染等级
        polluteLevel.push({
            "O3": getAqiLevel(data['O3_IAQI']),
            "PM25": getAqiLevel(data['PM25_IAQI']),
            "day": i + 1
        })
    }
    tableData.push({
        'id': '2',
        'day': forecastDateList
    });
    tableData.push({
            "id": '3',
            "resultDate": '—',
            "PM25Con": ['—', '—', '—', '—', '—', '—', '—'],
            "pollution": ['—', '—', '—', '—', '—', '—', '—'],
            "AQI": ['—', '—', '—', '—', '—', '—', '—']
        },
        {
            "id": '4',
            "resultDate": '—',
            "PM25Con": ['—', '—', '—', '—', '—', '—', '—'],
            "pollution": ['—', '—', '—', '—', '—', '—', '—'],
            "AQI": ['—', '—', '—', '—', '—', '—', '—']
        });
    const plusMinusInterval = [
        ['15', ['0', '50'], '0'],
        ['15', ['51', '100'], '0'],
        ['15', ['101', '150'], '0'],
        ['15', ['151', '200'], '0'],
        ['15', ['201', '300'], '0'],
        ['15', ['301', '999999999'], '0'],
    ];
    const param = {
        tableData: tableData,
        O3List: O3List,
        PM25List: PM25List,
        otherList: otherList,
        calcData: calcData,
        polluteLevel: polluteLevel,
        dayLen: 7,
        plusMinusInterval: plusMinusInterval,
        isCMAQ: false,
        isOPAQ: false,
        note: "",
    };
    let paramMap = handleData(param);
    paramMap.timepoint = forecastTime;
    paramMap.cityCode = '510100';
    paramMap.countryId = 0;
    return paramMap;
}

/**
 * 根据中值计算空气级别
 */
function getAqiLevel(numMedian) {
    const before = getLevel((numMedian - 15) < 0 ? 0 : (numMedian - 15));
    const after = getLevel(numMedian + 15);
    let result;
    if (before == after) {
        result = before;
    } else {
        if (before == "优") {
            result = before + "至" + after;
        } else if (before == "良") {
            result = before + "至" + after;
        } else {
            result = before.substring(0, 2) + "至" + after;
        }
    }
    return result
}

/**
 * 根据中值计算空气级别
 */
function getLevel(value) {
    let result;
    if (0 <= value && value <= 50) {
        result = "优";
    } else if (50 < value && value <= 100) {
        result = "良";
    } else if (100 < value && value <= 150) {
        result = "轻度污染";
    } else if (150 < value && value <= 200) {
        result = "中度污染";
    } else if (200 < value && value <= 300) {
        result = "重度污染";
    } else if (300 < value) {
        result = "严重污染";
    } else {
        result = "无";
    }
    return result
}


function handleData(param) {
    const {
        tableData,
        O3List,
        PM25List,
        otherList,
        calcData,
        polluteLevel,
        dayLen,
        plusMinusInterval,
        isCMAQ,
        isOPAQ,
        note
    } = param

    let PM25 = ''
    let PM25_dr = ''
    let IPM25 = ''
    let IPM25_dr = ''
    let O3 = ''
    let O3_dr = ''
    let IO3 = ''
    let IO3_dr = ''
    let AQI = ''
    let AQI_dr = ''
    let primary = ''  //首要污染物
    let grade = ''  //污染等级

    for (let i = 0; i < O3List.length; i++) {
        PM25 += PM25List[i].con + '|'
        PM25_dr += PM25List[i].con_dr + '|'
        IPM25 += PM25List[i].IAQI + '|'
        IPM25_dr += PM25List[i].IAQI_dr + '|'
        O3 += O3List[i].con + '|'
        O3_dr += O3List[i].con_dr + '|'
        IO3 += O3List[i].IAQI + '|'
        IO3_dr += O3List[i].IAQI_dr + '|'
        if (otherList[i].IAQI) {
            AQI += otherList[i].IAQI + '|'
        } else {
            const max = calcData.affirm[i].O3 >= calcData.affirm[i].PM25 ? calcData.affirm[i].O3 : calcData.affirm[i].PM25
            AQI += max + '|'
        }
        AQI_dr += calcData.affirm[i].AQI + '|'
        primary += calcData.affirm[i].primary + '|'
        grade += calcData.affirm[i].grade + '|'
    }
    const newPM25 = PM25.substr(0, PM25.length - 1) //PM25浓度
    const newPM25_dr = PM25_dr.substr(0, PM25_dr.length - 1) //PM25浓度区间
    const newIPM25 = IPM25.substr(0, IPM25.length - 1) //PM25AIQI值
    const newIPM25_dr = IPM25_dr.substr(0, IPM25_dr.length - 1) //PM25AIQI区间范围
    const newO3 = O3.substr(0, O3.length - 1) //O3浓度
    const newO3_dr = O3_dr.substr(0, O3_dr.length - 1) //O3浓度区间
    const newIO3 = IO3.substr(0, IO3.length - 1) //O3AIQI值
    const newIO3_dr = IO3_dr.substr(0, IO3_dr.length - 1) //O3AIQI区间范围
    const newAQI = AQI.substr(0, AQI.length - 1) //AQI中值
    const newAQI_dr = AQI_dr.substr(0, AQI_dr.length - 1) //AQI中值区间范围
    const newPrimary = primary.substr(0, primary.length - 1) //首要污染物
    const newGrade = grade.substr(0, grade.length - 1) //污染等级
    const username = tableData[0].name //播报员
    const returnArr = processingData(O3List, PM25List, otherList, calcData, polluteLevel, note)
    tableData.length = 4
    const tableJson = {
        tableData: [
            ...tableData,
            ...returnArr
        ],
        dayLen,
        plusMinusInterval,
        isCMAQ,
        isOPAQ,
        O3List, PM25List, otherList, result: calcData, polluteLevel
    }
    const obj = {
        username: username,//播报员
        PM25: newPM25,//PM25浓度
        PM25_dr: newPM25_dr,//PM25浓度区间
        IPM25: newIPM25,//PM25AIQI值
        IPM25_dr: newIPM25_dr,//PM25AIQI区间范围
        O3: newO3,//O3浓度
        O3_dr: newO3_dr,//O3浓度区间
        IO3: newIO3,//O3AIQI值
        IO3_dr: newIO3_dr,//O3AIQI区间范围
        AQI: newAQI,//AQI中值
        AQI_dr: newAQI_dr,//AQI中值区间范围
        PrimaryPollutant: newPrimary,//首要污染物
        GradeDescription: newGrade,//污染等级
        note,//备注信息
        tableJson: JSON.stringify(tableJson)
    }
    return obj
}

/** @name 将数据处理成需要的JSON格式 */
function processingData(O3List, PM25List, otherList, calcData, polluteLevel, note) {
    const fixed = {
        id: 5,
        CMAQ: false,
        OPAQ: false,
        isCMOP: ["", "", "", "", "", "", ""]
    }
    //PM25数据
    const PM25Data = handlePm25_O3List(PM25List)
    const PM25Con = {
        id: 6,
        PM25ConVal: PM25Data.ConVal,
        PM25ConInterval: PM25Data.ConInterval
    }
    const PM25IAQI = {
        id: 7,
        IAQIValue: PM25Data.AQI,
        IAQIInterval: PM25Data.AQIInterval
    }

    //O3数据
    const O3Data = handlePm25_O3List(O3List)
    const O3Con = {
        id: 16,
        O3ConVal: O3Data.ConVal,
        O3ConInterval: O3Data.O3ConInterval
    }
    const O3IAQI = {
        id: 17,
        IAQIValue: O3Data.AQI,
        IAQIInterval: O3Data.AQIInterval
    }
    //空气质量等级
    const PM25Level = []
    const O3Level = []

    polluteLevel.forEach(item => {
        PM25Level.push(item.PM25)
        O3Level.push(item.O3)
    })
    const PM25LevelObj = {
        id: 8,
        airQuality: PM25Level
    }
    const O3LevelObj = {
        id: 18,
        airQuality: O3Level
    }
    //首要污染物
    const pollution = []
    otherList.forEach(item => {
        item.type = item.type == '' ? "PM25" : item.type
        pollution.push(item.type)
    })
    const pollutionObj = {
        id: 9,
        pollution
    }
    //非PM2.5或O3为首要污染物
    const AQIValue = []
    const AQICInterval = []
    otherList.forEach(item => {
        AQIValue.push(item.IAQI)
        if (item.IAQI_dr) {
            AQICInterval.push(item.IAQI_dr.split('~'))
        } else {
            AQICInterval.push(["", ""])
        }
    })
    const otherObj = {
        id: 10,
        AQIValue,
        AQICInterval
    }
    // 计算后的数据
    const confirmAQIInterval = []
    const confirmPM25 = []
    const confirmO3 = []
    const confirmLevel = []
    const confirmMain = []
    calcData.affirm.forEach(item => {
        confirmAQIInterval.push(item.AQI.split('~'))
        confirmPM25.push(item.PM25)
        confirmO3.push(item.O3)
        confirmLevel.push(item.grade)
        confirmMain.push(item.primary)
    })
    //AQI
    const confirmAQI = {
        id: 11,
        AQIInterval: confirmAQIInterval
    }
    //PM25
    const confirmPM25AQI = {
        id: 12,
        PM25ConVal: confirmPM25
    }
    //O3
    const confirmPMO3AQI = {
        id: 19,
        O3ConVal: confirmO3
    }
    //等级
    const confirmLevelObj = {
        id: 13,
        pollutionRank: confirmLevel
    }
    //首污
    const confirmMainObj = {
        id: 14,
        pollution: confirmMain
    }
    //备注
    const remarksObj = {
        id: 15,
        remarks: note
    }
    const tableJSONData = [fixed, PM25Con, PM25IAQI, O3Con, O3IAQI,
        PM25LevelObj, O3LevelObj, pollutionObj, otherObj,
        confirmAQI, confirmPM25AQI, confirmPMO3AQI,
        confirmLevelObj, confirmMainObj, remarksObj
    ]
    return tableJSONData
}

/** @name 处理PM25,O3污染物数据格式 */
function handlePm25_O3List(list) {
    const ConVal = []
    const ConInterval = []
    const AQI = []
    const AQIInterval = []
    list.forEach(item => {
        ConVal.push(item.con)
        AQI.push(item.IAQI)
        ConInterval.push(item.con_dr.split('~'))
        AQIInterval.push(item.IAQI_dr.split('~'))
    })
    return {
        ConVal, ConInterval, AQI, AQIInterval
    }
}




