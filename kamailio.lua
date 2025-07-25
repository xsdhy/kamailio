

function ksr_request_route()
    KSR.info("=====>>>>>>>router-request: " .. KSR.pv.gete('$rm').. " from ip:".. KSR.pv.gete("$si") ..  " du:".. KSR.pv.gete("$du") .." has_totag:".. KSR.siputils.has_totag() .."\n");
    KSR.tm.t_relay()
end


function ksr_xhttp_event(evname)
    KSR.info("=====xhttp module triggered event: " .. evname .. "\n")
    KSR.set_reply_close()
    KSR.set_reply_no_connect()

    local upgrade = KSR.hdr.get("Upgrade")
    if upgrade == "websocket" then
        if KSR.websocket.handle_handshake() > 0 then
            KSR.info("handshak ok \n")
        else
            KSR.err("handshake err \n")
        end
        return 1
    end
    KSR.xhttp.xhttp_reply("404","Not Found","text/plain","Not Found")
    return 1
end





