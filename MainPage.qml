import QtQuick 2.0
import QtGraphicalEffects 1.12
import QtQuick.Controls 2.13

Flickable {
    id: element
    property real realWidth: swipeView.width
    property real realHeight: swipeView.height
    height: 800
    contentHeight: swipeView.height * 1.5
    contentWidth: swipeView.width
    boundsBehavior: Flickable.StopAtBounds
    ListModel {
        id: appModel
        ListElement {

            icon: "qrc:/images/Img368554456.jpg"
        }
        ListElement {

            icon: "qrc:/images/选区_002.png"
        }
        ListElement {

            icon: "qrc:/images/v2-f7069c486b92523f1a8d86f900872e1b_r.jpg"
        }
    }

    ListModel{
        id:topModel
        ListElement{
            name:"个性推荐"
        }
        ListElement{ name:
            "歌单"}
        ListElement{
            name:
            "个性推荐"}
        ListElement{name:"主播电台" }
        ListElement{name:"排行榜" }
        ListElement{name:"歌手" }
    }


    Rectangle {
        id: adView

        height: parent.height / 2
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 20
        anchors.rightMargin: 20


        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: root.fontSize * 3
            anchors.topMargin: 30
            anchors.leftMargin: (realWidth - (column.width)) / 2
            Row {
                id: column
                spacing: 30
                property int currentIndex: 0
                Repeater{
                    model: topModel
                    delegate:
                        indicatorForTop
                }
            } Rectangle{
                anchors.top: column.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: -((realWidth - (column.width)) / 2)
                anchors.topMargin: 10
                height: 2

                border.color: "gray"
                border.width: 2
            }

        }

        PathView {
            id: view
            property int iconWidhth: 550
            property int iconHeight: 200
            anchors.bottomMargin: 20
            anchors.fill: parent
            highlight: appHighlight
            preferredHighlightBegin: 0.5
            preferredHighlightEnd: 0.5
            focus: true
            model: appModel
            delegate: appDelegate
            path:
                /*Path {
            startX: 10
            startY: 50
            PathAttribute { name: "iconScale"; value: 0.5 }
            PathQuad { x: 200; y: 150; controlX: 50; controlY: 200 }
            PathAttribute { name: "iconScale"; value: 1.0 }
            PathQuad { x: 390; y: 50; controlX: 350; controlY: 200 }
            PathAttribute { name: "iconScale"; value: 0.5 }
        }*/
                Path {

                startX: 250
                startY: view.iconHeight / 2 + 100
                PathAttribute {
                    name: "iconZ"
                    value: 1
                }
                PathAttribute {
                    name: "iconScale"

                    value: 1
                }
                PathLine {
                    x: view.width / 2 - 70
                    y: view.iconHeight / 2 + 100
                }

                //PathPercent { value: 0.28; }
                PathAttribute {
                    name: "iconZ"

                    value: 10
                }

                PathAttribute {
                    name: "iconScale"

                    value: 1.2
                }
                PathLine {
                    x: view.width - 220
                    y: view.iconHeight / 2 + 100
                }
                PathAttribute {
                    name: "iconZ"
                    value: 1
                }
                PathAttribute {
                    name: "iconScale"

                    value: 1
                }
            }
        }

        PageIndicator {
            id: indicator
            anchors.horizontalCenter: parent.horizontalCenter

            anchors.top: parent.bottom
            anchors.topMargin:-75
            z:10
            currentIndex: view.currentIndex
            count: view.count
            delegate: Rectangle {
                width: 25
                height: 3

                color: index === view.currentIndex ? "red" : "silver"
                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -5
                    propagateComposedEvents: true
                    hoverEnabled: true
                    onEntered: {
                        indicator.currentIndex = index
                        view.currentIndex = index
                    }
                    onClicked: {

                        indicator.currentIndex = index
                        view.currentIndex = index
                    }
                }
            }
        }

        Rectangle {
            id: leftPageChanged
            width: 40
            opacity: 0.4
            color: "transparent"
            //设置背景透明，否则会出现默认的白色背景
            height: view.height
            visible: true
            anchors.left: view.left
            anchors.verticalCenter: view.verticalCenter
            anchors.leftMargin: 20
            z: 10
            Image {
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                source: "qrc:/listImage/otherImage/1/xiangzuo.png"
            }
            MouseArea {
               anchors.fill: parent
                propagateComposedEvents: false
                hoverEnabled: true
                onClicked: {
                    view.decrementCurrentIndex()
                }
                onEntered: {
                    parent.opacity=1
                }onExited: {
                    parent.opacity=0.2
                }
            }
        }

        Rectangle {
            width: 40
            anchors.right: view.right
            anchors.rightMargin: 20
            anchors.verticalCenter: view.verticalCenter
            visible: true
            color: "transparent"
            z: 10
            height: view.height

            opacity: 0.4
            id: rightPageChanged
            Image {
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                source: "qrc:/listImage/otherImage/1/xiangyou.png"
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                propagateComposedEvents: false
                onClicked: {
                    view.incrementCurrentIndex()
                }
                onEntered: {
                    parent.opacity=1
                }onExited: {
                    parent.opacity=0.2
                }
            }
        }
    }

    Rectangle {
        id: rectangle

        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        anchors.bottom: parent.bottom
        anchors.top: adView.bottom
        anchors.topMargin: -40
        Rectangle {
            id: rectangle1
            height: 30
            color: "#ffffff"
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.right: parent.right

            Text {
                id: element1
                text: qsTr("推荐歌单")
                anchors.left: parent.left
                anchors.leftMargin: 20
                font.pixelSize: 20
                font.family: root.fontFamily
            }

            Text {
                id: element2
                text: qsTr("更多")
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.right: parent.right
                font.pixelSize: root.fontSize
            }
        }

        Rectangle{
            anchors.top:  rectangle1.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottomMargin: 10
            height: 2
            anchors.topMargin: 25

            border.color: "gray"
            border.width: 2
        }

        Rectangle {
            id: rectangle2
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: rectangle1.bottom

            ListModel {
                id: gridViewModel

                ListElement {
                    name: "[华语速爆新歌] 最新华语音乐推荐"
                    icon: "qrc:/gridView/109951164188441847.jpg.png"
                     comment:"音乐应该被人发现"
                }
                ListElement {
                    name: "注入灵魂|当神级说唱遇上天籁HOOK"
                    icon: "qrc:/gridView/109951164213417907.jpg.png"
                     comment:"优质华语新歌"
                }

                ListElement{
                    name:"【旋律控】超级好听的欧美良曲"
                    icon:"qrc:/gridView/109951164399406487.jpg"
                    comment:"音乐应该被人发现"
                }
                ListElement{
                    name:"好这平凡的一生"
                    icon:"qrc:/gridView/109951164425343786.jpg"
                    comment:"音乐应该被人发现"
                }

                ListElement{
                    name:"好听到单曲循环鸭"
                    icon:"qrc:/gridView/109951164544249530.jpg"
                    comment:"音乐应该被人发现"
                }

                ListElement{
                    name:"写给坚强的你 "
                    icon:"qrc:/gridView/109951164546424860.jpg.png"
                    comment:"音乐应该被人发现"
                }

                ListElement{
                    name:"那个人现在还在你身边吗 "
                    icon:"qrc:/gridView/109951164554007381.jpg"
                    comment:"音乐应该被人发现"
                }

                ListElement{
                    name:"心做（男声）"
                    icon:"qrc:/gridView/1380986606815861.jpg"
                    comment:"音乐应该被人发现"
                }

//                ListElement{
//                    name:"岁月旅歌"
//                    icon:"qrc:/gridView/Iamges/GirdView/1418370012865049.jpg"
//                    comment:"音乐应该被人发现"
//                }
//                ListElement{
//                    name:" 你绝对熟悉的电音 自嗨蹦迪"
//                    icon:"qrc:/gridView/Iamges/GirdView/1380986606815861.jpg"
//                    comment:"音乐应该被人发现"
//                }


//                Component.onCompleted: {
//                    for (var i = 0; i < 8; ++i) {
//                        gridViewModel.append({"name": "第" + i + "项",
//       "icon": "qrc:/images/Iamges/icon_z4gltkbfpue/Rec-Button.png"
//                                             })
//                    }
//                }
            }
            //! [0]
            GridView {
                id: gridView
                anchors.fill: parent
                anchors.leftMargin: 30
                cellWidth:180
                cellHeight:180
                focus: true
                model: gridViewModel

                boundsBehavior: Flickable.StopAtBounds
                delegate: Rectangle {
                    width: 160
                    height:160

                    Image {
                        id: myIcon
                        y: 20
                        anchors.centerIn: parent
                        source: icon
                        width: 120
                        height: 120
                    }
                    Text {
                        id: myText
                        anchors {
                            top: myIcon.bottom
                            horizontalCenter: parent.horizontalCenter
                        }
                        width: parent.width

                        height: root.fontSize*3
                        text: name
                        wrapMode: Text.WrapAnywhere
                        font.pixelSize: root.fontSize
                        textFormat: Text.StyledText
                        horizontalAlignment: Text.AlignJustify
//                        onLineLaidOut: {
//                            line.width = width / 2  - (margin)

//                            if (line.y + line.height >= height) {
//                                line.y -= height - margin
//                                line.x = width / 2 + margin
//                            }
//                        }
                //! [layout]
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            //                  maskRectangle.height=0
                            gridView.currentIndex = index
                            maskRectangle.height = maskText.font.pixelSize + 10

                            startAnimation.start()
                        }
                        onClicked: {
                            gridView.currentIndex = index
                            maskRectangle.height = maskText.font.pixelSize + 10

                            startAnimation.start()
                        }
                    }

                    Rectangle {
                        id: maskRectangle
                        width: myIcon.width
                        height: maskText.font.pixelSize + 10
                        anchors.top: myIcon.top
                        anchors.left: myIcon.left
                        opacity: 0.8

                        z: 0
                        color: "#dcdcdc"
                        Text {
                            id: maskText
                            visible: parent.visible
                            text: comment
                            width: parent.width
                            font.family: root.fontFamily
                            font.pixelSize: root.fontSize
                            wrapMode: Text. WrapAnywhere
                        }

                        visible: index === gridView.currentIndex ? true : false
                        NumberAnimation on height {
                            id: startAnimation
                            from: 0
                            to: maskText.font.pixelSize + 10
                            target: maskRectangle
                            property: "height"
                            duration: 800
                            easing.type: Easing.InOutQuad
                            onStarted: {
                                maskText.visible = false
                            }

                            onStopped: {
                                maskText.visible = true
                                //                        maskRectangle.height=0
                                //console.log("重置" + index)
                            }
                        }
                    }
                }
            }
            //! [0]
        }
    }

    Component{
        id:indicatorForTop
    Text {
    font.family: root.fontFamily
    font.pixelSize: root.fontSize * 1.5
    text: name
    Rectangle{
        id:bottomIndicator
        anchors.top: parent.bottom
        anchors.left: parent.left
        width: parent.width
        height: 2
        color:column.currentIndex===index?"red":"white"
    }
    MouseArea{
        anchors.fill: parent
        anchors.margins: -5
        hoverEnabled: true
        onEntered: {
            column.currentIndex=index

        }
    }}}

    Component {
        id: appDelegate

        Item {
            id: container
            width: 550
            height: 250
            scale: PathView.iconScale
            z: PathView.iconZ
            Image {
                id: myIcon
                y: 20
                anchors.horizontalCenter: parent.horizontalCenter
                source: icon
                smooth: true
                width: parent.width
                height: parent.height
                // visible: false
            }
            Colorize {
                id: imageEffect
                anchors.fill: myIcon

                source: myIcon
                hue: 0.0
                saturation: 0.0
                lightness: -0.2
                visible: view.currentIndex === index ? false : true
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {

                    if (view.currentIndex !== index)
                        view.currentIndex = index
                }
            }
        }
    }

    Component {
        id: appHighlight
        Rectangle {
            width: 80
            height: 80
            color: "lightsteelblue"
        }
    }

    ScrollBar.vertical: ScrollBar {}
}

/*##^##
Designer {
    D{i:40;anchors_height:200;anchors_width:200}
}
##^##*/

