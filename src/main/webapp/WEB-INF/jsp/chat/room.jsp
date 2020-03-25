<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://sargue.net/jsptags/time" prefix="javatime" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chatting room</title>
    <link rel="stylesheet" href="/webjars/bootstrap/4.3.1/dist/css/bootstrap.min.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css" type="text/css" rel="stylesheet">
    <link href="/resources/css/chat.css" rel="stylesheet">

    <script src="/webjars/jquery/3.4.1/dist/jquery.min.js"></script>
    <script src="/webjars/sockjs-client/1.1.2/sockjs.min.js"></script>
    <script src="/webjars/stomp-websocket/2.3.3-1/stomp.min.js"></script>
    <script src="/webjars/bootstrap/4.3.1/dist/js/bootstrap.bundle.js"></script>
    <script type="text/javascript" src="/resources/js/chat.js"></script>

</head>
<body>
<div class="container">
    <h3 class=" text-center">GIVEANDTAKE</h3>
    <div class="chatting">
        <div class="inbox_all">
            <div class="inbox_people">
                <div class="headind_srch">
                    <div class="recent_heading">
                        <h4>GIVE AND TAKE TALK</h4>
                    </div>
                    <div class="srch_bar">
                        <div class="stylish-input-group">
                            <input type="text" id="receiver" class="search-bar"  placeholder="Search" >
                            <span class="input-group-addon">
                                    <button id=creating type="button"> <i class="fa fa-search" aria-hidden="true"></i> </button>
                            </span>
                        </div>
                    </div>
                </div>
                <div class="inbox_chat">
                    <div class="chat_list">

                    </div>
                </div>
            </div>
            <div class="messages">
                <div>
                    <button class="delete" id='deleteBtn'  >채팅그만두기</button>
                    <button onClick="self.location='/';" type="button"> <i class="fa fa-home" aria-hidden="true"></i> </button>
                </div>
                <div class="msg_history">


                </div>


                <div class="type_msg">
                    <div class="input_msg_write">
                        <input type="text" class="write_msg" placeholder="Type a message" id="message" />
                        <button class="msg_send_btn" type="button" id="sending"><i class="fa fa-paper-plane-o" aria-hidden="true"></i></button>
                    </div>
                </div>
            </div>
        </div>




    </div>
</div>

</body>
<script>
    // playInit = setInterval(function() {
    //     init();
    //     init2();
    // }, 2000);
    //
    init();
    $('.messages').hide();
    var chatUL = $(".inbox_chat");
    var me = null;
    <sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal" var="userinfo"/>;
    sender = '${userinfo.user.nickname}';
    </sec:authorize>
    function init() {
        // 채팅룸 출력
        chatService.findAllRoom(function (data) {
            var str = "";
            if (data == null || data.length == 0) {
                return;
            }
            console.log("data" + JSON.stringify(data));
            for (var i = 0, len = data.length || 0; i < len; i++) {
                str += "<div class='chat_list'>"
                str += "<ul>"
                str += "<li class='chat_li' data-rid='" + data[i].roomId + "'>";
                str += "<div class='chat_people'>"
                str += "<div class='chat_ib'>"
                for (var a = 0, length = data[i].users.length || 0; a < length; a++) {
                    if (sender != data[i].users[a].user.nickname) {
                        str += "<div class='chat_img'> "
                            +"<img src='/display?fileName=" + data[i].users[a].user.id
                            + "/profile/s_" + data[i].users[a].user.profileImage
                            + "' onerror=\"this.src='/resources/image/profile.png'\"/>"
                            +"</div>"
                        str += "<div class='chat_ib'>"
                        str += "<h5>" + data[i].users[a].user.nickname+"</h5>";
                    }
                    else{
                         str += "<span class='msgCnt'>" + data[i].users[a].msgCount + "</span>";
                    }
                }
                str +="<div class='chat_date'>"+ chatService.displayTime(data[i].msgDate)+"</div>"
                str += "<div>";
                str += "<p>" + data[i].roomName+ "</p>";
                str += "</div>"
                str += "<button id='enterBtn' class='btn float-right' >입장</button>";
                str += "</div></div></div></li></ul></div>";

            }

            chatUL.html(str);


        });

    }
    var roomId='';
    $("#creating").click(function() {
        var inputreceiver = document.getElementById("receiver").value
        if (inputreceiver == "") {
            alert("대화상대를 입력하지 않았습니다.");
            return;
        }
        else {
                    var nickname = {
                        nickname : inputreceiver
                    };

                    chatService.createRoom(nickname, function (result) {
                        alert(result);
                        document.getElementById("receiver").value="";
                    });
        }
    });

    $(document).on("click", "#enterBtn", function(){
        var room_id = $(this).closest("li").data("rid");
        if(sender != "") {
            location.href="/chat/room/enter/"+room_id;
        }

    });

