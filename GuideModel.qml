import QtQuick 2.0

ListModel {

    id: guideModel
    property var mapItem: ["推荐","我的音乐","创建的歌单","收藏的歌单"]
    signal mistake(var str)
    //将在 列表中发生改变的时候 进行变化
    signal listChanged(var str ,var isIncrease)
    //输入一个字符串 获得类索引
    function contain(className) {
        var classIndex = guideModel.mapItem.indexOf(className)
        console.log("classIndex:"+classIndex)
        if (classIndex !== -1)
            return {
                "flag": true,
                "index": classIndex
            }
        else
            return {
                "flag": false,
                "index": classIndex
            }
    }
    //添加 一个项 添加的名字 类别的名字
    function addItem(elementName, className) {
        var result = guideModel.contain(className)
        if (result.flag) {
            addData(guideModel.get(result.index).dataArray, elementName)
            var data=guideModel.get(result.index).dataArray
           // console.log("wtf3"+data.toString())
            console.log("添加成功")
        }
        else{
            console.log("failure to add data")
        }
    }
    function deleteItem(elementName, itemName) {
        var result = guideModel.contain(itemName)
        if (result.flag) {
            guideModel.deleteData(elementName,result.index)
        }
    }
    function addData(array, itemName) {
        //添加后去重
        console.log(array.toString()+"+ "+itemName)
        var res = []
        var list = array.split(",")
        //console.log("被拆分为"+list.toString()+list.indexOf(itemName))

        if (list.length === 0) {
            array += itemName
        }

        else if (list.indexOf(itemName) === -1) {

            list.splice(list.length, 0, itemName) //添加
            //console.log("list被重新设置"+list.toString())
            array = list.join(",") //重新设置
            //console.log("被重新设置后array的数据"+array.toString())
            guideModel.get(2).dataArray=array
            console.log("当前的属性为"+guideModel.get(1).dataArray)
            var sd=list.join(",")
            listChanged(itemName,true) //触发信号
            //console.log("wtf"+sd.toString())
            //console.log("wtf2"+array.toString())
            } else {
            emit: mistake("添加的数据重复了 请重新命名")
        }
    }
    function deleteData(elementName, classIndex) {
        var listElement = guideModel.get(classIndex)
        var array = listElement.dataArray
        var res = []

        res = array.split(",")
        var itemIndex = res.indexOf(elementName)
        if (itemIndex !== -1) {
            res.splice(itemIndex, 1)
            listElement.dataArray = res.join(",")
            listChanged(elementName,false)
        }
    }
    // 折叠 点击  点击选
    ListElement {
        dataArray: "发现音乐,私人FM,MV,朋友"
        imageResource: "qrc:/tour/Iamges/tour/yinle.png,qrc:/tour/Iamges/tour/diantai.png,qrc:/tour/Iamges/tour/MV.png,qrc:/tour/Iamges/tour/dilanxianxingiconyihuifu_huabanfuben.png"
        name: "推荐"
    }

    ListElement {
        dataArray: "本地音乐,下载管理,我的音乐云盘,我的歌手,我的电台"
        imageResource: "qrc:/tour/Iamges/tour/yinle_1.png,qrc:/tour/Iamges/tour/xiazai.png,qrc:/tour/Iamges/tour/yunyunpan.png,qrc:/tour/Iamges/tour/geshou.png,qrc:/tour/Iamges/tour/diantai.png" //默认图片为空
        name: "我的音乐"
    }

    ListElement {
        dataArray: "我喜欢的音乐"
        imageResource: "qrc:/tour/Iamges/tour/aixin.png" //默认图片为空
        name: "创建的歌单"
    }

    ListElement {
        dataArray: "默认歌单,新建歌单1,新建歌单2,新建歌单3,新建歌单4"
        imageResource: "qrc:/tour/Iamges/tour/vipsirenzhuanxiangdingzhiyewukehu.png"
        name: "收藏的歌单"
    }
}
