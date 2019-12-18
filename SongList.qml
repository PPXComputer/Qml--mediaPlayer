import QtQuick 2.12
import QtQuick.Controls 1.4 as Q14
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.12

Item {
    id: tabelViewTestItem
    //                width: parent.width
    //                height: parent.height
    Flickable {
        anchors.fill: parent
        anchors.topMargin: 20

        Rectangle {
            id: pageMessage
            height: 250
            anchors.top: parent.top

            anchors.left: parent.left
            anchors.right: parent.right

            Image {
                id: playListImage
                anchors.left: parent.left
                anchors.margins: 10
                anchors.top: parent.top

                cache: false
                source: "qrc:/listImage/otherImage/v2-f7069c486b92523f1a8d86f900872e1b_r.jpg"
                width: 200
                height: 200
                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -5
                    onClicked: {
                        swipeView.currentIndex = 2
                        console.log("go to playing zone ")
                    }
                }
            }

            Rectangle {
                anchors.leftMargin: 25
                anchors.right: parent.right
                anchors.bottom: playListImage.bottom
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.left: playListImage.right

                Column {
                    id: column
                    spacing: 15
                    anchors.fill: parent
                    Rectangle {
                        id: rectangle1
                        width: parent.width
                        height: 35
                        Rectangle {
                            id: rectangle
                            width: 40
                            height: 30
                            color: "#ee0000"
                            Text {

                                text: qsTr("歌单")
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                                font.pixelSize: root.fontSize
                            }
                        }

                        Text {
                            anchors.left: rectangle.right
                            id: songListName
                            font.pixelSize: 20
                            text: qsTr("主歌单")
                            anchors.top: parent.top
                            anchors.topMargin: 0
                        }
                    }
                    Text {
                        id: currentDateText
                        width: parent.width
                        height: 35
                        font.pixelSize: root.fontSize

                             property var locale: Qt.locale()
                             property date currentTime: new Date()
                             property string timeString

                             Component.onCompleted: {
                                 timeString =
                                         currentTime.toLocaleTimeString(locale, Locale.ShortFormat);
                                currentDateText.text=
                                Date.fromLocaleTimeString(locale, timeString, Locale.ShortFormat);
                             }

                    }
                    Row {
                        width: parent.width
                        height: 35
                        spacing: 20

                        Button {
                            id:playAll
                            height: parent.height
                            text: qsTr("播放全部")
                            flat: true
                            background: Rectangle{
                                anchors.fill: parent
                                border.width: 1
                                border.color: "silver"
                                radius: 5
                                MouseArea{
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    propagateComposedEvents: true
                                    onEntered: {
                                        parent.color="silver"
                                    }
                                    onExited: {
                                        parent.color="white"

                                    }
                                }
                            }

                            icon.source: "qrc:/play/Iamges/play/bofang.png"
                            display: AbstractButton.TextBesideIcon
                            onPressed: {
                                mediaPlayer.play()
                            }
                        }

                        Button {

                            height: parent.height
                            text: qsTr("收藏")
                            flat: true

                            icon.source: "qrc:/menu/Iamges/menu/shoucang.png"
                            display: AbstractButton.TextBesideIcon
                            background: Rectangle{
                                anchors.fill: parent
                                border.width: 1
                                border.color: "silver"
                                radius: 5
                                MouseArea{
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    propagateComposedEvents: true
                                    onEntered: {
                                        parent.color="silver"
                                    }
                                    onExited: {
                                        parent.color="white"

                                    }
                                }
                            }
                        }
                        Button {

                            height: parent.height
                            text: qsTr("分享")
                            display: AbstractButton.TextBesideIcon
                            flat: true
                            icon.source: "qrc:/menu/Iamges/menu/fenxiang.png"
                            background: Rectangle{
                                anchors.fill: parent
                                border.width: 1
                                border.color: "silver"
                                radius: 5
                                MouseArea{
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    propagateComposedEvents: true
                                    onEntered: {
                                        parent.color="silver"
                                    }
                                    onExited: {
                                        parent.color="white"

                                    }
                                }
                            }
                        }
                        Button {

                            height: parent.height
                            text: qsTr("下载全部")
                            flat: true
                            icon.source: "qrc:/menu/Iamges/menu/xiazai.png"
                            background: Rectangle{
                                anchors.fill: parent
                                border.width: 1
                                border.color: "silver"
                                radius: 5
                                MouseArea{
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    propagateComposedEvents: true
                                    onEntered: {
                                        parent.color="silver"
                                    }
                                    onExited: {
                                        parent.color="white"

                                    }
                                }
                            }
                        }
                    }
                    Text {
                        id: label
                        text: qsTr("标签")
                    }
                    Text {
                        id: description
                        text: qsTr("简介")
                    }
                }
            }
        }

        Q14.TableView {
            id: tableView
            height: 200
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.top: pageMessage.bottom
            antialiasing: true
            visible: true
            sortIndicatorOrder: Qt.AscendingOrder
            sortIndicatorVisible: true

            property string currentFilePath: ""
            style: TableViewStyle {

                headerDelegate: Rectangle {

                    //设置表头的样式
                    implicitWidth: /*styleData.value===""? 10:*/ tableView.width / 3
                    implicitHeight: fontSize * 2
                    border.width: 1
                    border.color: "gray"
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 0
                        text: styleData.value
                        color: styleData.pressed ? "burlywood" : "darkgray"
                        font.bold: true
                    }
                }

                itemDelegate: Text {
                    text: styleData.value
                    elide: Text.ElideLeft
                    property bool selected: styleData.selected
                    onSelectedChanged: {
                        if (selected
                                && styleData.column === tableView.columnCount - 1) {
                            // 显示的是所有被选中项
                            console.log("当前路径为" + styleData.value.toString())
                            tableView.currentFilePath = styleData.value.toString()
                        }
                    }
                }

                rowDelegate: Rectangle {

                    height: root.fontSize * 2
                    color: styleData.selected ? "burlywood" : "darkgray"
                    property string lastColor: ""
                    //property int row: styleData.row
                    anchors.leftMargin: 2


                    /*              MouseArea {
//                    anchors.fill: parent
//                   acceptedButtons: Qt.NoButton
//                   propagateComposedEvents: false
//                    hoverEnabled: true
//                    onEntered: {
//                        if(parent.row !== tableView.currentRow){
//                        parent.lastColor = parent.color
//                        parent.color = "#deb660"
//                        }else {
//                            parent.lastColor = parent.color
//                            parent.color = "#deb660"
//                        }
//                    }
//                    onExited: {
////                        if (!styleData.selected
////                                && parent.row !== tableView.currentRow) {
////                            parent.color = "darkgray"
////                            console.log("离开时的事件触发 ")
////                        } else {
////                            parent.lastColor = parent.color
////                            parent.color = "#deb660"
////                        }
////                        if(parent.row!==tableView.currentRow)
////                        parent.color="darkgray"
//                    }
////                    onClicked: {
////                        console.log("click")
////                        if (mouse.button === Qt.LeftButton) {
////                            var currentRow = tableView.rowAt(mouseX, mouseY)
////                            if (currentRow !== -1) {
////                                tableView.selection.deselect(
////                                            0, tableView.rowCount - 1)
////                                tableView.selection.select(currentRow)
////                                tableView.currentRow = currentRow
////                            }
////                        }
////                    }
//                }
//            }*/
                }
            }

            MouseArea {
                id: mouseRegion
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.topMargin: 0
                acceptedButtons: Qt.RightButton | Qt.LeftButton // 激活右键（别落下这个）
                drag.filterChildren: true
                propagateComposedEvents: true
                onClicked: {
                    if (mouse.button === Qt.LeftButton) {
                        var currentRow = tableView.rowAt(mouseX, mouseY)
                        if (currentRow !== -1) {
                            tableView.selection.deselect(0,
                                                         tableView.rowCount - 1)
                            tableView.selection.select(currentRow)
                        }
                    }

                    if (mouse.button === Qt.RightButton /* ||mouse.button===Qt.LeftButton*/
                            ) {
                        // 右键菜单
                        currentRow = tableView.rowAt(mouseX, mouseY)
                        if (currentRow !== -1) {
                            tableView.selection.deselect(0,
                                                         tableView.rowCount - 1)
                            tableView.selection.select(currentRow)
                            contentMenu.popup()
                        }
                    }
                }
                onDoubleClicked: {
                    if (mouse.button === Qt.LeftButton) {
                        var currentRow = tableView.rowAt(mouseX, mouseY)
                        if (currentRow !== -1) {
                            console.log("应该播放此歌曲")
                            tableView.selection.deselect(0,
                                                         tableView.rowCount - 1)
                            tableView.selection.select(currentRow)
                            if (playlist.currentItemSource !== tableView.currentFilePath) {
                                playlist.addItem(tableView.currentFilePath)
                                playlist.currentIndex = playlist.itemCount - 1
                                mediaPlayer.play()
                            }
                        }
                    }
                }
            }

            Button {

                anchors.right: parent.right
                anchors.bottom: parent.top
                id: openFile
                text: qsTr("新增文件夹")
                font.pointSize: root.fontSize / 2
                onClicked: {
                    fileDialog.visible = true
                }
            }

            Menu {
                // 右键菜单
                //title: "Edit"
                id: contentMenu
                MenuItem {
                    text: qsTr("查看评论")
                    icon.width: 16
                    icon.height: 16
                    icon.source: "qrc:/menu/Iamges/menu/bianji.png"
                    font.pixelSize: root.fontSize
                    onTriggered: {

                    }
                    background: Rectangle {
                        anchors.fill: parent
                        MouseArea {
                            anchors.fill: parent
                            onEntered: {
                                parent.color = "silver"
                            }
                            onExited: {
                                parent.color = "white"
                            }
                        }
                    }
                }
                MenuItem {
                    text: qsTr("播放")
                    font.pixelSize: root.fontSize
                    icon.width: 16
                    icon.height: 16
                    icon.source: "qrc:/play/Iamges/play/bofang.png"
                    onTriggered: {
                        if (playlist.currentItemSource !== tableView.currentFilePath) {
                            playlist.addItem(tableView.currentFilePath)
                            playlist.currentIndex = playlist.itemCount - 1
                            mediaPlayer.play()
                        }
                    }
                    background: Rectangle {
                        anchors.fill: parent
                        MouseArea {
                            anchors.fill: parent
                            onEntered: {
                                parent.color = "silver"
                            }
                            onExited: {
                                parent.color = "white"
                            }
                        }
                    }
                }

                MenuItem {
                    text: qsTr("下一首播放")
                    icon.source: "qrc:/play/Iamges/play/xiayishou-yuanshijituantubiao.png"
                    icon.width: 16
                    icon.height: 16
                    font.pixelSize: root.fontSize
                    onTriggered: {

                        if (playlist.itemSource(
                                    (playlist.currentIndex + 1)) !== tableView.currentFilePath) {
                            playlist.insertItem(playlist.currentIndex + 1,
                                                tableView.currentFilePath)
                        }
                    }
                    background: Rectangle {
                        anchors.fill: parent
                        MouseArea {
                            anchors.fill: parent
                            onEntered: {
                                parent.color = "silver"
                            }
                            onExited: {
                                parent.color = "white"
                            }
                        }
                    }
                }

                Menu {
                    title: qsTr("收藏到歌单")
                    font.family: root.fontFamily
                    font.pixelSize: root.fontSize
                    Repeater {
                        model: listView.model
                        MenuItem {
                            text: qsTr("收藏到歌单")
                            icon.width: 16
                            icon.height: 16
                            icon.source: "qrc:/menu/Iamges/menu/shoucang.png"
                            font.pixelSize: root.fontSize
                            onTriggered: {

                            }
                            background: Rectangle {
                                anchors.fill: parent
                                MouseArea {
                                    anchors.fill: parent
                                    onEntered: {
                                        parent.color = "silver"
                                    }
                                    onExited: {
                                        parent.color = "white"
                                    }
                                }
                            }
                        }
                    }
                }
                MenuItem {
                    text: qsTr("分享")
                    icon.source: "qrc:/listImage/otherImage/1/fenxiang.png"
                    icon.width: 16
                    icon.height: 16
                    font.pixelSize: root.fontSize
                    onTriggered: {

                    }
                    background: Rectangle {
                        anchors.fill: parent
                        MouseArea {
                            anchors.fill: parent
                            onEntered: {
                                parent.color = "silver"
                            }
                            onExited: {
                                parent.color = "white"
                            }
                        }
                    }
                }
                MenuItem {
                    text: qsTr("复制链接")
                    icon.source: "qrc:/menu/Iamges/menu/fenxiang.png"
                    font.pixelSize: root.fontSize
                    icon.width: 16
                    icon.height: 16
                    onTriggered: {

                    }
                    background: Rectangle {
                        anchors.fill: parent
                        MouseArea {
                            anchors.fill: parent
                            onEntered: {
                                parent.color = "silver"
                            }
                            onExited: {
                                parent.color = "white"
                            }
                        }
                    }
                }

                MenuItem {
                    text: qsTr("下载")
                    icon.source: "qrc:/menu/Iamges/menu/xiazai.png"
                    font.pixelSize: root.fontSize
                    icon.width: 16
                    icon.height: 16
                    onTriggered: {

                    }
                    background: Rectangle {
                        anchors.fill: parent
                        MouseArea {
                            anchors.fill: parent
                            onEntered: {
                                parent.color = "silver"
                            }
                            onExited: {
                                parent.color = "white"
                            }
                        }
                    }
                }

                MenuItem {
                    text: qsTr("从歌单中删除")
                    icon.source: "qrc:/menu/Iamges/menu/shanchu.png"
                    font.pixelSize: root.fontSize
                    icon.width: 16
                    icon.height: 16
                    onTriggered: {
                        mySql.removeMusic(tableView.currentFilePath)
                    }
                    background: Rectangle {
                        anchors.fill: parent
                        MouseArea {
                            anchors.fill: parent
                            onEntered: {
                                parent.color = "silver"
                            }
                            onExited: {
                                parent.color = "white"
                            }
                        }
                    }
                }
            }


            /*      function changed(index) {
    console.log("当前点击的路径为")
}

//        Connections {
//            target: tableView
//            onCurrentIndexChanged: {
//                console.log(tableView.currentIndex + " is clicked!" + tableView.currentTab)
//                changed(tableView.currentIndex)
//            }
//        }*/
            model: myModel
            Component.onCompleted: {
                console.log("现在数据有多少行" + myModel.rowCount())
            }

            Q14.TableViewColumn {
                role: ""
                title: "  "
            }

            Q14.TableViewColumn {
                role: "id"
                title: ""
            }
            Q14.TableViewColumn {
                role: "musicName"
                title: "名字"
            }
            Q14.TableViewColumn {
                role: "artist"
                title: "作者"
            }
            Q14.TableViewColumn {
                role: "album"
                title: "专辑"
            }
            Q14.TableViewColumn {
                role: "duration"
                title: "时长"
            }
            Q14.TableViewColumn {
                visible: false
                role: "filePath"
                title: ""
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

