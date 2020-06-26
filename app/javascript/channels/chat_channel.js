import consumer from "./consumer"

$(function () {
    $('[data-role="message-date"]').each(function (index, element) {
        var $element = $(element);
        var date = $element.text();
        $element.text((new Date(date)).toLocaleString('it-IT', { day: 'numeric', month: 'numeric', hour: 'numeric', minute: 'numeric' }));
    });
    $('[data-channel-subscribe="chat"]').each(function (index, element) {
        var $element = $(element),
            chat_id = $element.data('chat-id'),
            user_id = $element.data('user-id'),
            messageTemplate = $('[data-role="message-template"]');


        $element.animate({ scrollTop: $element.prop("scrollHeight") }, 1000);
        var channel = consumer.subscriptions.create(
            {
                channel: "ChatChannel",
                chat: chat_id
            },
            {
                received: function (data) {
                    var content = messageTemplate.children().clone(true, true);
                    if (data.user_id === user_id)
                        content.addClass("ml-auto");
                    else
                        content.addClass("mr-auto");
                    content.find('[data-role="message-text"]').text(data.content);
                    content.find('[data-role="message-date"]').text((new Date(data.created_at)).toLocaleString('en-GB', { day: 'numeric', month: 'numeric', hour: 'numeric', minute: 'numeric' }));
                    $element.append(content);
                    $element.animate({ scrollTop: $element.prop("scrollHeight") }, 1000);
                    channel.send({"chat_id": chat_id});
                }
            }
        );
    });
});