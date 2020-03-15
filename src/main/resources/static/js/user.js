console.log("user module****************************");

var userService = (function () {

    function checkUsername(username, callback, error) {
        console.log("CHECK USERNAME");
        $.ajax({
            url : '/user/usernameCheck?username='+ username,
            type : 'get',
            async: true,
            success: function (data) {
                if (callback){
                    callback(data);
                }
            },
            error: function (xhr, status, err) {
                if (error){
                    error(err);
                }
            }
        });
    }

    function changeAct(email, callback, error) {
        console.log("ACTIVATION");
        $.ajax({
            url: '/user/activate',
            data: email,
            dataType: 'text',//데이타 타입
            type : 'put',
            async: true,
            success: function (data) {
                if (callback){
                    callback(data);
                }
            },
            error: function (xhr, status, err) {
                if (error){
                    error(err);
                }
            }
        });
    }

    function changePW(password, callback, error) {
        console.log("CHANGE PASSWORD");
        $.ajax({
            url: '/user/changePW',
            data: password,
            type : 'put',
            async: true,
            success: function (data) {
                if (callback){
                    callback(data);
                }
            },
            error: function (xhr, status, err) {
                if (error){
                    error(err);
                }
            }
        });
    }

    return {
        checkUsername : checkUsername,
        changeAct : changeAct,
        changePW : changePW
    };





})();