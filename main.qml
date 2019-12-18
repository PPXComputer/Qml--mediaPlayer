import QtQuick 2.13
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.2
import QtMultimedia 5.13
import MyPackge 1.0
import QtQuick.Controls 1.4 as Q14
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.13

Window {
    id: root
    visible: true
    minimumWidth: 1100
    minimumHeight: 650
    height: 650
    title: qsTr("Hello World")
    // 应该是 一个列表视图中包含 一个 list项
    // 应该有一部的配置表信息
    property int fontSize: 12 //默认字体大小为12
    property var fontFamily: "SimSun"
    width: 1100
    onWidthChanged: {
        console.log("width :" + width)
    }
    onHeightChanged: {

        console.log("Height :" + height)
    }

    FileDialog {
        id: fileDialog
        title: qsTr("选择音乐文件")
        folder: shortcuts.home
        onAccepted: {
            console.log("You chose: " + fileDialog.fileUrl.toString())

            mySql.getMusicFile(fileDialog.fileUrl)
            //Qt.quit()
        }
        onRejected: {
            console.log("Canceled")
            //Qt.quit()
        }

        // FolderDialog.ShowDirsOnly
        nameFilters: ["Music files (*.mp3 *.wav)"]
    }
    MyModel {
        id: myModel

        Component.onCompleted: {
            setTableName("musicResource")
            console.log("数据库模型连接")
        }
    }
    MySql {
        id: mySql
        Component.onCompleted: {
            console.log("数据对象创建完毕")
        }
        onSomethingChanged: {
            myModel.submitAll()
        }
    }

    ListView {
        id: listView
        visible: true
        anchors.bottom: progressRow.top
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        // 默认将第一个作为 目标
        currentIndex: -1
        focus: true
        boundsBehavior: Flickable.StopAtBounds
        property real lastClassIndex: -1
        property real lastItemIndex: 0
        //property var myComponet:delegate
        width: parent.width / 6
        delegate: DelegateComponet {
            id: myComponet
        }
        // model是数据
        model: GuideModel {
            id: guideModel
        }
        ScrollBar.vertical: ScrollBar {
            width: 10
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 0
        }
        states: State {
            name: "right"
            PropertyChanges {
                target: listView
                width: 0
                visible: false
            }
        }
        transitions: Transition {
            NumberAnimation {
                properties: "width"
                easing.type: Easing.Linear
                easing.bezierCurve: []
                duration: 300
            }
            //ColorAnimation { properties: "color"; easing.type: type; easing.bezierCurve: getBezierCurve(name); duration: 1000 }
            PropertyAnimation {
                properties: "visable"
                duration: 300
            }
        }
        //用于展开 列表按键
    }
    Rectangle {
        id: coveImageRectangle
        width: listView.width
        height: listView.height / 6
        border.color: "#9d9696"
        border.width: 1
        property bool isFlod: false
        property bool isPlaying: false
        anchors.right: listView.right
        anchors.rightMargin: 0
        anchors.left: root.left
        anchors.leftMargin: 0
        anchors.bottom: progressRow.top
        anchors.bottomMargin: 0

        visible: !isFlod && isPlaying
        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: false
            onClicked: {
                swipeView.currentIndex = 1
            }
        }

        Image {
            id: coveImage
            width: 100
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            anchors.left: parent.left
            anchors.leftMargin: 5
            transformOrigin: Item.Center
            antialiasing: true
            cache: false
            fillMode: Image.PreserveAspectFit
            source: "qrc:/listImage/otherImage/1/guangdie.png"
        }

        Connections {
            target: CodeImg

            onImageResourceChanged: {
                coveImage.source = ""
                coveImage.source = CoveImageSource
                coveImage.visible = true
                console.log("更换图片")
            }
            onGetInformation: {
                // 插入数据 将信息读取成功后
                console.log("插入数据 将信息读取成功后")
                mySql.insertMusic(musicName, author, album, duration, filePath)
                textForMusicName.text = musicName
                textForMusicArtist.text = author
            }
        }

        Connections {
            target: mediaPlayer
            onPlaybackStateChanged: {
                if (mediaPlayer.playbackRate === MediaPlayer.StoppedState) {
                    coveImageRectangle.isPlaying = false
                } else {
                    coveImageRectangle.isPlaying = true
                }
            }
        }

        Connections {
            target: listView
            onStateChanged: {
                if (listView.state === '') {
                    coveImageRectangle.isFlod = false
                } else {
                    coveImageRectangle.isFlod = true
                }
            }
        }

        Text {
            id: textForMusicName
            text: qsTr("Text")
            clip: true
            anchors.bottom: textForMusicArtist.top
            anchors.bottomMargin: 15
            anchors.right: parent.right

            anchors.left: coveImage.right
            anchors.leftMargin: 0
            font.pixelSize: root.fontSize + 2
        }

        Text {
            id: textForMusicArtist
            text: qsTr("Text")
            clip: true
            anchors.verticalCenterOffset: 15
            anchors.left: coveImage.right
            anchors.right: parent.right
            anchors.leftMargin: 5
            anchors.verticalCenter: coveImage.verticalCenter
            font.pixelSize: root.fontSize
        }
    }

    Rectangle {
        id: flodRectangle
        anchors.left: listView.right
        anchors.verticalCenter: listView.verticalCenter
         radius: 5
         width: 32
         height:32
        Image{
            id:flod
       width: 32
       height:32
        source:"qrc:/listImage/otherImage/1/xiangzuo.png"
        }
        z: 10

        anchors.margins: 5
        opacity: 0.2
        MouseArea{
            anchors.fill: parent
            anchors.margins: -5
            hoverEnabled: true
        onClicked: {
            if (listView.state === ''){
                listView.state = "right"
         flod.source ="qrc:/listImage/otherImage/1/xiangyou.png"}
            else {
                listView.state = ''
               flod.source = "qrc:/listImage/otherImage/1/xiangzuo.png"

            }
        }
        onEntered: {

                flodRectangle.opacity=1
               flodRectangle.color="silver"



        }

        onExited: {
            flodRectangle.opacity=0.2
            flodRectangle.color="white"
        }
        }

    }

    SwipeView {
        id: swipeView
        anchors.rightMargin: 0
        anchors.topMargin: 0
        anchors.top: parent.top
        anchors.left: listView.right
        anchors.right: parent.right
        anchors.bottom: progressRow.top
//        currentIndex:0

        Component.onCompleted: {
            console.log("当前生成的 主界面的大小为 width :" + width + " height :" + height)
            console.log("坐标为  x: " + x + " y : " + y)

            contentItem.highlightMoveDuration = 0
        }
        Repeater {
            model: 1
            MainPage {
                width: swipeView.width
                height: swipeView.height
                id: firstMainPage
                visible: 0 === swipeView.currentIndex ? true : false
            }
        }
        SongList {
            width: swipeView.width
            height: swipeView.height
            id: songList
            visible: 1 === swipeView.currentIndex ? true : false
        }
        PlayZone {
            width: swipeView.width
            height: swipeView.height
            id: playZone
            visible: 2 === swipeView.currentIndex ? true : false
        }

        //        Item {
        //            id: tabelViewTestItem
        //            //                width: parent.width
        //            //                height: parent.height
        //            Rectangle {
        //                id: pageMessage
        //                width: parent.width
        //                height: 50
        //                Image {
        //                    id: playListImage
        //                    anchors.left: parent.left
        //                    anchors.margins: 10
        //                    anchors.top: parent.top
        //                    anchors.bottom: parent.bottom
        //                    cache: false
        //                    source: CoveImageSource

        //                    MouseArea {
        //                        anchors.fill: parent
        //                        anchors.margins: -5
        //                        onClicked: {
        //                            swipeView.currentIndex = 2
        //                            console.log("go to playing zone ")
        //                        }
        //                    }
        //                }
        //                Connections {
        //                    target: CodeImg
        //                    onImageResourceChanged: {
        //                        coveImage.source = ""
        //                        coveImage.source = CoveImageSource
        //                        console.log("更换图片")
        //                        playListImage.source = ""
        //                        playListImage.source = CoveImageSource
        //                    }
        //                }
        //            }

        //            Q14.TableView {
        //                id: tableView
        //                height: 200
        //                anchors.left: parent.left
        //                anchors.bottom: parent.bottom
        //                anchors.right: parent.right
        //                anchors.top: pageMessage.bottom
        //                antialiasing: true
        //                //        anchors.left: listView.right
        //                //        anchors.leftMargin: 0
        //                //        anchors.verticalCenter: parent.verticalCenter
        //                //        anchors.bottom: progressRow.top
        //                //        anchors.bottomMargin: 0
        //                //        anchors.right: parent.right
        //                //        anchors.rightMargin: 0
        //                visible: true
        //                sortIndicatorOrder: Qt.AscendingOrder
        //                sortIndicatorVisible: true

        //                property string currentFilePath: ""
        //                style: TableViewStyle {

        //                    headerDelegate: Rectangle {

        //                        //设置表头的样式 styleData.value===""? 10:
        //                        implicitWidth:  tableView.width / 3
        //                        implicitHeight: fontSize * 2
        //                        border.width: 1
        //                        border.color: "gray"
        //                        Text {
        //                            anchors.verticalCenter: parent.verticalCenter
        //                            anchors.left: parent.left
        //                            anchors.leftMargin: 0
        //                            text: styleData.value
        //                            color: styleData.pressed ? "burlywood" : "darkgray"
        //                            font.bold: true
        //                        }
        //                    }

        //                    itemDelegate: Text {
        //                        text: styleData.value
        //                        elide: Text.ElideLeft
        //                        property bool selected: styleData.selected
        //                        onSelectedChanged: {
        //                            if (selected
        //                                    && styleData.column === tableView.columnCount - 1) {
        //                                // 显示的是所有被选中项
        //                                console.log("当前路径为" + styleData.value.toString(
        //                                                ))
        //                                tableView.currentFilePath = styleData.value.toString()
        //                            }
        //                        }
        //                    }

        //                    rowDelegate: Rectangle {

        //                        height: root.fontSize * 2
        //                        color: styleData.selected ? "burlywood" : "darkgray"
        //                        property string lastColor: ""
        //                        //property int row: styleData.row
        //                        anchors.leftMargin: 2

        //                        /*              MouseArea {
        //    //                    anchors.fill: parent
        //    //                   acceptedButtons: Qt.NoButton
        //    //                   propagateComposedEvents: false
        //    //                    hoverEnabled: true
        //    //                    onEntered: {
        //    //                        if(parent.row !== tableView.currentRow){
        //    //                        parent.lastColor = parent.color
        //    //                        parent.color = "#deb660"
        //    //                        }else {
        //    //                            parent.lastColor = parent.color
        //    //                            parent.color = "#deb660"
        //    //                        }
        //    //                    }
        //    //                    onExited: {
        //    ////                        if (!styleData.selected
        //    ////                                && parent.row !== tableView.currentRow) {
        //    ////                            parent.color = "darkgray"
        //    ////                            console.log("离开时的事件触发 ")
        //    ////                        } else {
        //    ////                            parent.lastColor = parent.color
        //    ////                            parent.color = "#deb660"
        //    ////                        }
        //    ////                        if(parent.row!==tableView.currentRow)
        //    ////                        parent.color="darkgray"
        //    //                    }
        //    ////                    onClicked: {
        //    ////                        console.log("click")
        //    ////                        if (mouse.button === Qt.LeftButton) {
        //    ////                            var currentRow = tableView.rowAt(mouseX, mouseY)
        //    ////                            if (currentRow !== -1) {
        //    ////                                tableView.selection.deselect(
        //    ////                                            0, tableView.rowCount - 1)
        //    ////                                tableView.selection.select(currentRow)
        //    ////                                tableView.currentRow = currentRow
        //    ////                            }
        //    ////                        }
        //    ////                    }
        //    //                }
        //    //            }*/
        //                    }
        //                }

        //                MouseArea {
        //                    id: mouseRegion
        //                    anchors.fill: parent
        //                    acceptedButtons: Qt.RightButton | Qt.LeftButton // 激活右键（别落下这个）
        //                    drag.filterChildren: true
        //                    propagateComposedEvents: true
        //                    onClicked: {
        //                        if (mouse.button === Qt.LeftButton) {
        //                            var currentRow = tableView.rowAt(mouseX, mouseY)
        //                            if (currentRow !== -1) {
        //                                tableView.selection.deselect(
        //                                            0, tableView.rowCount - 1)
        //                                tableView.selection.select(currentRow)
        //                            }
        //                        }

        //                        if (mouse.button === Qt.RightButton /* ||mouse.button===Qt.LeftButton*/
        //                                ) {
        //                            // 右键菜单
        //                            currentRow = tableView.rowAt(mouseX, mouseY)
        //                            if (currentRow !== -1) {
        //                                tableView.selection.deselect(
        //                                            0, tableView.rowCount - 1)
        //                                tableView.selection.select(currentRow)
        //                                contentMenu.popup()
        //                            }
        //                        }
        //                    }
        //                    onDoubleClicked: {
        //                        if (mouse.button === Qt.LeftButton) {
        //                            var currentRow = tableView.rowAt(mouseX, mouseY)
        //                            if (currentRow !== -1) {
        //                                console.log("应该播放此歌曲")
        //                                tableView.selection.deselect(
        //                                            0, tableView.rowCount - 1)
        //                                tableView.selection.select(currentRow)
        //                                if (playlist.currentItemSource !== tableView.currentFilePath) {
        //                                    playlist.addItem(tableView.currentFilePath)
        //                                    playlist.currentIndex = playlist.itemCount - 1
        //                                    mediaPlayer.play()
        //                                }
        //                            }
        //                        }
        //                    }
        //                }

        //                Button {

        //                    anchors.right: parent.right
        //                    anchors.bottom: parent.top
        //                    id: openFile
        //                    text: qsTr("新增文件夹")
        //                    font.pointSize: root.fontSize / 2
        //                    onClicked: {
        //                        fileDialog.visible = true
        //                    }
        //                }

        //                Menu {
        //                    // 右键菜单
        //                    //title: "Edit"
        //                    id: contentMenu

        //                    MenuItem {
        //                        text: qsTr("播放")
        //                        font.pixelSize: root.fontSize
        //                        onTriggered: {
        //                            if (playlist.currentItemSource !== tableView.currentFilePath) {
        //                                playlist.addItem(tableView.currentFilePath)
        //                                playlist.currentIndex = playlist.itemCount - 1
        //                                mediaPlayer.play()
        //                            }
        //                        }
        //                    }

        //                    MenuItem {
        //                        text: qsTr("加入列表")
        //                        font.pixelSize: root.fontSize
        //                        onTriggered: {

        //                        }
        //                    }

        //                    MenuSeparator {}

        //                    Menu {
        //                        title: qsTr("收藏到其他歌单")

        //                        MenuItem {
        //                            text: qsTr("这里展开歌单列表")
        //                        }
        //                    }
        //                }

        //                /*      function changed(index) {
        //            console.log("当前点击的路径为")
        //        }

        //    //        Connections {
        //    //            target: tableView
        //    //            onCurrentIndexChanged: {
        //    //                console.log(tableView.currentIndex + " is clicked!" + tableView.currentTab)
        //    //                changed(tableView.currentIndex)
        //    //            }
        //    //        }*/
        //                model: myModel

        //                Q14.TableViewColumn {
        //                    role: "id"
        //                    title: ""
        //                }
        //                Q14.TableViewColumn {
        //                    role: "musicName"
        //                    title: "名字"
        //                }
        //                Q14.TableViewColumn {
        //                    role: "artist"
        //                    title: "作者"
        //                }
        //                Q14.TableViewColumn {
        //                    role: "album"
        //                    title: "专辑"
        //                }
        //                Q14.TableViewColumn {
        //                    role: "duration"
        //                    title: "时长"
        //                }
        //                Q14.TableViewColumn {
        //                    visible: false
        //                    role: "filePath"
        //                    title: ""
        //                }
        //            }
        //        }
    }

    TabBar {
        anchors.top: swipeView.top
        anchors.left: swipeView.left
        anchors.right: swipeView.right
        contentHeight: 20

        id: tabBar
        currentIndex: swipeView.currentIndex
        onCurrentIndexChanged: {
            swipeView.currentIndex = currentIndex
        }
        Component.onCompleted: {
            tabBar.currentIndex=0
        }

        TabButton {
            text: "First"
        }
        TabButton {
            text: "Second"
        }
        TabButton {
            text: "Third"
        }
    }

    MediaPlayer {
        id: mediaPlayer
        property int isPlay: 0 // 0停止 1 暂停 2 开始
        // source: playlist.currentItemSource // 初始化列表为 空 当添加的时候 就是在 list中添加和使用
        onSourceChanged: {
            // 包括了很多的 音乐信息
            console.log("当前播放的歌为" + metaData.author + metaData.date)
        }
        //MediaPlayer.duration 这里是以毫秒计数的
        onPlaying: {
            isPlay = 2
        }
        onStopped: {
            isPlay = 0
        }
        onPaused: {
            isPlay = 1
        }
        playlist: Playlist {
            id: playlist
            playbackMode: Playlist.Sequential
            property string name: currentPathMusic
            onCurrentItemSourceChanged: {
                CodeImg.setUrl(currentItemSource) //重新甚至图片
            }

            Component.onCompleted: {
                playlist.addItem(name + "平井真美子 - 孤灯.mp3")
                playlist.addItem(name + "Thomas Greenberg - The Right Path.mp3")
            }
        }
    }

    Rectangle {
        id: progressRow
        width: parent.width
        visible: true
        height: parent.height / 10
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0

        Row {
            leftPadding: 0
            spacing: 0
            anchors.fill: parent

            Row {
                id: startRow
                visible: true
                width: 0
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10
                antialiasing: false

                leftPadding: 10
                Connections {
                    target: listView
                    onWidthChanged: {
                        if (listView.width > startRow.width) {
                            startRow.width = listView.width
                            console.log("listview的长度 变化为" + listView.width)
                        }
                    }
                }

                Rectangle {
                    id: preButton
                    width: parent.width / 4
                    height: width

                    //                anchors.verticalCenter: parent.verticalCenter
                    Image {
                        anchors.centerIn: parent
                        width: parent.width - 5
                        height: parent.height - 5
                        id: imageForPre
                        source: "qrc:/play/Iamges/play/shangyishou-yuanshijituantubiao.png"
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            imageForPre.source = "qrc:/listImage/otherImage/1/icon-.png"
                        }
                        onExited: {
                            imageForPre.source
                                    = "qrc:/play/Iamges/play/shangyishou-yuanshijituantubiao.png"
                        }
                        onClicked: {
                            mediaPlayer.playlist.previous()
                        }
                    }
                }

                Rectangle {
                    id: startButton
                    property bool isPlay: false
                    width: parent.width / 4
                    height: width
                    //                anchors.verticalCenter: parent.verticalCenter
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            imageForStart.source = "qrc:/listImage/otherImage/1/bofang.png"
                        }
                        onExited: {
                            if (mediaPlayer.playbackState === MediaPlayer.PlayingState) {
                                imageForStart.source = "qrc:/play/Iamges/play/zanting.png"
                            } else {
                                imageForStart.source = "qrc:/play/Iamges/play/bofang.png"
                            }
                        }

                        onClicked: {

                            if (mediaPlayer.playbackState !== Audio.PlayingState) {
                                mediaPlayer.play()
                            } else {
                                mediaPlayer.pause()
                            }
                        }
                    }
                    Image {

                        id: imageForStart
                        anchors.centerIn: parent
                        width: parent.width - 5
                        height: parent.height - 5

                        source: mediaPlayer.playbackState === MediaPlayer.PlayingState ? "qrc:/play/Iamges/play/zanting.png" : "qrc:/play/Iamges/play/bofang.png"
                    }
                    //icon.source:":/new/Iamges/icon_udbw6jfgr79/message.png"
                }

                Rectangle {
                    id: nextButoon
                    width: parent.width / 4
                    height: width

                    //                anchors.verticalCenter: parent.verticalCenter
                    MouseArea {
                        anchors.fill: parent

                        hoverEnabled: true
                        onEntered: {
                            imageForNext.source = "qrc:/listImage/otherImage/1/xiayishou.png"
                        }
                        onExited: {
                            imageForNext.source
                                    = "qrc:/play/Iamges/play/xiayishou-yuanshijituantubiao.png"
                        }
                        onClicked: {
                            mediaPlayer.playlist.next()
                        }
                    }
                    Image {
                        id: imageForNext
                        anchors.centerIn: parent
                        width: parent.width - 5
                        height: parent.height - 5
                        source: "qrc:/play/Iamges/play/xiayishou-yuanshijituantubiao.png"
                    }
                }
            }

            Row {
                id: durationRow
                width: root.width - startRow.width - voiceRow.width
                height: parent.height
                spacing: 5
                Text {
                    id: durationTime
                    text: {
                        var milliseconds = mediaPlayer.position
                        var minutes = Math.floor(milliseconds / 60000)
                        milliseconds -= minutes * 60000
                        var seconds = milliseconds / 1000
                        seconds = Math.round(seconds)
                        if (seconds < 10)
                            return minutes + ":0" + seconds
                        else
                            return minutes + ":" + seconds
                    }
                    font.pixelSize: root.fontSize
                    font.family: root.fontFamily

                    anchors.verticalCenter: parent.verticalCenter
                }

                Slider {
                    id: durationTimeSlider
                    height: parent.height
                    width: parent.width * 0.9
                    //                anchors.verticalCenter: parent.verticalCenter
                    value: mediaPlayer.position / mediaPlayer.duration

                    background: Rectangle {
                        x: durationTimeSlider.leftPadding
                        y: durationTimeSlider.topPadding
                           + durationTimeSlider.availableHeight / 2 - height / 2
                        implicitWidth: 200
                        implicitHeight: 4
                        width: durationTimeSlider.availableWidth
                        height: implicitHeight
                        radius: 2
                        color: "#bdbebf"

                        Rectangle {
                            width: durationTimeSlider.visualPosition * parent.width
                            height: parent.height
                            color: "red"
                            radius: 2
                        }
                    }

                    handle: Rectangle {
                        antialiasing: true
                        x: durationTimeSlider.leftPadding + durationTimeSlider.visualPosition
                           * (durationTimeSlider.availableWidth - width)
                        y: durationTimeSlider.topPadding
                           + durationTimeSlider.availableHeight / 2 - height / 2
                        implicitWidth: 15
                        implicitHeight: 15
                        radius: 10
                        //color: durationTimeSlider.pressed ? "#f0f0f0" : "#f6f6f6"
                        border.width: durationTimeSlider.pressed ? 3 : 2
                        border.color: durationTimeSlider.pressed ? "silver" : "#bdbebf"
                        Rectangle {
                            width: 4
                            height: 4
                            radius: 2
                            color: "red"
                            anchors.centerIn: parent
                        }
                    }
                    property real index: 0
                    property bool changed: false
                    onMoved: {
                        if (pressed) {
                            index = position
                        }
                    }
                    onPressedChanged: {
                        if (pressed === true) {
                            changed = true
                        } else if (changed === true) {
                            mediaPlayer.seek(index * mediaPlayer.duration)
                            changed = false
                        }
                    }
                }

                Text {
                    id: endTime
                    text: {
                        var milliseconds = mediaPlayer.duration.valueOf()
                        var minutes = Math.floor(milliseconds / 60000)
                        milliseconds -= minutes * 60000
                        var seconds = milliseconds / 1000
                        seconds = Math.round(seconds)
                        if (seconds < 10)
                            return minutes + ":0" + seconds
                        else
                            return minutes + ":" + seconds /*
                                                                                                                        var minute = (mediaPlayer.duration.valueOf(
                                                                                                                                                                                                                                                                                                                                                                          ) / 1000).toFixed(0)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        var m = (minute / 60).toFixed(0)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            var s = (minute % 60).toFixed(0)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    //console.log(mediaPlayer.position)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  return m + ":" + s*/
                    }

                    font.pixelSize: root.fontSize
                    font.family: root.fontFamily
                    anchors.verticalCenter: parent.verticalCenter
                    // font.pixelSize: 12
                }
            }

            Row {
                id: voiceRow
                width: root.width / 4
                height: parent.height
                leftPadding: 10
                visible: true

                Rectangle {
                    visible: true
                    id: trumpetButton
                    width: 30
                    height: 30
                    opacity: 1
                    anchors.verticalCenter: parent.verticalCenter
                    Image {
                        id: voiceImage
                        anchors.fill: parent
                        source: mediaPlayer.muted ? "qrc:/listImage/otherImage/1/mn_shengyinwu_fill.png" : mediaPlayer.volume > 50 ? "qrc:/listImage/otherImage/1/mn_shengyin_fill.png" : "qrc:/listImage/otherImage/1/shengyin.png"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            mediaPlayer.muted = !mediaPlayer.muted
                        }
                    }
                }

                Slider {
                    id: voiceSlider
                    //anchors.verticalCenter: parent.verticalCenter
                    //                anchors.verticalCenter: parent.verticalCenter
                    value: 0.2
                    width: parent.width - trumpetButton.width - 150
                    height: parent.height
                    onValueChanged: {
                        mediaPlayer.volume = value
                        if (value < 0.5) {
                            voiceImage.source = "qrc:/listImage/otherImage/1/shengyin.png"
                        } else {
                            voiceImage.source = "qrc:/listImage/otherImage/1/mn_shengyin_fill.png"
                        }
                    }
                    visible: true

                    background: Rectangle {
                        x: voiceSlider.leftPadding
                        y: voiceSlider.topPadding + voiceSlider.availableHeight / 2 - height / 2
                        implicitWidth: 200
                        implicitHeight: 4
                        width: voiceSlider.availableWidth
                        height: implicitHeight
                        radius: 2
                        color: "#bdbebf"

                        Rectangle {
                            width: voiceSlider.visualPosition * parent.width
                            height: parent.height
                            color: "red"
                            radius: 2
                        }
                    }

                    handle: Rectangle {
                        visible: true
                        antialiasing: true
                        x: voiceSlider.leftPadding + voiceSlider.visualPosition
                           * (voiceSlider.availableWidth - width)
                        y: voiceSlider.topPadding + voiceSlider.availableHeight / 2 - height / 2
                        implicitWidth: 15
                        implicitHeight: 15
                        radius: 10
                        //color: voiceSlider.pressed ? "#f0f0f0" : "#f6f6f6"
                        border.width: voiceSlider.pressed ? 3 : 2
                        border.color: voiceSlider.pressed ? "silver" : "#bdbebf"
                        Rectangle {
                            width: 4
                            height: 4
                            radius: 2
                            color: "red"
                            anchors.centerIn: parent
                        }
                    }
                }
                Row {
                    width: voiceRow.width - trumpetButton.width - voiceSlider.width
                    anchors.verticalCenter: parent.verticalCenter
                    height: parent.height
                    spacing: 10
                    leftPadding: 10
                    Rectangle {
                        id: palyModelButton
                        width: 32
                        visible: true
                        height: 32
                        anchors.verticalCenter: parent.verticalCenter
                        ToolTip.timeout: 5000
                        ToolTip.visible: playModelButton.hovered
                        ToolTip.text: qsTr("列表循环")
                        //ToolTip.font.pixelSize: root.fontSize
                        Button {
                            id: playModelButton
                            width: 32
                            height: 32
                            hoverEnabled: true
                            anchors.fill: parent
                            flat: true
                            icon.width: parent.width
                            icon.height: parent.height
                            icon.source: "qrc:/model/Iamges/model/shunxubofang.png"
                            onClicked: {
                                if (mediaPlayer.playlist.playbackMode === Playlist.Sequential) {
                                    parent.ToolTip.text = qsTr("单曲循环")
                                    playModelButton.icon.source
                                            = "qrc:/listImage/otherImage/1/danquxunhuan.png"
                                    mediaPlayer.playlist.playbackMode = Playlist.Loop
                                } else if (mediaPlayer.playlist.playbackMode === Playlist.Loop) {
                                    parent.ToolTip.text = qsTr("随机播放")
                                    mediaPlayer.playlist.playbackMode = Playlist.Random
                                    playModelButton.icon.source
                                            = "qrc:/listImage/otherImage/1/suijibofang.png"
                                } else if (mediaPlayer.playlist.playbackMode === Playlist.Random) {
                                    parent.ToolTip.text = qsTr("列表播放")
                                    mediaPlayer.playlist.playbackMode = Playlist.Sequential
                                    playModelButton.icon.source
                                            = "qrc:/listImage/otherImage/1/xunhuanbofang.png"
                                }
                            }
                            background: Rectangle {
                                anchors.fill: parent
                                border.width: 1
                                border.color: "silver"
                                radius: 5
                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    propagateComposedEvents: true
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

                    Button {
                        id: wordButton
                        width: 30
                        flat: true
                        icon.width: parent.height
                        icon.height: parent.height
                        icon.source: "qrc:/listImage/otherImage/1/cibiaoquanyi.png"
                        anchors.verticalCenter: parent.verticalCenter
                        height: 30
                        background: Rectangle {
                            anchors.fill: parent
                            border.width: 1
                            border.color: "silver"
                            radius: 5
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                propagateComposedEvents: true
                                onEntered: {
                                    parent.color = "silver"
                                }
                                onExited: {
                                    parent.color = "white"
                                }
                            }
                        }
                        visible: true
                        //                anchors.verticalCenter: parent.verticalCenter
                    }

                    Button {
                        id: playListButton
                        width: 30
                        height: 30
                        flat: true
                        icon.width: parent.height
                        icon.height: parent.height
                        icon.source: "qrc:/listImage/otherImage/1/wj-bflb.png"
                        anchors.verticalCenter: parent.verticalCenter
                        text: playlist.columnCount()
                        onClicked: {
                            tableView.visible = !tableView.visible
                        }
                        visible: true
                        background: Rectangle {
                            anchors.fill: parent
                            border.width: 1
                            border.color: "silver"
                            radius: 5
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                propagateComposedEvents: true
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
        }
    }
}

/*##^##
Designer {
    D{i:1;anchors_height:720}D{i:9;anchors_height:97.5}D{i:6;anchors_width:200}
}
##^##*/

