var boardService = (function () {
    function checkLike(bid, callback, error) {
        $.ajax({
            type: 'get',
            url: "/board/like/"+bid,

            success: function (result, status, xhr) {
                if (callback){
                    callback(result);
                }
            },
            error: function (xhr, status, err) {
                if (error){
                    error(err);
                }
            }
        })
    }



    function addLike(bid, callback, error) {
        $.ajax({
            type:'post',
            url: "/board/like/"+bid,
            data: bid,
            success: function (deleteResult, status, xhr) {
                if (callback){
                    callback(deleteResult);
                }
            },
            error: function (xhr, status, er) {
                if (error){
                    error(er);
                }
            }
        });
    }

    function deleteLike(bid, callback, error) {
        $.ajax({
            type: 'delete',
            url: "/board/like/"+bid,
            data: bid,
            success: function (result, status, xhr) {
                if (callback){
                    callback(result);
                }
            },
            error: function (xhr, status, err) {
                if (error){
                    error(err);
                }
            }
        })
    }

    return {
        checkLike : checkLike,
        addLike : addLike,
        deleteLike :deleteLike
    };
})();