</script>

<script>
        var sock = new SockJS("/ws-stomp");
        var ws = Stomp.over(sock);
        var roomId = "${roomId}";
        var reconnect = 0;
        var message = '';
        var messages = [];
        console.log("룸아이디 타입"+typeof(roomId));
        //최초시작시 세팅

        var messageDIV = $(".msg_history");
        init2();
        function init2() {
            // 채팅룸 출력
            if(roomId==""){
                return;
            }
            chatService.findAllMessages(roomId, function (data) {
                init();
                console.log("**************"+JSON.stringify(data));
                $('.messages').show();
                var str = "";
                if (data == null || data.length == 0) {
                    return;

                }

                for (var i = 0, len = data.length || 0; i < len; i++) {
                   if(sender == data[i].sender) {
                       str +=   "<div class='outgoing_msg'>\n" +
                       "<div class='sent_msg'>\n" +
                       "<strong id='sender' class='primary-font'>" + data[i].sender + "</strong>" +
                       "<p>" + data[i].message + "</p>\n" +
                       "<span class='chat_date'>" + chatService.displayTime(data[i].createdDate) + "   " + "</span></h5>" +
                       "</div></div>"
                   }
                   else{
                       str +=
                        "<div class='incoming_msg'>\n" +
                        "<div class='incoming_msg_img'>";

                       if("[알림]" == data[i].sender){
                           str += "<img src='/resources/image/info2.png'>"
                       }
                       else {
                           for (var a = 0, length = data[i].chatRoom.users.length || 0; a < length; a++) {
                               if (data[i].sender == data[i].chatRoom.users[a].user.nickname) {
                                   str += "<img src='/display?fileName=" + data[i].chatRoom.users[a].user.id +
                                       "/profile/s_" + data[i].chatRoom.users[a].user.profileImage +
                                       "' onerror=\"this.src = '/resources/image/profile.png'\"/>";
                                   break;
                               }
                           }
                       }
                        str +=
                        "</div>"+
                        "<strong id='sender' class='primary-font'>" + data[i].sender + "</strong>" +
                        "<div class='received_with_msg'>"+
                        "<p>"+data[i].message+"</p>\n"+
                        "<span class='chat_date'>"+ chatService.displayTime(data[i].createdDate)+"   "+"</span></h5>"+
                        "</div></div>"
                   }
                }
                console.log(str);
                messageDIV.html(str);

            });

        }

        $(document).on("click", "#sending", function () {

            this.message = document.getElementById("message").value;
            console.log("SEND MESSAGE" + this.message);
            ws.send("/app/chat/message", {}, JSON.stringify({
                type: 'TALK',
                roomId: roomId,
                sender: sender,
                message: this.message,

            }));
            this.message = '';
            document.getElementById("message").value = '';
            init();
            init2();
        });

        function recvMessage(recv) {
            this.messages.push({
                "type": recv.type,
                "sender": recv.sender,
                "message": recv.message,
                "createdDate": recv.createdDate
            })
            init();
            init2();
        }

        //삭제
        $(document).on("click", "#deleteBtn", function () {
            ws.send("/app/chat/message", {}, JSON.stringify({
                type: 'QUIT',
                roomId: roomId,
                sender: sender,
                message: this.message,
                createdDate: this.createdDate
            }));

            alert("더이상 대화가 불가합니다.");
            init();
            location.href="/chat/room/stop/"+roomId;


        });


        //연결
        function connect() {
            // pub/sub event
            ws.connect({}, function (frame) {
                ws.subscribe("/user/queue/chat/room/" + roomId, function (message) {
                    var recv = JSON.parse(message.body);
                    recvMessage(recv);
                    init();
                    init2();
                });

            }, function (error) {
                if (reconnect++ <= 5) {
                    setTimeout(function () {
                        console.log("connection reconnect");
                        sock = new SockJS("/ws-stomp");
                        ws = Stomp.over(sock);
                        connect();
                    }, 10 * 1000);
                }
            });
        }

        connect();
</script>
</html>