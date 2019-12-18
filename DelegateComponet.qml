import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {
    id: delegateForTour
    property var datas: dataArray.split(",")
    property var imageDatas: imageResource.split(",")
    width: listView.width
    anchors.leftMargin: 10
    height: 100
    //property alias repeater: repeater //设置50的间距
    onDatasChanged: {
        delegateForTour.height = (datas.length) * 30 + 50
    }
    color: "#edecec"
    property int classIndex: index
    MouseArea {
        anchors.fill: parent
        //设置当前目标为 选中项
        propagateComposedEvents: true
        onDoubleClicked: {

        }
        onClicked: {
            listView.currentIndex = index
            console.log("事件没有传递")
            mouse.accepted = true //传递事件

        }
    }

    Column {
        id: column
        spacing: 5
        Flow {
            spacing: listView.width - classItem.width - 25
            leftPadding: 10
            rightPadding: 15
            Text {
                id: classItem
                width: listView.width
                text: name

                font.pointSize: 12
                property bool isEmpty: false
            }
            Button {
                visible: index===2
                width: 15
                antialiasing: true
                height: classItem.height
                    icon.width: width
                    icon.height: height
                icon.source: "qrc:/tour/Iamges/tour/yinle.png"
                property int count: 1
                onClicked: {
                    listView.model.addItem(count++, "创建的歌单")
                }

            }
        }

        DelegateRepater {
            id: repeater
        }

    }
}

