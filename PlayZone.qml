import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: playZoneView

    Rectangle {
        id: rectangle
        color: "#ffffff"
        anchors.fill: parent

        Row {
            id: row
            anchors.fill: parent

            Rectangle {
                id: rectangle2
                width: parent.width / 2
                height: parent.height
                color: "#ffffff"

                Column {
                    id: column
                    anchors.fill: parent
                    leftPadding: 50
                    Rectangle {
                        id: rectangle5
                        width: parent.width
                        height: parent.height * 0.8
                        Image {
                            id: rectangle3
                            width: 200
                            height: 200
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            source: "qrc:/gridView/109951164425343786.jpg"
                        }
                    }

                    Rectangle {
                        id: rectangle4
                        width: parent.width
                        height: parent.height * 0.2
                        color: "#ffffff"

                        Row {
                            id: row1
spacing: 5
leftPadding: 20
                            anchors.fill: parent
                            Button {
                                id: playListButton

                                flat: true
                                icon.width:25
                                icon.height:25
                                icon.source: "qrc:/menu/Iamges/menu/shoucang.png"
                                anchors.verticalCenter: parent.verticalCenter
                                text: qsTr("喜欢")
                                display: AbstractButton.TextBesideIcon
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

                            Button {
                                id: playListBut

                                flat: true
                                icon.width:25
                                icon.height:25
                                icon.source: "qrc:/listImage/otherImage/1/guangdie.png"
                                anchors.verticalCenter: parent.verticalCenter
                                text: qsTr("收藏")
                                display: AbstractButton.TextBesideIcon
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

                            Button {
                                id: playListBu

                                flat: true
                                icon.width:25
                                icon.height:25
                                icon.source: "qrc:/menu/Iamges/menu/xiazai.png"
                                anchors.verticalCenter: parent.verticalCenter
                                text: qsTr("下载")
                                display: AbstractButton.TextBesideIcon
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

                            Button {
                                id: playListB

                                flat: true
                                icon.width:25
                                icon.height: 25
                                icon.source: "qrc:/listImage/otherImage/1/fenxiang.png"
                                anchors.verticalCenter: parent.verticalCenter
                                text: qsTr("分享")
                                display: AbstractButton.TextBesideIcon
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

            Rectangle {
                id: rectangle1
                width: parent.width / 2
                height: parent.height
                color: "#ffffff"

                Text {
                    id: element
                    x: 0
                    y: 0
                    text: qsTr("暂无歌词")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 16
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:6;anchors_height:96;anchors_width:320}
D{i:8;anchors_height:400;anchors_width:200}D{i:7;anchors_height:400;anchors_width:200}
D{i:4;anchors_height:400;anchors_width:200}D{i:3;anchors_height:480;anchors_width:320}
D{i:1;anchors_height:200;anchors_width:200}
}
##^##*/

