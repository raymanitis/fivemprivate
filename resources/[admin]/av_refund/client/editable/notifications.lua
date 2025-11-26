RegisterNetEvent('av_refund:notification', function(title, message, type)
    lib.notify({
        title = title,
        description = message,
        type = type
    })
end)