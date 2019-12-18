import QtQuick 2.12

Repeater {
    id: repeater

    // 当前选择的目标 列表的坐标 相当于 对应什么类别
    property int currentIndex: delegateForTour.classIndex
    property int currentItemIndex: 0
    model: datas
    onVisibleChanged: {
//        var flag = false
//        for (var i = 1; i < parent.children.length - 1; ++i) {
//            console.log("onClicked..i=", i)
//            flag = parent.children[i].visible
//            parent.children[i].visible = !parent.children[i].visible
//        }
//        console.log("onClicked..flag = ", flag)
    }

    Rectangle {
        id: itemForDataArray
        // 返回 所给索引的项
        width: classItem.width
        height: classItem.height
        // 当前 repater的坐标 对应某一项
        property int itemIndex: index
        property int classIndex: repeater.currentIndex
        property bool isSelected: false
        color: isSelected?"silver":"#edecec"
        MouseArea {
            anchors.fill: parent

            //                    propagateComposedEvents: true // 将当前事件传递给 父节点
            function getItem(classINdex, itemIndex) {
                var rep = listView.itemAtIndex(
                            classINdex).children[1].children[itemIndex + 1]
                //console.log("找到的是" + rep.toString() + '\n')
                return rep
            }

            onClicked: {
                if (listView.lastClassIndex !== -1) {
                    var sd = getItem(listView.lastClassIndex,
                                     listView.lastItemIndex)

                    sd.isSelected=false
                    // console.log("之前项 设置成白色 " + sd.classIndex + " "
                    //   + sd.itemIndex + sd.toString() + '\n')
                }
                // console.log("之前的索引为" + listView.lastClassIndex + "  "
                // + listView.lastItemIndex)
                listView.currentIndex = parent.classIndex
                listView.lastClassIndex = parent.classIndex
                listView.lastItemIndex = parent.itemIndex
                var ref = getItem(parent.classIndex, parent.itemIndex)
                ref.isSelected=true

                console.log("现在点击的索引为" + parent.classIndex + " " + parent.itemIndex)
                //console.log("设置完成" + ref.classIndex )
                mouse.accpected = false // 传递事件
            }
            hoverEnabled: true
            onEntered: {
                itemText.font.pixelSize = 13
                itemText.font.bold=true
            }
            onExited: {
                itemText.font.pixelSize = 12
                itemText.font.bold=false
            }
        }


        // 自定义的数据
        Rectangle
        {
            visible: true
            width: 3
        height:classItem.height
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        color:parent.isSelected? "red":"#edecec"
    }
        Flow {
            spacing: 5
            anchors {
                verticalCenter: parent.verticalCenter

            }
            leftPadding: 20


            Image {
                id: icon
                width: 16
                height: 16
                source: index<=imageDatas.length-1? imageDatas[index]:
                 "qrc:/tour/Iamges/tour/vipsirenzhuanxiangdingzhiyewukehu.png"
            }
            TextInput {
                id: itemText
                enabled: itemForDataArray.isSelected
                font.family: root.fontFamily
                font.pixelSize: 12
                text: qsTr(datas[index]) 
                onTextEdited: {
                    itemForDataArray.color="silver"
                }onEditingFinished: {
                    itemForDataArray.color="#edecec"
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
