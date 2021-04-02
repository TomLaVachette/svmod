hook.Add("OnPlayerChat", "SV_OpenMenu", function(ply, text) 
    if text == "!svmod" or text == "/svmod" then
        if ply == LocalPlayer() then
            LocalPlayer():ConCommand("svmod")
        end

        return true
    end
end)